Return-Path: <netdev+bounces-478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6750E6F79BC
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 01:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A2A280F72
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8680CD53E;
	Thu,  4 May 2023 23:36:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A81C142
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 23:36:43 +0000 (UTC)
Received: from sonic309-21.consmr.mail.ne1.yahoo.com (sonic309-21.consmr.mail.ne1.yahoo.com [66.163.184.147])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F01512E86
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1683243401; bh=BAi4uS2WiT10qtC/CKY/kibMDj1d2qG9nAXyjlNXEv0=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=WoQQniL1340wR/qBQKAtUjy1Mg4UwCSTddReryJ17m/PZdSXa3tvsKAJSCzA8oxpiGPcpvyU5ou/wF07TyPv+xR/S6qfUv2iATpiyslkOMORByvRSa+kZJF1Eu7BTPNiv7onaEkcFp/kWmVP9/UENi4t3CHqPplUiH0CuWNB4oVyBCaajkYbtceLoUfPDmoqHLFHJg4Vh7m7r5XooyYKKaATsnettC32g+rMTwjsiqbcVr9Deima+a0OgBV+nk1u6psRsnh4nqNHoAgglLHla1Pb44jzp5jk9GkPFToaYVCMFN+qreQsocx/I4ZbPp4dNqQGJZ7oZBGA2qLZDegFXQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1683243401; bh=SZTCgP7D1xTr/c5Lq2SznugxsFDF2r30igHE+Gya8lm=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=FbYwvkfCPfGLRG4N8XvuU8FQRWbx3i/LO8akhnSm1cl2bop0DR3Sm9Cg6veF5s+a4RPaUi0qJV532B7FsA/4Lk6krkQq1L9mQtQPE4n9fZ7+oXaqPZFCYVwXLKBHx1TzID8kdRfIzX/dpJCwlfRB8qZI1Fhzf/SWVqQHNQTvW5nBl+8D9f/5V2eE+Pe+X6NlIw8V90C99s9njLDJ60dNj7Rr45M9GvYsVD4jYve4+iwtO2Fa5JEXooAgpO9dKDsvO8lHfGZK8mY3WRURpNzDm1OOnArsn9+EWSbQ/Mug7kSsv339K4WeYnWT2+Ls1jno/i/Nu8J7GOhw3y9uJTzS5Q==
X-YMail-OSG: RaPl7.oVM1mAmL0urcpKm1WZj0eayxGBDZOgWtA6rAyWbG0Jdlj6OJQKK1vSPfV
 cI6qq7qUYkgN3gl0gKe0yzpSvv.3O6Ykk3SVn_bNmbdKq3WV6zUPn8gPD8bgSUYLoCt8s.HHokOl
 RGlq2Q2DEtc_wRqpK7FDnCuFXG2Pn5Vc7oF1KgE5o.NKN4FxWML1y_sTBpw_IwYJ_0rxKfJZ.AzG
 NG34mcXEKyti.PivMScYTIS6Txq7hYpyOYmG2jVdT70tFsaBhROJBN9cS1TtEOlfq70BAqu1O0YC
 SkWQAVop5AIig.Rb_0_PXIIiAc434DX56OAULVH7N_o6e21rDYSEPFCDNajxKk9E9XPZ.Zpk_gzV
 TQD8.RbxcxQI1cz7NPRnFIygaD4n_z0hzzn5RkZaG5FgpxC68cP_MGgalUZdemBLITH8xmnUmXPF
 jg_YrV7xb9qUadJ2B13h9KQZ4lAbTGpujzG99SrUUUBXfnsQ3LTycMvCuskY.WluGEZ_lgBQvYqT
 HYG_N89hDSX4VuwEyUs3dJaovGZCutuu_tuHXhf614.ykNzMPnN7hZ1obMD_fq.VjRITwZeGm2D_
 cc3bi7vO2xmnRtputqrMjuLJ9F_5u0mOvmFBctd1ixwQy.InsPFb78rEkNToa0FqoOHejojbjn8I
 o5iJ1Mzg12TIVfOZnG4.kUcDHPO.fH53Zly4SYLNcpFrSq3uqVsxozXHjiesYxboEntAWzQksNeK
 fiBEmKy1lGMuh0YZQuOUCOTDwWY3_LxAs8MjZY_byhHTSq3MdLy8BsshNQdYKZc6IXinCH7ZEAL6
 XmO8ayGwc1gbZQmx8Px5u3cWgoGiBzASKrUw1UcW3lQ7mpo0vAXOl9vxKvC9DYzhH2C2wVsQpmBh
 my.6aBCRykkyUpYut2CQ_xBuNxSe75fbndIgEAYfMxU5EcJv7PvuB0FGzmKO8Tewr1G_XF_9fGki
 yVeNmJTIpsAaDTVGz0EGHdB1i7bUgpB2YRUYpjvAGEFhRU0Q32IARO4idDMPw3hoPJXSylEISwvG
 YHOe01HWDB.lKNDbwn6CeOPwXqKcpwoalc6eyOb9Drs8UwwbpcsgDrkr5smDiKXqqnTSNmenkUgk
 Ybbmkn6Rgz0OzR5D7OqaxdTkV4_9JVy8UyUMkHhUXoG7iu8ocKitOHXSEKVr6CHqiJ57oVSNGexu
 4ACP_ziLfvSi.DXBCsQJnTBTaj9LNU_.pWat5E91vaKnMONJK_2Pp1Xiq_1ilWMRf1qr32TwAWzP
 NldqiU7zLz.LzNsp.eZ5hC4gpRtOXYvJX3zGyfFcyR7eFsy4omiie6fJ4_vM.iAn1wn50uEo2sXW
 NyNekEt90guqvUzJWrnMY7iv_NCLGyXTPIfCTr0dr8Fq.iD7P1vddYcliWmZ96XXqxJvshoJ9wd.
 ICbYyW12qrGFFCwvEu..xl8mWbt.MfmweT40gWUF5mcv.uqg2uWsboBotRT3Y5u9ciJjq3JHJ_Xl
 s9lD2qA.QcX_YM9I91WclCplDUMW5s2bx0K92CuGYw0ODRjRG7hicHpWuD07OKzayaLMbnW.joJg
 cCdE.pBy_hxwXZfpV6W65OBADC.Q5cj9MGomjaYAOU2YFI1ktyURGuhXjnDBq4s5HAjenXdzx4OR
 LfDyxyNq446SRMv1v6ddhtibW9ViLcdMlIWREGYRuRITT6l909ouuTRgS2IgYlR3PRGTMlbn52CU
 xu4H_WXttRg9tt7woTXX_.q2QT9wBGwGZtBsNzOpsILqcikvUxxmVIqDIKyZg.5UWK3TYGbmUoeK
 AE8pXajPgPVqjy7Xij40ReTQ2b8H7BZz9gXIokJTzbylHPGUCOz4ReG4PMAxRIydbfdY75sxfddf
 1l3UU8UTv4blAeahfGdNpFS.RDQkU5JA39fqtgPuDCb7HLsufafpGeInSdr5a2ekCYfxVETqjxT3
 K9vhxwQgPRDss.3uiXjkOsUnLUL.eJgI8SMLpqZabUN7CxwQbHEhqPzIDvjUlsZsiRfKP3e4oGB7
 c9qkDw8rSXkkC_TfUSrsO5nR3TRUJWKC2ZFhGCBFLdzxPMMbJFcVS4T4xWbH6iQ_dUktpyjsqwqL
 o5CaXhEZGZN9LrM2b2x.eySjcIH_f0p_8zbsz_ThXI6hT69EVEEYBY_TfW3dxtD7tNBB5nNwx.i.
 WeVnUT9_o7mgmfBELSdW0_Hv4DjgS.7E33vRW8LjPU5FiyvVOTVA.hqvCKLGxsxXQO99KP2nrFeu
 PZvRo2wg5iyWF2r.KN.S1pkX6vXOHXIFGE6Jh4viCW4RCgm9A
X-Sonic-MF: <schneiderman.richard@yahoo.com>
X-Sonic-ID: 81f5bb71-aa0f-4a9f-ab87-87127724a337
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Thu, 4 May 2023 23:36:41 +0000
Date: Thu, 4 May 2023 23:36:37 +0000 (UTC)
From: Richard Schneiderman <schneiderman.richard@yahoo.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <533870578.436621.1683243397555@mail.yahoo.com>
Subject: r8125b ethernet hardware
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <533870578.436621.1683243397555.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.21417 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi LinuxDevs,

I have a Gigabyte Aorus Elite z690 AX ddr4 board.=C2=A0 I'm sure you're fam=
iliar with the r8125B ethernet issues.=C2=A0 So on the 5.19 kernel, if i ru=
n the r8169 driver i get a disconnect pretty quicky from my ethernet, aroun=
d 20 min,=C2=A0 If i compile the recent r8125 module from realtek, i can ca=
n just over an hour before disconnect.

the r8169 module seems a bit longer using kernel 6.1.3, sometimes an hour.=
=C2=A0 I"m using mainline installer for ubuntu to switch kernels.

So hear are my questions.

1. Will this ever be resolved?
2. Is RealTek working on this.=C2=A0 Even with the win10 drivers, i'm getti=
ng disconnects but the connection comes back immediately.=C2=A0 ubuntu requ=
ires a reboot.=C2=A0 the 10.056 windows driver seems to be the most stable.

3.=C2=A0 Would you be able to set me up, so that i can be of some assistanc=
e to resolve?

Hoping to hear from you guys.

Thanks,
Richard Schneiderman

