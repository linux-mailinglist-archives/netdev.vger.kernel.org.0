Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEFCE4BB5
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504704AbfJYNBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:01:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35350 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504641AbfJYNB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b6iuHPYlCH7nRYcL4N4YCQFM+mnd35/+AX1RxwRV/nc=; b=D1BUOeFQwhoKNkbFkpTGFokgRB
        WEJcOE37Ujw+t7Ld31pAerTV4DrxS53ceIErvPtiJb5JQisIZal77zd/6I/siw7EXODz9046CPybf
        VMX2WWG9tgXc3utC1m2hvbYKWgL0SnbndzJsrM88DKV9kkOtP/k2IPWH0HJBkE5gvHAI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNzDJ-0002q4-2z; Fri, 25 Oct 2019 15:01:09 +0200
Date:   Fri, 25 Oct 2019 15:01:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 04/12] net: ethernet: ti: cpsw: move set of
 common functions in cpsw_priv
Message-ID: <20191025130109.GB10212@lunn.ch>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-5-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024100914.16840-5-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 01:09:06PM +0300, Grygorii Strashko wrote:
> As a preparatory patch to add support for a switchdev based cpsw driver,
> move common functions to cpsw-priv.c so that they can be used across both
> drivers.

Hi Grygorii

Bike shedding, but it seems odd to move common code into a private
file. How common is the current code in cpsw-common.c?

      Andrew
