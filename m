Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DFF573C5E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiGMSNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGMSNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:13:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E883F26D0;
        Wed, 13 Jul 2022 11:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DDB261D5A;
        Wed, 13 Jul 2022 18:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE7AC34114;
        Wed, 13 Jul 2022 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657736015;
        bh=AaUsNxQggnzWiPVjpjcMAaRJhu9wrjZVpBIyOLXibdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FmIP6/Bd1FekydgfeyGeC1VUHDXWXSm9fS2zdhigJsfsvYez65GrU5wLQRmrsYcNt
         CrPpF0CYU4HvAJbZPiSYcvU0fLa1dKmkV7MEq3geWPAUl4G6xtJNPfkgn7lBs9qFsf
         XFUA9omvashJleu4rPueQPtadxAlov49n/KV1Z9XefMcV0auAdzvY+Eu7wRMxTu30n
         6rMqhZdxwJXZz5fCqlKq6GmZsS+bsTxQ5jRZSYJiG+qlfkmfDU8u+DV1EPgBhIpKN3
         0PnFLpfbsXOxhIAbceYECa4yzq6NkPYiC/b+uIfseluL5J/kc+OqROWtHzPq3ng0lN
         yqJLvBE9s0Yfw==
Date:   Wed, 13 Jul 2022 11:13:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] selftests/net: test nexthop without gw
Message-ID: <20220713111333.4ffd9f19@kernel.org>
In-Reply-To: <c4eccb16-3b45-1644-d4b0-ee3fee3810d9@6wind.com>
References: <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
        <20220712095545.10947-1-nicolas.dichtel@6wind.com>
        <20220712095545.10947-2-nicolas.dichtel@6wind.com>
        <Ys1JefI+co1IFda4@kroah.com>
        <20220712172515.126dc119@kernel.org>
        <c4eccb16-3b45-1644-d4b0-ee3fee3810d9@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 09:36:37 +0200 Nicolas Dichtel wrote:
> > And please don't resend your patches in reply to the previous version.
> > Add a lore link to the previous version in the commit message if you
> > want. In-reply-to breaks the review ordering for us :/  
> Oh ok, I didn't know that.

Yeah, I haven't documented it because it's a bit of an oddity 
and frankly a shortcoming of the tooling on my side. But IDK
how to "detach" the threads in a way that'd allow me to keep 
a queue sorted by posting data :(
