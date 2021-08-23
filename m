Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFDC3F5375
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 00:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhHWWmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 18:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhHWWmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 18:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F59B613A8;
        Mon, 23 Aug 2021 22:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629758528;
        bh=Z9Iq6ASnmxIybrEJe6v5jX8OFBkOsrcleFIRysOfPgU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vFYEjaKtRlkU9ZfTSNIj9gd2xnYS6IVBkCYjPZAJWtQxKpDUQAT+45aUj7Ge1DYQG
         SvwsLq00d8h2hkjy+CWPHzgfI2FRsuG/aMURzfZmitqkKODXIbYNrwo9p07Ug7azF+
         4qnNJXr8I2KorTmSdXnDe93GB47PSbQGEciYvByjYLQzie893hm9jq8UBw/QB/wfbK
         tEoly4s54rinBuRYxa4WWDN/q4bg3Ryya73hXN1yVdQgmAIF6Kw8+GU+kP/O9QKA+0
         5R6dAxoovG7PKMXsCxDypRGCjIf1KaioCjdoyp/XTGrXxf804Iwf5dGppXubtvG5CF
         w/dMqy/f/TNxg==
Date:   Mon, 23 Aug 2021 15:42:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 06/10] lan78xx: Fix exception on link speed
 change
Message-ID: <20210823154207.4ce7758a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210823135229.36581-7-john.efstathiades@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
        <20210823135229.36581-7-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Aug 2021 14:52:25 +0100 John Efstathiades wrote:
> +	ret = -ETIME;

ETIMEDOUT
