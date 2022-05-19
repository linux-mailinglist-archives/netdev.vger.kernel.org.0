Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E4052DE6A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244775AbiESUbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244768AbiESUbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:31:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18D0D46142
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:31:15 -0700 (PDT)
Date:   Thu, 19 May 2022 22:31:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Oliver Smith <osmith@sysmocom.de>,
        netdev@vger.kernel.org, Harald Welte <laforge@gnumonks.org>
Subject: Re: regression: 'ctnetlink_dump_one_entry' defined but not used
Message-ID: <YoapDx2ZIBlXs3nr@salvia>
References: <97b1ea34-250b-48ba-bc04-321b6c0482c1@sysmocom.de>
 <20220519102100.GJ4316@breakpoint.cc>
 <20220519131341.36c8b24e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220519131341.36c8b24e@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 01:13:41PM -0700, Jakub Kicinski wrote:
> On Thu, 19 May 2022 12:21:00 +0200 Florian Westphal wrote:
> > Oliver Smith <osmith@sysmocom.de> wrote:
> > > Hi Florian,
> > > 
> > > since May 17 we see some automatic builds against net-next.git fail with:
> > >   
> > > > net/netfilter/nf_conntrack_netlink.c:1717:12: error: 'ctnetlink_dump_one_entry' defined but not used [-Werror=unused-function]
> > > >  1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
> > > >       |            ^~~~~~~~~~~~~~~~~~~~~~~~  
> > > 
> > > Looks like this is a regression from your patch 8a75a2c17, I guess
> > > ctnetlink_dump_one_entry needs #ifdef CONFIG_NF_CONNTRACK_EVENTS?  
> > 
> > Its fixed in nf-next.
> 
> Let's get it out to net-next, please, I'm carrying this patch locally
> as well :(

I'll prepare a pull request asap.
