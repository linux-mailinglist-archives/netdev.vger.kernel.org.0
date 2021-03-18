Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA44340173
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 10:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCRJHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 05:07:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:33318 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229808AbhCRJGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 05:06:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 86DE6AC1E;
        Thu, 18 Mar 2021 09:06:52 +0000 (UTC)
Date:   Thu, 18 Mar 2021 10:06:52 +0100
From:   Jiri Bohac <jbohac@suse.cz>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH] net: check all name nodes in  __dev_alloc_name
Message-ID: <20210318090652.tetotzcnoiqjtlue@dwarf.suse.cz>
References: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
 <20210317211108.5b2cdc77@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317211108.5b2cdc77@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 09:11:08PM -0700, Stephen Hemminger wrote:
> Rather than copy/paste same code two places, why not make a helper function?

I tried and in it was ugly (too many dependencies into the
currecnt function)

Another option I considered and scratched was to opencode and
modify list_for_each to also act on the dev->name_node
which contains the list head. Or maybe one of the
list_for_each_* variants could be directly misused for that.

I don't understand why this has been designed in such a
non-standard way; why is the first node not part of the list and
the head directly in the net_device?

In the end I considered the copy'n'paste of 9 lines the least
ugly and most readable.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

