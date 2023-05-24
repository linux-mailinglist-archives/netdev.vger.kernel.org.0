Return-Path: <netdev+bounces-4834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 969C770EA88
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C27D1C209D5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59AE1118;
	Wed, 24 May 2023 01:05:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8382ED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:05:04 +0000 (UTC)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF8E185
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 18:04:59 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VjLwC1O_1684890295;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VjLwC1O_1684890295)
          by smtp.aliyun-inc.com;
          Wed, 24 May 2023 09:04:56 +0800
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state
From: Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <659eb737a46878dbf943361a5ededa8f05d0ba46.camel@redhat.com>
Date: Wed, 24 May 2023 09:04:44 +0800
Cc: netdev@vger.kernel.org,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>,
 Jack Yang <mingliang@linux.alibaba.com>
Content-Transfer-Encoding: 7bit
Message-Id: <1CAC04AB-977F-46FB-81D0-70F90456CC4F@linux.alibaba.com>
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
 <20230519080118.25539-1-cambda@linux.alibaba.com>
 <659eb737a46878dbf943361a5ededa8f05d0ba46.camel@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On May 23, 2023, at 21:45, Paolo Abeni <pabeni@redhat.com> wrote:
> 
> On Fri, 2023-05-19 at 16:01 +0800, Cambda Zhu wrote:
>> This patch removes the tp->mss_cache check in getting TCP_MAXSEG of
>> CLOSE/LISTEN sock. Checking if tp->mss_cache is zero is probably a bug,
>> since tp->mss_cache is initialized with TCP_MSS_DEFAULT. Getting
>> TCP_MAXSEG of sock in other state will still return tp->mss_cache.
>> 
>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>> Reported-by: Jack Yang <mingliang@linux.alibaba.com>
> 
> Could you please re-submit including the Eric's tags?
> 
> Thanks!
> 
> Paolo

Sorry for no Eric's tag. I don't know the 'Suggested-by' tag before,
and I'll re-submit the patch.

Should I add Eric's 'Reviewed-by' to the patch? Or this should be added
by maintainer? Sorry for my ignorance again. :)

Thanks,
Cambda

