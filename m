Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6CE6D9294
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbjDFJXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjDFJXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:23:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D5B01BC5;
        Thu,  6 Apr 2023 02:23:13 -0700 (PDT)
Date:   Thu, 6 Apr 2023 11:23:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chen Aotian <chenaotian2@163.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kadlec@netfilter.org, edumazet@google.com, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [netfilter-core] [PATCH] netfilter: nf_tables: Modify
 nla_memdup's flag to GFP_KERNEL_ACCOUNT
Message-ID: <ZC6PfTJmIiAhiG6C@salvia>
References: <20230406040151.1676-1-chenaotian2@163.com>
 <ZC6PLsY0+WWW21wE@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZC6PLsY0+WWW21wE@salvia>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 11:21:50AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 06, 2023 at 12:01:51PM +0800, Chen Aotian wrote:
> > For memory alloc that store user data from nla[NFTA_OBJ_USERDATA], 
> > use GFP_KERNEL_ACCOUNT is more suitable.
> >
> 
> Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
> 
> > Signed-off-by: Chen Aotian <chenaotian2@163.com>

BTW, this patch is intended for nf.git, I'll apply it now.
