Return-Path: <netdev+bounces-10718-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 065FA72FF0E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE4141C2040D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08C38BEF;
	Wed, 14 Jun 2023 12:50:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56516FD2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:50:05 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08154198
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:50:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1q9Pwf-00007c-5I; Wed, 14 Jun 2023 14:49:53 +0200
Date: Wed, 14 Jun 2023 14:49:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Lin Ma <linma@zju.edu.cn>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, tung.q.nguyen@dektech.com.au
Subject: Re: [PATCH v2] net: tipc: resize nlattr array to correct size
Message-ID: <20230614124953.GA15559@breakpoint.cc>
References: <20230614120604.1196377-1-linma@zju.edu.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614120604.1196377-1-linma@zju.edu.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Lin Ma <linma@zju.edu.cn> wrote:
> According to nla_parse_nested_deprecated(), the tb[] is supposed to the
> destination array with maxtype+1 elements. In current
> tipc_nl_media_get() and __tipc_nl_media_set(), a larger array is used
> which is unnecessary. This patch resize them to a proper size.

Reviewed-by: Florian Westphal <fw@strlen.de>

