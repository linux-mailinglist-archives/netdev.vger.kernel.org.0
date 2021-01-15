Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405432F7E3A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbhAOObR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:31:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbhAOObP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 09:31:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0Q7S-000lDP-MS; Fri, 15 Jan 2021 15:30:30 +0100
Date:   Fri, 15 Jan 2021 15:30:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy
 implementations for trunk setters
Message-ID: <YAGnBqB08wwWQul8@lunn.ch>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115105834.559-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 11:58:33AM +0100, Tobias Waldekranz wrote:
> Support for Global 2 registers is build-time optional.

I was never particularly happy about that. Maybe we should revisit
what features we loose when global 2 is dropped, and see if it still
makes sense to have it as optional?

However, until that happens:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
