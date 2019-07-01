Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778485C208
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfGARd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:33:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbfGARd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M6ak96NnHm1e/ciVGkISdA2XaYTHKY8l+a2ljt8tsgw=; b=dPEWwt/RRRwnh9CQ4VDy4gV/NZ
        56lTKzX6q0jcWfT/bGGda3iX+BiEbwH6FXTZ/3wcUTbqV9j+cRubr12YUCoU5PwjiK8tMExokz4Li
        n991FY5ft+IjofEDyY+8oc4//+ujFA4dixRKJluIWPTV0XgDYEnGOlU4+8DgUPNkCSLk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hi0Bf-0000QV-SB; Mon, 01 Jul 2019 19:33:55 +0200
Date:   Mon, 1 Jul 2019 19:33:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH v2 1/2] Documentation: net: dsa: Describe DSA switch
 configuration
Message-ID: <20190701173355.GG30468@lunn.ch>
References: <20190701154209.27656-1-b.spranger@linutronix.de>
 <20190701154209.27656-2-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701154209.27656-2-b.spranger@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 05:42:08PM +0200, Benedikt Spranger wrote:
> Document DSA tagged and VLAN based switch configuration by showcases.
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> ---
>  .../networking/dsa/configuration.rst          | 292 ++++++++++++++++++
>  Documentation/networking/dsa/index.rst        |   1 +
>  2 files changed, 293 insertions(+)
>  create mode 100644 Documentation/networking/dsa/configuration.rst
> 
> diff --git a/Documentation/networking/dsa/configuration.rst b/Documentation/networking/dsa/configuration.rst
> new file mode 100644
> index 000000000000..55d6dce6500d
> --- /dev/null
> +++ b/Documentation/networking/dsa/configuration.rst
> @@ -0,0 +1,292 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=======================================
> +DSA switch configuration from userspace
> +=======================================
> +
> +The DSA switch configuration is not integrated into the main userspace
> +network configuration suites by now and has to be performed manualy.
> +
> +.. _dsa-config-showcases:
> +
> +Configuration showcases
> +-----------------------
> +
> +To configure a DSA switch a couple of commands need to be executed. In this
> +documentation some common configuration scenarios are handled as showcases:
> +
> +*single port*
> +  Every switch port acts as a different configurable Ethernet port
> +
> +*bridge*
> +  Every switch port is part of one configurable Ethernet bridge
> +
> +*gateway*
> +  Every switch port except one upstream port is part of a configurable
> +  Ethernet bridge.
> +  The upstream port acts as different configurable Ethernet port.
> +
> +All configurations are performed with tools from iproute2, wich is available at

which

Once that is fixed:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
