Return-Path: <netdev+bounces-11448-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B5B733269
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E1F81C20FBF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6546B17FEC;
	Fri, 16 Jun 2023 13:45:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C8B15484
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:45:37 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C63189;
	Fri, 16 Jun 2023 06:45:35 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1qA9lY-0004cA-UG; Fri, 16 Jun 2023 15:45:28 +0200
Message-ID: <bfe90a36-f7ef-7ea7-da4c-f04da2700fbd@leemhuis.info>
Date: Fri, 16 Jun 2023 15:45:28 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] sfc: add CONFIG_INET dependency for TC offload
Content-Language: en-US, de-DE
To: Edward Cree <ecree.xilinx@gmail.com>, Arnd Bergmann <arnd@kernel.org>,
 Martin Habets <habetsm.xilinx@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Alejandro Lucero <alejandro.lucero-palau@amd.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
 linux-net-drivers@amd.com, linux-kernel@vger.kernel.org
References: <20230616090844.2677815-1-arnd@kernel.org>
 <20230616090844.2677815-2-arnd@kernel.org>
 <2fa7c4a5-79cb-b504-2381-08cb629d473d@gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <2fa7c4a5-79cb-b504-2381-08cb629d473d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1686923135;602a25fd;
X-HE-SMSGID: 1qA9lY-0004cA-UG
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16.06.23 13:39, Edward Cree wrote:
> On 16/06/2023 10:08, Arnd Bergmann wrote:
>>
>> Fixes: a1e82162af0b8 ("sfc: generate encap headers for TC offload")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
>  and I think you also need
> Fixes: 7e5e7d800011 ("sfc: neighbour lookup for TC encap action offload")
>  since that added the references to ip_route_output_flow and arp_tbl (the
>  commit in your Fixes: added the ip_send_check reference on top of that).
> 
> You also might want to add the Closes: tag from [1], I don't know how
>  that works but I assume it'll make someone's regression-bot happy.
>
> [1] https://lore.kernel.org/oe-kbuild-all/202306151656.yttECVTP-lkp@intel.com/

FWIW, yes, regression tracking relies on them (for now Link: and the
newly introduced Closes: work; the latter came up totally independent of
regression tracking). And I have no problem with being the bad guy here. :-D

But for completeness, in case anyone cares:

It's Linus that for many years already wants these links. He a while ago
mentioned that in a few posts I bookmarked:

https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/

But that's nothing new: Documentation/process/submitting-patches.rst
explained this usage for many years already (I just made this more
explicit a while a go).

Ciao, Thorsten

