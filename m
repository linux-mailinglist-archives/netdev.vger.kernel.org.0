Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052A6622605
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKIJAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiKII7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 03:59:53 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723B81CFFD
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 00:59:52 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221109085950epoutp03bf41bd0af28cf19fbd1339e5b2f1ae3b~l3vdXwpAB1521915219epoutp03C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:59:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221109085950epoutp03bf41bd0af28cf19fbd1339e5b2f1ae3b~l3vdXwpAB1521915219epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667984390;
        bh=Iu5+N+miN/+4cscMtRh0UJ9+d/gAQRYs8hInPQxbFg4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=vWCYUKAIiRIyZ4QTf+bCumxRg6Ml8dd6VSh7cjUlyXpDAtNbFT6QnzfhwUqmjI7xd
         LqIycQqFlI5n+QkxokzuY+q0VtNIBQPXOxoaySnIM11Jpeg+PxCFid8yuqhouIqDjW
         joAL/WzCIfS8H5wLcoPozoDfisxwUUSRA4/CRUdk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221109085950epcas5p471c0ec79a5417966cfc93a1d157a8db5~l3vcti8IO2285222852epcas5p4E;
        Wed,  9 Nov 2022 08:59:50 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N6f6q5SCPz4x9Pt; Wed,  9 Nov
        2022 08:59:47 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.96.56352.30C6B636; Wed,  9 Nov 2022 17:59:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221109085244epcas5p179caee6149b819c79c3bcd1636bf3a2f~l3pQRDe1F1197011970epcas5p1L;
        Wed,  9 Nov 2022 08:52:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109085244epsmtrp27fec17d4ebe1bc1c595226c0f82190d7~l3pQQIlNE0460304603epsmtrp2n;
        Wed,  9 Nov 2022 08:52:44 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-43-636b6c03b451
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.06.14392.C5A6B636; Wed,  9 Nov 2022 17:52:44 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221109085242epsmtip2213c7edd92acadff932d99f5abdab34d~l3pOeLNTV0645606456epsmtip21;
        Wed,  9 Nov 2022 08:52:42 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <wg@grandegger.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <87k04oxsvb.fsf@hardanger.blackshift.org>
Subject: RE: [PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to
 message ram
Date:   Wed, 9 Nov 2022 14:22:36 +0530
Message-ID: <005501d8f418$a2149540$e63dbfc0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJD6JMFT7t8BSDsfE8Wj4Sh/mZZ1gJCfwoQApKUAcIBOuS3Yq0v3zYw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmli5zTnaywdnF/BYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEdUtk1GamJK
        apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMG/3NLAWf
        RStevuBuYDwt2MXIySEhYCLRdmk2axcjF4eQwG5Gif43R5kgnE+MEt2z97NDON8YJeZe+MoC
        0zL97haoxF5Gif/NbawgCSGB54wSO8/HgdhsAjoSzZP/MoLYIgJ6Er8nLGICsZkFtjBJ/H1f
        BmJzCphJnH25GaxGWCBc4unmzWwgNouAisTrfYfB6nkFLCU+/epmg7AFJU7OfMICMUdeYvvb
        OcwQBylI/Hy6jBVil5vEt5s3oGrEJY7+7GEGOVRC4AKHxOeGI+wQDS4Szfd3s0HYwhKvjm+B
        iktJfH63FyqeLLHjXycrhJ0hsWDiHkYI217iwJU5QAs4gBZoSqzfpQ8RlpWYemod1I98Er2/
        nzBBxHkldsyDsVUkXnyewArSCrKq95zwBEalWUg+m4Xks1lIPpiFsGwBI8sqRsnUguLc9NRi
        0wLjvNRyeHQn5+duYgSnZi3vHYyPHnzQO8TIxMF4iFGCg1lJhJdbIztZiDclsbIqtSg/vqg0
        J7X4EKMpMLgnMkuJJucDs0NeSbyhiaWBiZmZmYmlsZmhkjjv4hlayUIC6YklqdmpqQWpRTB9
        TBycUg1Mx6bO+O4584dak4VSFq/Yz55ou8VzVqapfN4aMnv/xm9drzmzwuOXBrsed7s9e45y
        V+ga4/nSN3JeLZi/pGK7QcrJafOf8205G8N2b2Vd1tKrCYX7U4z4bykdvrzme0Gq2q4dD/f5
        K345VrFSXbFQ92XXWms17ca95+5XGV7RY+TqffVL4v2bhd42e7M4Om/qdYhYWbl7XLLUse7Z
        EW5qpijUt/uIsHesVuzXYMtvUkKcVY0fazwYrl+09PVYPyuqn7mrXN3T2sZ1w0mdaLvXT/zd
        WmwndjtGHLB2C7798aufVU/ZvL1f1b/EX8/Mc9p10mLXszoe9sNZuos28q7JPDTp7JwdK03V
        xY+0amUosRRnJBpqMRcVJwIAyXvfkVYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvG5MVnaywbXjUhYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEcUl01Kak5m
        WWqRvl0CV8aN/maWgs+iFS9fcDcwnhbsYuTkkBAwkZh+dwt7FyMXh5DAbkaJ+a9uskIkpCSm
        nHnJAmELS6z89xyq6CmjxNa2y2AJNgEdiebJfxlBbBEBPYnfExYxgRQxCxxikpj/ZzULRMdz
        RomJ21+AdXAKmEmcfbkZrENYIFRi3qcmMJtFQEXi9b7DTCA2r4ClxKdf3WwQtqDEyZlPwHqZ
        BbQlnt58CmXLS2x/O4cZ4jwFiZ9Pl7FCXOEm8e3mDagacYmjP3uYJzAKz0IyahaSUbOQjJqF
        pGUBI8sqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgKNXS3MG4fdUHvUOMTByMhxgl
        OJiVRHi5NbKThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCU
        amBKZ+mJfr4r88RyxfWp55JcfgS/Fp7XVJRivHznwxsZc78o5RqxLXk/ZYdObmf27eiUXfGp
        Wn03ee7XMyn+mxMc/yFB7l9ahG6W87YFXw7vPX+kp7W+6vl+1iaJ5AlX+Ha/OX7CPSU7SH5K
        0tKtnV/WtHcx1nYVaX5VStnx4Lh0WsPaMpe0HAdp2T3ZXv8b5uol3C26PmUL34dlGyMKLY4I
        VIibXHoiNi9NLsVmj0OKZ93Fi7VruHRkjq6y2uOTkXW2aFZDctfKaP5HhpKO0gKz9h6TmLn8
        zpmAzSd8nvh9FZj+8uOtXXfMfk36Uxyb0tzJdC9+Xltb2OH1TDvNnrYni/M81RKI/9yR89v3
        hIgSS3FGoqEWc1FxIgBVfxSGQQMAAA==
X-CMS-MailID: 20221109085244epcas5p179caee6149b819c79c3bcd1636bf3a2f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d@epcas5p4.samsung.com>
        <20221021095833.62406-3-vivek.2311@samsung.com>
        <87k04oxsvb.fsf@hardanger.blackshift.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Sent: 25 October 2022 13:02
> To: Vivek Yadav <vivek.2311@samsung.com>
> Cc: rcsekar@samsung.com; wg@grandegger.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> pankaj.dubey@samsung.com; ravi.patel@samsung.com;
> alim.akhtar@samsung.com; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to
> message ram
> 
> You should add the DT people on Cc:
> - devicetree@vger.kernel.org
> - Rob Herring <robh+dt@kernel.org>
> 
Okay, I will add them in the next patch series.
> On 21.10.2022 15:28:28, Vivek Yadav wrote:
> > Whenever the data is transferred or stored on message ram, there are
> > inherent risks of it being lost or corruption known as single-bit errors.
> >
> > ECC constantly scans data as it is processed to the message ram, using
> > a method known as parity checking and raise the error signals for
> corruption.
> >
> > Add error correction code config property to enable/disable the error
> > correction code (ECC) functionality for Message RAM used to create
> > valid ECC checksums.
> >
> > Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
> > Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git
> > a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> > b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> > index 26aa0830eea1..0ba3691863d7 100644
> > --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> > +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> > @@ -50,6 +50,10 @@ properties:
> >        - const: hclk
> >        - const: cclk
> >
> > +  mram-ecc-cfg:
> 
> This probably needs a prefix and a "$ref:
> /schemas/types.yaml#/definitions/phandle".
> 
okay
I will add in the next patch series.
> > +    items:
> > +      - description: M_CAN ecc registers map with configuration
> > + register offset
> > +
> >    bosch,mram-cfg:
> >      description: |
> >        Message RAM configuration data.
> > --
> > 2.17.1
> >
> >
> 
> Marc
> 
Thanks for the review.
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   |
> https://protect2.fireeye.com/v1/url?k=79b0bfe8-195222b5-79b134a7-
> 000babd9f1ba-4774190ce98312a8&q=1&e=e3b63c25-f82a-4aa4-aaee-
> 156c142ee4c6&u=https%3A%2F%2Fwww.pengutronix.de%2F  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

