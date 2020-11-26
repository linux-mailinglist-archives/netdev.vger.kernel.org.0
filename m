Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDF2C5FF2
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 07:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389600AbgK0GJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 01:09:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41224 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731381AbgK0GJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 01:09:04 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201127060901epoutp03de9c02887baa637d94543c75261a93e6~LSHDiyoZR1606916069epoutp03n
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 06:09:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201127060901epoutp03de9c02887baa637d94543c75261a93e6~LSHDiyoZR1606916069epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606457341;
        bh=iuHiz6slowdjHtBqvE/v4LWxnEYR2xu19aogJS1tp5E=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=AdGk6qeiKLerqkgpl2ultcoaKlgwIL7vHtW8oThtuulUL8ejrA630BHiJ9d13PkeD
         OAQ9UXOg9lsVCohC+ng5qKZkR68UTMEt9WuG2s1oKIiPt+APCP9pFbeg793qOx0u+r
         SEcT4XAWZ5XyrilLeZGyM7B1d1DM1+Z3A/T7xg38=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20201127060901epcas5p21c18c4b035a19bddfa16d9e18d60a9b4~LSHDAn59v0811008110epcas5p20;
        Fri, 27 Nov 2020 06:09:01 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.83.15682.DF790CF5; Fri, 27 Nov 2020 15:09:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20201126122104epcas5p2f8e6251df85df151dfdeb0a5f632296d~LDinLR8tF0915709157epcas5p2b;
        Thu, 26 Nov 2020 12:21:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201126122104epsmtrp2061d1f633dc21163ea3183894f196d71~LDinKeoDw3171431714epsmtrp2j;
        Thu, 26 Nov 2020 12:21:04 +0000 (GMT)
X-AuditID: b6c32a49-8d5ff70000013d42-6e-5fc097fd8499
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.7A.08745.0BD9FBF5; Thu, 26 Nov 2020 21:21:04 +0900 (KST)
Received: from pankjsharma02 (unknown [107.122.12.50]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201126122102epsmtip23777945182f6c1907080159de66bb4bf~LDilicsjB3039430394epsmtip2V;
        Thu, 26 Nov 2020 12:21:02 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     "'Oliver Hartkopp'" <socketcan@hartkopp.net>,
        "'Marc Kleine-Budde'" <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc:     <sriram.dash@samsung.com>, <dmurphy@ti.com>, <wg@grandegger.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <pankaj.dubey@samsung.com>
In-Reply-To: <e6f36ce5-1197-d93b-705b-2f7d68761f04@hartkopp.net>
Subject: RE: [PATCH] can: m_can: add support for bosch mcan version 3.3.0
Date:   Thu, 26 Nov 2020 17:51:01 +0530
Message-ID: <0e7001d6c3ee$9c42e1f0$d4c8a5d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIb1t9RAy9KWunJ2OiZjGyWlR5SqQHLgEDCAWPT3hMBH7kX0akttQpQ
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsWy7bCmhu7f6QfiDbY8YLeYc76FxaL79BZW
        iwvb+lgtVn2fymxxedccNov1i6awWBxbIGaxaOsXdosbr/4BifXsFkvv7WR14PbYsvImk8fH
        S7cZPZr/H2H32LSqk82j/6+BR9+WVYwex29sZ/L4vEkugCOKyyYlNSezLLVI3y6BK+PJquns
        BUeEKg73vWFsYJzK38XIySEhYCLx5NA7ti5GLg4hgd2MEjNOHGSGcD4xSnTemAqV+cwoMflJ
        JwtMy+FPvUwQiV2MEnNfd0M5rxklTi2dzwhSxSagLzGl6S8LSEJEYDujxM8t+9lBHGaBHkaJ
        1v5WoAwHB6eAg0TLlBiQBmEBT4kz58+zgoRZBFQlpm+OAwnzClhK/G3vY4awBSVOznwCdgWz
        gLbEsoWvmSEuUpD4+XQZK4gtIuAmceDHPkaIGnGJl0ePgK2VEDjCIbGs/wAjRIOLRP+NS0wQ
        trDEq+Nb2CFsKYnP7/ayQdjZEgt394OdKSFQIdE2QxgibC9x4MocsDCzgKbE+l36EGFZiamn
        1jFBrOWT6P39BGo6r8SOeTC2msTUp++gLpCRuPNoM9sERqVZSD6bheSzWUg+mIWwbQEjyypG
        ydSC4tz01GLTAsO81HK94sTc4tK8dL3k/NxNjOBEpuW5g/Hugw96hxiZOBgPMUpwMCuJ8LoL
        740X4k1JrKxKLcqPLyrNSS0+xCjNwaIkzqv040yckEB6YklqdmpqQWoRTJaJg1OqgYljlsmk
        bK7vT/dE7/YT/Fy69t7uxa77Hz8ozYxPlLaZFHBaxyQ7W8/kkq7/wevLXiZ7Me5MrhXvUvPu
        nbK5x38yj9tHn+0fXeffXvBI7ZDbjQSZVcsyp3ssW/ddukS0PYdR+o5fXrURW+hmv0VSk3L7
        J+hzP5Sd+L15pVym94zdguHPt7Wq3lU0Pfg8eVXc9W2tD/8v+fv6Q+HtksJKwYVrbze1WyUU
        vJuU3Hr5wOW+a2cqP0cWTjhzwIh7TsH5vphdc7MMwrUUVGeeblcr2H1Q9Y3FL2lmB4cmi8+b
        d51vC4lWb5G7s9eR581ml29FT0/tzpN8xrp+zySnqM2t3fqqtTULPxubzQni+p99jE2JpTgj
        0VCLuag4EQDSjprW0wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWy7bCSvO6GufvjDd5M1rCYc76FxaL79BZW
        iwvb+lgtVn2fymxxedccNov1i6awWBxbIGaxaOsXdosbr/4BifXsFkvv7WR14PbYsvImk8fH
        S7cZPZr/H2H32LSqk82j/6+BR9+WVYwex29sZ/L4vEkugCOKyyYlNSezLLVI3y6BK+PyhhPM
        BeuFKr4ufc3cwPiPr4uRk0NCwETi8KdeJhBbSGAHo8TU3wFdjBxAcRmJxZ+rIUqEJVb+e87e
        xcgFVPKSUeL9lr1sIAk2AX2JKU1/WUASIgK7GSU+XPzBDpJgFpjCKDH5iSxERzOTxOXvM1lB
        pnIKOEi0TIkBqREW8JQ4c/48WJhFQFVi+uY4kDCvgKXE3/Y+ZghbUOLkzCcsECO1JZ7efApn
        L1v4mhniOAWJn0+XsYLYIgJuEgd+7GOEqBGXeHn0CPsERuFZSEbNQjJqFpJRs5C0LGBkWcUo
        mVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyLWlo7GPes+qB3iJGJg/EQowQHs5IIr7vw
        3ngh3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MKUIGhre
        lAi65nH864Vqa2W7SMdJqr1PWewXWFyYqy/eazJvsvSdxUvNrdX/SV08k7J16t8Dd47GtXCa
        T1j7n4tRuuKaT3Tca9UrRtxNLlXxqRcv3ElffuGMsUe7kWaK5E7FdV9MeHRZO2OnnulKE3V8
        3TC7/dlD46ZDc4/98O75Un7Za1Gp8de6KafWxAffEZjfe1prY15AzMJ1ZlLfWIz+/Er91djr
        V77lyM/AqwGKnSwbinUOnvblUbxcnriqPcznucqrAhXzWsWZ9z8eyncNYv6+muGvzPS/W98H
        ZBa4K4VUOdqXpgqu2pNhLS69puNckfPPk9y/jz+Qidkiy/estszywLHVfTGbp777pMRSnJFo
        qMVcVJwIAGGYITU0AwAA
X-CMS-MailID: 20201126122104epcas5p2f8e6251df85df151dfdeb0a5f632296d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20201126045221epcas5p46f00cd452b8023262f5556e6f4567352
References: <CGME20201126045221epcas5p46f00cd452b8023262f5556e6f4567352@epcas5p4.samsung.com>
        <1606366302-5520-1-git-send-email-pankj.sharma@samsung.com>
        <e7a65c29-d0b0-358f-fc5f-c08944ada4df@pengutronix.de>
        <e6f36ce5-1197-d93b-705b-2f7d68761f04@hartkopp.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Oliver Hartkopp <socketcan=40hartkopp.net>
> Subject: Re: =5BPATCH=5D can: m_can: add support for bosch mcan version 3=
.3.0
>=20
>=20
>=20
> On 26.11.20 11:48, Marc Kleine-Budde wrote:
> > On 11/26/20 5:51 AM, Pankaj Sharma wrote:
> >> Add support for mcan bit timing and control mode according to bosch
> >> mcan IP version 3.3.0 The mcan version read from the Core Release
> >> field of CREL register would be 33. Accordingly the properties are to
> >> be set for mcan v3.3.0
> >
> > BTW: do you have the v3.2 and v3.1 datasheets?
>=20
> Unfortunately Bosch does not give access to older documents, so I tried t=
o
> concentrate all my downloaded versions of public available information he=
re:
>=20
> https://protect2.fireeye.com/v1/url?k=3D6afc7639-35674f23-6afdfd76-
> 000babff24ad-be473a015905c7ca&q=3D1&e=3D8d02d5be-2511-407d-bfd1-
> 1d9135e21b7c&u=3Dhttps%3A%2F%2Fgithub.com%2Fhartkopp%2FM_CAN-User-
> Manual-History

Thanks Oliver for sharing the link.=20
=40Marc: I have used the documents from the link provided by Oliver.

Regards
Pankaj Sharma

>=20
> PR's with updates are welcome ;-)
>=20
> Best,
> Oliver
>=20
> ps. =40Bosch Semiconductors - Read the README there=21 I would like to re=
move
> my own collection.
>=20
> >
> > Marc
> >
> >> Signed-off-by: Pankaj Sharma <pankj.sharma=40samsung.com>
> >> ---
> >> Depends on:
> >> https://protect2.fireeye.com/v1/url?k=3D6c628f8e-33f9b694-6c6304c1-000=
b
> >> abff24ad-a2e76f208a6b1470&q=3D1&e=3D8d02d5be-2511-407d-bfd1-
> 1d9135e21b7c&
> >> u=3Dhttps%3A%2F%2Fmarc.info%2F%3Fl%3Dlinux-
> can%26m%3D160624495218700%26
> >> w%3D2
> >>
> >>   drivers/net/can/m_can/m_can.c =7C 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/net/can/m_can/m_can.c
> >> b/drivers/net/can/m_can/m_can.c index 86bbbfa..7652175 100644
> >> --- a/drivers/net/can/m_can/m_can.c
> >> +++ b/drivers/net/can/m_can/m_can.c
> >> =40=40 -1385,6 +1385,8 =40=40 static int m_can_dev_setup(struct m_can_=
classdev
> *m_can_dev)
> >>
> 	&m_can_data_bittiming_const_31X;
> >>   		break;
> >>   	case 32:
> >> +	case 33:
> >> +		/* Support both MCAN version v3.2.x and v3.3.0 */
> >>   		m_can_dev->can.bittiming_const =3D m_can_dev->bit_timing ?
> >>   			m_can_dev->bit_timing :
> &m_can_bittiming_const_31X;
> >>
> >>
> >
> >

