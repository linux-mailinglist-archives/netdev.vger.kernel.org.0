Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7B76A638D
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 00:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjB1XCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 18:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1XCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 18:02:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7AE37B55;
        Tue, 28 Feb 2023 15:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9321611FB;
        Tue, 28 Feb 2023 23:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ABCC4339B;
        Tue, 28 Feb 2023 23:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677625253;
        bh=99o29zw3yIg7aA9J7+rUKtWHA2hbEKV1QYB7BfM4PfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IfJMksEKcqIv3a0o38+6TMgiPYuk7BS4L2VGNuGfMNVVdiP2qGxxkkR8nfWbz6XBR
         eJgdw84gC7u9i7sSJmDyvFtcQcZv07rlCsiQtQSg62Jhu+6zAqTgbn6k1PJmy79GW0
         6GGgWY4RoDR2DEpY+tZSDCxreWn6maDGyvcsip7Lqs+JxjHAy2g9w8Z50/W7USgVuZ
         NJKUfob+vaGqyBhu+IfrPNd3H8sdnf+z2e60je6Nb0qEUiBvwKj6NrcbQp+aLvUc7Y
         Xo5mtEuyE8Hlj8ZH+P3gVdyV8K9shslb4GQAMwUIVuzsvhfYV/FJZ06bPz3BE8cIsF
         ZLUu3ldQCvhUQ==
Date:   Tue, 28 Feb 2023 15:00:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 0/4] net/smc: Introduce BPF injection
 capability
Message-ID: <20230228150051.4eeaa121@kernel.org>
In-Reply-To: <1677576294-33411-1-git-send-email-alibuda@linux.alibaba.com>
References: <1677576294-33411-1-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 17:24:50 +0800 D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patches attempt to introduce BPF injection capability for SMC,
> and add selftest to ensure code stability.

What happened to fixing the issues Al pointed out long, long time ago?

https://lore.kernel.org/all/YutBc9aCQOvPPlWN@ZenIV/
