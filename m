Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A83933811B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhCKXLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:11:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCKXKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 18:10:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKURy-00AQt6-4T; Fri, 12 Mar 2021 00:10:38 +0100
Date:   Fri, 12 Mar 2021 00:10:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net: dsa: hellcreek: Move common code to
 helper
Message-ID: <YEqjblYcP723NbOG@lunn.ch>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
 <20210311175344.3084-6-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311175344.3084-6-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 06:53:43PM +0100, Kurt Kanzenbach wrote:
> There are two functions which need to populate fdb entries. Move that to a
> helper function.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
