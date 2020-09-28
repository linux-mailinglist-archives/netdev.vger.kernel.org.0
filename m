Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E334C27B705
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 23:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgI1Vb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 17:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgI1Vb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 17:31:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 359922083B;
        Mon, 28 Sep 2020 21:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601328717;
        bh=SjN0e+jLGv8/8+VAS7zDqk3KwwPZu+ADNY+cYSMdgas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nl1mCDSPHUW28U6VHFIKuRblJbWDJTlpOjrYBnlwzx/TzieYT8jcTCXAI++fYDORN
         sSiWkOO6V0aW4w+1jvSHibnxV6aU3XN/z3D2pXvDxcjIlrdppJk7SNL4XVeaDxzDUz
         MZ/x0pn7IXw6M5DAqdOuvx230JbA8Nmg1dq1OY1A=
Date:   Mon, 28 Sep 2020 14:31:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200926210632.3888886-2-andrew@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
        <20200926210632.3888886-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Sep 2020 23:06:26 +0200 Andrew Lunn wrote:
> Not all ports of a switch need to be used, particularly in embedded
> systems. Add a port flavour for ports which physically exist in the
> switch, but are not connected to the front panel etc, and so are
> unused.

This is missing the explanation of why reporting such ports makes sense.
