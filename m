Return-Path: <netdev+bounces-713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E93C96F934C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 19:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B95A1C21B88
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 17:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256DDA957;
	Sat,  6 May 2023 17:18:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F9310F2
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 17:18:45 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D615150E8;
	Sat,  6 May 2023 10:18:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1pvLY9-0006AS-DS; Sat, 06 May 2023 19:18:25 +0200
Date: Sat, 6 May 2023 19:18:25 +0200
From: Florian Westphal <fw@strlen.de>
To: "Fengtao (fengtao, Euler)" <fengtao40@huawei.com>
Cc: Florian Westphal <fw@strlen.de>, jhs@mojatatu.com,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
	kuba@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, yanan@huawei.com,
	caowangbao@huawei.com
Subject: Re: BUG: KASAN: stack-out-of-bounds in __ip_options_echo
Message-ID: <20230506171825.GA21013@breakpoint.cc>
References: <05324dd2-3620-8f07-60a0-051814913ff8@huawei.com>
 <20230502165446.GA22029@breakpoint.cc>
 <9dd7ec8f-bc40-39af-febb-a7e8aabbaaed@huawei.com>
 <20230505055822.GA6126@breakpoint.cc>
 <4f3d231e-5ba8-08a9-e2d3-95edf5bb2dc7@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f3d231e-5ba8-08a9-e2d3-95edf5bb2dc7@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fengtao (fengtao, Euler) <fengtao40@huawei.com> wrote:
> I already tested your patch for 24 hours, and the panic never happened; Could you send your commit to kernel-upstream?
> If you do not have time, I would be happy to sent this patch and add your SOB.

You can submit a patch since you did the analysis and testing. You can add:

Suggested-by: Florian Westphal <fw@strlen.de>

Thanks!

