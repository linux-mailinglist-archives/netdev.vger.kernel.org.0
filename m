Return-Path: <netdev+bounces-4550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A105770D353
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F2A91C20C87
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D061B90A;
	Tue, 23 May 2023 05:44:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E104EEDD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:44:15 +0000 (UTC)
Received: from out-39.mta0.migadu.com (out-39.mta0.migadu.com [IPv6:2001:41d0:1004:224b::27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A31D10C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 22:44:13 -0700 (PDT)
Message-ID: <5b6b8431-92c7-62df-299b-28f3a5f61d5f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684820650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IGxV7bRUi/GE13J/Uz6qtwRCl5Pm9NfAa4wWpSscMSs=;
	b=Nqx7uUOyUbn/ufMtUEQdd97JrXB+qKHU5OFZtzCCUCCn6fguKzx2BtSlvQ+p/gMRn4ODyg
	cMJq7Qv/wdkE4lDTXamqyuhMDatIAwhOT4BbKZl0I4EgCXPCpjsXWfwRfRB2G90+xlft6g
	GORT1nL91ifw7T9oUb402mlPC9rSBCU=
Date: Tue, 23 May 2023 13:44:06 +0800
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
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
 <0d515e17-5386-61ba-8278-500620969497@linux.dev>
 <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
 <CAD=hENdXdqfcxjNrNnP8CoaDy6sUJ4g5uxcWE0mj3HtNohDUzw@mail.gmail.com>
 <CAD=hENda4MxgEsgT-GUhYHH66m79wi8yxBQS8CYnxc_DsQKGwg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAD=hENda4MxgEsgT-GUhYHH66m79wi8yxBQS8CYnxc_DsQKGwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/23/23 13:18, Zhu Yanjun wrote:
> On Tue, May 23, 2023 at 1:08 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>> On Tue, May 23, 2023 at 12:29 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>>> On Tue, May 23, 2023 at 12:10 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>>>
>>>>
>>>> On 5/23/23 12:02, Zhu Yanjun wrote:
>>>>> On Tue, May 23, 2023 at 11:47 AM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>>>>>> On Tue, May 23, 2023 at 10:26 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>>>>>>
>>>>>>> On 5/23/23 10:13, syzbot wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot tried to test the proposed patch but the build/boot failed:
>>>>>>>>
>>>>>>>> failed to apply patch:
>>>>>>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
>>>>>>>> patch: **** unexpected end of file in patch
>>>>>> This is not the root cause. The fix is not good.
>>>>> This problem is about "INFO: trying to register non-static key. The
>>>>> code is fine but needs lockdep annotation, or maybe"
>>> This warning is from "lock is not initialized". This is a
>>> use-before-initialized problem.
>>> The correct fix is to initialize the lock that is complained before it is used.
>>>
>>> Zhu Yanjun
>> Based on the call trace, the followings are the order of this call trace.
>>
>> 291 /* called by the create qp verb */
>> 292 int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp *qp,
>> struct rxe_pd *pd,
>> 297 {
>>              ...
>> 317         rxe_qp_init_misc(rxe, qp, init);
>>              ...
>> 322
>> 323         err = rxe_qp_init_resp(rxe, qp, init, udata, uresp);
>> 324         if (err)
>> 325                 goto err2;   <--- error
>>
>>              ...
>>
>> 334 err2:
>> 335         rxe_queue_cleanup(qp->sq.queue); <--- Goto here
>> 336         qp->sq.queue = NULL;
>>
>> In rxe_qp_init_resp, the error occurs before skb_queue_head_init.
>> So this call trace appeared.
> 250 static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
> 254 {
>                          ...
> 264
> 265                 type = QUEUE_TYPE_FROM_CLIENT;
> 266                 qp->rq.queue = rxe_queue_init(rxe, &qp->rq.max_wr,
> 267                                         wqe_size, type);
> 268                 if (!qp->rq.queue)
> 269                         return -ENOMEM;    <---Error here
> 270
>
> ...
>
> 282         skb_queue_head_init(&qp->resp_pkts); <-this is not called.
> ...
> This will make spin_lock of resp_pkts is used before initialized.

IMHO, the above is same as

> Which is caused by  "skb_queue_head_init(&qp->resp_pkts)" is not called
> given rxe_qp_init_resp returns error, but the cleanup still trigger the
> chain.
>
> rxe_qp_do_cleanup -> rxe_completer -> drain_resp_pkts ->
> skb_dequeue(&qp->resp_pkts)

my previous analysis. If not, could you provide another better way to 
fix it?

Guoqing

