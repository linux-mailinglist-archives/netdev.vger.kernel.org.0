Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042991D5AA8
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgEOUZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:25:01 -0400
Received: from ns.kevlo.org ([220.134.220.36]:59251 "EHLO ns.kevlo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgEOUZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 16:25:01 -0400
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 04FHN0cK002095
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 16 May 2020 01:23:01 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 04FHMwXH002094;
        Sat, 16 May 2020 01:22:58 +0800 (CST)
        (envelope-from kevlo)
Date:   Sat, 16 May 2020 01:22:58 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: phy: broadcom: add support for BCM54811 PHY
Message-ID: <20200515172258.GA2035@ns.kevlo.org>
References: <20200515052219.GA15435@ns.kevlo.org>
 <b2f12255-83a6-9de2-c82f-ebdc6b0352f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2f12255-83a6-9de2-c82f-ebdc6b0352f2@gmail.com>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 08:53:37AM -0700, Florian Fainelli wrote:
> 
> 
> 
> On 5/14/2020 10:22 PM, Kevin Lo wrote:
> > The BCM54811 PHY shares many similarities with the already supported BCM54810
> > PHY but additionally requires some semi-unique configuration.
> 
> This looks mostly fine, just a couple of nits:
> 
> - the patch should be submitted against net-next, since it is a new
> feature/addition and not a bug fix
> 
> - you need an additional entry to support the automatic loading of the
> PHY driver, that means adding an entry to the  broadcom_tbl array.

Thanks for the review.  I'm going to send it to net-next.

> 
> With that:
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> -- 
> Florian
