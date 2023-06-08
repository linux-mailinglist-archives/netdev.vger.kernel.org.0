Return-Path: <netdev+bounces-9233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F09E17281E3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59A401C20FEB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB5312B9C;
	Thu,  8 Jun 2023 13:57:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2100112B96
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:57:30 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A72BE2
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:57:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1q7G8d-0000ur-MG; Thu, 08 Jun 2023 15:57:19 +0200
Date: Thu, 8 Jun 2023 15:57:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Simon Horman <simon.horman@corigine.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net 1/3] net/sched: act_ipt: add sanity checks on table
 name and hook locations
Message-ID: <20230608135719.GC27126@breakpoint.cc>
References: <20230607145954.19324-1-fw@strlen.de>
 <20230607145954.19324-2-fw@strlen.de>
 <ZIGxCWZJoSGJZiUw@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIGxCWZJoSGJZiUw@corigine.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Simon Horman <simon.horman@corigine.com> wrote:
> I think that patches for 'net' usually come with a fixes tag.
> Likewise for the other patches in this series.

Right, I'll add
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

