Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523773247AC
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhBXXzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:55:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhBXXzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:55:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF3zU-008JtV-Pq; Thu, 25 Feb 2021 00:54:48 +0100
Date:   Thu, 25 Feb 2021 00:54:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 02/12] Documentation: networking: dsa:
 rewrite chapter about tagging protocol
Message-ID: <YDbnSDrzdhywyg6+@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-3-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +It is desirable that all tagging protocols are testable with the ``dsa_loop``
> +mockup driver, which can be attached to any network interface. The goal is that
> +any network interface should be able of transmitting the same packet in the

should be _capable_ of ??

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
