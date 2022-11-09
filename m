Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF76622602
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 09:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiKII7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 03:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKII7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 03:59:48 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBD81C405
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 00:59:44 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221109085939epoutp01b92ee2e450b291d6b2f2cd4617ba3e33~l3vS2UzGS0283202832epoutp01N
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:59:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221109085939epoutp01b92ee2e450b291d6b2f2cd4617ba3e33~l3vS2UzGS0283202832epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667984379;
        bh=VrVKuCNznecatVSPG+DxQKB6B8G6Fb2s+mkGjeOwanA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=hIh3XaCpxDDJ45+AMjZucunmS/8USpjNIikJvkiTjrmAgvN2+/WI2YYiD/IjcwUHS
         yUbldP6d5PXC2VSh4tJYps6aaezlYeB9Rd30GfS/9Y6nE+4NOg95uViz7nSfSyqc+h
         h64F+JsopeeqWnTX4N6sLNi4uKfHCt1tFdbe/pzE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221109085938epcas5p17cfde582846e3d0feef54486326aca13~l3vRroNV70257502575epcas5p1C;
        Wed,  9 Nov 2022 08:59:38 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N6f6b1SK3z4x9Q4; Wed,  9 Nov
        2022 08:59:35 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.96.56352.7FB6B636; Wed,  9 Nov 2022 17:59:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221109084814epcas5p2adf370c40052fe18c8510ad9ef5267d4~l3lU-b8y21441614416epcas5p2g;
        Wed,  9 Nov 2022 08:48:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221109084814epsmtrp1cda38d6e5767a4293ca682b518fb7553~l3lU_kmWD2758827588epsmtrp1R;
        Wed,  9 Nov 2022 08:48:14 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-21-636b6bf7750e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.95.14392.E496B636; Wed,  9 Nov 2022 17:48:14 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221109084812epsmtip104556a7e10e19411d6bb7a41bf8d2944~l3lTMiKP62159621596epsmtip11;
        Wed,  9 Nov 2022 08:48:12 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <wg@grandegger.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20221025072441.2ag7lce6otf6iqgh@pengutronix.de>
Subject: RE: [PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to
 message ram
Date:   Wed, 9 Nov 2022 14:17:47 +0530
Message-ID: <004e01d8f418$014485d0$03cd9170$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJD6JMFT7t8BSDsfE8Wj4Sh/mZZ1gJCfwoQApKUAcIDKJ4mo60gcAwA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmlu737Oxkg21HOSwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFos
        vbeT1YHXY8vKm0weCzaVeny8dJvRY9OqTjaP/r8GHu/3XWXz6NuyitHj8ya5AI6obJuM1MSU
        1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
        xcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZPR/usxYs
        46uY3b+HsYHxNHcXIweHhICJxLurVl2MXBxCArsZJZYfnsUM4XxilHh74CALhPONUeLjnEOs
        XYycYB0fVzxig0jsZZT4/nM9VNVzRom2x8fYQKrYBHQkmif/ZQSxRQT0JH5PWMQEYjMLbGGS
        +Pu+DMTmFLCVmPnsKlhcWCBc4unmzWC9LAIqEofe7gSzeQUsJdr+/meGsAUlTs58wgIxR15i
        +9s5zBAXKUj8fLqMFWKXm0Tz2p1QNeISR3/2QNXc4JBoauCFsF0kTn8/yw5hC0u8Or4FypaS
        eNnfBmUnS+z41wn1cYbEgol7GCFse4kDV+awgMKOWUBTYv0ufYiwrMTUU+ugXuST6P39hAki
        ziuxYx6MrSLx4vMEVkiwS0n0nhOewKg0C8ljs5A8NgvJA7MQli1gZFnFKJlaUJybnlpsWmCc
        l1oOj+7k/NxNjODUrOW9g/HRgw96hxiZOBgPMUpwMCuJ8HJrZCcL8aYkVlalFuXHF5XmpBYf
        YjQFhvZEZinR5HxgdsgriTc0sTQwMTMzM7E0NjNUEuddPEMrWUggPbEkNTs1tSC1CKaPiYNT
        qoGpeceOS1JeTbOeHPt5cUVaqCHL/aMfKyPYVfaoPm3btL6xN/uosNNRdv6g5rmWaW8sN391
        enbx5OqzRzWM06fmPfaqdrw31y5od8rtQ/XhYreuHVuWwqMq7B1zw9Hzb3eew+Tfxbo7Nnz9
        9yXbUUA8KjzeZ7dByA9743lJh/2azbrDdd7psdrG2IjaPtvrW3I/yum62nm1uwxZW1pK6tzO
        TD07dUlMyK/ZPSu0Liitlr9cHvUn08U6TZpbUGFSY0Xc9q3MLJOObXr+8UrN2qXiyketjlyJ
        3r506Y6bKd89rmufWPIz1TEr4JThkb2nOev6XpvN+qwdztywbrn6irsvBb+nmeUujnpXlRj5
        6dc1JZbijERDLeai4kQA6ZpIcVYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWy7bCSnK5fZnaywc6zahYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEcUl01Kak5m
        WWqRvl0CV0bPh/usBcv4Kmb372FsYDzN3cXIySEhYCLxccUjti5GLg4hgd2MEu1frzNBJKQk
        ppx5yQJhC0us/PecHaLoKaPEm4Z2VpAEm4CORPPkv4wgtoiAnsTvCYuYQIqYBQ4xScz/s5oF
        ouMdo0TnggZ2kCpOAVuJmc+ugq0QFgiVmPepCaybRUBF4tDbnWwgNq+ApUTb3//MELagxMmZ
        T8DOYBbQlnh68ymULS+x/e0cZojzFCR+Pl3GCnGFm0Tz2p1QNeISR3/2ME9gFJ6FZNQsJKNm
        IRk1C0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwXGqpbmDcfuqD3qHGJk4
        GA8xSnAwK4nwcmtkJwvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgm
        y8TBKdXAJL3npvg2r2UL9/ha3eJffvHvv/a11rtXX/4z9eXHfuai1CNWVQYXt+k/WybWmvWw
        6Rr3o53MYrKm298X3LwuWafCFOjqwSHysMU3u85p3rXge1+eX7G88izyoZziix/197+YfL5a
        IXgi3azqInv3053JKtY5lRybc1hm1YRufBbaeCZk0ceDM3bEvT1/bP750Iyjaam1njuTf2/8
        L2Ym8GHuH41I2wlyJU4TrVYtDGev3NhQzbtN3LU3W+2p0GXtHqF15edCFhnuMTicHHfW4+Sn
        H4qT82SPLVeRPsmnb6G/7uzZYxOcurSuv4vc8vDpO0VWv5k3bz7TOZZz1G3frcumpt71j1bX
        ffkYFPV1oa4SS3FGoqEWc1FxIgDsVMBSQgMAAA==
X-CMS-MailID: 20221109084814epcas5p2adf370c40052fe18c8510ad9ef5267d4
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
        <20221025072441.2ag7lce6otf6iqgh@pengutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Sent: 25 October 2022 12:55
> To: Vivek Yadav <vivek.2311@samsung.com>
> Cc: rcsekar@samsung.com; wg@grandegger.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> pankaj.dubey@samsung.com; ravi.patel@samsung.com;
> alim.akhtar@samsung.com; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to
> message ram
> 
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
> 
> Can you please add an example to the yaml that makes use of the mram-ecc-
> cfg property?
> 
Okay, I will add in next patch series.
> regards,
> Marc
> 
Thanks for review.
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   |
> https://protect2.fireeye.com/v1/url?k=ec0872b8-8d836798-ec09f9f7-
> 74fe485fb347-10f7a5cc45234a40&q=1&e=48595861-7733-4e80-bf96-
> bd85b4d16570&u=https%3A%2F%2Fwww.pengutronix.de%2F  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

