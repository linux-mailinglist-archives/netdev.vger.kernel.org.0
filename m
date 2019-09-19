Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03540B71A8
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 04:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388426AbfISCuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 22:50:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54132 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbfISCuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 22:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SOt6fitAuRZcRmpDfmMRTm1rrq+84NUpxW5B9Ow0huo=; b=h7ij+hoc0z+F4jZxXJuvQ0tiAg
        2DM/0nV7LmfjIhAmGXpmOemVUGudE2gfkcAr2UQP3uDQH6ou4Fv7NY2rzLnoxgRE7CdN0D5cvkahH
        ScJXFJYRI733pFEYIwjTJHMPaPDu00tAUx7CmubXtx1NfgUEgFRd1HCP6uZA0IpxcT9Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAmWO-0003QV-RE; Thu, 19 Sep 2019 04:50:16 +0200
Date:   Thu, 19 Sep 2019 04:50:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Mamonov <pmamonov@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] net/phy: fix Marvell PHYs probe failure when HWMON
 and THERMAL_OF are enabled
Message-ID: <20190919025016.GA12785@lunn.ch>
References: <20190918213837.24585-1-pmamonov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918213837.24585-1-pmamonov@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 12:38:37AM +0300, Peter Mamonov wrote:
> Hello,
> 
> Some time ago I've discovered that probe functions of certain Marvell PHYs 
> fail if both HWMON and THERMAL_OF config options are enabled.

Hi Peter

It probably affects more then Marvell PHYs.

> The root 
> cause of this problem is a lack of an OF node for a PHY's built-in 
> temperature sensor.  However I consider adding this OF node to be a bit 
> excessive solution. Am I wrong? Below you will find a one line patch which 
> fixes the problem.

Your patch look sensible to me.

> I've sent it to the releveant maintainers three weeks 
> ago without any feedback yet.

Could you point me at the relevant mailing list archive?

      Thanks
	Andrew
