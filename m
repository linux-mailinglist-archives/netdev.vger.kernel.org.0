Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8E72B0985
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgKLQIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:08:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgKLQIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:08:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdF9E-006gNm-J5; Thu, 12 Nov 2020 17:08:32 +0100
Date:   Thu, 12 Nov 2020 17:08:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jian Yang <jianyang.kernel@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
Message-ID: <20201112160832.GB1456319@lunn.ch>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 12:43:08PM -0800, Jian Yang wrote:
> From: Mahesh Bandewar <maheshb@google.com>
> 
> Traditionally loopback devices comes up with initial state as DOWN for
> any new network-namespace. This would mean that anyone needing this
> device (which is mostly true except sandboxes where networking in not
> needed at all), would have to bring this UP by issuing something like
> 'ip link set lo up' which can be avoided if the initial state can be set
> as UP.

How useful is lo if it is up, but has no IP address? I don't think
this change adds the IP addresses does it? So you still need something
inside your netns to add the IP addresses? Which seems to make this
change pointless?

       Andrew
