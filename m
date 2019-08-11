Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C289232
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfHKPJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:09:00 -0400
Received: from mail.nic.cz ([217.31.204.67]:50442 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfHKPJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 11:09:00 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 755DF140AE8;
        Sun, 11 Aug 2019 17:08:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565536138; bh=onYQzXJIffIXyzyI+gyhotwF5S4WNSVTJ6DTpGp0nXM=;
        h=Date:From:To;
        b=cmLU3eIqUckDMcKUh3hrLmSQweasCCXy5y4flZJgDSQuf+4UF0VMqwK+puJh6TR8i
         Tr/BthdQOmcGQpBBDiGPpqEDXqwO2VmTENXa/hii/0ueciajx4YwnuDmYRKnHu7kzu
         VGC8J5yMVavAHu53s+j2H0czEifLKla51iPGjmX0=
Date:   Sun, 11 Aug 2019 17:08:58 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port
 registration
Message-ID: <20190811170858.5f4572dc@nic.cz>
In-Reply-To: <20190811160404.06450685@nic.cz>
References: <20190811031857.2899-1-marek.behun@nic.cz>
        <20190811033910.GL30120@lunn.ch>
        <91cd70df-c856-4c7e-7ebb-c01519fb13d2@gmail.com>
        <20190811160404.06450685@nic.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have sent two new patches, each fixing one of the bugs that negated
each other.

Marek
