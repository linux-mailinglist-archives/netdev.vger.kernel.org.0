Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50E1194FF3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgC0EQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgC0EQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 00:16:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 025A920578;
        Fri, 27 Mar 2020 04:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585282592;
        bh=VRn4CmnO4guCD3v0PtWxBdCVigKH7R2NN/+P9WQ6LhA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2dgPZUxTe0hmf+l3SsoeBLj329rzs1nPoy5RXCid7+x7zbHLD2+rGx5Zs9wPe4Ds7
         +4hm6xa1wdBJfO9t6Fe4bq8sLttnuv7dAOjjO23RFSn4lZ7CovBOrmX8SPHT8rUcYO
         HKGKR9DqamA1hJqoK5W+3L9hxTrPF9BjduDEmdOE=
Date:   Thu, 26 Mar 2020 21:16:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/12] ethtool: set coalescing parameters with
 COALESCE_SET request
Message-ID: <20200326211630.41e0329c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bee4443c5091f344629b22ccac812cb083303534.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
        <bee4443c5091f344629b22ccac812cb083303534.1585267388.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 01:12:02 +0100 (CET) Michal Kubecek wrote:
> Implement COALESCE_SET netlink request to set coalescing parameters of
> a network device. These are traditionally set with ETHTOOL_SCOALESCE ioctl
> request. This commit adds only support for device coalescing parameters,
> not per queue coalescing parameters.
> 
> Like the ioctl implementation, the generic ethtool code checks if only
> supported parameters are modified; if not, first offending attribute is
> reported using extack.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
