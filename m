Return-Path: <netdev+bounces-9810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E6372AB7E
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 14:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8D572819AE
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 12:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D251C15C;
	Sat, 10 Jun 2023 12:32:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D5D20FC
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 12:32:50 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A161FEB;
	Sat, 10 Jun 2023 05:32:46 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 46C0F846B0;
	Sat, 10 Jun 2023 14:32:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1686400363;
	bh=guqMrZKOUC2uEL7EAwTdxRfqwubHyfkjMz+33HjOPT0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ya0xddBXNYQ2m5YXPh+p1OtckwapSH0ZIwBifxoHPgUuCgsmMzpksG8pzcTu+Mpkh
	 HjOBvAYz2yyIl7jpjGpcbjvKA5uNqFQYiCjZEPK8Jt+IJ4lf8WSZiCZEIgKnnQUUcV
	 mi9aI9TRJpw9LxfxUlLoXPlfa8Slc/Mb96HRTHcfWLl0iVZ+p7bLYrel8Qxp73Egpu
	 7JdXOUi3P/ZWM4ehsKnbZ+kJ+N/Oj9m9ocX2M5m7WyWfNXE/oS1TF/ud5cpnsrcZCU
	 UECVxMf6DGz0qAvIDRP9kLa2GpgcB0q/6psuAIzRc1KRnoRTRO4Bif6Nzab2CR6OKx
	 HYYLcQshZbADw==
Message-ID: <cca9caf4-df21-eff5-ed21-562535163451@denx.de>
Date: Sat, 10 Jun 2023 14:32:41 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
Content-Language: en-US
To: Angus Ainslie <angus@akkea.ca>,
 =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>
Cc: Kalle Valo <kvalo@kernel.org>,
 Ganapathi Kondraju <ganapathi.kondraju@silabs.com>,
 linux-wireless@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
 Amol Hanwate <amol.hanwate@silabs.com>, Jakub Kicinski <kuba@kernel.org>,
 Johannes Berg <johannes@sipsolutions.net>,
 Martin Fuzzey <martin.fuzzey@flowbird.group>,
 Martin Kepplinger <martink@posteo.de>,
 Narasimha Anumolu <narasimha.anumolu@silabs.com>,
 Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
 Shivanadam Gude <shivanadam.gude@silabs.com>,
 Siva Rebbagondla <siva8118@gmail.com>,
 Srinivas Chappidi <srinivas.chappidi@silabs.com>, netdev@vger.kernel.org
References: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
 <112376890.nniJfEyVGO@pc-42> <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
 <3166282.5fSG56mABF@pc-42> <50ab38c7104b99277bca512ba8f59255@akkea.ca>
From: Marek Vasut <marex@denx.de>
In-Reply-To: <50ab38c7104b99277bca512ba8f59255@akkea.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 17:46, Angus Ainslie wrote:
> Hi Jérôme,
> 
> On 2023-06-09 08:10, Jérôme Pouiller wrote:
>>
>> You are talking about this driver[1] I assume?
>>
>> [1]: https://github.com/SiliconLabs/RS911X-nLink-OSD
>>
>> [...]
>>> In the meantime, since RSI neglected this driver for years, what would
>>> be the suggestion for people who are stuck with the RSI WiFi hardware?
>>
>> Unfortunately, my only suggestion is to use the downstream driver we
>> mentioned above.
> 
> That driver isn't really a solution as it rarely applies cleanly to 
> recent kernels.
> 
> The lack of proper commit messages also makes the changes opaque.

Worse, that repo is just massive dump of unreviewed, unreviewable, 
obfuscated goo. That is something I would never dare to put into any 
serious deployment.

To make it clear, the aforementioned suggestion is NOT an option.

