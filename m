Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F6C3D7E26
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 20:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhG0S6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 14:58:04 -0400
Received: from sonic304-22.consmr.mail.ir2.yahoo.com ([77.238.179.147]:32936
        "EHLO sonic304-22.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230334AbhG0S6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 14:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1627412281; bh=6hU2ULlWyMYV2mKH2ObUN+H/LxyhPSxjeSU/Kks8ODQ=; h=Date:From:Reply-To:To:Cc:Subject:References:From:Subject:Reply-To; b=pPlXHxH/Ivg+cfAuWY2dTQpJT1ZHFqtYtba8FajVns34PnMIiTeYTNcaa9qHbHAZJAl5Bf3jN2zLEDTfqQbhP6oJFps1+M2g8Udq3WLYgQ6J+YA4gFLmCJLOPXdNz/gQAI+BogYhGtt58bGMov7U83FHKYYg+ZahTSDtZlOmiv7Og66OTV81F57RkqWiaBURxqVE2uwJwVW/nhl2/S/K8VbhYMw3faaONk6HkZ5ygg/mgmgWsRk5YfyZ7Iz9CI9AmoQLR7rvwNtKLiUb3QDweqcbf+CAktAE4QEUxcMs71TUHVeegJKF+Z1nN3U1+4Yl0JRN08PrmAM4pA4OvotZiQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1627412281; bh=iXf1Tvb86Uo4EHCPcDxQVueIPMsytKqtnQvCNsy9EZv=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=QD99amrpUIEz2D8jjk36ELYxUkH47ztLLvqF8KLLcyJrxHnom+bTyyGdA/LuoN/Lv3L00Fs9QJGEHp1+5O4dwUFbSgJP7aniM8BdYWtgaDIDpxTXpbtakXp8pT0ZCj8YsdkRdfvv52Iw0lQqP5TOcZcF5e6CTQxc+j23lxvNY0Z8Iml+uveUblKgIL8hcHwHGqi5Lo2fRpqStshbpRly3ypMYoNLuVu/gjQK5MG5apkV2FVFRVM7VdZC58p+BeNt1kaiAs3mEBNRWwohZ3ckDC5gR0NocrC3iyKa1ZqsdV/DOH91HE9BFwcd/e5TUh3jF7CWxOIMP/pEjOV7utzk9A==
X-YMail-OSG: AOolPz0VM1nSe.y5fPp2AT7MjegTq0xVH3SCfc8V0hP.yDDyQieNRn5GEixTgrj
 2tccDCArENXpGJtM0RJ5FKEtle_Gci1M9oQQs2HBdVnfPU5.0o0TcZnU1SwnAs1W7rcBysC_xq4e
 CcqR2YWCRb7lzH6s1VjLHpnGo4HS8jDizH4GLYTN9z_z2CJJOYHi.M8L3qr6Oe6kTNu2o8Rf_.Rt
 9vxemgYM1gkr4Tk92yWg3jLu4tHMeFhIiy4t44mmhSKrWQWDsMepAYdKSUtkNekOjtZCzF4Vz47T
 x5WNscuhseq69s_k.vdRf1ABxxxReQzTKJoikINgBh0sNVdbaj.X7qczWrIi.BsNF8ZZlYnrAdIE
 naomj.94ADSkfESu4u5zd6ZAtdWkVqXzkvO2RGq9WlEmiK.GVDnTOJwtHCWALeqM62sACgtUT9CT
 I2rgFo.MDNJRgtle3eGcmJv4CICn61yPhZe25q60MbTOk0jTJ4JbDGRK_22CnA_WRONGkxWQVf0y
 Z13rWN1J25l9vkNritrm6nNxyrKrYmeBvn_sUuC1YG6YAx922ir05OYMVv4VO7Hu_hhKj5DoXPn_
 JagCPtfb4W4HpmKfY55nNQOmdtykwtvd51XikWaW6MIi0qMhBesGOg4c5JQg_Z6MKs2lFQm5ui36
 Ttr43lWtJsHMXR1N7Fk4I98xakcOVzGLmFVTQZnl2beY9PHsNhJf2WEES1Qd6RBjky_w3qR8FNnP
 PbFm34O4wxqVp7Gq.XWDYX4Nly7jSQbYGyO61KfkrnDU9uSFNhGtXyZN0H288A5skjTMtWRkdeGn
 G6ebuSbzbAPqlZVtLk0kG3oUXjolANuF4ppHMIAPPVvRPNa78L0cStNa.JN.Sp9TNAAiOYdPpqX8
 PjDmbbg7LvnPb2pWVq.DnzGDrR87X1jq0Vr2UDWpQZYV4_n1t3.hiPoZnm7z8xpA6tC0ILWAJl0p
 s8ulx1KUvxma8JwAa_qszO1Jsz2C9rl_lJ3CiDoxtNpJ6AI0HZULpXb6WTILT3Gj0o9EXefkKS9I
 pomAd6t2kloI5d1m5RtsBLwRW9qsWCzisI33MxnMLrZlyhlbNf16cV41Ox1GjL8.jqb5iW2efkoj
 Q5Ql4FD6999AjFD.uZjTfImabj7DYPX4WwIEce8IZkBQ6IUxxJRXyAS5GjRQ4zYRDPaee.3QlMY3
 kTUHgEnEroXDsJHq1Zpf.4LiS34soPYZ0dsZwc3n9UlFhz3C9zwlc61U11tutKtzKflEnrP29jCX
 zHfHK7esIQFGmCArHX7JkTPNtd_IT2x3nlXngm1VOTRyOINl9CaExABK6Z8IYwDZhj_A77Zx5BRS
 GuCv.t5P40ag3J0VgOVCM_iQh.JhGfcgxj96rFxhYXQ.2nqOpPbMoGGaSW2.h9TxI8HrBKZnQatX
 d76JBExqX1r1OSmRxjXF4QUok1pzE193H9GIu7ZHNDaC05c.uV4T01Pc6epnGl0KBt6C6_AlFjwC
 HADQrcDyONdxHM_hW2wHpQovksAVQhPcXZCbzjLAhwMPOC4aoi7CcxPhKIsv7esvljMC3gXPsnGz
 .w0pCQOMe7WrA8DNdWuEaVnPPLG2qFv4G02BdzyB9NcOMcw5r2SU12AOoFhEZBDooM3i7YaIv2xO
 u6ptA5NhuGDA_pxC5KNCA80JAfC5wD25.DkXNWnTVDdfvUtj2Qo6e7RBmeEXh3L61wByjYZRyiB0
 sv7N5KM_E4Yx.zIoWyKmPb2W6zJoVB33Oc9dFcKZwwhwbPc3tNm1.TlTp2ouLyI8RDqk.YtwXAy6
 zHelitb6GUPES9IeJFHQPtp4zf59f1yt_0aMGESMyXVaBl4QRKDkIifkHt_kffHH1zl2Bbcq.tQA
 Aq788vXtzyTlIIKiKmghrMOjLngR7ugo2fXqmoHiZEq_KhTYU68JcB5dPtJK519yO3KFQa38IIuF
 Urfh9zte0IYrV0E4eAs3vHsfZPEI0kmz9tE0wIXlmD6rlLjH3WQU6___.GOj2FDBIvioqaSCft9K
 SvDgsip1jOmvjpg6sSNZILppUBy.UxiqSxFyOxXD3IVHQtSimjytg2eq1G5Kc_kVG1ySwx6O2f7U
 g_n50oSf3gjsGtlfg1s5_UxXdd9ip3GpzJ9I863vMuAViDmCOtd6ev702TJw9kOS2G59pl1F187K
 QKtiSfH6o9ZxbFgSercDzkPUmRikFKQX.RQGch3fPe1Ngwr4iRNPwnPQm_qeGtXKBWWCZBzHpA9Y
 wTnClL0xt6hRXeRUu2oAvZ_1hQxJnD4Bqh6d2X1RSXpF_v1gFhwmDkIXh4O3P_3ehgKwnTJ2J9Tp
 9cLRf_Wh7RIJD2kJodRWqAU94we1FLLzmg6SZ30ihjhE70rROmvdxEmeF0ezpne3jdkx2PaqYY1b
 RVxni0ZDIOPPa9k9kip5xA0hYDY_4K94CoV.adi9ydbaVudY3PhQ5DbKW4CArcReIfOZLKJMK.Ld
 lh0U6vrbMZr8_P3qOEAlc3fJ22zZTo8stDj2WFjm94r2RkphSJssGozfjPmD4ifP2VAcTszc23qD
 aMjruldFmIaF8xzqjLbgihkHhMFknBgAGnN7SK9qEv48NOo81ic9OTPSsW__52YmWV67IHzg8FTJ
 l73c8roJ1pbvL9uXsbYTO93NiFy2tBRad0TYdSf6s2u4UPSk_Y3mbYLY1kMuJqcxyj_75xaED..I
 nm.wnca1Z6IO80n7JXwmYT6ASfOn.XNEcN4UGuqQOkXSbnEJIRWiHIckTz04fp8yZSWa0.poeMSl
 RZooKLKelZlSXI4Hi4B.kgMlu4rNxrlpl4hqjL3RgqA8GpG2oGuhW2DblzPOa2HKRH8dSehwxYdK
 h4ZL9zHL3OINslyf1eyIQa0GTNna0AJwAfbyyz73SuM_E9eP2Vdf2b4xL2zyvXr5ioGFZJqxlZGv
 SXCzsPBwJNidvOcxDC0VJZK7vl5m9sjuo9K2t.ND8Vu3NwnxZ
X-Sonic-MF: <htl10@users.sourceforge.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ir2.yahoo.com with HTTP; Tue, 27 Jul 2021 18:58:01 +0000
Date:   Tue, 27 Jul 2021 18:57:56 +0000 (UTC)
From:   Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Larry Finger <larry.finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        Salah Triki <salah.triki@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <1490129435.403938.1627412276697@mail.yahoo.com>
Subject: Re: [PATCH] wireless: rtl8187: replace udev with usb_get_dev()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1490129435.403938.1627412276697.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.18749 YMailNodin
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > On Saturday, 24 July 2021, 19:35:12 BST, Salah Triki <salah.triki@gmail.com> wrote:
> >
> >> Replace udev with usb_get_dev() in order to make code cleaner.
> >
> >> Signed-off-by: Salah Triki <salah.triki@gmail.com>

Nacked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Seeing as the change does not add any value.

> >> ---
> >> drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 4 +---
> >> 1 file changed, 1 insertion(+), 3 deletions(-)
> >
> >> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> > b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> >> index eb68b2d3caa1..30bb3c2b8407 100644
> >> --- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> >> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> >> @@ -1455,9 +1455,7 @@ static int rtl8187_probe(struct usb_interface *intf,
> >
> >>    SET_IEEE80211_DEV(dev, &intf->dev);
> >>    usb_set_intfdata(intf, dev);
> >> -    priv->udev = udev;
> >> -
> >> -    usb_get_dev(udev);
> >> +    priv->udev = usb_get_dev(udev);
> >
> >>    skb_queue_head_init(&priv->rx_queue);
> >
> >> -- 
> >> 2.25.1
> >
> > It is not cleaner - the change is not functionally equivalent. Before
> > the change, the reference count is increased after the assignment; and
> > after the change, before the assignment. So my question is, does the
> > reference count increasing a little earlier matters? What can go wrong
> > between very short time where the reference count increases, and
> > priv->udev not yet assigned? I think there might be a race condition
> > where the probbe function is called very shortly twice. Especially if
> > the time of running the reference count function is non-trivial.
> >
> > Larry, what do you think?


> BTW, please don't use HTML in emails. Our lists drop all HTML mail (and
for a good reason).

Yes, sorry about that (I got a few bounces). Yahoo (where this is coming from) seems to make it quite hard to send plain non-html e-mails. See if this one gets through.


> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/

> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
