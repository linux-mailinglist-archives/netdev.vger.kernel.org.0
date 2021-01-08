Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0C92EEA85
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbhAHApr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbhAHApq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:45:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6622323447;
        Fri,  8 Jan 2021 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610066706;
        bh=ichOfYVV6QKkj4LIoAZyeadXbjf/ie4F1oedhKSaTQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WXw2V9MN126k6JyDYoGVycAAsob2WckDRKcWUmPs7h0JFt5QlQYQWzPbUWUv0ICZZ
         IFgPATGuwwoXK3pmRXQHfEW5PwjmmJ+b7rMDhqNxKypIRPoMW7VQZSaD4GFf5ZHZto
         RjNTTEb60Og6Pdp9iclXonjCA3NO3Gtn9knrdLowNutIBYEdJtRBuz5T5JMcAc3Eep
         N7tyqQQ0sj1uwyNHdmZdRFeQ12M43LENikgd7J2U4GtbkMwp1UJfrosgJlqq3Ftg0H
         /Slo2cIi2WCTtrbJfBNdU/hPe/SVIRl5SQnhj7Pk0u7n/jf+GkMxzUhfhsLQw7liUY
         RlEq86SZyFDKw==
Date:   Thu, 7 Jan 2021 16:45:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net-next repost v2 7/7] net: selftests: Add lanes
 setting test
Message-ID: <20210107164504.4a07de2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106130622.2110387-8-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
        <20210106130622.2110387-8-danieller@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 15:06:22 +0200 Danielle Ratson wrote:
>  .../selftests/net/forwarding/ethtool_lanes.sh | 186 ++++++++++++++++++
>  .../selftests/net/forwarding/ethtool_lib.sh   |  34 ++++
>  tools/testing/selftests/net/forwarding/lib.sh |  28 +++

Why is ethtool_lanes test getting added to net/forwarding? =F0=9F=A4=94
