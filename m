Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DFD5F6A3A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiJFPGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiJFPGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:06:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F6C88DE2;
        Thu,  6 Oct 2022 08:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D20FD619EC;
        Thu,  6 Oct 2022 15:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3666C433D6;
        Thu,  6 Oct 2022 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665068812;
        bh=MDzPc+gslB3lFJVHCDL7oB438br41NbH0vrN2nPdfp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RTvYqVsGUc+07tdnYX2as73+3v0myn5rZPOURR3R+8XEUkkzASdWujqgKKRwU4ojj
         +65u3fWZBADWcaT0PnHEylFcSEHivWSKmb2UyYeoDDd0TRNF7wXaQdj+A0Mv6fSqai
         a+UqEY9NbI0LWQzU0/cVI5Sl5eO0MIyfJtO+jOTUl6EkruQ2ZLzF3lhbeywhiqBhZ/
         FojeGJ0s+bSYIpKDx3fGtIb8CbJPivs7dcz/w8Gvor9cZPCkEyiNu5PTi/wCqU6Akj
         MhN/lb29PDB2ES+KV6f3+2fn5hdRhxTP1mlYxSSY/5nC4k2zXnWvfSbkhMbv9ZJWQw
         JrglYw4Xe0ogw==
Date:   Thu, 6 Oct 2022 08:06:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     davem@davemloft.net, edumazet@google.com, khalasa@piap.pl,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: ethernet: xscale: fix space style issues
Message-ID: <20221006080651.6cc91dd7@kernel.org>
In-Reply-To: <Yz5cP82JRuvZHh+I@Red>
References: <20221005120501.3527435-1-clabbe@baylibre.com>
        <20221005203545.48531d8e@kernel.org>
        <Yz5cP82JRuvZHh+I@Red>
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

On Thu, 6 Oct 2022 06:40:31 +0200 LABBE Corentin wrote:
> The difference with classic checkpatch is that I have tested it.

If you make some material changes to the driver I'd reconsider,
otherwise I'd strongly prefer to stick to the general policy.

> And the patch #2 fixes the bad netdev_debug().

Please isolate that from the noise and send it separately
(after net-next opens).
