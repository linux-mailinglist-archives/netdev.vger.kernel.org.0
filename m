Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5C03762D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfFFOQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:16:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfFFOQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 10:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OgARH1dVDOOt+nGSnZvgunyMLkeANbEU5Wuqid1elos=; b=v+HHExsL3NJYPtn6/TChAJIRzr
        iXxNk6pIOf2Wwe2z6xC7dZszvx/XH+1lRlG/LOwj94NvedGIi+f1UJYLTEUuezPjneCnxJS9mWAmq
        14kDn/SyeoDAUzyx5M95/kb2F7TON0QQ74FX4N0bCrNH3ZPRrlsY4ICwjKfadOJDpwBI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYtBu-0006rn-RL; Thu, 06 Jun 2019 16:16:30 +0200
Date:   Thu, 6 Jun 2019 16:16:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next v4 16/20] net: axienet: document device tree
 mdio child node
Message-ID: <20190606141630.GJ19590@lunn.ch>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
 <1559767353-17301-17-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559767353-17301-17-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:42:29PM -0600, Robert Hancock wrote:
> The mdio child node for the MDIO bus is generally required when using
> this driver but was not documented other than being shown in the
> example. Document it as an optional (but usually required) parameter.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
