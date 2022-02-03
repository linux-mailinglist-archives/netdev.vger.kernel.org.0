Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45EC4A909F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 23:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355794AbiBCWXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 17:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCWXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 17:23:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16B1C061714;
        Thu,  3 Feb 2022 14:23:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nFkVb-000435-Qq; Thu, 03 Feb 2022 23:23:19 +0100
Date:   Thu, 3 Feb 2022 23:23:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 05/52] netfilter: nf_conntrack_netbios_ns:
 fix helper module alias
Message-ID: <20220203222319.GB14142@breakpoint.cc>
References: <20220203202947.2304-1-sashal@kernel.org>
 <20220203202947.2304-5-sashal@kernel.org>
 <20220203134622.5964eb15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203134622.5964eb15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  3 Feb 2022 15:28:59 -0500 Sasha Levin wrote:
> > Intentionally not adding a fixes-tag because i don't want this to go to
> > stable. 
> 
> Ekhm. ;)

Seems there is no way to hide fixes from stable guys :-)

Seriously, I don't think there is anything going to break here because
'modinfo nfct-helper-netbios_ns' and 'modinfo nfct-helper-netbios-ns'
return same module.

OTOH, this was noticed by pure coincidence; I don't think its
important to have it in stable.
