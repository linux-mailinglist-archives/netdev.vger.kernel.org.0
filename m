Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C547E114C74
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 07:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfLFGxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 01:53:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24179 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfLFGxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 01:53:19 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20191206065316epoutp02e4ed5bd725a43c23cbaff5551cc20fbd~dtaxSSN2S3137431374epoutp02f
        for <netdev@vger.kernel.org>; Fri,  6 Dec 2019 06:53:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20191206065316epoutp02e4ed5bd725a43c23cbaff5551cc20fbd~dtaxSSN2S3137431374epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1575615196;
        bh=6q2km7P8W0ptCfUIkh6mVjoU06ki9p4x8jz4+H3ttQo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=SRwIwQRP14k5Dg6/N0cUEM279O6m/r/AW2nN11q0rtFP5jlwmlZONjjdAyBCcu0PI
         YDY0+55eDGbhTvoU+toHHVBCN1Y2dQ71MrTp7eWrtTFkfd5PsR6mnUVoB6xH0GTKDZ
         hdWSUjghf5MBDO7/vMhEqHTBWJOrQf8MGH3d2l/c=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191206065315epcas5p2180d84f4c9ea4632e3757033938b176e~dtaw3J-zS0235302353epcas5p2p;
        Fri,  6 Dec 2019 06:53:15 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.0C.19726.BDAF9ED5; Fri,  6 Dec 2019 15:53:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20191206065315epcas5p31cea423889a39b4fc4b350fc0681fe7c~dtawYrgE12908629086epcas5p3H;
        Fri,  6 Dec 2019 06:53:15 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191206065315epsmtrp2b5dbafa8b0166cec4130e1416ceb3532~dtawX8Pkf3273732737epsmtrp2Z;
        Fri,  6 Dec 2019 06:53:15 +0000 (GMT)
X-AuditID: b6c32a49-7c1ff70000014d0e-30-5de9fadbd8d7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.C1.06569.BDAF9ED5; Fri,  6 Dec 2019 15:53:15 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.85.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191206065313epsmtip143ccef58c0711e68d79f29240247ee72~dtavAIJ0r1340813408epsmtip1Q;
        Fri,  6 Dec 2019 06:53:13 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     "'Dan Murphy'" <dmurphy@ti.com>
Cc:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <rcsekar@samsung.com>, <pankaj.dubey@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <f0550b0b-6681-75a3-c58a-28f5b7ca0821@ti.com>
Subject: RE: [PATCH 0/2] can: m_can_platform: Bug fix of kernel panic for
Date:   Fri, 6 Dec 2019 12:23:11 +0530
Message-ID: <021d01d5ac01$d55f1220$801d3660$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQE7rWdEBMvebVKOOOKqXHxmn9mClwHtd6OFAaMRhhWoxCE6wA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsWy7bCmlu7tXy9jDaYtN7GYc76FxaL79BZW
        i1XfpzJbXN41h81i/aIpLBbHFohZLNr6hd1i1oUdrBZL7+1kdeD02LLyJpPHx0u3GT36/xp4
        9G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov07RK4Mp7tOc9S8JS74vem96wNjB1cXYycHBIC
        JhIvd2xn7GLk4hAS2M0o8eP7SxYI5xOjRM+NZ0wQzjdGiXmn1zPCtKx41sEGkdjLKLHn2252
        COc1o8SHW0fZQKrYBPQlpjT9ZQGxRQSUJVY1nALrYBa4wihxeuoLsFGcAlYSfasWgRUJC3hK
        rG9ey9rFyMHBIqAi0XBODsTkFbCUOPJDFaSCV0BQ4uTMJ2DVzALaEssWvmaGOEhB4ufTZawQ
        cXGJl0ePsEOsdZI4f+oVK8haCYH/bBI3Zu5jAZkpIeAiMeFSAkSvsMSr41vYIWwpic/v9rJB
        2NkSC3f3Q5VXSLTNEIYI20scuDIHLMwsoCmxfpc+xFY+id7fT5ggqnklOtqEIKrVJKY+fQcN
        NRmJO482Qw33kJi84ADLBEbFWUj+moXkr1lIfpmFsGwBI8sqRsnUguLc9NRi0wLDvNRyveLE
        3OLSvHS95PzcTYzg5KTluYNx1jmfQ4wCHIxKPLwzPr+IFWJNLCuuzD3EKMHBrCTCm873MlaI
        NyWxsiq1KD++qDQntfgQozQHi5I47yTWqzFCAumJJanZqakFqUUwWSYOTqkGxszj7+e9Vtmp
        zFXzqYDJ+dSzc1djeT210l7JMs09kH/w0F1z/0InRfa7wh/CZrjds2W1+3H2/KNHSvxfcsUj
        Tb0P2By5sie5y/ZswknDLSVSvTll7/WCeiYedKt5UnpW9sLm2l23dr6Zv8Yh/WOzp83kC3oz
        qqS4jR/G71B8q8WWsNHfZJWcthJLcUaioRZzUXEiANj0qoBKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSnO7tXy9jDU7OFraYc76FxaL79BZW
        i1XfpzJbXN41h81i/aIpLBbHFohZLNr6hd1i1oUdrBZL7+1kdeD02LLyJpPHx0u3GT36/xp4
        9G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov07RK4Mh73eBS846q4P+8bYwPjDY4uRk4OCQET
        iRXPOti6GLk4hAR2M0p8fbmDpYuRAyghI7H4czVEjbDEyn/P2SFqXjJKrL/6mxEkwSagLzGl
        6S8LiC0ioCyxquEU2CBmgTuMEstPfoaaepxR4s6Df8wgVZwCVhJ9qxaBdQgLeEqsb17LCrKN
        RUBFouGcHIjJK2ApceSHKkgFr4CgxMmZT8CqmQW0JZ7efApnL1v4mhniOAWJn0+XsULExSVe
        Hj3CDnGPk8T5U69YJzAKz0IyahaSUbOQjJqFpH0BI8sqRsnUguLc9NxiwwKjvNRyveLE3OLS
        vHS95PzcTYzgKNPS2sF44kT8IUYBDkYlHt4Zn1/ECrEmlhVX5h5ilOBgVhLhTed7GSvEm5JY
        WZValB9fVJqTWnyIUZqDRUmcVz7/WKSQQHpiSWp2ampBahFMlomDU6qB0WOGT6B/UYJBnLa+
        27I3Egt6m+4oaeiVbKp8+2dLgmLvztsv39u0qmjtYehbcfRkqSsve31rBJPpZIaZh+TeVXbf
        fR9r1syjnr/C6foSzarLcy52i2378Yy/uOinz83LLJWHFyiYMIYHaPlt/LJEsiO9/kn9z8yo
        5xu8HtU96n2qe1OyYfVhJZbijERDLeai4kQAEzTZGq4CAAA=
X-CMS-MailID: 20191206065315epcas5p31cea423889a39b4fc4b350fc0681fe7c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191119102134epcas5p4d3c1b18203e2001c189b9fa7a0e3aab5
References: <CGME20191119102134epcas5p4d3c1b18203e2001c189b9fa7a0e3aab5@epcas5p4.samsung.com>
        <1574158838-4616-1-git-send-email-pankj.sharma@samsung.com>
        <f0550b0b-6681-75a3-c58a-28f5b7ca0821@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Dan Murphy <dmurphy=40ti.com>
> Subject: Re: =5BPATCH 0/2=5D can: m_can_platform: Bug fix of kernel panic=
 for
>=20
> Pankaj
>=20
> On 11/19/19 4:20 AM, Pankaj Sharma wrote:
> > The current code is failing while clock prepare enable because of not
> > getting proper clock from platform device.
> > A device driver for CAN controller hardware registers itself with the
> > Linux network layer as a network device. So, the driver data for m_can
> > should ideally be of type net_device.
> >
> > Further even when passing the proper net device in probe function the
> > code was hanging because of the function m_can_runtime_resume()
> > getting recursively called from m_can_class_resume().
> >
> > Pankaj Sharma (2):
> >    can: m_can_platform: set net_device structure as driver data
> >    can: m_can_platform: remove unnecessary m_can_class_resume() call
>=20
> Did you CC: linux-stable for these?  We are probably going to have custom=
ers
> picking up 5.4 LTS and would need these bug fixes.
Hello Dan,=20
I haven=E2=80=99t=20copied=20to=20linux-stable,=20but=20the=20patches=20are=
=20already=20in=20linux-stable=20branch.=20=0D=0AYou=20can=20check=20in=20f=
ollowing=20link.=0D=0Ahttps://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux.git/log/?h=3Dlinux-5.4.y=0D=0A=0D=0APankaj=0D=0A=0D=0A>=20=0D=0A>=
=20Or=20at=20the=20very=20least=20see=20if=20the=20stable=20automation=20wi=
ll=20pick=20these=20up.=0D=0A>=20=0D=0A>=20Dan=0D=0A>=20=0D=0A=0D=0A=0D=0A
