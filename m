Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091753F837F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbhHZIGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 04:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232223AbhHZIGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 04:06:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40468610A7;
        Thu, 26 Aug 2021 08:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629965161;
        bh=DpKd9QQbUDt650wor/8qnzJYHCsfKIDS1j7TLDRKy2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FSsX2fGL/O2AY9VzVl5Zl6T8KI+ejB8v+TxGMnEzyz7VK7PrHQCGQY1scsD0RUiD5
         QID1tlL2nYF9yzLSBcaedE745j3AvhOGrcbQ+urUceC5/ySLeqSQ8W11gi6e8VWOyx
         THnS3SWJCtC2CQ5Q9ouHqmXcHs8uHCFxaLYh1Zbc=
Date:   Thu, 26 Aug 2021 09:55:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with
 fw_devlink=on
Message-ID: <YSdJB8CZ83dYBtTT@kroah.com>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-3-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826074526.825517-3-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:45:25AM -0700, Saravana Kannan wrote:
> This is just a quick fix to make this driver work with fw_devlink=on.
> The proper fix might need a significant amount of rework of the driver
> of the framework to use a component device model.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/net/dsa/realtek-smi-core.c | 7 +++++++
>  1 file changed, 7 insertions(+)

"quick" fixes are nice, but who is going to do the real work here to fix
this properly if this series is accepted?

thanks,

greg k-h
