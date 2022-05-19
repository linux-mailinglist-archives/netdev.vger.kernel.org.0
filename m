Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBE352D05E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbiESKVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiESKVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:21:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488BFF1F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:21:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nrdHA-0007kn-8B; Thu, 19 May 2022 12:21:00 +0200
Date:   Thu, 19 May 2022 12:21:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Oliver Smith <osmith@sysmocom.de>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        Harald Welte <laforge@gnumonks.org>
Subject: Re: regression: 'ctnetlink_dump_one_entry' defined but not used
Message-ID: <20220519102100.GJ4316@breakpoint.cc>
References: <97b1ea34-250b-48ba-bc04-321b6c0482c1@sysmocom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97b1ea34-250b-48ba-bc04-321b6c0482c1@sysmocom.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Smith <osmith@sysmocom.de> wrote:
> Hi Florian,
> 
> since May 17 we see some automatic builds against net-next.git fail with:
> 
> > net/netfilter/nf_conntrack_netlink.c:1717:12: error: 'ctnetlink_dump_one_entry' defined but not used [-Werror=unused-function]
> >  1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
> >       |            ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> Looks like this is a regression from your patch 8a75a2c17, I guess
> ctnetlink_dump_one_entry needs #ifdef CONFIG_NF_CONNTRACK_EVENTS?

Its fixed in nf-next.
