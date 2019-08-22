Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455439949F
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbfHVNKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:10:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730641AbfHVNKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 09:10:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TpDkHz85Kjqehy4umH5vnslGrYpGSIvW7NR7XyRapmQ=; b=XbKoqtFmBwN/RbmBduwBBT0cQQ
        QMSy1QV6GQwIpwq/ymfZhP4fhUZac72evX+IAwwsCsQHDD0jfb0f7+HaKBJgh/TNa9yaSDMflFf8T
        70BpW9XpvcaZClTCilCulQ0sXD1GSRqeqLblbDu20z8VeNnJRWLUkPjo/8U283GQP/yc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0mrX-0003qk-8w; Thu, 22 Aug 2019 15:10:47 +0200
Date:   Thu, 22 Aug 2019 15:10:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 03/10] net: dsa: mv88e6xxx: move hidden
 registers operations in own file
Message-ID: <20190822131047.GE13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821232724.1544-4-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:17AM +0200, Marek Behún wrote:
> This patch moves the functions operating on the hidden debug registers
> into it's own file, hidden.c.

Humm, actually...

These are in the port register space. Maybe it would be better to move
them into port.c/port.h?

What you really need is that they have global scope within the driver
so you can call them. So add the functions definitions to port.h.

Vivien, what do you think?

	Andrew
