Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5BA1CBDE7
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgEIFtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgEIFtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:49:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5FCF21582;
        Sat,  9 May 2020 05:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589003350;
        bh=HpzK77V7ZTe2xyZ7rSyEisyDueYQxUsKw8a/xbIsAuI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gtqkZWqmYR0dJi17ciI60bEXnkrcFMQkQH0FDDdpNC0PU06bS55aSyoR17wRTPdP3
         rHOblT5/5kcyL634rmb+iFJh2CSs5QJ0e4InZJqU2jkJvP4b4umx4Kv0pOnEZ8eoG+
         Up4cRgOr54vwlJuy/dpcx0IJsAO0jEVgGQGluDV0=
Date:   Fri, 8 May 2020 22:49:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] net: tg3: tidy up loop, remove need to compute off
 with a multiply
Message-ID: <20200508224908.5c594f73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508231447.485241-1-colin.king@canonical.com>
References: <20200508231447.485241-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 00:14:47 +0100 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the value for 'off' is computed using a multiplication and
> a couple of statements later off is being incremented by len and
> this value is never read.  Clean up the code by removing the
> multiplication and just increment off by len on each iteration.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you!
