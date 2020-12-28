Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58D92E6C74
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgL1Wzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729504AbgL1VRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 16:17:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A9D2084D;
        Mon, 28 Dec 2020 21:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609190218;
        bh=VeYjFk0QFJysNKxF9L0279JLYEp2fxJUpC0JuwRpKuE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D8IDhElt86urwjookhPiLZU3N/L9g0UfewPn9CNCf3dEXTnqPVT4U7S0mqRnEPJMn
         Ljv/kOGL1Ba+eTr7LoOhmI4QGHN2cBubClyHtJL9Fz17DYEJWuZD8H5LCprDEjtsHv
         1vFRV6bHJHfk3WoJDhzM9HQCnCbbEFtauQxAXR1h927+1bui8bCNzzU19rO9mi9vrZ
         huZ+MZc4c0+NFIUUV7yZr/91Z+akNlUIL66u4sHSR6vPmouIS0T6ST9kzy8afnZYV4
         nlC5vV5VpHDbidoF7NCDv1YRI1vgLUl//XowgIlqX1xVMzGIUPbCcRKXvG2opK7plJ
         gc1GU7E8ZNoBQ==
Date:   Mon, 28 Dec 2020 13:16:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: Add a virtual nci device driver
Message-ID: <20201228131657.562606a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228094507.32141-1-bongsu.jeon@samsung.com>
References: <20201228094507.32141-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 18:45:07 +0900 Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> A NCI virtual device can be made to simulate a NCI device in user space.
> Using the virtual NCI device, The NCI module and application can be
> validated. This driver supports to communicate between the virtual NCI
> device and NCI module.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

net-next is still closed:

http://vger.kernel.org/~davem/net-next.html

Please repost in a few days.

As far as the patch goes - please include some tests for the NCI/NFC
subsystem based on this virtual device, best if they live in tree under
tools/testing/selftest.
