Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93386453F02
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhKQDh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhKQDhz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:37:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AD32615E1;
        Wed, 17 Nov 2021 03:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637120097;
        bh=VUmTIC5BCyZ67w3qyjsYJF8UTcuEeggLjE43jAsZRD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TpRtqW9K38XsKt2Jsswp3oGgIz8moVJ/FoKwYK6BnhVVFh5py0AAmx2OAXafjgYTF
         i2hnSzbu0NpUAewcSc+kqOn7J4v6gG4/zOuxi6De07zFSYGlkg/twBCmzBbe1sVUcF
         U8G8C10a45A2SFCkrMpb+2F0AQjuor8eBaEraNyT+o21Bv4Bj8tMj3ODKrnGz9OWYJ
         TYUH1k8z0zftZikYRj6KjSEkLV8GnygVyMNjSmcGIXJCd/P+VdSJo5rrkFf9Y06teK
         bArTFlLdREii0nzt/Bt5eXvgTWpIUFNVRrnUnUcLKr20O4jpoW/AYJ1PuM4oMUNQed
         aRDdVCxM4C8MQ==
Date:   Tue, 16 Nov 2021 19:34:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Rocco.Yue@gmail.com,
        chao.song@mediatek.com, yanjie.jiang@mediatek.com,
        kuohong.wang@mediatek.com, zhuoliang.zhang@mediatek.com,
        lorenzo@google.com, maze@google.com, markzzzsmith@gmail.com
Subject: Re: [PATCH net-next v2] ipv6: don't generate link-local addr in
 random or privacy mode
Message-ID: <20211116193456.54436652@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <14eee606-427b-e0e4-abe2-de4e166c1585@gmail.com>
References: <20211116060959.32746-1-rocco.yue@mediatek.com>
        <14eee606-427b-e0e4-abe2-de4e166c1585@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 13:21:12 -0700 David Ahern wrote:
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> you should add tests under tools/testing/selftests/net.

Please keep David's review tag and repost with a selftest.
