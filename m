Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C323A77D
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgHCNb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:31:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40220 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgHCNb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 09:31:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2aYn-0082pS-TP; Mon, 03 Aug 2020 15:31:25 +0200
Date:   Mon, 3 Aug 2020 15:31:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 0/7] compiler warnings cleanup, part 1
Message-ID: <20200803133125.GN1862409@lunn.ch>
References: <cover.1596451857.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 01:57:03PM +0200, Michal Kubecek wrote:
> Maciej Żenczykowski recently cleaned up many "unused parameter" compiler
> warnings but some new occurences appeared since (mostly in netlink code).

Hi Michal

Could you modify the compiler flags to get gcc to warn about these?
Otherwise they will just come back again.

	  Andrew
