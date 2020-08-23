Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7744A24EFAC
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 22:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHWUI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 16:08:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40796 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgHWUI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 16:08:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9wHz-00BQsM-98; Sun, 23 Aug 2020 22:08:27 +0200
Date:   Sun, 23 Aug 2020 22:08:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 4/9] ioctl: make argc counters unsigned
Message-ID: <20200823200827.GI2588906@lunn.ch>
References: <cover.1598210544.git.mkubecek@suse.cz>
 <7bf829e6ec7b80b6a4e69cf59f54a36b1934fab9.1598210544.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bf829e6ec7b80b6a4e69cf59f54a36b1934fab9.1598210544.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 09:40:27PM +0200, Michal Kubecek wrote:
> Use unsigned int for cmd_context::argc and local variables used for
> command line argument count. These counters may never get negative and are
> often compared to unsigned expressions.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
