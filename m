Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784D82CE52D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgLDBeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:34:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgLDBeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:34:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkzyK-00A8KN-Ue; Fri, 04 Dec 2020 02:33:20 +0100
Date:   Fri, 4 Dec 2020 02:33:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201204013320.GA2414548@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201203162428.ffdj7gdyudndphmn@skbuf>
 <87a6uu7gsr.fsf@waldekranz.com>
 <20201203215725.uuptum4qhcwvhb6l@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203215725.uuptum4qhcwvhb6l@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Of course, neither is fully correct. There is always more to improve on
> the communication side of things.

I wonder if switchdev needs to gain an enumeration API? A way to ask
the underlying driver, what can you offload? The user can then get an
idea what is likely to be offloaded, and what not. If that API is fine
grain enough, it can list the different LAG algorithms supported.

      Andrew
