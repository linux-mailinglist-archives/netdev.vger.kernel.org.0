Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E373234B3F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387890AbgGaSix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:38:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbgGaSix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 14:38:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1Zvf-007jCt-Vp; Fri, 31 Jul 2020 20:38:51 +0200
Date:   Fri, 31 Jul 2020 20:38:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <dthompson@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200731183851.GG1748118@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config MLXBF_GIGE
> +	tristate "Mellanox Technologies BlueField Gigabit Ethernet support"
> +	depends on (ARM64 || COMPILE_TEST) && ACPI && INET
> +	select PHYLIB
> +	help
> +	  The second generation BlueField SoC from Mellanox Technologies
> +	  supports an out-of-band Gigabit Ethernet management port to the
> +	  Arm subsystem.

You might want to additionally select the PHY driver you are using.

    Andrew
