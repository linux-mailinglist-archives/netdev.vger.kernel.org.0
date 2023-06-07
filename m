Return-Path: <netdev+bounces-8786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC907725BD0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 146211C20D01
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19586FBB;
	Wed,  7 Jun 2023 10:46:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72EB79F7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:46:58 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2045B1BD8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:46:37 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QbkW84ZwFzlXJ0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:44:52 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 18:46:35 +0800
Message-ID: <0e4a9752-ab3e-07cd-e030-45f230481d0b@huawei.com>
Date: Wed, 7 Jun 2023 18:46:34 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: selftests/tc-testings cgroup.json test failed
To: Hangbin Liu <liuhangbin@gmail.com>
CC: <netdev@vger.kernel.org>
References: <ZIBT2d9U9/pdR/gc@Laptop-X1>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <ZIBT2d9U9/pdR/gc@Laptop-X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/7 17:54, Hangbin Liu wrote:
> Hi Zhengchao,
> 
> I tried run cgroup.json (and flow.json) with linux 6.3 and iproute 6.3.
> But almost test failed. e.g.
> 
> All test results:
> 
> 1..56
> not ok 1 6273 - Add cgroup filter with cmp ematch u8/link layer and drop action
>          Could not match regex pattern. Verify command output:
> filter protocol ip pref 1 cgroup chain 0
> filter protocol ip pref 1 cgroup chain 0 handle 0x1
>          action order 1: gact action drop
>           random type none pass val 0
>           index 1 ref 1 bind 1
> 
> 
> not ok 2 4721 - Add cgroup filter with cmp ematch u8/link layer with trans flag and pass action
>          Could not match regex pattern. Verify command output:
> filter protocol ip pref 1 cgroup chain 0
> filter protocol ip pref 1 cgroup chain 0 handle 0x1
>          action order 1: gact action pass
>           random type none pass val 0
>           index 1 ref 1 bind 1
> 
> 
> I saw the matchPattern checks ".*cmp..." which is not exist with my tc output.
> 
> "matchPattern": "^filter protocol ip pref [0-9]+ cgroup chain [0-9]+.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff gt 10\\)",
> 
> So which tc version are you using? Am I missed something?
>
Hi Hangbin:
	I upgraded iproute to 6.3.0 locally, and these test cases are
successfully executed. My kernel version is 6.4.0 and OS version is
ubuntu 1804 LTS. I am wondering if it had something to do with the OS?

Zhengchao Shao

> Thanks
> Hangbin

