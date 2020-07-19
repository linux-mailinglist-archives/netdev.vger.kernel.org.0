Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4F322527D
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 17:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgGSPbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 11:31:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgGSPbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 11:31:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxBHN-005t2I-4r; Sun, 19 Jul 2020 17:31:05 +0200
Date:   Sun, 19 Jul 2020 17:31:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: Wrap ndo_do_ioctl() to prepare for DSA
 stacked ops
Message-ID: <20200719153105.GI1383417@lunn.ch>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718030533.171556-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 08:05:30PM -0700, Florian Fainelli wrote:
> In preparation for adding another layer of call into a DSA stacked ops
> singleton, wrap the ndo_do_ioctl() call into dev_do_ioctl().
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
