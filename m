Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C3F16F971
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgBZIQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgBZIQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 03:16:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20EC220714;
        Wed, 26 Feb 2020 08:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582704999;
        bh=AQwB89v8ebH3YVd21IcGyMfmH8x1a5GN9DmaECnRUtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PRkjcHSAHnkmQwJOgjia5+LSNgc5zjeYq7D4GjztfneR5zOA8+AegH3+z6+Gvw8Qy
         786HsZxrVEj7aQu6fJ0agvRqcfNvWR5n1PluH5fnb+uC5646ngnuMAAvjv5nNysBlz
         T+en5jyS/PR1Dd1a/NDtBbVXk4I/KvvxPHA6LYq4=
Date:   Wed, 26 Feb 2020 09:16:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 6/9] drivers/base/power: add dpm_sysfs_change_owner()
Message-ID: <20200226081636.GE24447@kroah.com>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
 <20200225131938.120447-7-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225131938.120447-7-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:19:35PM +0100, Christian Brauner wrote:
> Add a helper to change the owner of a device's power entries. This
> needs to happen when the ownership of a device is changed, e.g. when
> moving network devices between network namespaces.
> This function will be used to correctly account for ownership changes,
> e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
