Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF328656B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgJGRGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGRGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:06:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF5021582;
        Wed,  7 Oct 2020 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602090376;
        bh=43hualOk3Bfg6cqfdB094J9YAJPe9d1MudmOwcCWClg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q9kYN0/F1MPIQcD/DIEho4PXQbjvkhU8cIaK4Jc2pj7VYYXeApHGFZ5fli51W/83L
         7fJcxHZrRpcuh4g3wJ8QL2xBX8QrUOzEXi5iUBqX8ZRvAXunj0nhNAVG6z/UQtbjGP
         LB7VlriwyifE8kojDWxUvVTbYnRkbJrsFH8QlK0o=
Date:   Wed, 7 Oct 2020 10:06:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2 2/2] netlink: export policy in extended ACK
Message-ID: <20201007100614.7d334deb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006201333.b901bad12976.I6dae2c514a6abc924ee8b3e2befb0d51b086cf70@changeid>
References: <20201006181555.103140-1-johannes@sipsolutions.net>
        <20201006201333.b901bad12976.I6dae2c514a6abc924ee8b3e2befb0d51b086cf70@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 20:15:55 +0200 Johannes Berg wrote:
> +	case NLA_S64:
> +		/* maximum is common, u64 min/max with padding */
> +		return common +
> +		       2 * (nla_attr_size(0) + nla_attr_size(sizeof(u64)));
> +		break;

nit: break
