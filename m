Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C44148D25
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390725AbgAXRnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:43:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387629AbgAXRnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 12:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xlB7pdO8ZpjfH97DTU8ogLfu7UznhJEWnG5qDbqO3Iw=; b=wqBNQ7dFNb444gmlYzy+FkUH9b
        ZZSdEeka+ujTphy8GhsZX33kbGtZgKXKfJvz0vW5zqmhreezwudODlAtwfpkM9KVIyb3ouv6V71gb
        eUf9VQuYM+mkJ6Q7FZlm3+0L4lCca3v2d6C4QvaimE/wytiVshjrQTWvqFmRad3g1pHE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iv2zD-0003UM-8e; Fri, 24 Jan 2020 18:43:15 +0100
Date:   Fri, 24 Jan 2020 18:43:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next v3 03/10] net: bridge: mrp: Add MRP interface used
 by netlink
Message-ID: <20200124174315.GC13647@lunn.ch>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124161828.12206-4-horatiu.vultur@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> br_mrp_flush - will flush the FDB.

How does this differ from a normal bridge flush? I assume there is a
way for user space to flush the bridge FDB.

    Andrew
