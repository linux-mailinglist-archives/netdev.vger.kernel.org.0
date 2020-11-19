Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA612B9DAB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgKSW2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgKSW2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:28:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57B3C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:28:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfsPI-00055D-Nj; Thu, 19 Nov 2020 23:28:00 +0100
Date:   Thu, 19 Nov 2020 23:28:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v2] aquantia: Remove the build_skb path
Message-ID: <20201119222800.GJ15137@breakpoint.cc>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ramsay, Lincoln <Lincoln.Ramsay@digi.com> wrote:
> > Ramsay, Lincoln <Lincoln.Ramsay@digi.com> wrote:
> > > The build_skb path fails to allow for an SKB header, but the hardware
> > > buffer it is built around won't allow for this anyway.
> > 
> > What problem is being resolved here?
> 
> Sorry... Do I need to re-post the context? (I thought the reply headers would have kept this with the original patch that included the justification, plus the discussion that led to this revised patch).

This is the only text that gets recorded in git, see

https://patchwork.kernel.org/project/netdevbpf/patch/CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com/

so, yes, please include this information in the patch description and
post a v3.

Thank you.
