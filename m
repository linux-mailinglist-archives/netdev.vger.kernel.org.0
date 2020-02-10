Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDDF1573AF
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 12:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJLum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 06:50:42 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56576 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgBJLum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 06:50:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j17aL-0004Dl-2n; Mon, 10 Feb 2020 12:50:41 +0100
Date:   Mon, 10 Feb 2020 12:50:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 1/5] icmp: introduce helper for NAT'd source address
 in ndo context
Message-ID: <20200210115041.GF2991@breakpoint.cc>
References: <20200209143143.151632-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209143143.151632-1-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)

CONFIG_NF_NAT would be preferrable even though it makes little
difference in practice I guess.
