Return-Path: <netdev+bounces-1796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5506FF2C3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6205728177B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B121773E;
	Thu, 11 May 2023 13:27:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A3C1F93D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:27:47 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0094D047;
	Thu, 11 May 2023 06:27:25 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1px6Im-00022X-Gn; Thu, 11 May 2023 15:25:48 +0200
Message-ID: <71f119ab-24e2-6a35-2b7d-43ea2a9578b8@leemhuis.info>
Date: Thu, 11 May 2023 15:25:47 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [regression] Kernel OOPS on boot with Kernel 6.3(.1) and RTL8153
 Gigabit Ethernet Adapter
Content-Language: en-US, de-DE
To: Jakub Kicinski <kuba@kernel.org>
Cc: Linux regressions mailing list <regressions@lists.linux.dev>,
 =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
 Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
 "David S. Miller" <davem@davemloft.net>, Stanislav Fomichev
 <sdf@fomichev.me>, workflows@vger.kernel.org,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info>
 <87lei36q27.fsf@miraculix.mork.no> <20230505120436.6ff8cfca@kernel.org>
 <57dbce31-daa9-9674-513e-f123b94950da@leemhuis.info>
 <20230505123744.16666106@kernel.org>
 <9284a9ec-d7c9-68e8-7384-07291894937b@leemhuis.info>
 <20230508130944.30699c33@kernel.org>
From: Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20230508130944.30699c33@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1683811645;98bcdeff;
X-HE-SMSGID: 1px6Im-00022X-Gn
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 08.05.23 22:09, Jakub Kicinski wrote:
> On Sat, 6 May 2023 08:20:23 +0200 Linux regression tracking (Thorsten
> Leemhuis) wrote:
>>> I don't seem to have the permissions on BZ, but I'm guessing we could
>>> do the opposite - you could flip bugbot on first to have it flush the BZ
>>> report to the list, and then reply on the list with regzbot tracking?  
>>
>> That's the plan for the future, but for now I don't want to do that, as
>> it might mess up other peoples workflows, as hinted above already and
>> discussed here:
>>
>> https://lore.kernel.org/all/1f0ebf13-ab0f-d512-6106-3ebf7cb372f1@leemhuis.info/
>>
>> That was only recently, but if you jump in there as well it might
>> persuade Konstantin to enable bugbot for other products/components. Then
>> I could and would do what you suggested.
> 
> CC: workflows
> 
> I'm a bit confused. I understand that we don't want to automatically
> send all bugzilla reports to the ML. But AFAIU this is to avoid spamming
> the list / messing with people's existing BZ workflow.
> If you pre-triage the problem and decide to forward it to the list -
> whether you do it with buzbot + regzbot or manual + regzbot is moot.
> 
> The bugbot can be enabled per BZ entry (AFAIU), so you can flip it
> individually for the thread you want to report. It should flush that 
> BZ to the list. At which point you can follow your normal ML regression
> process.
> 
> Where did I go off the rails?

You missed that Konstantin (now CCed) is just a bit careful for the
bugbot bring up and therefore for now only allows bugbot to be enabled
for BZ entries that are filed against the product/component combination
Linux/Kernel. I could reassigning bugs there, but that would break the
workflow for maintainers like Kalle, which look at all bugs assigned to
their product/component combo (Drivers/network-wireless in Kalle's case).

Ciao, Thorsten

