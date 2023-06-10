Return-Path: <netdev+bounces-9811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6DB72AB80
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 14:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CA411C20B2F
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 12:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165AA14269;
	Sat, 10 Jun 2023 12:34:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC0B256A
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 12:34:23 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5D41FEB;
	Sat, 10 Jun 2023 05:34:21 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 8AE1B846E1;
	Sat, 10 Jun 2023 14:34:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1686400459;
	bh=PNe4FsyuPcUOE42No01ipnOOCZXiputDOxeshlsmFVw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AM6yRSHEAr0MrLM+njgel9pV1/KYBEaw+q/Ls1eL5KAHNv9XKwme4qmoVLdyYvTeQ
	 LosRUUbhDYFaD2q7EtrSYTztPgVt2LqF/ItyGGKOGH4JKU/RkJSiE2ZYrRsbrQcQc7
	 LcU+szoLm6Tca0Pn2T4jGLZf7DHwuV1yvEhIRlWdD892T3Lst7txykMHa0fMzoodFW
	 bPOQYrxMnr0ZVMzmh+UnggBYTP4cuw50z3idEtaAOizakf9CInXfaeaUuEnmwbFd2H
	 Zr9Q3Ye9cLBvtK9pW+LQsVLH9KDo9T4pHBLIm9tAc6xTmhQKDd9taUPSH0OXMqxeBZ
	 l2RdgT6J7GIlQ==
Message-ID: <b739c6b7-4f9b-9f43-6370-3b025dcb1622@denx.de>
Date: Sat, 10 Jun 2023 14:34:18 +0200
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
To: =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
 Kalle Valo <kvalo@kernel.org>,
 Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
Cc: linux-wireless@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
 Amol Hanwate <amol.hanwate@silabs.com>, Angus Ainslie <angus@akkea.ca>,
 Jakub Kicinski <kuba@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
 Martin Fuzzey <martin.fuzzey@flowbird.group>,
 Martin Kepplinger <martink@posteo.de>,
 Narasimha Anumolu <narasimha.anumolu@silabs.com>,
 Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
 Shivanadam Gude <shivanadam.gude@silabs.com>,
 Siva Rebbagondla <siva8118@gmail.com>,
 Srinivas Chappidi <srinivas.chappidi@silabs.com>, netdev@vger.kernel.org
References: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
 <112376890.nniJfEyVGO@pc-42> <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
 <3166282.5fSG56mABF@pc-42>
From: Marek Vasut <marex@denx.de>
In-Reply-To: <3166282.5fSG56mABF@pc-42>
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

On 6/9/23 17:10, Jérôme Pouiller wrote:
> Hi Marek,

Hi,

> On Monday 5 June 2023 11:59:41 CEST Marek Vasut wrote:
>> On 6/1/23 12:47, Jérôme Pouiller wrote:
>>> On Saturday 27 May 2023 23:12:16 CEST Marek Vasut wrote:
>>>> On 2/27/23 11:28, Kalle Valo wrote:
>>>>> Ganapathi Kondraju <ganapathi.kondraju@silabs.com> writes:
> [...]
>>>> Has there been any progress on improving this driver maintainership
>>>> since this patch ?
>>>
>>> Hello Marek,
>>>
>>> The situation is still blurry. There is a willing to maintain this driver
>>> (and several people would like I take care of that). However, the effort
>>> to properly support this driver is still unknown (in fact, I have not yet
>>> started to really look at the situation).
>>
>> I have to admit, the aforementioned paragraph is quite disturbing,
>> considering that this patch adds 6 maintainers, is already in V3, and so
>> far it is not even clear to silabs how much effort it would be to
>> maintain driver for their own hardware, worse, silabs didn't even check.
>> What is the point of adding those maintainers then ?
> 
> 
> I think Ganapathi just wanted to give a list of people to keep in Cc in
> case there were some discussions about this driver. The status change was
> probably not what he wanted to do.

Do I understand this correctly that there is no intention to actually 
improve the upstream support from RSI side ?

[...]

