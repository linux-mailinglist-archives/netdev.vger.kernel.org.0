Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0399D6D17B1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCaGoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjCaGoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8868B191C3;
        Thu, 30 Mar 2023 23:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B876224E;
        Fri, 31 Mar 2023 06:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25125C433D2;
        Fri, 31 Mar 2023 06:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680245043;
        bh=Dg8+XeLoNg8oV3/BvnrqBJhqLomBFX+0yu2Jt4UxMOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fc5V+7jjhRjCZsX/T9nP2fPj+sgDvjk2/DJiQt6gz2thRgYEK50i3pCK+Xr8FtVRO
         NDOXFHmdEOUw6kGSDVQiZ90Mk5UX+jrOjAmO1Rv2CMQzp56ETbQobTajlk2uzsJ5ul
         pfIN5myZsfZWgvxf2YB+L+SYExUF27DXPNs0xVi+juKLr9Kt7Pnr1B2TI7Sg+6oUYZ
         ZLWbfk6wBzqIUhdH8YJ4m1Fg1NKdp7XDmCIkbOb022+Q7kpleZ0pF0y4EzCb0QShjn
         05HTYWFnTbM2DJtNHH431qZ7gNMxaXTAAYucw8DKiwa5/08eWKbcz/Fw+9zPi4JhME
         XNeErKa65TpLw==
Date:   Thu, 30 Mar 2023 23:44:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] netfilter updates for net-next
Message-ID: <20230330234402.0c618493@kernel.org>
In-Reply-To: <20230330202928.28705-1-fw@strlen.de>
References: <20230330202928.28705-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 22:29:24 +0200 Florian Westphal wrote:
> are available in the Git repository at:
> 
>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next 

Could you resend with a https link and a signed tag? :(
