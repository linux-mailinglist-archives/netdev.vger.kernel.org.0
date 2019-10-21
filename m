Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27768DEC46
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbfJUMbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:31:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfJUMbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/0WHOLj1WHltl84XL/M5JBKcWuG1ZK/0/anzpUvZ6Mk=; b=m2tpD4CLPnV6PKZs9O6qht/+Ir
        oHtcXukEIoVv+VYy4vPRLbL+72uMeoqJCslBmWI1Nm0nmjaVi6yrxphdQFmW0YKLlDHl2ZsXtL0NA
        3dt+/VaUQYWtCB7gX1TGuDBL6YDE5jF7MVlR60D4kiidx1Nb7arLNVdmr7QxGbb7xyjE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMWqj-0004J2-Gk; Mon, 21 Oct 2019 14:31:49 +0200
Date:   Mon, 21 Oct 2019 14:31:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/16] net: dsa: use dsa_to_port helper
 everywhere
Message-ID: <20191021123149.GB16084@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-2-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020031941.3805884-2-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 11:19:26PM -0400, Vivien Didelot wrote:
> Do not let the drivers access the ds->ports static array directly
> while there is a dsa_to_port helper for this purpose.
> 
> At the same time, un-const this helper since the SJA1105 driver
> assigns the priv member of the returned dsa_port structure.

Hi Vivien

Is priv the only member we expect drivers to change? Is the rest
private to the core/RO? Rather then remove the const, i wonder if it
would be better to add a helper to set priv?

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
