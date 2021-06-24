Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C863B33AF
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhFXQQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:16:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhFXQQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 12:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YKTqBFZYplSbzfgPPeESwH1lmfP9/yl2E+XRKu/drWE=; b=tudKc8szd7T8wq4/DC6W+j2WrQ
        MS+wr7RO1SoljNV6D4DX9hrsM5+8OdY5WImWqT3ZxXjRtP+08PLboUD8COpDORHkTmvr6CRfXXqNf
        3yfGhUdPYRiN9RD9dP1B7e08V4pQJ1AIlWVFcnIbVNHqTG/XObuHBLk3o5f7yHCms3qE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwRzl-00B02V-Ll; Thu, 24 Jun 2021 18:14:25 +0200
Date:   Thu, 24 Jun 2021 18:14:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jon@solid-run.com, tn@semihalf.com, jaz@semihalf.com,
        hkallweit1@gmail.com
Subject: Re: [net-next: PATCH] net: mdiobus: fix fwnode_mdbiobus_register()
 fallback case
Message-ID: <YNSvYTuZPzHbalw/@lunn.ch>
References: <20210624005151.3735706-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624005151.3735706-1-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 02:51:51AM +0200, Marcin Wojtas wrote:
> The fallback case of fwnode_mdbiobus_register()
> (relevant for !CONFIG_FWNODE_MDIO) was defined with wrong
> argument name, causing a compilation error. Fix that.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
