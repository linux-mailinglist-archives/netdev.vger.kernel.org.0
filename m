Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D32530B632
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhBBEIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhBBEIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:08:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C35264D9F;
        Tue,  2 Feb 2021 04:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612238854;
        bh=LaeD5DPvFdSktOmKKZgyECD+giBegBebD6UQTrQ6sAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dbcnpMHMWhiFUgUtO9oSDqCiMMJiR1n2fJ1YUcWz73DlsaZiYHAQauDSnP2P5UYjz
         O9ZA8azXd7v8R308Q0xYYhvLCC2Ld2A1GDk+rlwz5imghZ23TakjppcX4Md+FquDfq
         SdXudIxO16n+6VUDMNhGQpNXyo/c9SJsFtA/cXqz7aGCldaMrtlwgtVod7CeAI70qS
         KZbt2+jZ1phR125TpDCghqWMQTdNXUpDhwh1fsWVrCDfMKt5x38aBkBmr8z38M+Aoe
         ul6+2/P2a7TtVkn8f4et4g98w1eux0J+hOh/aAtBbvbW5db9kGK3JJL3I4VBY15NYv
         tY47uoXpHfECA==
Date:   Mon, 1 Feb 2021 20:07:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: make sendmsg/recvmsg process multiple messages at once
Message-ID: <20210201200733.4309ef71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3ba8R6fN3O5zLAw-e7q0gjFxBd_WUKjq0hTP+JpAbJEKg@mail.gmail.com>
References: <CADxym3ba8R6fN3O5zLAw-e7q0gjFxBd_WUKjq0hTP+JpAbJEKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 20:41:45 +0800 Menglong Dong wrote:
> Hello, guys!
> 
> I am thinking about making sendmsg/recvmsg process multiple messages
> at once, which is possible to reduce the number of system calls.
> 
> Take the receiving of udp as an example, we can copy multiple skbs to
> msg_iov and make sure that every iovec contains a udp package.
> 
> Is this a good idea? This idea seems clumsy compared to the incoming
> 'io-uring' based zerocopy, but maybe it can help...

Let me refer you to Willem and Paolo :)
