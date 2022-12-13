Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D740D64B436
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiLML3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLML2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:28:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2127F1D0E9;
        Tue, 13 Dec 2022 03:28:27 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:28:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Li Qiong <liqiong@nfschina.com>, Simon Horman <horms@verge.net.au>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH v2] ipvs: add a 'default' case in do_ip_vs_set_ctl()
Message-ID: <Y5hh2NPmmkmD4VTt@salvia>
References: <272315c8-5e3b-e8ca-3c7f-68eccd0f2430@nfschina.com>
 <20221212074351.26440-1-liqiong@nfschina.com>
 <c3ca27a-f923-6eb6-bbe4-5e99b65c5940@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c3ca27a-f923-6eb6-bbe4-5e99b65c5940@ssi.bg>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 04:20:41PM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Mon, 12 Dec 2022, Li Qiong wrote:
> 
> > It is better to return the default switch case with
> > '-EINVAL', in case new commands are added. otherwise,
> > return a uninitialized value of ret.
> > 
> > Signed-off-by: Li Qiong <liqiong@nfschina.com>
> > Reviewed-by: Simon Horman <horms@verge.net.au>
> 
> 	Change looks correct to me for -next, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Applied, thanks.
