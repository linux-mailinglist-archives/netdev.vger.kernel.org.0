Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B187240768
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgHJOWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:22:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgHJOWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:22:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k58gj-008xFz-51; Mon, 10 Aug 2020 16:22:09 +0200
Date:   Mon, 10 Aug 2020 16:22:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 7/7] build: add -Wextra to default CFLAGS
Message-ID: <20200810142209.GJ2123435@lunn.ch>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <12f1db189afc7798ff4d53326221ee6758628bc3.1597007533.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f1db189afc7798ff4d53326221ee6758628bc3.1597007533.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:24:38PM +0200, Michal Kubecek wrote:
> As a result of previous commits, ethtool source now builds with gcc
> versions 7-11 without any compiler warning with "-Wall -Wextra". Add
> "-Wextra" to default cflags to make sure that any new warnings are
> caught as early as possible.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
