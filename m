Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A836D38
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFFHUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:20:08 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59168 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfFFHUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:20:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hYmgv-0003Oa-Qx; Thu, 06 Jun 2019 09:20:05 +0200
Date:   Thu, 6 Jun 2019 09:20:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Florian Westphal <fw@strlen.de>, kbuild-all@01.org,
        netdev@vger.kernel.org
Subject: Re: [ipsec-next:testing 4/6] net/xfrm/xfrm_state.c:1792:9: error:
 '__xfrm6_tmpl_sort_cmp' undeclared; did you mean 'xfrm_tmpl_sort'?
Message-ID: <20190606072005.5re77ol5ebyu5rfo@breakpoint.cc>
References: <201906052002.P2x8MWme%lkp@intel.com>
 <20190605124045.gzkafkixihwu7447@breakpoint.cc>
 <20190606063832.GC17989@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606063832.GC17989@gauss3.secunet.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steffen Klassert <steffen.klassert@secunet.com> wrote:
> On Wed, Jun 05, 2019 at 02:40:45PM +0200, Florian Westphal wrote:
> > 
> > Steffen, as this is still only in your testing branch, I suggest you
> > squash this snipped into commit 8dc6e3891a4be64c0cca5e8fe2c3ad33bc06543e
> > ("xfrm: remove state and template sort indirections from xfrm_state_afinfo"),
> > it resolves this problem for me.
> 
> Ok, I did that. Please doublecheck my work.

Looks good to me, also, the updated ipsec-next/testing now builds with
CONFIG_IPV6=n.

Thanks,
Florian
