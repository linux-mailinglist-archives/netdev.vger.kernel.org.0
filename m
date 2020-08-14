Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3EC245030
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 01:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHNXn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 19:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgHNXn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 19:43:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063CCC061385;
        Fri, 14 Aug 2020 16:43:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8F5B1277D40A;
        Fri, 14 Aug 2020 16:27:09 -0700 (PDT)
Date:   Fri, 14 Aug 2020 16:43:54 -0700 (PDT)
Message-Id: <20200814.164354.1568500831741804705.davem@davemloft.net>
To:     po-hsu.lin@canonical.com
Cc:     kuba@kernel.org, skhan@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] selftests: rtnetlink: load fou module for
 kci_test_encap_fou()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200813044422.46713-1-po-hsu.lin@canonical.com>
References: <20200813044422.46713-1-po-hsu.lin@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 16:27:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Thu, 13 Aug 2020 12:44:22 +0800

> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> index 3b42c06b..96d2763 100644
> --- a/tools/testing/selftests/net/config
> +++ b/tools/testing/selftests/net/config
> @@ -31,3 +31,4 @@ CONFIG_NET_SCH_ETF=m
>  CONFIG_NET_SCH_NETEM=y
>  CONFIG_TEST_BLACKHOLE_DEV=m
>  CONFIG_KALLSYMS=y
> +CONFIG_NET_FOU

You need to assign it a value, not just add it to the file by itself.
