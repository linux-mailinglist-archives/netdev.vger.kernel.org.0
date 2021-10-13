Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD242BFC2
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhJMMWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 08:22:02 -0400
Received: from sonic306-20.consmr.mail.ne1.yahoo.com ([66.163.189.82]:32805
        "EHLO sonic306-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhJMMWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 08:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.com; s=a2048; t=1634127598; bh=59ehpsV6we++SPvKD6pA7TwtexdocZDdTB22sdCQp7s=; h=From:Subject:Date:To:References:From:Subject:Reply-To; b=ZVe18YlUiSiH1b/5+yJ5y3DWFihL68GgyoZVClnArOTCZdhJ/Lr4Rg+l9ihYlHBslse5ZBRfmXpztCw+8wOGEdnuDUzVL/bvMRUSPR+NmhVjcskmES2wMOWSkHrqBFcbAVp2cP8EZFopQV8Oae9UvMQrE25pdg65atmpFVbk5z8k/2gVZFVyGd95sc1sWE5pvPGDIKnsJ7PvJcPyqnpypVGU5Tb+iScnFaR6o+KPENV1JPol2YjXXR19t8e5rHkFjapyjV+FXHnNXsycB+Em2tuv7mrIrXY/lg59TyELSsWboVH1g4+JZxztXMvE0pF8/uBWa/iOy0JSBfvlDi7RDQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1634127598; bh=P+Q18oifKMG4LVXkSpRyJqBbydZWhztwzj1vKxmYZft=; h=X-Sonic-MF:From:Subject:Date:To:From:Subject; b=ds++R1VznfmxMQi8g9h577XUGGEIENyvHRdxwumll4lyb9hD7STzNZyZYctCZLQmekLFvde5qSlPB94nAInywCWzM+deXDHK2dGMbTIBsosvejQWArR4ChOpuDzUAL/L3kpGuM77E1b0keQgyOFEU+hQpuKUAe8yoqazH0onGiUjB+DPK6+MINFJEC8kD+3A7adOpR509aMqLHD/jajdzX0Juc9v0An/2nsoY+zz6d02Ue9l/pVNshgU5BgwsLK8tfVPWljUgV4xNp+4Fek3Wn7pyLHN9lrX/Hq/1AIZoiQtsa6GjL0vXJpCMWHaz2Bc1VLgkGG9XLPbbqmaI9S/ZA==
X-YMail-OSG: Zs4T7GYVM1mIV38UO490wVr9Uf.NzCoJXZ7ByWhrXUEz4s4nLjGFJHAVdzo2rhA
 X3Ap5rexf1UoPvigw7mIpTJr8YQaIO0eImQZbyaCGbFwXW_9ZbrJTZcGftn4bijJX7SQG.OoawnH
 5ujBuN3MXwxasEY5utRiQQ.hYU5y40TnbMm4uFTd4LTBkJATiq8a3_tPzBptt3BTcEP.o1ZMx0_x
 KPwiJINkOBBBKm3TFe5IzzxNAW9A57QtQzci3DaLAxqaxug91QucSyGU_DwrY_vArD5IfLhN70s2
 B9xptA1sdgtpj4YYMzuHephPXyz37E6Go39hIttrSiv4RkHVRIeCAo3DMkNaSWYUQZe1M7XJwcp2
 oEL9EV9pUfySxHvjVBi9esSvRS6setNlzQM4_75itQo93EJYqbnijNz0pTM_gcMbxZkldQrdq5GQ
 89Gz95LNYJPrhggqJq1HLHHyfNZpfxhJPaCDdxBDOTeYZLq_ncbIFBOr102MV6EuEfB9rnOJFTs_
 DRk.B3_mwPqWALUj1pT4LTv8RMt_zsIaaMBoONFBBMkOh817_sLwiHFBpR6SwmeK_IMaNxQwdOo3
 CstQ_3rldTTqnSs1KWYUJSgArq2amU86iQz995Lws0G._cgkJTDEak1G3vgbNFtOi0NQ5zOe2y3.
 8bgfA1h1Egl2mIabDe319xSQHeXFjJcJdmyaJqn5XADnMv7U2KwMUsfA8i.eKD2MJifVnpgpNcYf
 4dWO6HZe7.PeM2RM4rlmKBkYB065FZWkdvYjinWDz5CdJtCqhTzljoJ1WbizESfIG1.l2GTPWA5f
 SVEuRpYHt9p0hW6u2uhYue_wH07wLU5SZJixGq.XdlcMjMdojfV3r1u5RfgJd4sTyCEeoqw1iw5M
 WB.Efw7HYjfF_mZuzBPKgRYOfKw_m1DSSuae_bIe2.kp04K1ORIepR8CEWre5t6YxUOmGgyutTdn
 m6YMgh_uaf5soCPnpJuJKWZFTrObawqiNVGR9C2hrndoDxgsauhlFpJhHrclHO.aunTMWHi8o7ff
 HBGC1Mrsu.kdaJ9yFpFOa18LavnCcY37YhQGxvHjjncZaRrwWpB4s.lOCar5qUjmRupogQVrhdqk
 V5YaStQpnDGWZK3ikI05stzmRIBs.o8kTCMoHo5WuEP6Xlf0cmFG55yOYK2P6AwI163TUnRf63Ga
 mcwFro1hlu_CrTppWuEUCpLyHjVChQxn_tctvfCc3Q9e1jUAtWi1h79vNjKqQq5TxE3.QW_JHUcx
 yjiItSKR9Aiwn3pnjjLlLb8x7lnpGBU96vCun4seevmx2fHcQw7c1_zQt6haza79b6fAv7TAWJlX
 jf3PgFfUY4x5slF2OwV4XoaXVXFpjioC_OP2TtEfowdSd6AiPZgzw7ddfcQFInABC9ODb2OqeJyg
 gJHrPcVfw4tJ9GdQr3jhSIEiROuZKoa4kKDFzKJswNLZc3ppRbFkw7qbqPyi222w8kW60V1rXiv4
 HmNnK3nqMFD_t2vv5xvj6da8qW5V6W7VoI_TV629jAw9ZjDiglNiSGVabKPdZikJ8JDMvIJbNtXT
 71uH6VyFEZgCWU.6hCjmFltlVo6HqPh0p8DaEBT7D6o1ii4pL9faIURTsw4hlgQlPl.vVwTXyEFw
 vP5d.8azfyxdX7HRNNKWz_HYoUWEV6bZFJk1Y6IieG9R87ywQD.tbcsBC5LnbzfzETZZygXFvgOj
 cgxpF1aO3r7vU9FOeT2gFTs6O9FLRznKOlgrN8p1o3Ny2gC13W78BG_hfmabXW.d48tL3QLxjmVc
 ro3r278uboanNOi4hLcYQFO2nURDeOxYEC4.R64gvTYf2g_babNdVbhFqdmcCOQwKPHFHqUTIY4h
 LzAB7G.gURIC03hn_Lvzuqg8tnMs8tWT1XDgBIub1W0YoqrtF2qEjD4ZbLRHbZp6V0X5P5vnYm0I
 gpXD49jgD9BWum1xIohQYk68D4Wf9mKjY45y29IE.MWYtBHHM4HG1hOjO98L7hTY88XfCheXhrIP
 DegMMflmsm7jeIz6hRW6V2BL2fzyN5e7k.7jrwO7GWoJVQMXDvmQtyuxy14xqSZ6H__s46zdQIOr
 wpMtA_6c6xwbQhZJKJqqz7.XqIjDVdqt5gT_9_Hf_9sQJkNboKpGumxKgeBVhKiazgkBS97MwhwQ
 vonz_MOv_HyPo_1wS22l961PI6fmY4pkop2pYXkYxDm8Mjj0GjcmNhFph1GRgajuAg2DrZVrIgN2
 Nj30ne0w-
X-Sonic-MF: <vschagen@cs.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Wed, 13 Oct 2021 12:19:58 +0000
Received: by kubenode501.mail-prod1.omega.sg3.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID f0c2e6c44a0c01c89cc561ccf12c50ad;
          Wed, 13 Oct 2021 12:19:52 +0000 (UTC)
From:   R W van Schagen <vschagen@cs.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: Question: ESP GSO not working
Message-Id: <FBA664BB-EB62-4A70-9025-B1A33100B029@cs.com>
Date:   Wed, 13 Oct 2021 20:19:45 +0800
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.7)
References: <FBA664BB-EB62-4A70-9025-B1A33100B029.ref@cs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing a new kernel driver I am writing I noticed that
esp_gso_segment is never called. esp_gro_receive, the .xmit,
.output_tail and .encap references are all used. So its not
missing a module.

I tried without my own code and it still doesn=E2=80=99t do GSO?

Ethtools is showing GRO and GSO enabled on the NIC.

I guess I=E2=80=99m getting code blind and it must something simple
as missing a flag.

Richard van Schagen=
