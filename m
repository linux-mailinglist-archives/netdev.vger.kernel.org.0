Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BC51FE174
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbgFRBZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:25:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731493AbgFRBZu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljJM-001303-JJ; Thu, 18 Jun 2020 03:25:48 +0200
Date:   Thu, 18 Jun 2020 03:25:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [net-next PATCH 1/5 v2] net: dsa: tag_rtl4_a: Implement Realtek
 4 byte A tag
Message-ID: <20200618012548.GB249144@lunn.ch>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617083132.1847234-1-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:31:28AM +0200, Linus Walleij wrote:
> This implements the known parts of the Realtek 4 byte
> tag protocol version 0xA, as found in the RTL8366RB
> DSA switch.
 
Hi Linus

David likes to have a 0/X patch which contains the big picture for the
patchset. It gets used for the merge commit he makes for the patchset.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
