Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59FB610847
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiJ1Cjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiJ1Cjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83B76402;
        Thu, 27 Oct 2022 19:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A10F625C2;
        Fri, 28 Oct 2022 02:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA14C433C1;
        Fri, 28 Oct 2022 02:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666924772;
        bh=Zq8Biy8yyjz5QeLIoqnImdO4uiv3Fe/XLFyNI2N2wo4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N06kh0OTaDOe6TbUhYeoK5uC84aG3qfxdCyRkRxrpIjpReBbq35ghnNZIZA7LdpMB
         D74lzDI1obWg4juYKcKPpcUNt+7f4lHhDm3RSlk2L4o60YVDvf3IiIU+/V3+rUnelB
         shmFOMYCSmzDYryvJnPPDKwIc2I2kySUNzqua/G8oi2BckS2Dzc8QgABD160yW5kb8
         nsPC2ObDLuQdahyh8SfJUJDKQ2HPwcKbdOzI2d93v5RM2x3+Pftd070fFodZ6aV9m+
         9cWwiYWtALt1P7p3DLVwV39/Be2UsUhhWZcVH89EVOj4Zq94+vWlpxSNi4cpaoHAHa
         3ylIpEFoen8cQ==
Date:   Thu, 27 Oct 2022 19:39:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/2] netlink: introduce NLA_POLICY_MAX_BE
Message-ID: <20221027193931.2adce94d@kernel.org>
In-Reply-To: <20221027233500.GA1915@breakpoint.cc>
References: <20220905100937.11459-1-fw@strlen.de>
        <20220905100937.11459-2-fw@strlen.de>
        <20221027133109.590bd74f@kernel.org>
        <2f528f1a320c55fdc7f3be55095c1f0eacee1032.camel@sipsolutions.net>
        <20221027233500.GA1915@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 01:35:00 +0200 Florian Westphal wrote:
> > In fact we could easily just have three extra types NLA_BE16, NLA_BE32
> > and NLA_BE64 types without even stealing a bit?  
> 
> Sure, I can make a patch if there is consensus that new types are the
> way to go.

The NLA_BE* idea seems appealing, but if the implementation gets
tedious either way works for me.
