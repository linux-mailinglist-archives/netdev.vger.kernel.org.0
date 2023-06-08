Return-Path: <netdev+bounces-9329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5743C728754
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E078C2817DA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA42168CE;
	Thu,  8 Jun 2023 18:36:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E022F7E3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:36:39 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD952697
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:36:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1q7KUu-0002gl-Ke; Thu, 08 Jun 2023 20:36:36 +0200
Date: Thu, 8 Jun 2023 20:36:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net v2 0/3] net/sched: act_ipt bug fixes
Message-ID: <20230608183636.GG27126@breakpoint.cc>
References: <20230608140246.15190-1-fw@strlen.de>
 <CAM0EoMmcgoTbneB+JYt_oUKwsFMiA7xsuCWA=epr=mZnzhaX6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoMmcgoTbneB+JYt_oUKwsFMiA7xsuCWA=epr=mZnzhaX6w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On Thu, Jun 8, 2023 at 10:03 AM Florian Westphal <fw@strlen.de> wrote:
> > I think that we should consider removal of this module, while
> > this should take care of all problems, its ipv4 only and I don't
> > think there are any netfilter targets that lack a native tc
> > equivalent, even when ignoring bpf.
> >
> 
> I am all for removing it - but i am worried there are users based on
> past interactions. Will try to ping some users and see if they
> actually were using it.

Thanks Jamal.  I'd also be interested in what xt module(s) are used,
if any.

> I will send a patch to retire it if it looks
> safe.

Thanks.

