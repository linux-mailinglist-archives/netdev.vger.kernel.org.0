Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CEC14F01B
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgAaPtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbgAaPtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:49:14 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930CF215A4;
        Fri, 31 Jan 2020 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580485753;
        bh=2gQzGawFtJ0AX22UQEgJjtt8igG3qLYSNb2ir/2wfMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VFofvlGVnSTjWet29KfyBW89m+C9xUCqYDJf9Nis2pKTde5nZZRSpGA5kDqcYR9f5
         IP3EjoYESb6+cp741OMwY8yfV+/X2MxWXxW4JlX0kvtzqAULwIH/sWwmPdAERt0QVl
         eS0NAhNZORbaNzbr7j2s09UIWW7Z+8OEIRjseqZA=
Date:   Fri, 31 Jan 2020 07:49:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/2] net: mdio: of: fix potential NULL pointer
 derefernce
Message-ID: <20200131074912.2218d30d@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130174451.17951-1-michael@walle.cc>
References: <20200130174451.17951-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 18:44:50 +0100, Michael Walle wrote:
> of_find_mii_timestamper() returns NULL if no timestamper is found.
> Therefore, guard the unregister_mii_timestamper() calls.
> 
> Fixes: 1dca22b18421 ("net: mdio: of: Register discovered MII time stampers.")
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied both, thank you.
