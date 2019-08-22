Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD4798A25
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 06:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfHVEE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 00:04:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfHVEE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 00:04:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44FD91524749A;
        Wed, 21 Aug 2019 21:04:28 -0700 (PDT)
Date:   Wed, 21 Aug 2019 21:04:27 -0700 (PDT)
Message-Id: <20190821.210427.500229269128524420.davem@davemloft.net>
To:     anders.roxell@linaro.org
Cc:     shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: add missing NFT_FWD_NETDEV to config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820134102.25636-1-anders.roxell@linaro.org>
References: <20190820134102.25636-1-anders.roxell@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 21:04:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>
Date: Tue, 20 Aug 2019 15:41:02 +0200

> When running xfrm_policy.sh we see the following
> 
>  # sysctl cannot stat /proc/sys/net/ipv4/conf/eth1/forwarding No such file or directory
>  cannot: stat_/proc/sys/net/ipv4/conf/eth1/forwarding #

I don't understand how a netfilter config options is going to make that
generic ipv4 protocol per-device sysctl appear.

If it's unrelated to your change, don't include it in the commit message
as it is confusing.

Thank you.
