Return-Path: <netdev+bounces-7943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73ACB7222C9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E12281C20AFF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E9B156C8;
	Mon,  5 Jun 2023 09:59:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6E55680
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:59:50 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EBCB0;
	Mon,  5 Jun 2023 02:59:44 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id A97BA8467E;
	Mon,  5 Jun 2023 11:59:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685959182;
	bh=yzbvSbjMl2YsxvMpDx5BjJDvIMXshX3uhOceQVaVxY0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BfeQy4uEUo7AB4FOoIvmC4FJ4E9Z+0xqfKR0xig5ibbGvSQXKXho9lpOeHnC6c2T3
	 KaxGAaS2VYZo5X5wgkjgieo0quT7f2Qha1UUcjMD1+4AH96zoQE4wwT2ZwnWv2V3YT
	 6RIQKVwprTDJCHLwAGXQvF5UO3pSShrJhx+A9Emhd3uqC/rWwj2LbA6h75kVpYCVtU
	 t+CovtAB/LF9DK6wGSdUCZwXbTCoxL7jJ9Bn/GgEswtIlAwwlcaYKfltVc/VEI+SuV
	 EZ4K9eyYPpiAXbyX2VoKtLkQi32JCjptXBnh3XhRZiyclaJvW8INEyPXAlavd2CdH7
	 3M3tlRBorghNg==
Message-ID: <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
Date: Mon, 5 Jun 2023 11:59:41 +0200
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
 <87lekj1jx2.fsf@kernel.org> <8eb3f1fc-0dee-3e5d-b309-e62349820be8@denx.de>
 <112376890.nniJfEyVGO@pc-42>
From: Marek Vasut <marex@denx.de>
In-Reply-To: <112376890.nniJfEyVGO@pc-42>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/1/23 12:47, Jérôme Pouiller wrote:
> On Saturday 27 May 2023 23:12:16 CEST Marek Vasut wrote:
>> On 2/27/23 11:28, Kalle Valo wrote:
>>> Ganapathi Kondraju <ganapathi.kondraju@silabs.com> writes:
>>>
>>>> Silicon Labs acquired Redpine Signals recently. It needs to continue
>>>> giving support to the existing REDPINE WIRELESS DRIVER. This patch adds
>>>> new Maintainers for it.
>>>>
>>>> Signed-off-by: Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
>>>> ---
>>>> V2:
>>>> - Add proper prefix for patch subject.
>>>> - Reorder the maintainers list alphabetically.
>>>> - Add a new member to the list.
>>>> ---
>>>> V3:
>>>> - Fix sentence formation in the patch subject and description.
>>>> ---
>>>>
>>>>    MAINTAINERS | 8 +++++++-
>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index ea941dc..04a08c7 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -17709,8 +17709,14 @@ S:  Maintained
>>>>    F: drivers/net/wireless/realtek/rtw89/
>>>>
>>>>    REDPINE WIRELESS DRIVER
>>>> +M:  Amol Hanwate <amol.hanwate@silabs.com>
>>>> +M:  Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
>>>> +M:  Jérôme Pouiller <jerome.pouiller@silabs.com>
>>>> +M:  Narasimha Anumolu <narasimha.anumolu@silabs.com>
>>>> +M:  Shivanadam Gude <shivanadam.gude@silabs.com>
>>>> +M:  Srinivas Chappidi <srinivas.chappidi@silabs.com>
>>>>    L: linux-wireless@vger.kernel.org
>>>> -S:  Orphan
>>>> +S:  Maintained
>>>>    F: drivers/net/wireless/rsi/
>>>
>>> For me six maintainers is way too much. Just last November I marked this
>>> driver as orphan, I really do not want to add all these people to
>>> MAINTAINERS and never hear from them again.
>>>
>>> Ideally I would prefer to have one or two maintainers who would be
>>> actively working with the drivers. And also I would like to see some
>>> proof (read: reviewing patches and providing feedback) that the
>>> maintainers are really parciticiping in upstream before changing the
>>> status.
>>
>> Has there been any progress on improving this driver maintainership
>> since this patch ?
> 
> Hello Marek,
> 
> The situation is still blurry. There is a willing to maintain this driver
> (and several people would like I take care of that). However, the effort
> to properly support this driver is still unknown (in fact, I have not yet
> started to really look at the situation).

I have to admit, the aforementioned paragraph is quite disturbing, 
considering that this patch adds 6 maintainers, is already in V3, and so 
far it is not even clear to silabs how much effort it would be to 
maintain driver for their own hardware, worse, silabs didn't even check. 
What is the point of adding those maintainers then ?

> Is this driver blocking some architectural changes? Kalle is talking about
> patches to review. Can you point me on them?

You can look up patches at patchwork.kernel.org or lore.kernel.org and 
search for "rsi:" or "wifi: rsi:" tags.

This driver is basically unusable and I am tempted to send a patch to 
move it to staging and possibly remove it altogether.

WiFi/BT coex is broken, WiFi stability is flaky at best, BT often 
crashes the firmware. There are very iffy design decisions in the driver 
and other weird defects I keep finding.

Multiple people tried to fix at least a couple of basic problems, so the 
driver can be used at all, but there is no documentation and getting 
support regarding anything from RSI is a total waste of time. Sadly, the 
only reference material I could find and work with is some downstream 
goo, which is released in enormous single-commit code dumps with +/- 
thousands of lines of changes and with zero explanation what each change 
means.

> Anyway, I would like to come back with a plan by the end of the summer.

Sure.

In the meantime, since RSI neglected this driver for years, what would 
be the suggestion for people who are stuck with the RSI WiFi hardware?

