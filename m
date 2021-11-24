Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DBC45B301
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbhKXEQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhKXEQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:16:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0AAF60FA0;
        Wed, 24 Nov 2021 04:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637727209;
        bh=eqz/QGVARcSmjPuurQbLH3s0ioMZvO5xAzsQ2JZIEug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zr1KYde+bXt/wzHlv9ghGFD1LXOxIKowsTqcoPRrqZOjRp5b2BfkscMtvb93zxxDR
         xSx36iIyk1sf2BAA6hL5b7DSbJBj3NnUuC9sznYDsWDqXWYPshnSZFvbxowfglWG4P
         445V5N5G5Lie7FN2RJk5V0j2C+7dDMWKg0oLKt0QXffYIUw/yo8xtROIXUhECkVkis
         G+pWXayrKQwGUGW9foY7vi9VBDWClh1gDcbfe1Dsts2Cl2uHd6FLvQXHlZSHPYjfg1
         2+8fBv/0efCwfOl5lvwwfe7kvSu92iqS0BMPS7lM3LWglAghmuzosXB5/1I3wgsz7B
         POZokdFnNzWSA==
Date:   Tue, 23 Nov 2021 20:13:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Bernard Zhao <bernard@vivo.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bridge: replace simple_strtoul to kstrtol
Message-ID: <20211123201327.3689203b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f98615d9-a129-d0b0-e444-cb649c14d7ce@nvidia.com>
References: <20211119020642.108397-1-bernard@vivo.com>
        <YZtrM3Ukz7rKfNLN@shredder>
        <f98615d9-a129-d0b0-e444-cb649c14d7ce@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 12:17:39 +0200 Nikolay Aleksandrov wrote:
> > # ip link add name br0 type bridge vlan_filtering 1
> > # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol 
> > bash: echo: write error: Invalid argument
> 
> Good catch, Bernard please send a revert. Thanks.

Doesn't look like he did, would you mind taking over?
