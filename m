Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB48343150
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 23:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfFLVIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 17:08:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfFLVIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 17:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LXhjfj3yV/yi51h0z1gxG2/eH2J8U+odewFrbIfak1c=; b=XN7MoYipeafmEf5mf1JIYpjmE2
        CNC6NwRk8bzErTHhDi9QVxdbsNbj8LJpNPUU880cBO1VJKcgMDlsKV0zi4aOi5j6pAU8r3Y9DyR2g
        gE/URanq+Ntzswyn13HWpMmGy1qoSigOiu9QZtkcnKO+HEa657APcW7yRavV9hYtxSbA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hbAUE-0007zz-9c; Wed, 12 Jun 2019 23:08:50 +0200
Date:   Wed, 12 Jun 2019 23:08:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net] net: dsa: microchip: Don't try to read stats for
 unused ports
Message-ID: <20190612210850.GD23695@lunn.ch>
References: <1560371612-31848-1-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560371612-31848-1-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 02:33:32PM -0600, Robert Hancock wrote:
> If some of the switch ports were not listed in the device tree, due to
> being unused, the ksz_mib_read_work function ended up accessing a NULL
> dp->slave pointer and causing an oops. Skip checking statistics for any
> unused ports.
> 
> Fixes: 7c6ff470aa867f53 ("net: dsa: microchip: add MIB counter reading
> support")
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
