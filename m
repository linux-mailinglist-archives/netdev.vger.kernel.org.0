Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C931785FBE
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 12:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbfHHKde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 06:33:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58966 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728289AbfHHKde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 06:33:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hvfje-0008Ep-UW; Thu, 08 Aug 2019 12:33:30 +0200
Date:   Thu, 8 Aug 2019 12:33:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netfilter/nf_nat_proto.c - make tables static
Message-ID: <20190808103330.ijyw6n4eystwury4@breakpoint.cc>
References: <55481.1565243002@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55481.1565243002@turing-police>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Valdis Klētnieks <valdis.kletnieks@vt.edu> wrote:
> Sparse warns about two tables not being declared.
> 
>   CHECK   net/netfilter/nf_nat_proto.c
> net/netfilter/nf_nat_proto.c:725:26: warning: symbol 'nf_nat_ipv4_ops' was not declared. Should it be static?
> net/netfilter/nf_nat_proto.c:964:26: warning: symbol 'nf_nat_ipv6_ops' was not declared. Should it be static?
> 
> And in fact they can indeed be static.

Acked-by: Florian Westphal <fw@strlen.de>

Seems i removed the static qualifier when i added inet nat support,
but the patch that was merged doesn't use them outside of
nf_nat_proto.c.

Thanks for fixing this.
