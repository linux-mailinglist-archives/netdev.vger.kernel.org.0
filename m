Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4755916F964
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgBZIOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgBZIOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 03:14:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20DAB20714;
        Wed, 26 Feb 2020 08:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582704854;
        bh=QCiOk0U0PibJS9jpQa+zsi2PX4helxpe0bcqZAJnjAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zNkYEe6SwMICmB10jY1mI0OhJmGbWfTtuZTkrEEMhPzV8QNzP9t/r6VY2CZDi/Wzy
         zUSaOrCqjE4n8TtPi5A/v+YTxGgYTcMvMWPx11NH0jkqFvvPJu9vOtnaL8Pj0nfpvV
         6xb9vZE7mM41ERupa3rBIgTrK0PovZNIgZB/PSGk=
Date:   Wed, 26 Feb 2020 09:14:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 2/9] sysfs: add sysfs_link_change_owner()
Message-ID: <20200226081411.GB24447@kroah.com>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
 <20200225131938.120447-3-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225131938.120447-3-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:19:31PM +0100, Christian Brauner wrote:
> Add a helper to change the owner of a sysfs link.
> This function will be used to correctly account for kobject ownership
> changes, e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
