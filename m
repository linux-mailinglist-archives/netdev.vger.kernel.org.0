Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17720F2EEA
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388936AbfKGNKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:10:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388519AbfKGNKM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 08:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/QHiy/cv5+OF+NRN/1coM4xrb4sObBOqgxTnlwXFFgQ=; b=VdAZOQI2ti8EG8mVB0wXaNmwWa
        1Ij5PutHe2VAUVac9S+dHP8/S9+n9pfNeev1V5qMemwMpiBMYxqgrW5uylfUg+lvePnIsmNWRwdAU
        URC84CulYGUwUHunV4Px4+eHhs8EVArm8mhorxKqJQZ3LLKUx9QmevCcppFcDP65cz68=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iShY7-00068m-SX; Thu, 07 Nov 2019 14:10:07 +0100
Date:   Thu, 7 Nov 2019 14:10:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: global2: Fix gcc compile error
Message-ID: <20191107131007.GF22978@lunn.ch>
References: <1573129568-94008-1-git-send-email-chenwandun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573129568-94008-1-git-send-email-chenwandun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 08:26:07PM +0800, Chen Wandun wrote:
> In commit c5f299d59261 ("net: dsa: mv88e6xxx: global1_atu: Add helper for
> get next"), it add a parameter in mv88e6xxx_g2_atu_stats_get only when
> CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 enabled, it also should make the same
> change when CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 disabled.

Hi Chen

Thanks for the report. A fix was merged last night.

       Andrew
