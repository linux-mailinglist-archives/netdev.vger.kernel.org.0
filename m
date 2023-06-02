Return-Path: <netdev+bounces-7392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4D271FFFD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7174428180A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD8815496;
	Fri,  2 Jun 2023 11:05:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7BD8466
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 11:05:49 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19D7133;
	Fri,  2 Jun 2023 04:05:47 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1q52bI-0004TD-P5; Fri, 02 Jun 2023 13:05:44 +0200
Message-ID: <5b235e0f-cd4c-a453-d648-5a4e9080ac19@leemhuis.info>
Date: Fri, 2 Jun 2023 13:05:44 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: system hang on start-up (mlx5?)
From: "Linux regression tracking #update (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
To: Chuck Lever III <chuck.lever@oracle.com>,
 "elic@nvidia.com" <elic@nvidia.com>
Cc: "saeedm@nvidia.com" <saeedm@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>,
 "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>,
 Linux regressions mailing list <regressions@lists.linux.dev>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <bf2594bb-94e0-5c89-88ad-935dee2ac95c@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <bf2594bb-94e0-5c89-88ad-935dee2ac95c@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1685703947;77e8c7d7;
X-HE-SMSGID: 1q52bI-0004TD-P5
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[TLDR: This mail in primarily relevant for Linux regression tracking. A
change or fix related to the regression discussed in this thread was
posted or applied, but it did not use a Link: tag to point to the
report, as Linus and the documentation call for. Things happen, no
worries -- but now the regression tracking bot needs to be told manually
about the fix. See link in footer if these mails annoy you.]

On 08.05.23 14:29, Linux regression tracking #adding (Thorsten Leemhuis)
wrote:
> On 03.05.23 03:03, Chuck Lever III wrote:
>>
>> I have a Supermicro X10SRA-F/X10SRA-F with a ConnectX®-5 EN network
>> interface card, 100GbE single-port QSFP28, PCIe3.0 x16, tall bracket;
>> MCX515A-CCAT
>>
>> When booting a v6.3+ kernel, the boot process stops cold after a
>> few seconds. The last message on the console is the MLX5 driver
>> note about "PCIe slot advertised sufficient power (27W)".
>>
>> bisect reports that bbac70c74183 ("net/mlx5: Use newer affinity
>> descriptor") is the first bad commit.
>>
>> I've trolled lore a couple of times and haven't found any discussion
>> of this issue.
> 
> #regzbot ^introduced bbac70c74183
> #regzbot title system hang on start-up (irq or mlx5 problem?)
> #regzbot ignore-activity

#regzbot fix: 368591995d010e6
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

