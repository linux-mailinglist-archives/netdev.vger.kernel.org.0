Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAEBD614D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 13:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbfJNLar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 07:30:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11279 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbfJNLaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 07:30:46 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191014113044epoutp01f621e1ec646fc77f58c80e81c7f818d0~NgA57pEwm2750827508epoutp01A
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 11:30:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191014113044epoutp01f621e1ec646fc77f58c80e81c7f818d0~NgA57pEwm2750827508epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571052644;
        bh=mAMSwg0MGY35MVh1mHoEbPeplNKRC2VmwZX0t8+ADIw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=j1IHxgjoOpXdF3nAfBupwihiUCtdrJzsO6fMyLS7wycwrcw3CDl//7eW7dQCtz4yL
         8SUskwTQjY821NMyoYEV52Ga4tTnSYfmvQXQYYQcC+Hjp6DqNkBNcsDH2RbTBxUpSO
         etF5L4aq23m+BjCoHsuCmnEgT07+n743oC7HarjM=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191014113044epcas5p1212c6e4a3af23a83adfe53e8a4342a41~NgA5br2LC2844828448epcas5p18;
        Mon, 14 Oct 2019 11:30:44 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.07.04480.46C54AD5; Mon, 14 Oct 2019 20:30:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191014113043epcas5p482215422b46c008b4198893fb2a43899~NgA5EFPhu2792327923epcas5p4x;
        Mon, 14 Oct 2019 11:30:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191014113043epsmtrp21c97371cf877df6d29370a78187b4094~NgA5C5cZU0178601786epsmtrp2v;
        Mon, 14 Oct 2019 11:30:43 +0000 (GMT)
X-AuditID: b6c32a4b-ca3ff70000001180-90-5da45c64c4b2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.F1.04081.36C54AD5; Mon, 14 Oct 2019 20:30:43 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.85.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191014113041epsmtip16d627a16c89daf1c1c715a3995934dcc~NgA3Tsah33130331303epsmtip1N;
        Mon, 14 Oct 2019 11:30:41 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <wg@grandegger.com>, <davem@davemloft.net>,
        <eugen.hristev@microchip.com>, <ludovic.desroches@microchip.com>,
        <pankaj.dubey@samsung.com>, <rcsekar@samsung.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <79c10dd5-0c44-ce70-9cb9-bb61e12362d4@pengutronix.de>
Subject: RE: [PATCH] can: m_can: add support for one shot mode
Date:   Mon, 14 Oct 2019 17:00:40 +0530
Message-ID: <001b01d58282$d0a03fa0$71e0bee0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQK+j4JJ4HkhOxWJfJCfQUyc5gk6xQFleCA9AYcBKFSlcIHnQA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsWy7bCmlm5KzJJYg2UdLBZzzrewWBz4cZzF
        YtX3qcwWl3fNYbN4sfY6q8X6RVNYLI4tELNYtPULu8WsCztYLW6sZ7dYem8nqwO3x5aVN5k8
        Pl66zehx58dSRo/+vwYefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAldE9qYe54B9PRfeBPuYG
        xpVcXYycHBICJhKP5r9hAbGFBHYzShxZr9LFyAVkf2KUeLB1OyOE841R4uLBGcwwHTMO7YdK
        7GWU+D73JwuE85pRYvHR+WwgVWwC+hJTmv6CzRUR0JP4PWERE0gRs8BaJon+JV9Yuxg5ODgF
        nCTal2qD1AgL2ElM/jCBFcRmEVCV+PbhGxNICa+ApcSTVlmQMK+AoMTJmU/ARjILaEssW/ga
        6iAFiZ9Pl7FCxMUlXh49wg6x1kmi8dYJdpC1EgLd7BINSyHukRBwkVj44CI7hC0s8er4Fihb
        SuLzu71sEHa2xMLd/SwgN0gIVEi0zRCGCNtLHLgyByzMLKApsX6XPsRaPone30+YIKp5JTra
        hCCq1SSmPn3HCGHLSNx5tJkNosRD4tD9wgmMirOQ/DULyV+zkPwyC2HXAkaWVYySqQXFuemp
        xaYFxnmp5XrFibnFpXnpesn5uZsYwclKy3sH46ZzPocYBTgYlXh4FdIWxwqxJpYVV+YeYpTg
        YFYS4WWYsCBWiDclsbIqtSg/vqg0J7X4EKM0B4uSOO8k1qsxQgLpiSWp2ampBalFMFkmDk6p
        BsZpAsbH1x8TmPuhSI5dlXXD+hubP2Ud/R696f2vy55uM9SP/5rxc+2ZHzciQz4pzPTtZz1p
        mVdwZbPpHcl2je4nT9x4nL+YNWqkfnksf3Sr0bpA0SzxWc16skKRylEz37GuMlo+R0z55czE
        sA/8jFoCIeLpO80+1N87HvGj5YHE9XuHa5vbVISUWIozEg21mIuKEwEVtVQjUgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSnG5yzJJYg29H1CzmnG9hsTjw4ziL
        xarvU5ktLu+aw2bxYu11Vov1i6awWBxbIGaxaOsXdotZF3awWtxYz26x9N5OVgdujy0rbzJ5
        fLx0m9Hjzo+ljB79fw08+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PUlBtMBa94KvZei29g
        nMjVxcjJISFgIjHj0H7GLkYuDiGB3YwSjTcuAjkcQAkZicWfqyFqhCVW/nvODlHzklFiYXs3
        K0iCTUBfYkrTXxYQW0RAT+L3hEVMIDazwHYmiR17yyAazjNKnG3dxwwylFPASaJ9qTZIjbCA
        ncTkDxPA5rAIqEp8+/CNCaSEV8BS4kmrLEiYV0BQ4uTMJywQI7Ulnt58CmcvW/iaGeI2BYmf
        T5exQsTFJV4ePcIOcY6TROOtE+wTGIVnIRk1C8moWUhGzULSvoCRZRWjZGpBcW56brFhgWFe
        arlecWJucWleul5yfu4mRnDUaWnuYLy8JP4QowAHoxIP74nkxbFCrIllxZW5hxglOJiVRHgZ
        JiyIFeJNSaysSi3Kjy8qzUktPsQozcGiJM77NO9YpJBAemJJanZqakFqEUyWiYNTqoExm2vi
        NZOyTFMOjzdFKTvbQ6oiNj7nX1LtOK3nitTayik3bPPmzDFdeOOt65QnnmYxQS9LJysnCdZb
        Fa++LBb7/N3enXmN3bW71hxhfit1rCHswrlddzISNnz+duWPQtdLvarevQ27OR88vhi47B7r
        6TDphgiBph3/hBOMZwjtXN9R+vqN64clSizFGYmGWsxFxYkANrLXDbYCAAA=
X-CMS-MailID: 20191014113043epcas5p482215422b46c008b4198893fb2a43899
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758
References: <CGME20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758@epcas5p3.samsung.com>
        <1569411904-6319-1-git-send-email-pankj.sharma@samsung.com>
        <79c10dd5-0c44-ce70-9cb9-bb61e12362d4@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Marc Kleine-Budde <mkl=40pengutronix.de>
> Subject: Re: =5BPATCH=5D can: m_can: add support for one shot mode
>=20
> On 9/25/19 1:45 PM, Pankaj Sharma wrote:
> > According to the CAN Specification (see ISO 11898-1:2015, 8.3.4
> > Recovery Management), the M_CAN provides means for automatic
> > retransmission of frames that have lost arbitration or that have been
> > disturbed by errors during transmission. By default automatic
> > retransmission is enabled.
> >
> > The Bosch MCAN controller has support for disabling automatic
> > retransmission.
> >
> > To support time-triggered communication as described in ISO
> > 11898-1:2015, chapter 9.2, the automatic retransmission may be
> > disabled via CCCR.DAR.
> >
> > CAN_CTRLMODE_ONE_SHOT is used for disabling automatic retransmission.
> >
> > Signed-off-by: Pankaj Sharma <pankj.sharma=40samsung.com>
> > Signed-off-by: Sriram Dash <sriram.dash=40samsung.com>
>=20
> The patch does not apply to net-next/master. Please use net-next/master a=
s a
> base for patches introducing new features.
>=20

Thank you for the information.

> I've ported the patch and applied it.
>=20

We are not able to get the patch in the net-next/master branch.
Sent patch v2 after rebasing to net-next/master
https://lore.kernel.org/patchwork/patch/1139214/

> tnx,
> Marc
>=20
> --
> Pengutronix e.K.                  =7C Marc Kleine-Budde           =7C
> Industrial Linux Solutions        =7C Phone: +49-231-2826-924     =7C
> Vertretung West/Dortmund          =7C Fax:   +49-5121-206917-5555 =7C
> Amtsgericht Hildesheim, HRA 2686  =7C http://www.pengutronix.de   =7C


