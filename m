Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBF85F57BE
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 17:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJEPow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 11:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiJEPoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 11:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9015411802;
        Wed,  5 Oct 2022 08:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8699C61728;
        Wed,  5 Oct 2022 15:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA089C433C1;
        Wed,  5 Oct 2022 15:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664984684;
        bh=o0JGcCrOPBtEAT5SvB2ymNerKwfOl8r6AZuOjzfOb4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rZNZ7v9qF2Demi+FSDLXIi3JcbcA5ut1QfdPtf0lvoCm19LutTgmf7wtD7bqONtmG
         K9X5fbrFd7mkaBB8Z0ihqzzIssix1DPDDk/VLJwFDZczpQf4lJb1D/nYI9n5e8AYzc
         tZfCl+ROV1O6N+puKEwhpBS0BQgCUr0q0ttJM5HD9LJ/C6kCE/wcKqZQWrlX6Wgzfn
         eXL6qRahi03j8Don4yv4mzM/wLOA1WxXmc0ntVtRHRyeaY6ednExGYTvnf4ySQhdVB
         q4PI8WTbL+r4zTUBX5eCJoUsfl/iLD5tfTaOxRsZM4syP8JLrrJn0/Z6vPW0I4+9KV
         kui6f1Ok0CYVg==
Date:   Wed, 5 Oct 2022 08:44:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Daniel Xu <dxu@dxuuu.xyz>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <20221005084442.48cb27f1@kernel.org>
In-Reply-To: <Yz1SSlzZQhVtl1oS@krava>
References: <20221003190545.6b7c7aba@kernel.org>
        <20221003214941.6f6ea10d@kernel.org>
        <YzvV0CFSi9KvXVlG@krava>
        <20221004072522.319cd826@kernel.org>
        <Yz1SSlzZQhVtl1oS@krava>
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

On Wed, 5 Oct 2022 11:45:46 +0200 Jiri Olsa wrote:
> On Tue, Oct 04, 2022 at 07:25:22AM -0700, Jakub Kicinski wrote:
> > On Tue, 4 Oct 2022 08:42:24 +0200 Jiri Olsa wrote:  
> > > I did not see that before, could you please share your config?  
> > 
> > allmodconfig  
> 
> I compiled linux-next with that and can't see that,
> any other hint (apart the old gcc) about your setup?

Hm, I was compiling Linus's tree not linux-next.
Let me try linux-next right now.

Did you use the 8.5 gcc (which I believe is what comes with 
CentOS Stream)?  I only see it there.
