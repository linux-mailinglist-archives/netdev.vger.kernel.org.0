Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FFC1CCBAE
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgEJOxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:53:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:33084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgEJOxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 10:53:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 98B4CAC52;
        Sun, 10 May 2020 14:53:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EEF47602CA; Sun, 10 May 2020 16:53:20 +0200 (CEST)
Date:   Sun, 10 May 2020 16:53:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v3 04/10] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200510145320.GG30711@lion.mk-sys.cz>
References: <20200509162851.362346-1-andrew@lunn.ch>
 <20200509162851.362346-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509162851.362346-5-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 06:28:45PM +0200, Andrew Lunn wrote:
> Add the attributes needed to report cable test results to userspace.
> The reports are expected to be per twisted pair. A nested property per
> pair can report the result of the cable test. A nested property can
> also report the length of the cable to any fault.
> 
> v2:
> Grammar fixes
> Change length from u16 to u32
> s/DEV/HEADER/g
> Add status attributes
> Rename pairs from numbers to letters.
> 
> v3:
> Fixed example in document
> Add ETHTOOL_A_CABLE_NEST_* enum
> Add ETHTOOL_MSG_CABLE_TEST_NTF to documentation
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
