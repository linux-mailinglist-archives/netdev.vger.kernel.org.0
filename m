Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B98849BD56
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 21:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiAYUlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 15:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiAYUlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 15:41:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415EAC06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 12:41:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D234D61780
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C3BC340E0;
        Tue, 25 Jan 2022 20:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643143270;
        bh=rgE6CLs63EH5FYzaJgYp9J+dQbdgQkXaMMO0PoWnYQE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ulalc1fGdRREPeMcw0XYbHiCWdVXz1T7MCiTVW1iymfbHS5zje8nSs+Mt/km412Ut
         Lk6I4w4ZnlgCf69GVDn/yjY64o8vY1jl4b914w8okxTiX+YjADaec8sjmzdG/bsR4t
         KlCV4kCIwtrZ1OKv097MjaSV6KECy4zXu2YC4Oi29EQh49zQpJZoVFfj8nRS61g2gl
         G8ZWq28M+nQkPnKHp+qhBGXFRe35TwHbQL8hQ3btGqKsWu5IbPxCjeQ36Cz90KV7p+
         L63bE9oYC0+hld/oN/Okfss5SPAGGpMv9mmsKNdpSzCYBMlqyBl/6OqTayBmluMQUs
         uz6WYZS/AHf9g==
Date:   Tue, 25 Jan 2022 12:41:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: dsa: Avoid cross-chip syncing of VLAN
 filtering
Message-ID: <20220125124108.5a19f007@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <87wninbppy.fsf@waldekranz.com>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
        <20220125100131.1e0c7beb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <87wninbppy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 20:05:45 +0100 Tobias Waldekranz wrote:
> On Tue, Jan 25, 2022 at 10:01, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 24 Jan 2022 22:09:42 +0100 Tobias Waldekranz wrote:  
> >> This bug has been latent in the source for quite some time, I suspect
> >> due to the homogeneity of both typical configurations and hardware.
> >> 
> >> On singlechip systems, this would never be triggered. The only reason
> >> I saw it on my multichip system was because not all chips had the same
> >> number of ports, which means that the misdemeanor alien call turned
> >> into a felony array-out-of-bounds access.  
> >
> > Applied, thanks, 934d0f039959 ("Merge branch
> > 'dsa-avoid-cross-chip-vlan-sync'") in net-next.  
> 
> Is there a particular reason that this was applied to net-next?

Not sure, there were issues with kernel.org infra during the night,
could be unintentional.

> I guess my question is really: will it still be considered for
> upcoming stable kernel releases?

Only after the next merge window, but yes.
