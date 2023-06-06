Return-Path: <netdev+bounces-8409-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 488AB723F41
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03A3A2815E0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDF52A719;
	Tue,  6 Jun 2023 10:21:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650272A717
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:21:42 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28C7E6B;
	Tue,  6 Jun 2023 03:21:40 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 24A315C00E7;
	Tue,  6 Jun 2023 06:21:40 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 06 Jun 2023 06:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm1; t=
	1686046900; x=1686133300; bh=L3ruZsoNMC24z4nGykitqEHJTk2DsiwNv4s
	+KpsYVhY=; b=cQOuzlDf954AAyZ3fzxsKHPzmBWUkFvc3RXIqqWBI/wrO4YMxnv
	J7qNOoaOPr5wV1oqdJM/llje3mIq8KRspBJaVxERBS+b2+rw0Oj4MMyT/KLObsTN
	QS63NRHm3R3LLzKIJR0ZVbpVsx3iSDfhdF8GKCA1VjjwN3rmqW68+Crd1Gtxz+9G
	q1QSANnaa0GblJdG1jIvdH5sDSwrVyNtE1k90zB95g3whfUa8qEOP66nS6mIkqO+
	e7G6rPvOZM6LG0TnLHGG0WaqJh6XTs4on4GgLHCqC5IyUGUc5DjDhmeIwuMvbF0C
	FejzDhLWxkREtP9iNonG7sx8JOsFloPwhFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1686046900; x=1686133300; bh=L3ruZsoNMC24z4nGykitqEHJTk2DsiwNv4s
	+KpsYVhY=; b=dxRD7YCXiG0YFmIuM4qLgZDdJdSPLTjqo34GjbSDf31hOGGimjM
	gMLF0S4VyAiJd0YI0Kb9iNLcRu2H0rIuD1OuRI0pbQFof2/cIURVaoXRce+L3Nos
	Exe+pyH1a9Nc3Gu6dCL+qXvOgmlLjoVrs8gFC0PE6LiunqjO1NLUzimxYP5EgyJs
	9IDTHHK4w/M1ztSSAY6xUvPeoRPCQ0zcHb7YRW/5Wg1Rg2eaIveJNouw+Heli7oY
	Efwk25hRdjDZWfPGtiRiKS8+GE9wSWLAkLPLR9dNrIP4RkEKtMDf4NrMxQGBDs7q
	xXhBna5hbt/HA/LUaotTU5qzycoMHFQ/a1Q==
X-ME-Sender: <xms:swh_ZIerVh8YrXlcEfBC2gujAG41LN4dPnkcGdhWlP5wJE-elY5kWg>
    <xme:swh_ZKNubLBJcezfmiTb6XjR-Fpa4yDqozu7D86B4o4MA0UIVCenBWBQTOrAs73so
    8JyZjc-Hx0TE8Zju4Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtuddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeegfeejhedvledvffeijeeijeeivddvhfeliedvleevheejleetgedukedt
    gfejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:swh_ZJjlNdk1P4DlvVwACsmevoraICw3-7MJh0RZ8oxsO1bQee8gng>
    <xmx:swh_ZN-9PKXwv5MTNFf_MdRVNfgoxFyuWatLpP5OflGoLZxG_SrfjQ>
    <xmx:swh_ZEv2SpW6dFgZLRCw4ZyriV9xQWSQvo1zN_MYihjbjbw_3yvX5A>
    <xmx:tAh_ZETaEEXMmRB5DBpTmf61rBpFJssAO0XpZrkAnurEBdIEcxk2QA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 9405FB60086; Tue,  6 Jun 2023 06:21:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <8db9886f-e24f-44ee-8f8a-880dc3e4bf75@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdUH2Grrv6842YWXHDmd+O3iHdwqTVjYf8f1nbVRzGA+6w@mail.gmail.com>
References: 
 <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
 <11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail.com>
 <CAMuHMdUH2Grrv6842YWXHDmd+O3iHdwqTVjYf8f1nbVRzGA+6w@mail.gmail.com>
Date: Tue, 06 Jun 2023 12:21:19 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "open list" <linux-kernel@vger.kernel.org>,
 linux-next <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org,
 clang-built-linux <llvm@lists.linux.dev>,
 Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
 "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
 Netdev <netdev@vger.kernel.org>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>,
 "Maxime Coquelin" <mcoquelin.stm32@gmail.com>, maxime.chevallier@bootlin.com,
 "Simon Horman" <simon.horman@corigine.com>
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol: lynx_pcs_destroy
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023, at 11:28, Geert Uytterhoeven wrote:
> On Tue, Jun 6, 2023 at 11:16=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> =
wrote:
>> On Tue, Jun 6, 2023, at 11:01, Geert Uytterhoeven wrote:
>>
>> This won't work when PCS_LYNX is a loadable module and
>> STMMAC is built-in. I think we should just select PCS_LYNX
>
> Oops, you're right, forgot about that case.
> What about using IS_REACHABLE() instead?
> No, that won't work either, as DWMAC_SOCFPGA can be modular,
> with STMMAC builtin.

It would work because of the 'select PCS_LYNX' below DWMAC_SOCFPGA,
but I think that's too fragile and would easily break when another
dwmac front-end starts using PCS_LYNX without have the same select
statement. I think we should always avoid IS_REACHABLE().

      Arnd

