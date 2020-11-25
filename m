Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AE32C4587
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgKYQo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730115AbgKYQo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 11:44:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58128C0613D4;
        Wed, 25 Nov 2020 08:44:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1khxuQ-0001mb-95; Wed, 25 Nov 2020 17:44:46 +0100
Date:   Wed, 25 Nov 2020 17:44:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Marco Elver <elver@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org, a.nogikh@gmail.com, edumazet@google.com,
        andreyknvl@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, idosch@idosch.org, fw@strlen.de,
        willemb@google.com
Subject: Re: [PATCH v6 0/3] net, mac80211, kernel: enable KCOV remote
 coverage collection for 802.11 frame handling
Message-ID: <20201125164446.GC2730@breakpoint.cc>
References: <20201125162455.1690502-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125162455.1690502-1-elver@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marco Elver <elver@google.com> wrote:
[..]

> v6:
> * Revert usage of skb extensions due to potential memory leak. Patch 2/3 is now
>   idential to that in v2.
> * Patches 1/3 and 3/3 are otherwise identical to v5.

The earlier series was already applied to net-next, so you need to
rebase on top of net-next and include a revert of the patch that added
the kcov skb extension.

Also, please indicate the git tree that you want this applied to in the
subject.
