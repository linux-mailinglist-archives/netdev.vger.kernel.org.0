Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF1589E9
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfF0S1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:27:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfF0S1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:27:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ztM6sSMYRixPhO9qumni8kqDDcCea1JGJtq1QVwCzoQ=; b=ZEC7r+jBn2a6dAumXQkva0kVRl
        gSJNrfWwSzCqYsG9w2nJoD0Au3eagAk6+OHem8ZjnUbQt0fIOGYPLG9BGz0U+3YAM0Wsd6EITqX+b
        yI6WMj40eSm2TyjVIU5GzB6qWjINF586exXy42uECIumhKc057Yy88oV/klFofH3mbJE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgZ70-0002g5-6F; Thu, 27 Jun 2019 20:27:10 +0200
Date:   Thu, 27 Jun 2019 20:27:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: wait after reset deactivation
Message-ID: <20190627182710.GH31189@lunn.ch>
References: <2e272a4e588ae44137864237d0cd73e2208f2c60.1561659459.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e272a4e588ae44137864237d0cd73e2208f2c60.1561659459.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 09:17:39PM +0300, Baruch Siach wrote:
> Add a 1ms delay after reset deactivation. Otherwise the chip returns
> bogus ID value. This is observed with 88E6390 (Peridot) chip.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
