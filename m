Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D04E31A9
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 13:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439526AbfJXL6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 07:58:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfJXL6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 07:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dpdPtQ9YYpbeXJdY8m/o433LsLuOnXN6uIZDYX/6rAM=; b=fHx25Q4caYOzwuBrhSqpJ+DJEz
        Sz/0DM3QFO3se0K96dUAlqJdoDQRXSeYUPN0pJP3qLPVWD1uGw6rx3dx2KVC9OTAZZNjE5kQEndfJ
        pl8k3aAzUn1+iAhqf2/yNvzlYbf/+bFLPxYb+nBa4bQPwgw6RHUZzYKPVjYJbjvA3A4I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNbl9-0003K5-OU; Thu, 24 Oct 2019 13:58:31 +0200
Date:   Thu, 24 Oct 2019 13:58:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin King <colin.king@canonical.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: fix dereference on ds->dev before null
 check error
Message-ID: <20191024115831.GA12631@lunn.ch>
References: <20191024103218.2592-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024103218.2592-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 11:32:18AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently ds->dev is dereferenced on the assignments of pdata and
> np before ds->dev is null checked, hence there is a potential null
> pointer dereference on ds->dev.  Fix this by assigning pdata and
> np after the ds->dev null pointer sanity check.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
