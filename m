Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE4B4348F0
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhJTKbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhJTKbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 06:31:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE46C06161C;
        Wed, 20 Oct 2021 03:29:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1md8qV-00020Q-HQ; Wed, 20 Oct 2021 12:29:19 +0200
Date:   Wed, 20 Oct 2021 12:29:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eugene Crosser <crosser@average.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Subject: Re: [PATCH net 1/1] vrf: Revert "Reset skb conntrack connection..."
Message-ID: <YW/vf/NoIChwT4KI@strlen.de>
References: <20211018182250.23093-1-crosser@average.org>
 <20211018182250.23093-2-crosser@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018182250.23093-2-crosser@average.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eugene Crosser <crosser@average.org> wrote:
> This reverts commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1.
> 
> When an interface is enslaved in a VRF, prerouting conntrack hook is
> called twice: once in the context of the original input interface, and
> once in the context of the VRF interface. If no special precausions are
> taken, this leads to creation of two conntrack entries instead of one,
> and breaks SNAT.

Fixes: 09e856d54bda5f ("vrf: Reset skb conntrack connection on VRF rcv")
Acked-by: Florian Westphal <fw@strlen.de>
