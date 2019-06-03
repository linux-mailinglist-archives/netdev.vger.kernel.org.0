Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5E1330F3
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfFCNWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:22:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbfFCNWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 09:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VBTaQTRRFJk9ShP9IjlzRSGL8L3GcMXx/V92hcLsIJk=; b=5V1h9xk2eg5rUFfi6oHhFoZutF
        E32KrnWqwiGFdQxxf6+rttQm+8jmiSFLI3X0pyfQm9Qgf+96W7rf7Bal2zDbTUCfTXq4eIMlAf2cJ
        ogOH8rT9WMt3SD+zCusowQgVpNHFkWbU0ifxJGxFwliRUTz77+3LE8a0o5jR2Rf7zqBQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXmuc-00053V-1E; Mon, 03 Jun 2019 15:22:06 +0200
Date:   Mon, 3 Jun 2019 15:22:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix comments and macro
 names in mv88e6390_g1_mgmt_rsvd2cpu
Message-ID: <20190603132206.GH3154@lunn.ch>
References: <20190603075236.18470-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603075236.18470-1-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 07:52:46AM +0000, Rasmus Villemoes wrote:
> The macros have an extraneous '800' (after 0180C2 there should be just
> six nibbles, with X representing one), while the comments have
> interchanged c2 and 80 and an extra :00.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
