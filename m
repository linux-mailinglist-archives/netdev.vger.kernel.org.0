Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038F949DFEF
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbiA0K6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:58:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbiA0K6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:58:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A522B82216;
        Thu, 27 Jan 2022 10:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C084C340E4;
        Thu, 27 Jan 2022 10:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643281079;
        bh=5TCz4kuVhHHwa0yiuXQAlSFBrqJ1NBrp2JbclURD3Io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kPat4FPo0aXNIsOep71l9XcYtTXgaz/0fGVNB6uPUuCIqF4/JFZE9ffq7hqQxVW1D
         WlqQyX6i6rYIBuONCvwwfjePJSErAm8l6W+Lyby1ATaWRAbdZ+/GZ57j3J9eD2V+aG
         WmwaBqssWdVMqeWTIlVrML/nF/Ib+44dX2AUYNeU=
Date:   Thu, 27 Jan 2022 11:57:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/4] usbnet: add "label" support
Message-ID: <YfJ6tZ3hJLbTeaDr@kroah.com>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127104905.899341-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:49:01AM +0100, Oleksij Rempel wrote:
> Add devicetree label property for usbnet devices and related yaml
> schema.

That says _what_ you are doing, but not _why_ you would want to do such
a crazy thing, nor what problem you are attempting to solve here.

thanks,

greg k-h
