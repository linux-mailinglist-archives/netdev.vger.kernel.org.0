Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE201C7E46
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgEGAAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgEGAAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:00:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C3BC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 17:00:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41E3212776891;
        Wed,  6 May 2020 17:00:22 -0700 (PDT)
Date:   Wed, 06 May 2020 17:00:18 -0700 (PDT)
Message-Id: <20200506.170018.550097165407520983.davem@davemloft.net>
To:     fgont@si6networks.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next] ipv6: Implement draft-ietf-6man-rfc4941bis
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501035147.GA1587@archlinux-current.localdomain>
References: <20200501035147.GA1587@archlinux-current.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:00:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Gont <fgont@si6networks.com>
Date: Fri, 1 May 2020 00:51:47 -0300

> Implement the upcoming rev of RFC4941 (IPv6 temporary addresses):
> https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-09
> 
> * Reduces the default Valid Lifetime to 2 days
>   The number of extra addresses employed when Valid Lifetime was
>   7 days exacerbated the stress caused on network
>   elements/devices. Additionally, the motivation for temporary
>   addresses is indeed privacy and reduced exposure. With a
>   default Valid Lifetime of 7 days, an address that becomes
>   revealed by active communication is reachable and exposed for
>   one whole week. The only use case for a Valid Lifetime of 7
>   days could be some application that is expecting to have long
>   lived connections. But if you want to have a long lived
>   connections, you shouldn't be using a temporary address in the
>   first place. Additionally, in the era of mobile devices, general
>   applications should nevertheless be prepared and robust to
>   address changes (e.g. nodes swap wifi <-> 4G, etc.)
> 
> * Employs different IIDs for different prefixes
>   To avoid network activity correlation among addresses configured
>   for different prefixes
> 
> * Uses a simpler algorithm for IID generation
>   No need to store "history" anywhere
> 
> Signed-off-by: Fernando Gont <fgont@si6networks.com>

Applied, thanks.
