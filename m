Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FD21FE094
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgFRBs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:48:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45456 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731984AbgFRB14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljLP-00131y-97; Thu, 18 Jun 2020 03:27:55 +0200
Date:   Thu, 18 Jun 2020 03:27:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [net-next PATCH 2/5 v2] net: dsa: rtl8366rb: Support the CPU DSA
 tag
Message-ID: <20200618012755.GC249144@lunn.ch>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
 <20200617083132.1847234-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617083132.1847234-2-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:31:29AM +0200, Linus Walleij wrote:
> This activates the support to use the CPU tag to properly
> direct ingress traffic to the right port.
> 
> Bit 15 in register RTL8368RB_CPU_CTRL_REG can be set to
> 1 to disable the insertion of the CPU tag which is what
> the code currently does. The bit 15 define calls this
> setting RTL8368RB_CPU_INSTAG which is confusing since the
> iverse meaning is implied: programmers may think that

inverse

> setting this bit to 1 will *enable* inserting the tag
> rather than disablinbg it, so rename this setting in

disabling

> bit 15 to RTL8368RB_CPU_NO_TAG which is more to the
> point.
> 
> After this e.g. ping works out-of-the-box with the
> RTL8366RB.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
