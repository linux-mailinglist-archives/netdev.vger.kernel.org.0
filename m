Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04E9EEB3C
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfKDVew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:34:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbfKDVev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MqRWKXNuFJtjmc6Uj1X8898+VZapLnI8f/Yktr22yWw=; b=2ULrUc+A6yhHpeDi/9Sm5AzXyW
        b5k3CUgTJeQ6yKQ6B2maXD2W7/b/pQTfQEc1Ss6Z6AviZfoTPDW3Q5ryF16ImbhhJ0xmc/KCH3eAO
        IUphSha7+icqZkZU1WY01twOq+Eu82iaKPI/EH3/WwLt6ANcnO4TtdTxGI/cXyRKW8uw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRjzs-0006Uc-PJ; Mon, 04 Nov 2019 22:34:48 +0100
Date:   Mon, 4 Nov 2019 22:34:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: Describe BCM7445 switch
 reset property
Message-ID: <20191104213448.GC17620@lunn.ch>
References: <20191104184203.2106-1-f.fainelli@gmail.com>
 <20191104184203.2106-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104184203.2106-2-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 10:42:02AM -0800, Florian Fainelli wrote:
> The BCM7445/BCM7278 built-in Ethernet switch have an optional reset line
> to the SoC's reset controller, describe the 'resets' and 'reset-names'
> properties as optional.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

