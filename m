Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF334E7BE9
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiCYWAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiCYWAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671C8126590
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:58:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F350160C34
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 21:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2B0C340ED;
        Fri, 25 Mar 2022 21:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648245527;
        bh=51uIhwJxLwWUU7nZ7b10bTqP+8+5UpR8e0rdnoe/u6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qcIQjff8SslTBXA78IHG/RATUlyvdbdbf6DrLGpPZlllrtj6wF54unItJJ1ajrRkK
         xHWrF3KOE50wJF0JQguVj1YH3btnV5B4qgthMWpSt5iTnUZBUzeWwUymH0naJJ1NPZ
         1FGFYU0m+3iQS9wsj7AZtyh3joff28a45FutjYYutMLIXaXlXGmynCMsG3NyH6uCg1
         Bl/jbyw6fzaKfp3ZcVnecKs5d0NRXCcbC2QeuvCxCROU0Beu8DjpGS0KwJfh0c6Qu4
         iMxhZLUawA1cGy2QYL2Q6gbebwCOXW9ZeUwaHS7Y0BSg5fP3lMF8WpKeJtTwV/EVVk
         MJJ54Dre875RQ==
Date:   Fri, 25 Mar 2022 14:58:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] net: ensure net_todo_list is processed quickly
Message-ID: <20220325145845.642c2082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220325225055.37e89a72f814.Ic73d206e217db20fd22dcec14fe5442ca732804b@changeid>
References: <20220325225055.37e89a72f814.Ic73d206e217db20fd22dcec14fe5442ca732804b@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 22:50:55 +0100 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In [1], Will raised a potential issue that the cfg80211 code,
> which does (from a locking perspective)

LGTM, but I think we should defer this one a week and take it 
to net-next when it re-opens, after the merge window.
