Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF0A194FF1
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgC0EQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgC0EQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 00:16:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4815520575;
        Fri, 27 Mar 2020 04:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585282567;
        bh=MPqAiPXpN5JEkst6TsHe7SkHCTDCe2DIkSuHMQ7/dms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=quKFvuyz12eu/G9oWjWmPb1R2W8+1AEE+hw7Bl+9O57Uy07ZsDD007nRvzia+GCVv
         5MYYmypeP5931n/0LABmOuiShM30MTWgEnAhlTR5dnuJbuMaBv/4KGhv4L7tvj36Pe
         FKKcQf+OwiuJoRaZ3XyPuHKiAth54sUoaMRotbHo=
Date:   Thu, 26 Mar 2020 21:16:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] ethtool: provide coalescing parameters
 with COALESCE_GET request
Message-ID: <20200326211605.6f80f9c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0d94d1390e886c2d616291c46509fac4cd9eac11.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
        <0d94d1390e886c2d616291c46509fac4cd9eac11.1585267388.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 01:11:57 +0100 (CET) Michal Kubecek wrote:
> Implement COALESCE_GET request to get coalescing parameters of a network
> device. These are traditionally available via ETHTOOL_GCOALESCE ioctl
> request. This commit adds only support for device coalescing parameters,
> not per queue coalescing parameters.
> 
> Omit attributes with zero values unless they are declared as supported
> (i.e. the corresponding bit in ethtool_ops::supported_coalesce_params is
> set).
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
