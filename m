Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F11244A528
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 04:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242335AbhKIDFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 22:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242316AbhKIDFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 22:05:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036CD61107;
        Tue,  9 Nov 2021 03:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636426982;
        bh=mAPRGTo8qEALDIeot6JiMQ1fThLG8fXVOip31PH+G/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nwz+qwHUtlX6tZCT9XGrvCZN1EPyIn9OJPXHklYAgQeUgd+KxX8GSB4MJbUp72fCk
         iWp+4rMq+5f9D3GnBetsiUhQ5A6uQ97z4ktp1JvWjiZrA+X63d/fj6S5P7YPHB6C2F
         j60O96yW8lon3P37HXm+gVQWAJv++5xD4JUOzqZ86NE4IjvYQIq89T2hJI4QH7VdPk
         Rfhk0OBT2keMT8hMjMQje/ZSeGP5uzQB6k8bmtL6+W3MAHMDNCaJuiSkd/2mkFRTXZ
         yFn19aU8aXQVRJxqiwDGWvLCiC/ydV1xosPr+R4qoLlgITmLHdmmvKuNi0EAmLs/cX
         krESrdRXcVQaA==
Date:   Tue, 9 Nov 2021 04:02:57 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/8] leds: trigger: netdev: drop
 NETDEV_LED_MODE_LINKUP from mode
Message-ID: <20211109040257.29f42aa1@thinkpad>
In-Reply-To: <20211109022608.11109-4-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
        <20211109022608.11109-4-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Nov 2021 03:26:03 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> Drop NETDEV_LED_MODE_LINKUP from mode list and convert to a simple bool
> that will be true or false based on the carrier link. No functional
> change intended.

The last time I tried this, I did it for all the fields that are now in
the bitmap, and I was told that the bitmap guarantees atomic access, so
it should be used...

But why do you needs this? I guess I will see in another patch.

Marek
