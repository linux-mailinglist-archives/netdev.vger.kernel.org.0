Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAC44342E0
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 03:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhJTBbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 21:31:49 -0400
Received: from sonic313-10.consmr.mail.ne1.yahoo.com ([66.163.185.33]:42984
        "EHLO sonic313-10.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhJTBbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 21:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.com; s=a2048; t=1634693375; bh=5jUdieFX6fYJl4buCpMSjviV+fr+b60BjVABTvmyRww=; h=From:Subject:Date:To:References:From:Subject:Reply-To; b=HRo06yd9tCre+P3yejuaOPgn5kpO+VJr0qNFS3CLU7ALIlomjwxvpq+KcLzQRpi/LWWGW0niZNMHiiJQUeshbDDCxqnVBUF+hTtRTBQbq1We0KIqO6Qrqihsp58khUAUQ2m+E0xsIAoYZHEE9lTgWspZwa81ix41xiAFpzmVyNacstk/oh8rHq6DErRqHwjwVGTxWE8qTPTin+OfPRKjwc8WZVwsF9su0Z6JyVC3VypxD71MC89vquYtYju1GzuPztxtgUGqeHj1/iZMrNirwuinKicX3DDPiQCMYXDyYQO0dRyGeOkZZmdGeNbgQVyFjbhFaZOTGn/whBnJd9bd8A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1634693375; bh=psck61r/dvK/B97RrXe53N5MtORJG+9iZdzr+TrJWWq=; h=X-Sonic-MF:From:Subject:Date:To:From:Subject; b=Fr7Zzp/gSKtOIdoQzd4g+EPjShaqmtYhwXG0jGCLtO4R9q7/7k92HVRkN/9t1oUwENLCawh2m/mCHW5tshxJM0bJuRIfMKlkw0Xk0E5WFBT5bqmBPN7e31NIeJUr2WGPgY7ItmAcDoHDdIfA5IxsVCdHcApcq/j2GyHZ2VJDQ2AcV3PO5qP0gP2okn08Mwf9VIblVIFLFgvuHgC8z8SuxIyRHazkTsn4jctb0xJ2GC6qQ8WS7eurZsGIhvkv8QbXQzdfPc3Xab2lgzRpdPwahqHSgmWz5yWvmI2CylcEZiJ4trxf2uWTNsIhatvb5cB1Xs9wYdYRY73AAJr0Dnccew==
X-YMail-OSG: KStiZO4VM1nRK3bbQnlV6KLK56CUC2jSX8foZZ1tdkZ.aV6mP2gcfnGPjru75VA
 FIpRz0qBXfvnTloCGijFtOxdKW799QdfURfFIWDU6CwbLRboTx6rqhv2i3qlJ.wykaWxC5GPaCxe
 xwjMLe8lOyvbIdGcuEStx4E2zZxRsj.6NhItEmoqz5Ug28HCqXFqlVkehvJhEXUWfu50OmDznUXF
 H8IrHXg9HTLs1oqCGI4bTUTCWuhrNNq37hCM00MlSvnn.PXM.ZXkEKQYDPKYkM0L0EPrxSMN602p
 VaaGQ9z1I40Kp8XaFoF9Hi7Zho8p2NKKT4DWVBxesZJS4pPFxms3.nM848D4MCxfVhS5yg_szK6U
 A_g6PxEFwlcoaCy1kRYsXkstW91hY3zhd25PVfPMmRNE9oGxhqRuL8BKE1BnqapscmL6U9RLcIEC
 EhXv9qdOIw5f9FiWIVxnkRvb5pvbYzestUp9jKrQVLgxJmD1Z7os98crxkteM8UTpXWqXGhB1HZn
 xJNlnnvgH3Gv1TTx.X5sbKKWDYNoOv1TZ_t.IdnDN3US_oH4VFsByAZPsBf3IuuiW3GlOB2Mlgg0
 k7zCjwV8hPilUUymanAIX6V8kyeCAxMsGOOeBzbDW7ZXa036Fr5_gy6pjGOBMcVTR1_oXHxu5an4
 gH_mweBfbGYjlVuAI6qIQWT.Ox4L3wiNuKGCtXbadPLgeynbwMG1rkmpz3SpFGE35gAvlXGgC3h1
 .6G78BFdxhyM59st5pH3bJ62Ag6pwWlxUIp8tPZGKEozrm.naj0RtNgHp71_gnpfhoUazUXbBqH8
 uH5MwmJ68ch7S2A2X94pqlkseQmECb5rwzr4fMgb.MS9HUZHYaaf3ozhx9MrOLykbbJLZxYDusLf
 dYfc3iMjRSEWAgevrK6y.zODPq_oT3SSc_n.tVl2rrET0q4KlGv9SlCyhapNPPt3pCEzLEslSmPD
 .N1ee4kkf7aGpH6y7u2LOaT79rqwVNnXR3wQCXwkVydJBdQcJvoGK.DEz0oPGpW3Pls_LaMDn.vz
 bx2nACJLT20x_vsw8Lp.DehG8suCrhD6nnX5x9tc9w5NXo8iU2dwQ56Bfd.52FULcPJLtHC5aRAd
 3ij5ZQxb_7nEjtlHB_5BZn6k2UPSUFH0ayrfnuhMIjlNkXq5ouTLsN6s1y.7VUTLSiuQRow6Jeoq
 sGDUbqeSCGRtu.6GafnWxpdntjr.9nVLmKLMdTvVFi9w9xS.qDR4JdL0ZoD7SKo5qdyA3OX8TRkW
 BRAlEHmK7Hpmxu9MrBDhroFq74L1PXUYCZoBF9OxTAMtvEka58iMm_mtYa..Oylvo9rYM1qJA1Xy
 hq5I0eb.gCS6PLBp63nkLBECPshID.s5Zml6O7klO8L74xGZJRIwu0f0w10_6xra8upDEYMH5Q8N
 NbmBTX8GsEtDfaKN8cJTsHRnfdnDy7oKfzCdM2LiLxf9NuxqIQzu9yZt_GuCBnX8qJ9vfaIkm0xe
 pL9CcNGk3CFNOe8hwou_nSxQU6I90abdLAXNMlTpQ6V6ibwNzkDPOJ6tPrg17ZVzwPSEj.j41NUX
 66GSQI8pjS33P7p1rBMA7GeSx37N1PEKp2l5039U4B1ihilNyhD57fCTJq0LaH6Py2tYZylPIZig
 BhP.skPsn0KKweDyWBoEeUcIE0DnE_eN9TDiHRNC5a40GZbOUbAgILLvMTtQKkfNGrPkD2H2jihM
 l0wtsHvM5DKjY_eNY7eIfEEGXy86EIfqGh_3CBMECw8goO9eF2by.o.xbm.CGV_3wNwb1N5FqWwP
 k0_DHvQbEjjQ7t7eBrAlhptoHbqMjB1pEF0T7YBurBAmCGqWjXP3L8nHgOdt.DaqVOxLCaEsL6lP
 rJmX9i52IGqQVeIJDGV2XthOH6NqC_XQy15F03WnmXMaSDcJFK1gSi2rz4ko.fKntlS3tyuOUouZ
 HByN8mHw72_Yjc4JCIaqBKoOMlHINhIpwgNsJ.gt1qDg1jTA5AVcR2EToosDuU5Ivynvczt4H7_u
 Htq3XdoiAJ2nqrUtV4AGAZ1At4wCyBduG7NVNjZCXe8NsR0r9WWIHakyq3EYBivl7J1bh3rs0yCN
 MRcYar5z6BNAKHthiH0vtriWNoxy.pIJ8D83hP2j6Ft58SOFFRfOF2ANRsGDmoKL6ag4yaimQWxu
 BvVIS.pt34yLZYwl0npG..bLLPtzFPkw7m10iTfMQUvTIWoMbL2PFYKAs0EHXjfU._BCUO06801U
 yY62.jA--
X-Sonic-MF: <vschagen@cs.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Wed, 20 Oct 2021 01:29:35 +0000
Received: by kubenode533.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3688122108f771e4283fb5e66fea5c34;
          Wed, 20 Oct 2021 01:29:29 +0000 (UTC)
From:   R W van Schagen <vschagen@cs.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: DSA slaves not inheriting hw_enc_features and xfrmdev_ops?
Message-Id: <CDEC9628-69B6-4A83-81CF-34407070214F@cs.com>
Date:   Wed, 20 Oct 2021 09:28:40 +0800
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.7)
References: <CDEC9628-69B6-4A83-81CF-34407070214F.ref@cs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

When I register a master device (eth0) with ESP hardware offload:

	netdev->xfrmdev_ops =3D &mtk_xfrmdev_ops;
	netdev->features |=3D NETIF_F_HW_ESP;
	netdev->hw_enc_features |=3D NETIF_F_HW_ESP;

Only the =E2=80=9Cfeatures=E2=80=9D are inherited by the DSA slaves. =
When those
get registered without the xfrmdev_ops the HW_ESP feature is
dropped again.

Is this a =E2=80=9Cbug=E2=80=9D and should I make a patch to fix this or =
is this actually
a design feature?

As a work-around I am using a notifier call and add those features but
I don=E2=80=99t think this is the proper way to do this in a production =
driver.

Thanks
Richard van Schagen=
