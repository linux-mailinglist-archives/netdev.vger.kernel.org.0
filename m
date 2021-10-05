Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D1C421BD0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhJEBXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhJEBXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF4EC610CC;
        Tue,  5 Oct 2021 01:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396920;
        bh=gTQ2n1FEdaY6DNoqo71cjxij54hJtCzLSxmCD3zHY/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hVvQXuMLojBVt5/fOnHcA+5uoo69p9Qve11pJXcDRnA/YA6TYfUvcVkgWTogW93Re
         vSBFqe5g6nnLjT09jLtv5ybZo+jXTunP7lbKkYfksuL41BEPSP05Q1A7XzVwZ6JmH2
         lW0CNh45sQlEaM06E2UY1iCMVYFbiZbeVXQCugu+kFI9jKy5QTrfY7iH6CcE54vSvV
         YlInelVfKLHRY8/1Z//YGAkEa1Pegz1592SnWEYwavsJkQg1h+WUcrNb4YtKoqvmfz
         rI/TDeft4vCzsL4Me6T7E9N9d1XAJIYcPNAKdfCQB1FFL6keRoOhrTEegDnoW0n62n
         oShyI0cvjYilQ==
Date:   Mon, 4 Oct 2021 18:21:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2021-10-04
Message-ID: <20211004182158.10df611b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211004222146.251892-1-luiz.dentz@gmail.com>
References: <20211004222146.251892-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Oct 2021 15:21:46 -0700 Luiz Augusto von Dentz wrote:
> bluetooth-next pull request for net-next:
> 
>  - Add support for MediaTek MT7922 and MT7921
>  - Add support for TP-Link UB500
>  - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
>    8822C/8852A.
>  - Add initial support for link quality and audio/codec offload.
>  - Rework of sockets sendmsg to avoid locking issues.
>  - Add vhci suspend/resume emulation.

Now it's flipped, it's complaining about Luiz being the committer 
but there's only a sign off from Marcel :(
