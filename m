Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAB9240767
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHJOVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:21:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgHJOVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:21:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k58gJ-008xFS-2k; Mon, 10 Aug 2020 16:21:43 +0200
Date:   Mon, 10 Aug 2020 16:21:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 6/7] ioctl: convert cmdline_info arrays to named
 initializers
Message-ID: <20200810142143.GI2123435@lunn.ch>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <fc5fd96e639e92bcfea5c1574dd8265e4de2aa03.1597007533.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc5fd96e639e92bcfea5c1574dd8265e4de2aa03.1597007533.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:24:35PM +0200, Michal Kubecek wrote:
> To get rid of remaining "missing field initializer" compiler warnings,
> convert arrays of struct cmdline_info used for command line parser to
> named initializers. This also makes the initializers easier to read.
> 
> This commit should have no effect on resulting code (checked with gcc-11
> and -O2).
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
