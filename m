Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2277B1F7E40
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 22:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFLUvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 16:51:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFLUvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 16:51:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jjqeR-000Kex-1H; Fri, 12 Jun 2020 22:51:47 +0200
Date:   Fri, 12 Jun 2020 22:51:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, wu000273@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix a potential incorrect error handling in
 rawsock_connect
Message-ID: <20200612205147.GC69216@lunn.ch>
References: <20200612203745.58304-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612203745.58304-1-pakki001@umn.edu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 03:37:43PM -0500, Aditya Pakki wrote:
> In rawsock_connect, the device is allocated by calling nfc_get_device.
> In case of incorrect bounds index, the device should be freed by
> calling nfc_put_device. The patch fixes this issue.

Hi Aditya

Putting nfc in the Subject: would of been nice.

People are more likely to review your patch if they can easily spot it
modifies some core they are interested in. The name of the driver, or
the subsystem in net/ is something that people look out for.

You might also want to read the netdev FAQ.

    Andrew
