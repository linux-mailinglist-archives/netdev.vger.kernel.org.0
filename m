Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC7BDAB90
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409355AbfJQLyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 07:54:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19993 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409341AbfJQLyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 07:54:49 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20191017115446epoutp045fa9a4d7bbaf309499998e7d24215d06~ObRvx1yhg1419714197epoutp04t
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:54:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20191017115446epoutp045fa9a4d7bbaf309499998e7d24215d06~ObRvx1yhg1419714197epoutp04t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571313286;
        bh=9jV+kSGWbjQY3QvQJzMos5sqI2aE1dpYKztG7UbH68A=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=gHR4LGnDr4iUJ3zL/aYHCxxWOxKqretNZjynw6lhO1gOD9Nby9PtajjzSOQ79ILT5
         fU8pGaWUkOEaTj7dUT7EWUlp+rnBBCWCvwo11gHbo/Oat9niU+EgwL+QzhSbZHqT5K
         aLMYYPbSfCwh909fKgnKd6A5VM1Kr46l5R/v6+Lw=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20191017115445epcas5p4642bb0cc615a62bb58ecf0c0974b16ed~ObRvAodTo0364603646epcas5p46;
        Thu, 17 Oct 2019 11:54:45 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.A4.04480.58658AD5; Thu, 17 Oct 2019 20:54:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20191017115445epcas5p12e882471c2acd7638bbeeaa9b33bb241~ObRuap1UT0913209132epcas5p1o;
        Thu, 17 Oct 2019 11:54:45 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191017115445epsmtrp202e637636c962f2cb870b74a6d9a1e02~ObRuZ3tvo1901719017epsmtrp2M;
        Thu, 17 Oct 2019 11:54:45 +0000 (GMT)
X-AuditID: b6c32a4b-cbbff70000001180-f7-5da856852954
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.01.03889.58658AD5; Thu, 17 Oct 2019 20:54:45 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.85.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191017115442epsmtip1a4e186875488c19cac22a86b5f75bb33~ObRsGbf3a2659326593epsmtip1i;
        Thu, 17 Oct 2019 11:54:42 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     "'Jeroen Hofstee'" <jhofstee@victronenergy.com>,
        "'Simon Horman'" <simon.horman@netronome.com>
Cc:     "'kbuild test robot'" <lkp@intel.com>, <kbuild-all@lists.01.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <davem@davemloft.net>,
        <eugen.hristev@microchip.com>, <ludovic.desroches@microchip.com>,
        <pankaj.dubey@samsung.com>, <rcsekar@samsung.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>
In-Reply-To: <1921cfe4-0ee0-e2a5-6696-df5f612c6c56@victronenergy.com>
Subject: RE: [PATCH] can: m_can: fix boolreturn.cocci warnings
Date:   Thu, 17 Oct 2019 17:24:41 +0530
Message-ID: <000f01d584e1$ab1907b0$014b1710$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQFBl3stLMda2COLQ4+xvzWrGT0LJgGMJ+EIAU1Heb8BtkGFyQF4xXLRAVs56cYDWI5Z86gwscDw
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0gUURTGuTszO7NLa+OoddKIXFDQfFLRFGYPKgaKsMj+sKy2HNR0N9nR
        0gjK8hErqYimbVI+UkwtwVbxjflINCwfZUUhlFq6pj00tdKs3Vvkf7/7feecjw8uQ3AfKEcm
        XBct6nWaSLVcSVa3url5Jh4uCfa50beJz32aQPLNcx0kX/KpieK7UwYQXzqbRfD9dbly3nzl
        nZwfvfeC4isKMkn+Ud4KvqBqmuaNPTUU/7JWwb+soPmiwVpq+3LBdPeVTPjS9xoJhQ1jMiHl
        5i9SeDNXhITslLeEkLbgI6SaSpEwVblGyHj4mQ5QBin9QsTI8LOi3tv/hDKsvamMiMrnYl9X
        e11CXTYGpGCA3QDZVY2UASkZjq1HUD5YLrMYHPsVweIMi42ZP2zMkRsQY90wx+uw3ohgvKMN
        4cc4guz5KmTZlrPekHl5gbSwPRsCuYm9tGWIYJMJKO8fkFsMBbsbhpoMtIXtWH/4UTRmjSZZ
        F5j/mG3VVexmWHz1nsJsC503hq1HCXYdFOePE7jDWvg+UkxhfSWMtbfRODgIWo2z1mBgu2iI
        L2yR4YVdkJL8nMJsB+YOE43ZEaYmG+WYIyC/Po3ElWMhKccOy9ug+VmuVSZYN6io88axNnDt
        57AMT6vgahKHp10ha2QSYV4Nb949+HtcgNSpZDodORuXFDMuKWZcUsb4PywPkaVolRglaUNF
        aWPUep14zkvSaKUYXajXqTPaSmT9fu57a1Dlk30tiGWQepmqJqAkmKM0Z6U4bQsChlDbq24n
        3AnmVCGauPOi/sxxfUykKLUgJ4ZUr1RlUM+PcmyoJlqMEMUoUf/PlTEKx0uIchkrM+/YPzqv
        mThd7w2pQYuDij53vtM5sKDgQuyByoySg0VxgXn3hqRbYUpTDhfaPTHka7p/qNXj25atOb7O
        5oGF0UmHYaVH78Ug0WHg2PX0dL/xLtWRX90Ns66pRIPtx/vzVKbfjF4b09fs/njCMJ3pdJJ0
        2OMZvjevJ36nr5qUwjS+7oRe0vwGSX7vy3oDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSnG5r2IpYg/tNPBZzzrewWBz4cZzF
        YsX7fawWZ7uvMVqs+j6V2eLyrjlsFq+aH7FZvFh7ndVi/aIpLBbHFohZLNr6hd1i1oUdrBY3
        dnJa3FjPbrH03k5WB36PLStvMnl8vHSb0WPxnpdMHt2z/7F43PmxlNFjevdDZo/+vwYefVtW
        MXp83iTnMengB/YArigum5TUnMyy1CJ9uwSujGXH5zAW/BGsuH5iCmMD42K+LkYODgkBE4lX
        jXldjFwcQgK7GSWuTf7CAhGXkVj8ubqLkRPIFJZY+e85O0TNS0aJqZ3bGEESbAL6ElOa/rKA
        2CICKRJrb54EK2IWmMossWfja2aIjtnMEtdvX2cDqeIUcJV4vK+LHcQWFrCT+LX0JROIzSKg
        KvHnzXSwOK+ApcT/m89YIWxBiZMzn4BtYBbQlnh68ymcvWwhyAKQ8xQkfj5dxgoRF5d4efQI
        O8RFURKHZ31nn8AoPAvJqFlIRs1CMmoWkvYFjCyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1
        kvNzNzGCI1lLawfjiRPxhxgFOBiVeHh3BKyIFWJNLCuuzD3EKMHBrCTCO79lSawQb0piZVVq
        UX58UWlOavEhRmkOFiVxXvn8Y5FCAumJJanZqakFqUUwWSYOTqkGxgV+617oCbJ6dBuYiv/q
        aXz5Yv1v/h/3t7yy2aNQHSkT9NhiiV1BgfOfV3bf5rT2CprZP7Kfu1L+IQOvgGrsrfk5i3Zf
        fL/dcdOll3Zt7SLpm6zf2e4uib3JpvVX/7Nh4+Ijytwv2ZT+7DZfo+U94cDKWwJf5KdlX5vb
        lLh2+qX3+TXFrn/nLFdiKc5INNRiLipOBAD4UIJS4AIAAA==
X-CMS-MailID: 20191017115445epcas5p12e882471c2acd7638bbeeaa9b33bb241
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191015083235epcas5p3344c1a176f616a7f83833f6a704a4f2a
References: <1571052844-22633-1-git-send-email-pankj.sharma@samsung.com>
        <20191014150428.xhhc43ovkxm6oxf2@332d0cec05f4>
        <20191015055718.mypn63s2ovgwipk3@netronome.com>
        <9ad7810b-2205-3227-7ef9-0272f3714839@victronenergy.com>
        <20191015071311.yssgqhoax46lfa7l@netronome.com>
        <CGME20191015083235epcas5p3344c1a176f616a7f83833f6a704a4f2a@epcas5p3.samsung.com>
        <1921cfe4-0ee0-e2a5-6696-df5f612c6c56@victronenergy.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jeroen Hofstee <jhofstee=40victronenergy.com>
> Subject: Re: =5BPATCH=5D can: m_can: fix boolreturn.cocci warnings
>=20
> Hello Simon,
>=20
> On 10/15/19 9:13 AM, Simon Horman wrote:
> > On Tue, Oct 15, 2019 at 06:37:54AM +0000, Jeroen Hofstee wrote:
> >> Hi,
> >>
> >> On 10/15/19 7:57 AM, Simon Horman wrote:
> >>> On Mon, Oct 14, 2019 at 11:04:28PM +0800, kbuild test robot wrote:
> >>>> From: kbuild test robot <lkp=40intel.com>
> >>>>
> >>>> drivers/net/can/m_can/m_can.c:783:9-10: WARNING: return of 0/1 in
> >>>> function 'is_protocol_err' with return type bool
> >>>>
> >>>>    Return statements in functions returning bool should use
> >>>>    true/false instead of 1/0.
> >>>> Generated by: scripts/coccinelle/misc/boolreturn.cocci
> >>>>
> >>>> Fixes: 46946163ac61 (=22can: m_can: add support for handling
> >>>> arbitration error=22)
> >>>> CC: Pankaj Sharma <pankj.sharma=40samsung.com>
> >>>> Signed-off-by: kbuild test robot <lkp=40intel.com>
> >>>> ---
> >>>>
> >>>> url:    https://github.com/0day-ci/linux/commits/Pankaj-Sharma/can-
> m_can-add-support-for-handling-arbitration-error/20191014-193532
> >>>>
> >>>>    m_can.c =7C    4 ++--
> >>>>    1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> --- a/drivers/net/can/m_can/m_can.c
> >>>> +++ b/drivers/net/can/m_can/m_can.c
> >>>> =40=40 -780,9 +780,9 =40=40 static inline bool is_lec_err(u32 psr)
> >>>>    static inline bool is_protocol_err(u32 irqstatus)
> >>>>    =7B
> >>>>    	if (irqstatus & IR_ERR_LEC_31X)
> >>>> -		return 1;
> >>>> +		return true;
> >>>>    	else
> >>>> -		return 0;
> >>>> +		return false;
> >>>>    =7D
> >>>>
> >>>>    static int m_can_handle_protocol_error(struct net_device *dev,
> >>>> u32 irqstatus)
> >>>>
> >>> <2c>
> >>> Perhaps the following is a nicer way to express this (completely unte=
sted):
> >>>
> >>> 	return =21=21(irqstatus & IR_ERR_LEC_31X); </2c>
> >>
> >> Really...., =21=21 for bool / _Bool types? why not simply:
> >>
> >> static inline bool is_protocol_err(u32 irqstatus)
> >> 	return irqstatus & IR_ERR_LEC_31X;

Thank you. Will Modify in v2.

> >> =7D
> > Good point, silly me.
>=20
>=20
> For clarity, I am commenting on the suggestion made by the tool, not the =
patch
> itself..
>=20
> Regards,
>=20
> Jeroen


