Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3869BB93AD
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390869AbfITPI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 11:08:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387614AbfITPIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 11:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P3JIZQUh28xQ7KcAHkcaUqzj0/5saX1Ep2XYOScw4dk=; b=JW+o+Gt9rkq8DmwTJLKstrGyuE
        byEDABTDl/qpEJmaf8gaahDWpLhdmnUWRQf1xUlgup5HSP5C0D8cLxrVq2MgpyuvPtzgmM3l05DFK
        Sq+7HEGvE4F6n4ni64DtO2Dy57jL/P9T6TElgYR7mxUHxqZKuvxC4Qo6JLtqSWxnkaSw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iBKW9-0005qh-G1; Fri, 20 Sep 2019 17:08:17 +0200
Date:   Fri, 20 Sep 2019 17:08:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dsa: vsc73xx: Use
 devm_platform_ioremap_resource() in vsc73xx_platform_probe()
Message-ID: <20190920150817.GE3530@lunn.ch>
References: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
 <dbc78014-6ed4-5080-8208-0a5930a3bf6e@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbc78014-6ed4-5080-8208-0a5930a3bf6e@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 04:28:00PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 20 Sep 2019 15:23:39 +0200
> 
> Simplify this function implementation by using a known wrapper function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
