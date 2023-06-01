Return-Path: <netdev+bounces-7013-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A93FC71930B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64A8228160E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F522BA3B;
	Thu,  1 Jun 2023 06:15:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A362916
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:15:00 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821CCE2;
	Wed, 31 May 2023 23:14:58 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aef03.dynamic.kabel-deutschland.de [95.90.239.3])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3AB5E61E4052B;
	Thu,  1 Jun 2023 08:14:15 +0200 (CEST)
Message-ID: <15af2a2f-2235-b9c5-b104-a09836f11dd9@molgen.mpg.de>
Date: Thu, 1 Jun 2023 08:14:14 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH] igb: Fix extts capture value format for
 82580/i354/i350
Content-Language: en-US
To: Egg Car <eggcar.luan@gmail.com>
Cc: jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
References: <20230531090805.3959-1-eggcar.luan@gmail.com>
 <92180324-fa55-5427-839e-d555ac5a6cd7@molgen.mpg.de>
 <CACMC4jY=c8kBwxRjLL++ro=Zz1O54h5Y6ADU6x+46pgN8XhkpA@mail.gmail.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CACMC4jY=c8kBwxRjLL++ro=Zz1O54h5Y6ADU6x+46pgN8XhkpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Dear Egg,


Thank you for your reply.

Am 01.06.23 um 07:55 schrieb egg car:

>> It’d be great, if you added a paragraph how to reproduce the
>> issue.
> 
> I have tested an i350 NIC with a 1PPS signal input to a SDP pin,
> running 'ts2phc' program from linuxptp project, and found that the
> 1PPS timestamps reading out are raw register value in resolution of
> 1ns and a maximum range of 2^40 ns, thus about 1099 s. It was
> supposed to be in TAI timestamp format.
> 
> Sorry I'm new to kernel development, should I make a new patch to add
> a paragraph in the commit information?

There is no hard rule about it, but I would appreciate it. In the end,
it’s the maintainers’ decision. You can amend the commit, and then 
regenerate the patch with `git format-patch -1 -v2`. Below the --- line 
you can add a short change-log, what you changed between the patch 
iterations.

>> I do not see the variable *flags* being used.
> 
> This patch has a typo, please ignore this one, I have submitted a new one
> that fixed this.

I have not seen this yet.

> I have tested the patch on a Ubuntu server 22.04 machine with kernel 
> version 5.19.17, then I generated the patch in the 'net-queue'
> development repo. I just handwritten the changes in the dev repo,
> made a silly mistake.
> 
> Apolot8ze for that, I'll be more careful next time.
No problem. This has happened to all of us. Congratulations on your 
first(?) Linux kernel contribution. Glad to have you and I am looking 
forward to your next improvements.


Kind regards,

Paul

