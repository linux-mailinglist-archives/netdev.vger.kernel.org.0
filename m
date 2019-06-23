Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99704FE92
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 03:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfFXBpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 21:45:46 -0400
Received: from sonic316-47.consmr.mail.bf2.yahoo.com ([74.6.130.221]:33022
        "EHLO sonic316-47.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbfFXBpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 21:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1561340744; bh=Wn45IEVQxjYS/KJ/AenupJ6pixj3tpnk+IQw8lNF8Cw=; h=Date:From:Reply-To:Subject:References:From:Subject; b=pneMGMj26KBi1J2xXOQmtbJZg8yCxgotNwM396NTjWhXjPXCb/A1azCMEs0rMmLFKesjP9XIqh90eU0sJA160YINckS5G2eZTuSeTfGT9NAhJkkEk8x20x/R0hNHnmiadTqHPQUvSey60g7rX+lSd4vUmxGxX+VUh/Gfb2gDfkXjL6OQmeYkTGbFa//ipxalnLIAcbyJeIZXErpj2AScz7eCr4yopDnHBBfKc+tlXW+xQ6QpWt04A5XkkPWmfPSRYpdCT0f4fpUCEJ5Uvj4FVk6H61Gu/5uFcdBw4pQSgXxgChY6dW+3QdQssKJChbnar7yy0airDjUEf4Q5QgVirw==
X-YMail-OSG: FBbN.icVM1l_nZZx6IF7XriQ6h42c1JoEIEFM49yRQ6DDx9lD5rkvUEz5H4ddix
 PycaNECwhhDsu7y041i5wwXphiVBmpU5HzBIkOWkYjkY6uE4q2FV71HiZ9errI.aANOw43.vYvOy
 oyk3m9AV6wiSDtGRxsAeXLZv08bwQku4Skx5G_A8gaVhlInhdGHVkghMCnIu8l57QE2D5WbpvFTb
 zFfkg6MGX5L4Sk1rSQJAXlCvdTT4E8dQ7rws6jPqZY8KwVI8zKPftp5IN..AvN9nBK55jzm703_g
 jVg0y642Fp0znE0Iv9nKDOzPawV.MHAiMRLSFrWi9v_y2FRygufBy1k.8xzFT9Ls7iDDcheDWmL0
 EjrlKjjKILoKWQeUm2gV3KTmAboP8TjyiTz3_I0aAjLe776VmLfXq2abouZ2ZoD1dOA2XgQai2fI
 c20.qaM75ZdjaJ2urz8zDy2Caw49rsqQQ6FsXJJ2jUxiwBKF734QwOimnxzms4ivDpwzEXNXcVqU
 TZxFK7jcuRevGmIVoz1sRk5VgQ4VEEiz2YT9.vAGn6KIkWHkR5tZZDxOvrOqlfGHs2vS87sFWfYN
 LElJWdD6p8sjHSfRLs0qfz3cj68ZqZRRUwPDXG3ylfLDX4.ltrs6MPTIBCI1UrdCjE3QuZqvaO8J
 Iak0UrS7wwydtIPwq9hqnKSYrq3yvDV9CoPgfqD3QViVNyNFxFXQytoTaZi_eOssSvFPmtzAqUKT
 .pz8pbU9dATBDm2MSipSAUKqy9OQ3eDTiTEjfD9a6upkdHfq2k7wH2WKyn9COYAjYmp_RuAny9RI
 BfrpcXyqXK_Xferj5GGBJCeHCyOMZevwuYL2ffUD_Zryt1j..OVP64fZabEdz0smXn.Q1DqRq1Uj
 T5THvUxOwk0mTKwIbhMKtykKx4J_BcfrD42PQowGx5tyDUgShd0QznUhA_W0alE2d2u8TmES8FsK
 N4dTYiNzWNkssCFEMOvGT.gpTmxfvHrWaqkrmxf8IITKw0C5fxNJjj6uqXVGfusJYxBqb80yWFHv
 wuq5WCkh0BSROOH9YwdE.p.iIZdxmhu87KojueI11kFLxZiqQkiE1K4YKCWRdb31WB6ZxfgBQhZT
 YzsYwt8N_4VMQkssjB6eV5SugFrgWAY7BGJAvmjvpqFCK.dH.1BmLT0J3ftQWzwamNOXRFhKc.RS
 uSakMEY.jGgU9GAFSF_e32E8psIhcBLMEqUX2wU3w5DjSWtCiwIsJrlk7qmBrOH.vx6zossTGokL
 E6DCaJEshppt_q7FF0S4N
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Mon, 24 Jun 2019 01:45:44 +0000
Date:   Sun, 23 Jun 2019 23:03:31 +0000 (UTC)
From:   "gh10 ." <gh10@gajdm.org.in>
Reply-To: "gh10 ." <gh10@gajdm.org.in>
Message-ID: <1272711745.493629.1561331011554@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1272711745.493629.1561331011554.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13837 YahooMailBasic Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am in the military unit here in Afghanistan, we have some amount of funds that we want to move out of the country. My partners and I need a good partner someone we can trust. It is risk free and legal. Reply to this email: hornbeckmajordennis635@gmail.com

Regards,
Major Dennis Hornbeck.
