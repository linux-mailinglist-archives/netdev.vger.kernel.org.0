Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E262FF6B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 22:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbhAUVCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 16:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbhAUVBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 16:01:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 981AF22BEF;
        Thu, 21 Jan 2021 21:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611262841;
        bh=5SXnEbiaKqZ2yFRY61kXsY2VsK7sJkZOKIoN+OpkNYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PuO1OPK5fVt3xmUlThAo4IxL2uE5dZb9tKcZA2hWx47yGRz17QyuhaWm3HdMP4Obg
         x3O5dCzW4yiB+Y/ZXMONCDFP0XmpBqUGmBVmpaNMczkEBrZUh7EXd8hlT2NAD3kdJN
         LNuU1nNZlBuPJQ4wc8g6yQIVNpJwzg8T6KF2pj/045wFf1tI8+fAlRFQ+gt+drvsY0
         sb6U0GYS1CtCRaXvp8dc6pLvasHk2rq8hYMRXqKahK/XUwNnSFJhJFhvD7JXKU6hpH
         tuL5aqeUBfhuS3rCJ1Cj8Y8uyE0c/00EAl4arc3o6/xYAUvC0PmsFVjfYWnL24DTGt
         5X5SYYKKaEULQ==
Date:   Thu, 21 Jan 2021 13:00:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add entry for Arrow SpeedChips XRS7000
 driver
Message-ID: <20210121130039.183ad7e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120135323.73856-1-george.mccollister@gmail.com>
References: <20210120135323.73856-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 07:53:23 -0600 George McCollister wrote:
> Add myself as maintainer of the Arrow SpeedChips XRS7000 series Ethernet
> switch driver.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Applied, thank you!
