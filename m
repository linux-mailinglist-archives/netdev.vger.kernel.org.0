Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2953B8986
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhF3UK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:10:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhF3UK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 16:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=YXxSXRFPg28uV5V9uwDD2a1T1RKptZdfGi2KsRpu4gs=; b=25
        ENOgpjL+XjvutaiU2LxqzAQu7Vy3hFFYA/gl6w4LrHHg029nAj9IcMFKm6XVOzyKW9Lf8QlXc8ZsO
        20RZP8KUklWme0HSHHEZ62T9aobGjj0C7twz0aUtwrbOjr2E5uW8OuBt98DzmivxJ85cJXVES+c5O
        NuGkcA9fG74YZOg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lygVY-00Bh8X-5c; Wed, 30 Jun 2021 22:08:28 +0200
Date:   Wed, 30 Jun 2021 22:08:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 4/6] net: dsa: mv88e6xxx: enable devlink ATU hash
 param for Topaz
Message-ID: <YNzPPH0+3Sss9YKt@lunn.ch>
References: <20210630174308.31831-1-kabel@kernel.org>
 <20210630174308.31831-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630174308.31831-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 07:43:06PM +0200, Marek Behún wrote:
> Commit 23e8b470c7788 ("net: dsa: mv88e6xxx: Add devlink param for ATU
> hash algorithm.") introduced ATU hash algorithm access via devlink, but
> did not enable it for Topaz.
> 
> Enable this feature also for Topaz.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 23e8b470c7788 ("net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
