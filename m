Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E3724075E
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgHJOT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:19:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48724 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgHJOTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:19:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k58e4-008xDo-A0; Mon, 10 Aug 2020 16:19:24 +0200
Date:   Mon, 10 Aug 2020 16:19:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 3/7] ioctl: get rid of signed/unsigned comparison
 warnings
Message-ID: <20200810141924.GF2123435@lunn.ch>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <0365573afe3649e47c1aa2490e1818a50613ee0a.1597007533.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0365573afe3649e47c1aa2490e1818a50613ee0a.1597007533.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	while (arg_num < ctx->argc) {
> +	while (arg_num < (unsigned int)ctx->argc) {

Did you try changing ctx->argc to an unsigned int? I guess there would
be less casts that way, and it is a more logical type for this.

    Andrew
