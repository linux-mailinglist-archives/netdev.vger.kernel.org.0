Return-Path: <netdev+bounces-3784-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E56B6708D6D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:39:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FCAD28160C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88ECC387;
	Fri, 19 May 2023 01:39:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8F362
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:39:01 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 695D6E51;
	Thu, 18 May 2023 18:38:59 -0700 (PDT)
Received: from [172.30.38.111] (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id 1D5AB1801097CD;
	Fri, 19 May 2023 09:38:50 +0800 (CST)
Message-ID: <f65fe4d6-7877-fd70-9e26-e94b4ebdde38@nfschina.com>
Date: Fri, 19 May 2023 09:38:49 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next] net: bna: bnad: Remove unnecessary (void*)
 conversions
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: rmody@marvell.com, skalluru@marvell.com, GR-Linux-NIC-Dev@marvell.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: yunchuan <yunchuan@nfschina.com>
In-Reply-To: <20230517081801.508322e7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


在 2023/5/17 23:18, Jakub Kicinski 写道:
> On Wed, 17 May 2023 13:14:11 +0800 yunchuan wrote:
>> 在 2023/5/17 11:17, Jakub Kicinski 写道:
>>> On Wed, 17 May 2023 10:27:05 +0800 wuych wrote:
>>>> Pointer variables of void * type do not require type cast.
>>> What tool are you using to find these.
>>> How many of such patches will it take to clean up the entire tree?
>> I use the scripts I found on the  kernel Newbies to find these.
>>
>> website: https://kernelnewbies.org/KernelJanitors/Todo/VoidPointerConvs
> How many of such patches will it take to clean up all of net/ and drivers/net ?



I have identified 48 areas that need to be modified using the script, 
and have not yet confirmed whether all of them need to be modified.


