Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6917B245960
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgHPTj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:39:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbgHPTj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 15:39:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7OV3-009c5c-LS; Sun, 16 Aug 2020 21:39:25 +0200
Date:   Sun, 16 Aug 2020 21:39:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        jiri@mellanox.com
Subject: Re: [PATCH] net: devlink: Remove overzealous WARN_ON with snapshots
Message-ID: <20200816193925.GA2291288@lunn.ch>
References: <20200816192638.2291010-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816192638.2291010-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 09:26:38PM +0200, Andrew Lunn wrote:
> It is possible to trigger this WARN_ON from user space by triggering a
> devlink snapshot with an ID which already exists. We don't need both
> -EEXISTS being reported and spamming the kernel log.

Upps. Forgot the net-next in the subject line.

Jiri, should we backport this? I can rebase onto net?

      Andrew
