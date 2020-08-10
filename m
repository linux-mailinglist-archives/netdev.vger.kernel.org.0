Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116F0240764
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHJOVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:21:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgHJOVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:21:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k58fp-008xEv-UO; Mon, 10 Aug 2020 16:21:13 +0200
Date:   Mon, 10 Aug 2020 16:21:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 5/7] settings: simplify link_mode_info[]
 initializers
Message-ID: <20200810142113.GH2123435@lunn.ch>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <92e78acec9d1b68ea048b39bbb079548df186c9f.1597007533.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92e78acec9d1b68ea048b39bbb079548df186c9f.1597007533.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:24:32PM +0200, Michal Kubecek wrote:
> Use macro helpers to make link_mode_info[] initializers easier to read and
> less prone to mistakes. As a bonus, this gets rid of "missing field
> initializer" warnings in netlink/settings.c
> 
> This commit should have no effect on resulting code (checked with gcc-11
> and -O2).
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
