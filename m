Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD670147A5D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgAXJZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728928AbgAXJZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 04:25:34 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0EC2208C4;
        Fri, 24 Jan 2020 09:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579857933;
        bh=AfebeLfh+ayKC/+pxhlr5IHwQ2fgWqNng93G1sRYY30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0jTyUbHwa7Qs0M1/RISNRkznQYLg1YFHrMj4bMsBomKgUOZGwf332y4OUdhLVpn9U
         98q9zYelY34N/ikxsNdU3lmunw/qhFmWK1cHVyk6m2ZSJjKI1XUZ7Wo0JbpkiOYZu1
         wRYCQ6ZOAqYqpntD87lLT4hlBdEIhX+CpW78s40o=
Date:   Fri, 24 Jan 2020 10:25:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Request to back port "net: phy: Keep reporting transceiver type"
 to stable-4.9
Message-ID: <20200124092524.GC2984592@kroah.com>
References: <163b5dc9-1b09-cc29-6dfb-f40bafee8270@gmail.com>
 <714709aa-48f4-ae6c-21db-7bed220ce3a7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <714709aa-48f4-ae6c-21db-7bed220ce3a7@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 09:42:02AM -0800, Florian Fainelli wrote:
> And you will need to back port 19cab8872692960535aa6d12e3a295ac51d1a648
> ("net: ethtool: Add back transceiver type") before in order for the
> requested commit to build.

Both now queued up, thanks.

greg k-h
