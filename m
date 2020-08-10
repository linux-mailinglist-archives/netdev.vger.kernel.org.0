Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653EF240743
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgHJOMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:12:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48710 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgHJOMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:12:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k58XG-008xBZ-PC; Mon, 10 Aug 2020 16:12:22 +0200
Date:   Mon, 10 Aug 2020 16:12:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/7] ioctl: check presence of eeprom length
 argument properly
Message-ID: <20200810141222.GE2123435@lunn.ch>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <fb0a0177b4cb7d477ff964a64c9293f7267fdd5c.1597007533.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb0a0177b4cb7d477ff964a64c9293f7267fdd5c.1597007533.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:24:22PM +0200, Michal Kubecek wrote:
> In do_geeprom(), do_seprom() and do_getmodule(), check if user used
> "length" command line argument is done by setting the value to -1 before
> parsing and checking if it changed. This is quite ugly and also causes
> compiler warnings as the variable is u32.
> 
> Use proper "seen" flag to let parser tell us if the argument was used.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
