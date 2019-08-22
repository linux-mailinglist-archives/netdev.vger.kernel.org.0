Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD6699455
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbfHVMzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:55:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732412AbfHVMzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bM0MkRHYfNA980m8+yt4fRO9sphl5lmQiQGPgydPNeo=; b=B8eL9+u0k6XlNvVjku5UjrPJm9
        G4z2uYa/ErJ+dAOIcngUFIHeldmi16o9utLhjqXfboxPuBkf5nlqaDNA9YA/FZYjbGBBJ79DRufUH
        MlaFZwd+kWbguoxnpuj9BBIUWrCrZ0L6+4YpV9Up1IQ28LubwkvLe5u0fvkXEzH5K8TQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0mcv-0003ao-TE; Thu, 22 Aug 2019 14:55:41 +0200
Date:   Thu, 22 Aug 2019 14:55:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 02/10] net: dsa: mv88e6xxx: remove extra newline
Message-ID: <20190822125541.GB13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821232724.1544-3-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:16AM +0200, Marek Behún wrote:
> There are two newlines separating mv88e6390_hidden_wait and
> mv88e6390_hidden_read. Remove one.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
