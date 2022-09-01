Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBC25AA09F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbiIAUFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 16:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbiIAUFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 16:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02475F981;
        Thu,  1 Sep 2022 13:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5686361EAE;
        Thu,  1 Sep 2022 20:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD45C433D6;
        Thu,  1 Sep 2022 20:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662062730;
        bh=5r4jBptDpX0GOnn49bfo1sovLH5zW/naowLeGSe9hpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QoK2Cfzy+S+TwZ2LS+FvCahk5/6IjMGWbTxYPS6Ltf+cp4fA6qo5mN1KRIxi+Ib7F
         4oINgkKhEcgqGPNoCl8Xmee0PoyNKt21k3XrgbYQPXuyIYUWUEr+gWxvVtupSxgZ0v
         bUOWm6kBRg6seqOxrNklanVGiKgedkBVAiNvC9sMzePOaO7cQH9N35ys2PhGdNXjKF
         Lm2uOQUqOQcKljdBUTmWiW0jsjG/UuF+lGT0hPCS/1e6+5YkZOv0rdiM3ZTKdvzo+r
         LJSHdv+AJu9hmaklVpNUSUv7nZpoOJvMPPXtwUyeBCs2gNWswe/ETC8Ows5tPPeR/X
         DOHdOwoyYWuCw==
Date:   Thu, 1 Sep 2022 13:05:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: sort .gitignore file
Message-ID: <20220901130529.2f364617@kernel.org>
In-Reply-To: <fe9280ff-50b3-805a-07ef-0227cbec13e8@tessares.net>
References: <20220829184748.1535580-1-axelrasmussen@google.com>
        <fe9280ff-50b3-805a-07ef-0227cbec13e8@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Sep 2022 12:15:02 +0200 Matthieu Baerts wrote:
> Hello,
> 
> On 29/08/2022 20:47, Axel Rasmussen wrote:
> > This is the result of `sort tools/testing/selftests/net/.gitignore`, but
> > preserving the comment at the top.  
> 
> FYI, we got a small conflict (as expected by Jakub) when merging -net in
> net-next in the MPTCP tree due to this patch applied in -net:
> 
>   5a3a59981027 ("selftests: net: sort .gitignore file")
> 
> and these ones from net-next:
> 
>   c35ecb95c448 ("selftests/net: Add test for timing a bind request to a
> port with a populated bhash entry")
>   1be9ac87a75a ("selftests/net: Add sk_bind_sendto_listen and
> sk_connect_zero_addr")
> 
> The conflict has been resolved on our side[1] and the resolution we
> suggest is attached to this email: new entries have been added in the
> list respecting the alphabetical order.

Yup, that was my plan as well. Apologies for the trouble, I thought
since the conflict will only exist for a day I'd be the only one
suffering.

I think we should also sort the Makefile FWIW.
Perhaps it's better done during the merge window.

> I'm sharing this thinking it can help others but if it only creates
> noise, please tell me! :-)

> [1] https://github.com/multipath-tcp/mptcp_net-next/commit/4151695b70b6

It is useful, thanks!
