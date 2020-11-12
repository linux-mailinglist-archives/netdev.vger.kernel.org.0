Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D462B12CD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgKLXap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:30:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKLXao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:30:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9E32216C4;
        Thu, 12 Nov 2020 23:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605223844;
        bh=/smW2Mj/RmZNaBmvs2fa3vn4w5/l4ecXd3sUvqUUKcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A3+LNyE4rH/brfsnlvqYeUqTr+mQGuUZ5ONmEifkkSpHc3V+EpZmGI/juttmo3PVM
         72iox8ZrH6+MTt2zdbP9Qgg7jt7cFhkB+wIx7k73ferTDc/tdIeQJxsj4ntpA//lho
         R0LLhGGoITE4fV3tIbvGcmYhcd+0zFdW1Y600TK4=
Date:   Thu, 12 Nov 2020 15:30:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lev Stipakov <lstipakov@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lev Stipakov <lev@openvpn.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/3] net: mac80211: use core API for updating TX stats
Message-ID: <20201112153042.23df4eb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112110953.34055-1-lev@openvpn.net>
References: <20201112110953.34055-1-lev@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 13:09:53 +0200 Lev Stipakov wrote:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add")
> has added function "dev_sw_netstats_tx_add()" to update
> net device per-cpu TX stats.
> 
> Use this function instead of ieee80211_tx_stats().
> 
> Signed-off-by: Lev Stipakov <lev@openvpn.net>

Heiner is actively working on this.

Heiner, would you mind looking at these three patches? If you have
these changes queued in your tree I'm happy to wait for them.
