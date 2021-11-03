Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F780443AB9
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 02:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhKCBNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 21:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhKCBNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 21:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12D6E60FC4;
        Wed,  3 Nov 2021 01:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635901842;
        bh=xI9EJ2i6X9dxqm5x8ZW0RA+QOVBUId4dJCq44ghvmK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mUq1CEHZdLfPWeL31ZzgZgIxBBnELvCAd0rvfWK31pNdiH7nDIppJ4x01QFHl7fZu
         Hs3ZeXZIIyyks5fG62xLL8Wz/ymXWeqeqNfUBDWlfc+7pPQiM6j/0w1ra7qMQ/AdVb
         fW+P9eVukjDa9hmepXUbLU1KV3aE5IFu8wn9OJip3UU1qzdq+zUZgWNXmOevft3/qx
         veyWvfqR6ei7k6qMWpSHFzGTBlYef/gfNxgc6mclex9vCyyfSfiRYjstdf+SeBjULK
         pXVBm9i5SxiTgGFBeBIMzn0xETmPhU5Cp2ZhJ41gA7ZhZZ6Ow+aUzSwOGdUOWJKd4U
         Y38tFhLnFmKgw==
Date:   Tue, 2 Nov 2021 18:10:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [-next] net: marvell: prestera: Add explicit padding
Message-ID: <20211102181038.31035104@kicinski-fedora-PC1C0HJN>
In-Reply-To: <SJ0PR18MB4009AED9ADC1CB53775F71FEB28B9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <20211102082433.3820514-1-geert@linux-m68k.org>
        <CAK8P3a1x0dU=x=mnBC8JeDG=dsQNfyO7X=16jm0WUwQ8wwLp=w@mail.gmail.com>
        <SJ0PR18MB4009AED9ADC1CB53775F71FEB28B9@SJ0PR18MB4009.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 11:36:19 +0000 Volodymyr Mytnyk [C] wrote:
> Should I rebase my changes based on yours now ? Is it possible to make a relation chain ?

Please rebase your changes on top of net/master.
