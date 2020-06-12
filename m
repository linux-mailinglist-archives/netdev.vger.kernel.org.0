Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA731F7E2D
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgFLUrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 16:47:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38758 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFLUrB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 16:47:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jjqZM-000KbY-Gu; Fri, 12 Jun 2020 22:46:32 +0200
Date:   Fri, 12 Jun 2020 22:46:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, wu000273@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix potential memory leak caused in error
 handling
Message-ID: <20200612204632.GB69216@lunn.ch>
References: <20200612200656.56019-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612200656.56019-1-pakki001@umn.edu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 03:06:54PM -0500, Aditya Pakki wrote:
> In ethoc_probe, a failure of mdiobus_register() does not release
> the memory allocated by mdiobus_alloc. The patch fixes this issue.

Hi Aditya

Please improve the Subject: line to indicate which driver you are
fixing.

A Fixes: tag would also be nice.

  Andrew
