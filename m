Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149BC31BE58
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhBOQHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:07:32 -0500
Received: from sonic306-8.consmr.mail.bf2.yahoo.com ([74.6.132.47]:46774 "EHLO
        sonic306-8.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231470AbhBOQCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1613404907; bh=Uz8GRnidgEXUoLSlgeR3ElSnlO8K5iYVa9AT8u/qtWc=; h=Date:From:Reply-To:Subject:References:From:Subject:Reply-To; b=nP11NyyQOOWCWzCVCSCs8pp4ufeMM8t8lgCPsp8DGemOYB/XI0p97a/q0TqQoHZ6JYnh2q98rg9a32hs+7L5q7APZ5pep6ndgT6KGbXYeewiz4vNOAQB8i9yoP5pwIU2YpTpofBsJ2l+QUlD5kCnOe1mWCIxiJHSYM3Y4QAgB344GrcQvUOtWNJaGGKalV4YcBCAdbOJtJJrIRv0DZ3+1FnsF2CSlrp94r4l1Yv+BT/szDrId/1dOZfBLqzQD/HlMzzhAdqZeDIOuK7aUOVk1ZbUGGnmEsEplQN/cVnbe0KzUrKDEbmIqgAOBZH742d4PXW1f8wWSCnOaUSh0LOqiQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1613404907; bh=wR1clyFFwqygA9ClpTFj82JmTTjQRuxX3cdCf35x5Aa=; h=X-Sonic-MF:Date:From:Subject:From:Subject; b=P/vDobb2OhLGTDfsQx392A174uvjQKGY4ziejKpAFXc96aejD9NhkYKVaMIaN1hBuLNDxPiMLbby0wJ0omUT3Us8RVhA+ouFuV7lubEUVeksfZmt99doMj2EeRjoDHcAcfOmcORewJYxV9oECx+8Pi8QKwmpJOAcMX4FcJTjWWubDZCQEiusXIfvYG7R44epZIZjp+MvcwMvv69gmlMm/0zFeNXW7IxVgfj8dPy/th8byL8Ky6zrb95BoYYY+LpAQmEVW6/YW7vYI0ZSr8aqoheEOk3j1l0B4sOYkEsJs8jk1HsSR3GqE57gdLg2zfirzSuFhvL35LYQJ6dvB4YXAw==
X-YMail-OSG: 6dGybBUVM1nju2K3c1qOY_f0DKThXvoAcsxwWnk5pd0onQv5Noh.KnBLsVMyzXU
 a_PdDf_pjG1VOWyqN4dAP8WrEl9MEfloAxkP6hTnwyAmriHblke1oAVlYpeXjNmJyhqGtuLI2TTC
 eUO93HBx9E.A2XKxC.OTuPNY.CTBl1FgSTsydkfTZTBBjoq1IuNpT1Tp5PqndvQeuH0puU45UDjw
 Lt2ylb3n9Pc9GmMFcnVhPf5QsauT7_nqtBv5MSOxO7oQ_mNn1.zvwe_QmdFbkfGlxnVxM3cQIS4O
 LL1fGLB_qILeWKL1V4rInHkocHOvMKlaS4g.HNn7EOXMkSvLZw3bAUuVqsKouSCAzmewKnp7tB45
 dmGpEcSDOo.yl2U6bx.GeKRkR9NcF2jOpS62_GRQFHvGlsaLcE7HqmAwUuKNZFZ45cNGGWXzaSSs
 h0GUfrl.hWvBF9gEV0v7Fq.3KR8OXhSbma1.Qngxrhrjo5CexxMB9IzhAZwiNP_FlYSSFfILnxh9
 RlOKjio0bfBDyC3_Vf6GxRXt9NYMXNugpIQiTt7dF7XBWrXcuw6OgTwU.1MYjeNiw5NkCQP3GEoO
 PqwuoTeKF0MduhMAC_H5da5Wta.dRfMp.YMP5qvxoWT7r63iXcXuuxXmRxoV3rujCq22wt.eyJ3j
 4RAktQcNA7UmRzK_PtURnyW2B5LvywUGSQKTmrCHHz7bYTu6a1HhibrN72BcU.Nvtfz7pFeFj_RQ
 ROzmQzuScLuCsO0kTJukWyvWcH2ddB1tifkgk.EkMUmAiTpN1GElrxH8.b2f4sMiKIwk2t0dd1On
 bh_3m7WiIuSOfyySr7_xxcRRAdqKsKpU.jbpYWTVZZBekhrBYH5vWaJZ98sWlkEYo4Cwo2VJTcrc
 jcvVqVb02d_RC36UhRZVjhk1uCvPA2VtUKXewBSCvkoH_Q39kdO_57zr7LWVqL8nPm2UJRtqqBFC
 8kkHf5SFfEB5L6Yx0SKOtkman554BU.L25_NzzV47y_1X9SWeUrHLfWZsRLACyC4BJaa9FvDdBOU
 5XWjQSCLi9Hn9LSNajVmhnF4MqyJDYFFzwyMCCHD.PryF6FPBrDIXo_El6Mj3_qtiMQwBjXkbd_h
 x9oTOJLg4JX84hqDHyWCXBL.WfSzoiGStyzsSlIkd1sdPuz5r.vC5awtXrevZL5vkcreL6i6ie8W
 CuyVTsvo.YtG_1jvBH.3uGGy5WW7WgA1aZ7_fz1PsXtDtHYtS8xRaf.hk0QnrsbpoHn_AJDtgKUM
 15J81iKl3HCKfljO2tPMDiMUMoSeTsgG3iBf1B7hUF42lqBOSLWxd0C4Wpm2tRTLGgnhswScrNdX
 LBExkWshbkYQ9Qe4hf65xDIxbLDl6eq5O5EXHGDjYimxXIgWgi2mjBs6fnm3UN0ALhbtxgINMHq4
 P6S57Sl6O8ZsdqwV4hpXjfEJ5DyyQJ4juvRuuaHhkQlf_aQn4xIMXZurbF.nFuuRuQIzuYaNAjK5
 txVq_tDQURPPIyd3WOe8ZlZAJ3U3Vo7okawbepYZR0Alx6n6Fdu7pNjPgqv6yufRSc5jJ0vuy214
 vK3DyBgAH9WSA9wnM6IiURLAg8sm5deLlKGuqMbA.vzrsUELMEqc_JbyBvg.rSLYYUNsUzIvCZAM
 A1Mk_yDGxuJOSJhDK6g4LYadfViI4vQIt8rzJle2jsRel.IVfcMxlVZVpcA_N2bp2U4ILWx9LA7x
 XjEV8Z2X7eFXYbG_jt.RcB6xNcA7QC6q2gMe_068DSaGGHncsipyrgwrV9gFpln3Jn8Wh3Qa89eZ
 reMecNww7xQSjT_uNUmNY5teF2XRMraV6yK4bvv7mCAFJDrGTIc_eOooYUugX9hG8TJrVScXXxV6
 h0bW5xJNmMQlwEbyUax5QxZwItAnSyuOmEcJZtWw.FEDvBB1POowchG6d7A5HtkwaUYyIZ.I8SsW
 ebzdC4Ao5no.s_Palzigpl8m63w7zv6BBhm2fdJyEqIhu9PAAi6SSVSskjzbOxMeB5fBjEPHcJpu
 OFT9iqeBcYz8HRtaUfEW1Qdu1.DF.zGPh8vplQZ1_FVC2dBcr0.2c94f10rLMtPsWjiG2K7HXcpV
 OnNF0yn6TSzEn4ukV0EencsGrz8SPGaiTDrxNw3ahabjPqvmddMkKz.5ly1rSkva4dEnj6L713Zv
 .3YfzYfnrsqv1t5lM9B6WkWjcgxrYDbWqCiS_KBgIqkp5M1msz6XxdFzb7lMgUCFXZYwpsEHxIiM
 Ho12E1xkIGdL0QUA2e2qxs4niM_qYzMnI4yexVaXM9wZ_5eYIXQQlFUPKPEL4_qtX5IvZg6DMfQ1
 xbx3EFxNBmYe73MawrzgJPS.LcfV0asgb.GQdtsFhopfkUUcZIs6KGB_uwbb_ycCxFt.2hJx76v7
 uo7AaVZDTCtvgQKBYZruG39JIWgElvG4apPuP80a1j7Hi86dqrW.QjfR30X6gO19xPpi4_cgfAXt
 m9CUxbBu.iHX24iIhepVHET_ltS4k.arqaHZUEJXGn6m60Ht_zYx_zB3mvvysc4v4HK9HPEkU6f1
 H5Oz3NgUzzaqmfCpzbX3DTHocRjRxRXU9j.Vk4p7XBPDepiImD1oETfuTRuH7mhZOdzgeLG0KD8_
 ucs02p5erfhiBpfMcIa4JnHGu5udMNS1z5WnYQEE4Ys8qgm.hftULkj8GxrLc.8mgki9wmQUNI_y
 4uBsVqAa32tTEkxWkpOn9nDWatAiI904AlbaPodZnetILdvN1sKSHgSIGoLGRQaDUArcqd7p5_jr
 1k9AK4fTq3bt3OG.XEydZpipWR2Z5OReHYQOtWVrnVX.aEw4N4.mKOALu7hqaJSClfJ_SYG8.B00
 slU1bAysSZzRX_.bizOkQmTN3HHcyVuj26.E8uq7H2GB6ileG1MR779341d8CanNFRtB7OT6GxbH
 PfoeyvBoQaUQeI.a9ldzxpv6tZz5uCvryQv7Uz7nCF_QdesRqLM8C7opSJH9QDBNgsiSsA42KFyB
 2AAH5StYIUnr3CKOMWiSeCY7Mvp9OBk4BEmG0G46nPxOhUx7iJDEmlFo9tPdY.yixSXImlyl3_A0
 PgXGyfskjBoJski5pCiGX3K0usRkqvIyZZgxfGh1g6JXIlH1byMulrklnm46merPvbBXySzVraP9
 zGnnV53RD8hUR13RM9K9zDL6P65nVLVwRruJdRLAX5owFqZa6NlsGKVjzLGxBqm1eWsIpMI9nwwv
 nLBiATFLJyZaR564.nKkqCI2MpXVgnSkpcAyDAwV5cMFK8VaDSfZCcK0ZQrEQRUCWhA_sQQWopHp
 TU3NEYnmXzMTDB6nqJ54NFsKp.IJSnLB9M0ryaj5O_DNoxB41xZ6C6G2VkYQCKHbVpy5HPHP2vd_
 rdIi7aggHZWpXZw2dy3ZnYeZYv1qZM4NexgbY6WMfecg3QtRlXCBmVooSS.1m_kOWvBk81IEuRB5
 0KGJOgZOj7BJq_cRHb.Cfa.oHnBgUFeRoYLzyUgXmL1bSOEIK.xpbwfJI51fEQNKn_cisnIEP3lC
 cputttSbfCXU6YzAzpQjpylR3OuK4ISgnx6mGzFzjELI.yjELUlmiQosAYUV7OTlmpW.z9l2lTwG
 9XIgoEfS0O7_J6Psw0P4TQ1mYy_VMmZciY1k504FbsYSdrPTuenc5my03oMkrCJ122dY9g7Cyf8y
 f_Bv.eES.U5LI0nmWbeg7ePzrXaBvUFU7uNT.skw4IqrQWFEIF3aZu_GB1UJaYbzO9WiNvM0EYY5
 OPvM.55rGobXea9MePmdvRCw8jNiTM3xOJeZn84c1ScRGqGlfrLjebll9c_4ZPCRTStGPoZ3XJtw
 sBci9it6rvMRygFc-
X-Sonic-MF: <mau20@gbcon.in>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Mon, 15 Feb 2021 16:01:47 +0000
Date:   Mon, 15 Feb 2021 15:48:57 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau20@gbcon.in>
Reply-To: maurhinck7@gmail.com
Message-ID: <409229248.1491421.1613404137763@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <409229248.1491421.1613404137763.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17712 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck7@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92021 The Maureen Hinckley Foundation All Rights Reserved.
