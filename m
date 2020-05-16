Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1471A1D5DD2
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 04:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgEPCM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 22:12:29 -0400
Received: from ns.kevlo.org ([220.134.220.36]:55785 "EHLO ns.kevlo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgEPCM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 22:12:29 -0400
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 04G2Bxbg006096
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 16 May 2020 10:12:01 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 04G2BvAI006095;
        Sat, 16 May 2020 10:11:57 +0800 (CST)
        (envelope-from kevlo)
Date:   Sat, 16 May 2020 10:11:57 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: phy: broadcom: add support for BCM54811 PHY
Message-ID: <20200516021157.GA6075@ns.kevlo.org>
References: <20200515172447.GA2101@ns.kevlo.org>
 <20200515143142.20ee5a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515143142.20ee5a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 02:31:42PM -0700, Jakub Kicinski wrote:
> 
> On Sat, 16 May 2020 01:24:47 +0800 Kevin Lo wrote:
> > The BCM54811 PHY shares many similarities with the already supported BCM54810
> > PHY but additionally requires some semi-unique configuration.
> > 
> > Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Checkpatch complains about using spaces instead of tabs:
> 
> ERROR: code indent should use tabs where possible
> #80: FILE: drivers/net/phy/broadcom.c:359:
> +        }$

Thanks for spotting this out.  Will send the patch to fix it.
