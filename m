Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050912C181D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731764AbgKWWC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbgKWWC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:02:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EEA7206CA;
        Mon, 23 Nov 2020 22:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606168947;
        bh=R+4xkUCrdZZhJSKwsHs4zF7sObO5pUrKgWUJ2vVKd3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JmdbGgxZjkjP+jF/CqFE5sHuSE0Fv52h4ETVbcaQj4srs1kHWujAljtsYN3iMLwhn
         JhfqawPRxcl1/uAUFk8Y08u66FrckvCBQfi85GqP8308bC86S/s15pY8J/nQh6E4rk
         jF7ZLdE2vyO3STvrbFZiEV+DDwn+U+hWzsU7vc2s=
Date:   Mon, 23 Nov 2020 14:02:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 0/3] net: ptp: introduce common defines for
 PTP message types
Message-ID: <20201123140225.6744937a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120084106.10046-1-ceggers@arri.de>
References: <20201120084106.10046-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 09:41:03 +0100 Christian Eggers wrote:
> This series introduces commen defines for PTP event messages. Driver
> internal defines are removed and some uses of magic numbers are replaced
> by the new defines.

Applied, thanks!
