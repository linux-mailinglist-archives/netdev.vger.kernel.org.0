Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD30194FF8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgC0ERb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgC0ERa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 00:17:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6C0720575;
        Fri, 27 Mar 2020 04:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585282650;
        bh=RPePmMwPFimXPGkwR32QX+QDFjudoyz3rqrcouN9uHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C2GKWPh9puE+f9Q4elfNr+nHGoCOPRF18GgMYS+Hetgs9pwa68NMA19RA6i+UF9cb
         gw7sIp009rVUoR9DtUtsmtX+l0+bOBcwoLSIYdR1RF7rT/DO1JkZ9bsdmxBRHLPsxz
         w8Fk2DJWk5CktJ70PgrOEaufvX3Pd3HPuQybPH54=
Date:   Thu, 26 Mar 2020 21:17:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 00/12] ethtool netlink interface, part 4
Message-ID: <20200326211728.0f0d53d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 01:11:47 +0100 (CET) Michal Kubecek wrote:
> Implementation of more netlink request types:
> 
>   - coalescing (ethtool -c/-C, patches 2-4)
>   - pause parameters (ethtool -a/-A, patches 5-7)
>   - EEE settings (--show-eee / --set-eee, patches 8-10)
>   - timestamping info (-T, patches 11-12)
> 
> Patch 1 is a fix for netdev reference leak similar to commit 2f599ec422ad
> ("ethtool: fix reference leak in some *_SET handlers") but fixing a code
> which is only in net-next tree at the moment.

LGTM, let's CC Richard for the timestamp stuff.
