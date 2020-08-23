Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D960C24EFAB
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 22:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgHWUGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 16:06:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgHWUGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 16:06:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9wGS-00BQr4-Hj; Sun, 23 Aug 2020 22:06:52 +0200
Date:   Sun, 23 Aug 2020 22:06:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 1/9] netlink: get rid of signed/unsigned
 comparison warnings
Message-ID: <20200823200652.GH2588906@lunn.ch>
References: <cover.1598210544.git.mkubecek@suse.cz>
 <06083ab4701848eeb56afec9a5d8b757dd6cb399.1598210544.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06083ab4701848eeb56afec9a5d8b757dd6cb399.1598210544.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 09:40:18PM +0200, Michal Kubecek wrote:
> Use unsigned types where appropriate to get rid of compiler warnings about
> comparison between signed and unsigned integer values in netlink code.
> 
> v2: avoid casts in dump_features()
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
