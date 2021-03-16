Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EBF33DFA8
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhCPU7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232111AbhCPU7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 16:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1D6B64F6B;
        Tue, 16 Mar 2021 20:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615928342;
        bh=kemmhiNXGjgM3Xez8OspoEtsDyPaLxVqLgsB1W7iaYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SlRhSovfQZ7GhqhOSREw5bDT+EfPb3UQVIPexq2SwpdkbuWHKs0xDq0idL1zR4fN2
         ES7yOeXaVJ5WERa3vTSRA/6j+iD0rBhWj8rXJIIqLU6r1Z5oqzUBZ8g5nRmqk3a7uZ
         zW5lQ9RGy6OEEQAdRBJ8slKIHqnn1UJFuqebk+hsODDWzlip9fIHgXIPMgXr8VIysK
         ZKf6CEXEwpVPp5RG1xZ3h2aWNI5RyrMVkuOb2ucY0DY/i6+pZcrk3gK7xt5+Mw3hbX
         TMOzNO1DMgbgnU9U60kidurfftDaW/FICTv6jZEQMWNF1pqd8yd/0h94gqiJrhpwQE
         c/qRaWgIziW7w==
Date:   Tue, 16 Mar 2021 13:59:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] net: bridge: mcast: simplify
 allow/block EHT code
Message-ID: <20210316135901.4e4239fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315171342.232809-1-razor@blackwall.org>
References: <20210315171342.232809-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 19:13:40 +0200 Nikolay Aleksandrov wrote:
> There are no functional changes.

That appears to indeed be the case:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
