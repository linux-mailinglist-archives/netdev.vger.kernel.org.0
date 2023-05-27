Return-Path: <netdev+bounces-5935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D5D713682
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 23:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A011F1C20A01
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 21:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4BFD17FEC;
	Sat, 27 May 2023 21:12:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F39125DF
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 21:12:29 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7562AC7;
	Sat, 27 May 2023 14:12:25 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id B062B84671;
	Sat, 27 May 2023 23:12:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685221937;
	bh=Bx/bXNjb2IOpW6Kp9gSlSspt35H9ACoDVnbFbqhl+O8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sSP64hDoEJuGBCEIowAgDmABQJL8Fm4JMhiQXiry8K6MATNUHQAr3XosoQTda5pR3
	 BlEh/P5xG5GVLeqIXbAAKcJvx2Swhd9/QdwsUI2ON+rHW542DzmaXqpy3hmhoJmNbe
	 1ursbRIGNGHFn5gVevqA6dihDz0iO1OK9a35DvdF15qYoHLgot4HGuo3CV+ZAWGOD2
	 iUwIRrU2rC5svMtxXZlPeNr/PjqoQTizIFzD66HNgef8O5eAKnSGolA1a31+SaJMN5
	 7nsZFio3UW7FYxXoBamDARAW3MvH4ShuoxKdccAFDbCVI8W0pw2PoXO5RWNcRalyyX
	 NmQqmz8m50bfQ==
Message-ID: <8eb3f1fc-0dee-3e5d-b309-e62349820be8@denx.de>
Date: Sat, 27 May 2023 23:12:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
To: Kalle Valo <kvalo@kernel.org>,
 Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
Cc: linux-wireless@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
 Amol Hanwate <amol.hanwate@silabs.com>, Angus Ainslie <angus@akkea.ca>,
 Jakub Kicinski <kuba@kernel.org>,
 Jerome Pouiller <Jerome.Pouiller@silabs.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Martin Fuzzey <martin.fuzzey@flowbird.group>,
 Martin Kepplinger <martink@posteo.de>,
 Narasimha Anumolu <narasimha.anumolu@silabs.com>,
 Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
 Shivanadam Gude <shivanadam.gude@silabs.com>,
 Siva Rebbagondla <siva8118@gmail.com>,
 Srinivas Chappidi <srinivas.chappidi@silabs.com>, netdev@vger.kernel.org
References: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
 <87lekj1jx2.fsf@kernel.org>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <87lekj1jx2.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2/27/23 11:28, Kalle Valo wrote:
> Ganapathi Kondraju <ganapathi.kondraju@silabs.com> writes:
> 
>> Silicon Labs acquired Redpine Signals recently. It needs to continue
>> giving support to the existing REDPINE WIRELESS DRIVER. This patch adds
>> new Maintainers for it.
>>
>> Signed-off-by: Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
>> ---
>> V2:
>> - Add proper prefix for patch subject.
>> - Reorder the maintainers list alphabetically.
>> - Add a new member to the list.
>> ---
>> V3:
>> - Fix sentence formation in the patch subject and description.
>> ---
>>
>>   MAINTAINERS | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ea941dc..04a08c7 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17709,8 +17709,14 @@ S:	Maintained
>>   F:	drivers/net/wireless/realtek/rtw89/
>>   
>>   REDPINE WIRELESS DRIVER
>> +M:	Amol Hanwate <amol.hanwate@silabs.com>
>> +M:	Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
>> +M:	Jérôme Pouiller <jerome.pouiller@silabs.com>
>> +M:	Narasimha Anumolu <narasimha.anumolu@silabs.com>
>> +M:	Shivanadam Gude <shivanadam.gude@silabs.com>
>> +M:	Srinivas Chappidi <srinivas.chappidi@silabs.com>
>>   L:	linux-wireless@vger.kernel.org
>> -S:	Orphan
>> +S:	Maintained
>>   F:	drivers/net/wireless/rsi/
> 
> For me six maintainers is way too much. Just last November I marked this
> driver as orphan, I really do not want to add all these people to
> MAINTAINERS and never hear from them again.
> 
> Ideally I would prefer to have one or two maintainers who would be
> actively working with the drivers. And also I would like to see some
> proof (read: reviewing patches and providing feedback) that the
> maintainers are really parciticiping in upstream before changing the
> status.

Has there been any progress on improving this driver maintainership 
since this patch ?

