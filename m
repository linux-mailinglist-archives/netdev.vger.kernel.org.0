Return-Path: <netdev+bounces-3375-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22761706B8B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1940C1C20F6F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96696442F;
	Wed, 17 May 2023 14:49:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C821C26
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:49:05 +0000 (UTC)
Received: from bagheera.iewc.co.za (bagheera.iewc.co.za [154.73.34.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAC146BD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:48:58 -0700 (PDT)
Received: from [154.73.32.4] (helo=tauri.local.uls.co.za)
	by bagheera.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <jaco@uls.co.za>)
	id 1pzISF-0004y6-5y; Wed, 17 May 2023 16:48:39 +0200
Received: from [192.168.42.201]
	by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
	(envelope-from <jaco@uls.co.za>)
	id 1pzGNZ-0002O9-Jp; Wed, 17 May 2023 14:35:41 +0200
Message-ID: <42af9ae4-403f-55f1-f169-800e544c9770@uls.co.za>
Date: Wed, 17 May 2023 14:35:42 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] net/pppoe: make number of hash bits configurable
Content-Language: en-GB
To: patchwork-bot+netdevbpf@kernel.org
Cc: netdev@vger.kernel.org
References: <E1pzFCV-0005Ly-U7@plastiekpoot>
 <168432542271.5953.3107796853932406707.git-patchwork-notify@kernel.org>
From: Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <168432542271.5953.3107796853932406707.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wow that was quick.  Thank you for applying, much appreciated.

Kind regards,
Jaco

On 2023/05/17 14:10, patchwork-bot+netdevbpf@kernel.org wrote:

> Hello:
>
> This patch was applied to netdev/net-next.git (main)
> by David S. Miller <davem@davemloft.net>:
>
> On Wed, 17 May 2023 10:00:03 +0200 you wrote:
>> When running large numbers of pppoe connections, a bucket size of 16 may
>> be too small and 256 may be more appropriate.  This sacrifices some RAM
>> but should result in faster processing of incoming PPPoE frames.
>>
>> On our systems we run upwards of 150 PPPoE connections at any point in
>> time, and we suspect we're starting to see the effects of this small
>> number of buckets.
>>
>> [...]
> Here is the summary with links:
>    - net/pppoe: make number of hash bits configurable
>      https://git.kernel.org/netdev/net-next/c/96ba44c637b0
>
> You are awesome, thank you!

