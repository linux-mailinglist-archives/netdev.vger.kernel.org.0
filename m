Return-Path: <netdev+bounces-5855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DF371328C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 06:21:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B9B82819AF
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 04:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA05A20;
	Sat, 27 May 2023 04:21:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289F2646
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 04:21:05 +0000 (UTC)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2675DF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 21:21:02 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VjYlwVf_1685161257;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VjYlwVf_1685161257)
          by smtp.aliyun-inc.com;
          Sat, 27 May 2023 12:20:59 +0800
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net v2] tcp: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state if user_mss set
From: Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <20230526194136.1c9f8d6c@kernel.org>
Date: Sat, 27 May 2023 12:20:45 +0800
Cc: netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>,
 Jason Xing <kerneljasonxing@gmail.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>,
 Jack Yang <mingliang@linux.alibaba.com>
Content-Transfer-Encoding: 7bit
Message-Id: <EB2BBD52-2795-4D17-AAE5-389635B69326@linux.alibaba.com>
References: <20230524131331.56664-1-cambda@linux.alibaba.com>
 <20230526194136.1c9f8d6c@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On May 27, 2023, at 10:41, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Wed, 24 May 2023 21:13:31 +0800 Cambda Zhu wrote:
>> This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
>> with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
>> tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
>> it's zero is probably a bug.
>> 
>> With this change, getting TCP_MAXSEG before connecting will return
>> default MSS normally, and return user_mss if user_mss is set.
> 
> Hi, your patch was marked as "Changes requested" by DaveM (I think).
> Presumably because of the missing CCs. Would you mind resending one
> more time with the fuller CC list?

I have resubmitted the patch and hope I got everything right this time :)

Thanks!

Cambda

