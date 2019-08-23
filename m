Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88B19A505
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 03:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbfHWBkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 21:40:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbfHWBkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 21:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NGAzIuWLPKcXKejvQX+WldsUJLvDF6qATXEz4HLdru8=; b=KPSQakDVpww20G72Mzm2YYf70n
        xMXuMYTJJ7nf/coY+BpglVqMara1JUEuxxvRqr77oWEG+h8sLZPsNlylwOaExdge28EpIleBE2Iuv
        5aig7AF2lys160rJbtXxWeOurqFxThgkVlFLJrVaNm0crKxNfwPRQtFeYB33TpOz5T6w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0yZO-00016T-RX; Fri, 23 Aug 2019 03:40:50 +0200
Date:   Fri, 23 Aug 2019 03:40:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 06/10] net: dsa: mv88e6xxx: add serdes_get_lane
 method for Topaz family
Message-ID: <20190823014050.GM13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-7-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821232724.1544-7-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:20AM +0200, Marek Behún wrote:
> The Topaz family has only one SERDES, on port 5, with address 0x15.
> Currently we have MV88E6341_ADDR_SERDES macro used in the
> mv88e6341_serdes_power method. Rename the macro to MV88E6341_PORT5_LANE
> and use the new mv88e6xxx_serdes_get_lane method in
> mv88e6341_serdes_power.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
