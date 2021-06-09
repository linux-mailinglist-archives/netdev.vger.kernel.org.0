Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AE53A1DBE
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 21:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhFITfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 15:35:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60022 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFITfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 15:35:54 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6D72C6422C;
        Wed,  9 Jun 2021 21:32:45 +0200 (CEST)
Date:   Wed, 9 Jun 2021 21:33:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] etfilter: fix array index out-of-bounds error
Message-ID: <20210609193353.GA4610@salvia>
References: <20210608153408.160652-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608153408.160652-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 04:34:08PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the array net->nf.hooks_ipv6 is accessed by index hook
> before hook is sanity checked. Fix this by moving the sanity check
> to before the array access.

Applied, thanks.
