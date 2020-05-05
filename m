Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731031C5454
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 13:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEEL0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 07:26:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:42288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgEEL0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 07:26:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 19E82AD12;
        Tue,  5 May 2020 11:26:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 173E8602B9; Tue,  5 May 2020 13:26:48 +0200 (CEST)
Date:   Tue, 5 May 2020 13:26:48 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 09/10] net: phy: Put interface into oper
 testing during cable test
Message-ID: <20200505112647.GM8237@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-10-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505001821.208534-10-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:18:20AM +0200, Andrew Lunn wrote:
> Since running a cable test is disruptive, put the interface into
> operative state testing while the test is running.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Things could be simplified a bit by putting netif_testing_off() into
ethnl_cable_test_finished() but it's probably not worth the confusion
from setting the state in one place and clearing it in a completely
different one.

Michal
