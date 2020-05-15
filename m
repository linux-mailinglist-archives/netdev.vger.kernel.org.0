Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D0D1D5BA3
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgEOVbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgEOVbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 17:31:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 711F820709;
        Fri, 15 May 2020 21:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589578304;
        bh=12Sn1Y2UmzI20c5aoxj40/oDCmfQRHwUnQWRuWs8ayA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2YQoDd4Exz0ccyaymMHjc+Ac8hu6OW3BLPAEJNr7IYlxquYlExICLE4DArgGJotOr
         i78JCgff41Xvo61ee4zN1BY7Z4Rb5dD/zijjDeHA+hXQjuVGFsFps1OseVgeiP6jlW
         b7+3i+wC4d1miMlTY09wQe/bcWS5JRF6BTE2+w+E=
Date:   Fri, 15 May 2020 14:31:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Lo <kevlo@kevlo.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: phy: broadcom: add support for BCM54811
 PHY
Message-ID: <20200515143142.20ee5a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515172447.GA2101@ns.kevlo.org>
References: <20200515172447.GA2101@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 May 2020 01:24:47 +0800 Kevin Lo wrote:
> The BCM54811 PHY shares many similarities with the already supported BCM54810
> PHY but additionally requires some semi-unique configuration.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Checkpatch complains about using spaces instead of tabs:

ERROR: code indent should use tabs where possible
#80: FILE: drivers/net/phy/broadcom.c:359:
+        }$
