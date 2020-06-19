Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0042015EF
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 18:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394566AbgFSQYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 12:24:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390342AbgFSO6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 10:58:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmISw-001HqP-VA; Fri, 19 Jun 2020 16:58:02 +0200
Date:   Fri, 19 Jun 2020 16:58:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 0/3] Add Marvell 88E1340S, 88E1548P support
Message-ID: <20200619145802.GJ279339@lunn.ch>
References: <20200619084904.95432-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619084904.95432-1-fido_max@inbox.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:49:01AM +0300, Maxim Kochetkov wrote:
> This patch series add new PHY id support.
> Russell King asked to use single style for referencing functions.

Hi Maxim

In future, please put which tree this patchset is for into the subject
line:

[PATCH net-next v2] ...

       Andrew
