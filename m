Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EEC5BEA9B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiITP4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiITPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:55:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A046B675
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98D56B82AEA
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D4CC433C1;
        Tue, 20 Sep 2022 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663689355;
        bh=hjBg5cwgLvlSWYJOh+ELk2rQKYR36ZekZfXqVnzdzGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GklAb1UyhSWOHKll2l01HPHcYMPhoShqkIaiy1rekKylkvwFguHdRNq9LK29WuBeD
         /dMwJzjRF8gCCuNS/3nj8al8DjbMCN0+ta0e0QoVfHc2ZpZm7u43ZV9XAF0O2dYWPW
         YR+64q5lWCvBVSvwzUO1KRTgen6rAjd26glr3hEQp5q4EhVPYJJMjxEC++Qyn9Y99a
         wHsg0yL4chQFcP8zpxMeec3W4xxVlEBm/H3Tm34h04N1lOdwhe4MPxqTNOZ7MdRU/6
         TXK6YvwcbZM8nPeYS5pRJk593TlKpBB72tEw0k9IW5c32ExcA6Zw/3gUAsMvnLyZk9
         bjwLrnpeFUp7g==
Date:   Tue, 20 Sep 2022 08:55:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>
Subject: Re: [PATCH net] selftests/bonding: add a test for bonding lladdr
 target
Message-ID: <20220920085553.646a87f6@kernel.org>
In-Reply-To: <YyPTvVzFWoVdf3D8@Laptop-X1>
References: <20220915094202.335636-1-liuhangbin@gmail.com>
        <970039e7-1c13-e6d7-cb70-53af92eb9958@redhat.com>
        <YyPTvVzFWoVdf3D8@Laptop-X1>
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

On Fri, 16 Sep 2022 09:39:09 +0800 Hangbin Liu wrote:
> Hi David, Jakub, Paolo,
> 
> I saw the patch checking failed[1] as there is no fixes tag.
> 
> I post the patch to net tree as the testing commits are in net tree. I'm
> not sure if this patch should go net-next? Any suggestion?

Sorry about the delay in responding. There are corner cases the
patchwork check does not take into account so feel free to ignore
it unless maintainers bring it up as well.

For selftest I don't feel like we have enough experience deciding
so either net or net-next is fine by me. Since the new patch targets
net-next I'll take that one :)
