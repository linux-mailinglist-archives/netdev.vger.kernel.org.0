Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E13A439F04
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhJYTOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:14:15 -0400
Received: from sonic309-25.consmr.mail.ir2.yahoo.com ([77.238.179.83]:39031
        "EHLO sonic309-25.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233228AbhJYTOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1635189110; bh=QyWIY6pEFThT88EmytgW3yM/+P9YYjDpyIPGVYXm+tM=; h=Date:From:Reply-To:To:Cc:Subject:References:From:Subject:Reply-To; b=ST9YuZN61sCCTCjyKHLQvXfFFWerV4cX/Xc7GhEPxRyEzToikwWVQBbyvezT3IKzJEoROgkoKopo6OkiB+OFakSqgiT90fHpn6zS8g2WSNGNc/sItDC8L51Dkz9mjJ3c/ef6+gzaHvCKfARGnwjjh0bCfUXM7vDD0bstve2Cc04Qmh+XAGaC65fPNlMNWyNxapT8IB4sSuSWhLpcISVWHw2Xv8Sw/+119/ATzo6yVpLcZxnH9Arg0Q3blCCme9PXmC6jhhI5Hcl+nhauq/juoh1Z1KHv80qMFuAAyc4hXyN8gDdt4gyGbVHNR3d8yVMoJk7IynP74o+yfVhF1KiaKw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1635189110; bh=Cq39qSqfTeWmVg6oNBLor6POweV0lByIP133EdmOiLV=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=Ddpq5qd/pnWPkdCisdgpzdA6IuQTrJtlv0krjZ6NQVfwqMxQi2JLN/DWUcWjSHBQguEAD//CRwNbdXysHEWQ51jD+tw8DRoyRigfikKxP/6IAcwkXEy94BtfWuoOD2hRDQKgp2b6GyXkg7G6qlmT8S0y+B8l+QmKMt5e10QoVKN0kdSJCXUa1kd6o683100C98FPHA0aVj+QaBVQu45seSEywfie5hvBEl5n6yjDtClxDb0BeI/2lg9eUz7hk5PXYFQTopk49JYlut1Q0aVZEKbzvJKSTUpTxc52YBhFJlJo0r5vSaJmKQ6HQxutgO2DMQibWr7Cf58wN4UDaleFPw==
X-YMail-OSG: wZpuMPMVM1l2cetFGc7mNoBKWkuIVK9kqE6Yon.rxu.pIu.DwQ4oEW9_NyDGsL1
 O7KpEkJhQ1Rk3u_6eJm3NJJxa.tgsVrRKlczSEIAL.2FgZpbXvePEFUEbo434.rvfGukyGe3vdgU
 yM86Mg9xeqhC6o8Y0VZ209dRhxjsvOtUC6ir0czcCZaKSFzscVD.jDEUkmUA.Mva5XITmn1H6vyb
 XxO9jR4pvRYa1kSqvUe8YA9do1knHe6WK9GprNo7yNY_VJQEZEgBHV10W0CRlFsDH40C2XEMAK9x
 WW3Y7O15e99dLDhCZteSiQm_sHr8POgaaiCWSfSaCdjKM445YSetsmtH_i8dZaYx4p3FFvbKyMw.
 3iJNjz8AJUz4zovNLjPJcJ16mWKIxzHzAsFRgDA9QxoHMCWJ.5ojXRWMUbQmT9qIqnFAyAVTniQd
 46Xx5gQUbG9IqHASAJIEIhUIXG1povZncbPmsGa4iqHaN1wUDedQO8aXGI4dP2eWYgBEK6TC4UW9
 4JBx4u1cmMSFbW8ODTs07.XVwDPWeRHnpIZVFzdGvwzAnML35LkRD5EkhGuGpbzfQzMFHnIbH7pY
 iSHDabSx90CAM4eOKyq0ewj0.pzVib4hPh.6QrTN6AgLjeX7y_8Xmb1isneAAuSnxkz0BeCYP0k5
 U715WKWVTM0uYUyTwZuRdMr5lqyUSAA_Nc4Ata16CwS.6D1C4nFon5WlizbLNdcvWODcYEEXaRep
 TjcEWRrE5GcAYB.R037lo9ZC5ilU.PcO58m0_vsZ8gxtYpv3ZNuSwT8xmR9dNybbFdNL_5d7DBfp
 guVUB5tkhG9I2NdSWbp4AaBPswfyBE7GWK_kdxWnXPLWKVQ_C9k6x6DpRRUJwFcTZIDoVCQiqh8g
 rV7quxfSeAgnQyp.URW1O2USv_mZxRfya1WYwCDl2YDIvp8DpwF9uOkHaA_95SzJPMDX65gHGwdM
 FNqx.HG3Sp8wizscQPNs5BlwZ3Gkwe6FGSvwm53Ff1DPVWsb7XUUxEoVE3gPCxK.hdnl0lRoksAj
 MzOhHZTDe7DupUnaxf5Z37Q2W4zWECXBpwAgUreOcCj.gJgPaoAwlSUFuCW3j2UUz24EWYlwZMnF
 ifQ6TXxxOjfaYQRHXVkwQGLk_dPOm6IVkbfZs8SRD3VCpAJ1JG4wQ8njDiir9ohdD3HdUJWQqjON
 tlc0UcbEUJU4rmh0rfca.otUFPMqAe23JrMo71lV8jQHid4Vd7NU42NsO5ryOQOKbeTKSsc5vVHO
 ZfdoFNh63ChxJPtiH1TvHzNRV.D1SZVosQjXvXdys7fJ._PLRf18EJiR_NWXtJGypWeCksYQQy7d
 Cqojjout3UWrY2q6EROlFZBVU.poDE0KsJgXJOCLZYpvEawKQFPBP_ta2yh7lgq45L_K1XMRK88y
 5tybubE_JorZUgYEHjK81Ug3alAchmbTpYoJq2o0StCI9uFFaZeMHgrrefKR4E5UJfNmBiGiOXt8
 Uf02p.CK0hThptNovxM3DIIztZwxLdXW.4ayUr2iNmeyYDXnuuTtd99tp83wZk8D1eq9vu0yB44Z
 W2hqWQJKYy3UVE8HqMrf5CUc5j2o_BKYKJe.gEgga8pIzKsJNH4BIg3AWkwfmQRteFv240aQ6Vr1
 IBhLtuLUeSvK8HbHZrN3Dq0V.fZPar.qQDQc5lPUu0N7_7rWpBBKE1wue7dH_gxMXq7uWOBe3yiR
 Tf2yuw0MA78y3adtsvsNc.uWNEoV.4Y8_LVUt9Q2OugxXmbzbBdGTKrdONXbLiBTmC0GO09qhmZf
 ro5dkPEv9Wna5i.N_FaLAOC_iwjdwVa4lJujGLt7lFdhjwckyR8MnSHCtmTFrHLFHf2Hvo3NsQAb
 geDTOS7EXR2.2ILlabwtoJYv4669Jm7eWYnzfXGtydaDpXPhh5_D.qWC0iUtxNEAX8F.qKBhy1BT
 oeqtl17Z86yHo8p2jQ4PVj6PHK6p17LoID0mfTyLJ_mYqfX97O0L6O30J1iPY0tx6kTY4SEW9Lrw
 YtTZ9w3IaFDzq.ctpboJcvQpYIWi4yZAtJPVjwu_fBULHuYjB5QACGRtk4sjCYHHmnxtuSx6G.Zd
 xyxwI9tDGoZSYEYYrf6INtbVLYKMJijyHeQRfrvAPhLfGbOIGSPw011N5GRuS8jjiRO.jUrc2Re4
 uwqJhnuS2iwB9AESoD1XSjEj6GZGTh31OM.uor7P0lKz5fbe_r4SkIi4SpQgb8hpIg6719Ltwply
 Mo8YQxBLk9S4CJ32YBkSarvSeaQX4G1XK_KkYp6foEaorWT2OjnvPZLMzbzR3G7W8bDlKgiAJKDB
 jSRc-
X-Sonic-MF: <htl10@users.sourceforge.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Mon, 25 Oct 2021 19:11:50 +0000
Date:   Mon, 25 Oct 2021 19:11:50 +0000 (UTC)
From:   Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
To:     Johan Hovold <johan@kernel.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Larry Finger <larry.finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Message-ID: <1202359771.1685642.1635189110010@mail.yahoo.com>
Subject: Re: [PATCH 3/4] rtl8187: fix control-message timeouts
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1202359771.1685642.1635189110010.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.19198 YMailNodin
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> USB control-message timeouts are specified in milliseconds and should
> specifically not vary with CONFIG_HZ.

> Fixes: 605bebe23bf6 ("[PATCH] Add rtl8187 wireless driver")
> Cc: stable@vger.kernel.org      # 2.6.23
> Signed-off-by: Johan Hovold <johan@kernel.org>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

> ---
> .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c | 14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)

> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
> index 585784258c66..4efab907a3ac 100644
> --- a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
> @@ -28,7 +28,7 @@ u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
>     usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
>             RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
>             (unsigned long)addr, idx & 0x03,
> -            &priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
> +            &priv->io_dmabuf->bits8, sizeof(val), 500);

Looks reasonable, although I would have preferred a common defined value taken from a common header, instead of a hard-coded 1/2 second.
