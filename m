Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9500B2F903E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbhAQCwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbhAQCwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 21:52:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE62422BEA;
        Sun, 17 Jan 2021 02:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610851882;
        bh=neYJhAFX2EpB91GSh7sWfwsfCQdMzbg/Mpk7qBV5Ddc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ednjdjLnf9uNnHKnzDkBpjMhyarm+epKnUbiYN/5qF9VRgzxlFuo+k/heQEBj+BA9
         qp7vq4YtW1tb2OVrFfq4JbxoKl0k1B+YFs9c0Ae7kbOz5b1T1lDKHa2aBezgwqIH/j
         4tKnER5ATfLCnup/15E6vG3BcKhC6bIGbzxIVxqVYdS5tv54dXHAkfGM7CeHBXXDV5
         rtFwTC51yuZANdt54gv06yB04BXufKkcoX7YWmoq7T/HdKm8F0TGWoGw6zhdoNIoJ3
         oPiNATz2jgmoVOz179GD2JUsP/DKLrblYZCNOKVR3o2K9GtHIpe7EFZpZ9wjrtEHT/
         zXgUfQ53cmICQ==
Date:   Sat, 16 Jan 2021 18:51:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH net-next V2 1/8] net: netdevice: Add operation
 ndo_sk_get_slave
Message-ID: <20210116185121.7f6c4c83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114180135.11556-2-tariqt@nvidia.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
        <20210114180135.11556-2-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 20:01:28 +0200 Tariq Toukan wrote:
> ndo_sk_get_slave returns the slave that corresponds to a given socket.
> Additionally, we implement a helper netdev_sk_get_lowest_dev() to get
> the lowest slave netdevice.

Please don't add new uses of the word "slave" outside of the bond, 
and preferably even there.
