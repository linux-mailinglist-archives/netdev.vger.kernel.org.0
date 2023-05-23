Return-Path: <netdev+bounces-4519-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E368E70D29F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84E71C2084C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5527379C1;
	Tue, 23 May 2023 03:58:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BFB7492
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:58:10 +0000 (UTC)
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF19BB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:58:07 -0700 (PDT)
Message-ID: <e0d9f667-06b3-802f-8e9c-739eae14f8ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684814284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+l87Hpar9mvl8WdHQoVBboBQJwVyZRSK9FMUxoP/jMo=;
	b=HuOciLxkWXiIIiobvBE1TmuY2l1BIxlDVwBkv5lLjEIJDA7JVJsJDy4zfNYuoocHSuxjeY
	tEx6cH1LdNKrA3qMqlGDu3LGe8YDsC4mZbdiuRkBFn8sB8CY3fysUABYt5qjew1YelNHIE
	tcVGcBWXRsZLpb2QmDRpfVpEAvxFCbA=
Date: Tue, 23 May 2023 11:58:00 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
Content-Language: en-US
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <000000000000a589d005fc52ee2d@google.com>
 <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/23/23 11:47, Zhu Yanjun wrote:
> On Tue, May 23, 2023 at 10:26 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 5/23/23 10:13, syzbot wrote:
>>> Hello,
>>>
>>> syzbot tried to test the proposed patch but the build/boot failed:
>>>
>>> failed to apply patch:
>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
>>> patch: **** unexpected end of file in patch
> This is not the root cause. The fix is not good.

Could you explain about the root cause?

Thanks,
Guoqing

