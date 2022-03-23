Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AD24E4C09
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 06:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240580AbiCWFNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 01:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiCWFNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 01:13:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E503146172;
        Tue, 22 Mar 2022 22:11:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E9B2615C4;
        Wed, 23 Mar 2022 05:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50812C340E8;
        Wed, 23 Mar 2022 05:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648012295;
        bh=twJa8z2WuTuCCTXplZkeqyLcJT4YJH1ALfCTJg9asGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GZYbLIC2YT2wIpJW5DQR0JXtC2S6yUPpwmr8PqeJMgGgfhEAE8+2ji9EogfpFkp++
         sixVLYm9hAeDBtr1IZO4wyTDRNvr44E3BenK6OspKpTIXUY1T4/txuwyhkHbx+DZqI
         Go199aUs+HrcR7tEw49lV/DOYUY9B1MntWAx1ac9Ytt0qreK+OeJ83JwDZmAfYRP0O
         io0Q+QzIVCASK7NmWyUOxKAzce2jju1Mgv5vFYkuUjS9xP8HL2FS64Dv5qxsRUREJx
         n/E674ufMXx2BNfYHpEvvmrKVmPMuFSSZl1AFMi/PGO9fL5uZk5xuvbr7a3NZKOcdq
         Yx25hoeVMq/BA==
Date:   Tue, 22 Mar 2022 22:11:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: ipset: Fix duplicate included
 ip_set_hash_gen.h
Message-ID: <20220322221133.7475f708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1648005894-28708-1-git-send-email-baihaowen@meizu.com>
References: <1648005894-28708-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 11:24:54 +0800 Haowen Bai wrote:
> No functional change.

In some deeply philosophical sense? This patch does not build.
