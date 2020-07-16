Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E39222CE2
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgGPUcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgGPUcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 16:32:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D23D207E8;
        Thu, 16 Jul 2020 20:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594931526;
        bh=Nqxulrodxo8eOevLZn2HwsAISOP60thSdFpkTzjHl1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cH1b0WZXXlqv/IqmIu/n/UBktooOBSfIG9m2vop4KbpespzV/W2T/ehiaxmj9JUg9
         VxNDMKimDmjtZle3uDOyH349zcEXT9hXK0vlRLqQ6ZM7lffxf175iWlO4jslFBYEzJ
         4PR5uaDaJLwyAUkGG3R+OUYtlQ67rXQPrFzrKj2I=
Date:   Thu, 16 Jul 2020 13:32:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Sergey Organov <sorganov@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: dp83640: fix SIOCSHWTSTAMP to update the
 struct with actual configuration
Message-ID: <20200716133202.24b1b5d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716185650.GA1074@hoboy>
References: <20200715161000.14158-1-sorganov@gmail.com>
        <20200716185650.GA1074@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 11:56:50 -0700 Richard Cochran wrote:
> On Wed, Jul 15, 2020 at 07:10:00PM +0300, Sergey Organov wrote:
> > From Documentation/networking/timestamping.txt:
> > 
> >   A driver which supports hardware time stamping shall update the
> >   struct with the actual, possibly more permissive configuration.
> > 
> > Do update the struct passed when we upscale the requested time
> > stamping mode.
> > 
> > Fixes: cb646e2b02b2 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
> > Signed-off-by: Sergey Organov <sorganov@gmail.com>  
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied, thank you!
