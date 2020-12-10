Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD162D51B5
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbgLJDnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730729AbgLJDnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:43:13 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE10C0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 19:42:33 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7FED64D259C21;
        Wed,  9 Dec 2020 19:42:32 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:42:32 -0800 (PST)
Message-Id: <20201209.194232.2256501629400589947.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     simon.horman@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, lkp@intel.com
Subject: Re: [PATCH net-next] nfp: silence set but not used warning with
 IPV6=n
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209161821.1040796-1-kuba@kernel.org>
References: <20201209161821.1040796-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:42:32 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed,  9 Dec 2020 08:18:21 -0800

> Test robot reports:
> 
> drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_rx_resync_req':
> drivers/net/ethernet/netronome/nfp/crypto/tls.c:477:18: warning: variable 'ipv6h' set but not used [-Wunused-but-set-variable]
>   477 |  struct ipv6hdr *ipv6h;
>       |                  ^~~~~
> In file included from include/linux/compiler_types.h:65,
>                     from <command-line>:
> drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_add':
> include/linux/compiler_attributes.h:208:41: warning: statement will never be executed [-Wswitch-unreachable]
>   208 | # define fallthrough                    __attribute__((__fallthrough__))
>       |                                         ^~~~~~~~~~~~~
> drivers/net/ethernet/netronome/nfp/crypto/tls.c:299:3: note: in expansion of macro 'fallthrough'
>   299 |   fallthrough;
>       |   ^~~~~~~~~~~
> 
> Use the IPv6 header in the switch, it doesn't matter which header
> we use to read the version field.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Applied, thanks.

