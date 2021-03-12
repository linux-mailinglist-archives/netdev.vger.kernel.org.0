Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AAF33905F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhCLOwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:52:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53988 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhCLOw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 09:52:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKj9M-00AXgg-LW; Fri, 12 Mar 2021 15:52:24 +0100
Date:   Fri, 12 Mar 2021 15:52:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     ChiaHao Hsu <andyhsu@amazon.com>
Cc:     netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YEuAKNyU6Hma39dN@lunn.ch>
References: <20210311225944.24198-1-andyhsu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311225944.24198-1-andyhsu@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 10:59:44PM +0000, ChiaHao Hsu wrote:
> In order to support live migration of guests between kernels
> that do and do not support 'feature-ctrl-ring', we add a
> module parameter that allows the feature to be disabled
> at run time, instead of using hardcode value.
> The default value is enable.

Hi ChiaHao

There is a general dislike for module parameters. What other mechanisms
have you looked at? Would an ethtool private flag work?

     Andrew
