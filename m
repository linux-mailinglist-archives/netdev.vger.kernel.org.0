Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9FD424229
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbhJFQIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232071AbhJFQIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 12:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17075610A0;
        Wed,  6 Oct 2021 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633536416;
        bh=Qok4WNyAOzjO8FdziSTbeDBU+2x5NVrxBuFweVNXjIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XI1S+/lAjFz8pwLOn+NGUhCybCfe9nrGC1lK4CSagueqLsknUI7nSQ1VpQf8BH1GH
         +rvDZIIoMGbAdNCu5DPTCCCqNFJ6aNpIcoH2q5cS4RodvWip2UWYy2sU6TrL5BDCPn
         5X0TEM4Cr0atMZSWb8v/AOmNeNPWNN+e0oSYezoU=
Date:   Wed, 6 Oct 2021 18:06:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, rafael@kernel.org,
        saravanak@google.com, mw@semihalf.com, andrew@lunn.ch,
        jeremy.linton@arm.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/9] device property: move mac addr helpers
 to eth.c
Message-ID: <YV3JnjlqOwJ7JEQS@kroah.com>
References: <20211006154426.3222199-1-kuba@kernel.org>
 <20211006154426.3222199-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006154426.3222199-5-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 08:44:21AM -0700, Jakub Kicinski wrote:
> Move the mac address helpers out, eth.c already contains
> a bunch of similar helpers.
> 
> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
