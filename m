Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62175F46C7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJDPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJDPeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:34:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CBB647CF;
        Tue,  4 Oct 2022 08:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86DB6614CD;
        Tue,  4 Oct 2022 15:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF544C433C1;
        Tue,  4 Oct 2022 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664897656;
        bh=yQrBIXU89mMolDamqhxF5HiqkK2P6npnDnaoce55Pgg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VbQEfSSxXd3DoiUODajVkQz+bNltZx4y/fjeHqhyR5hNj0M0qpP0j/It1/L5EUGv8
         rhuRiV7YqksuN9F4cn2GA5u1hPQ0V/BG4HeARnsqPp39YHqJuCjWW4soocYyfsCUil
         od2F5ko4+57+bGrBwW9n8ARp3oJxS+BivWInD3GPtHNzJRxOQHZh7BP4ZcrNlYVvQf
         KHsPWZOd4wA1UEem7YJ2BZ42GPZoy5Z9MfSZsqJ+IP/fh0NqJIZHGDmUO9xi0DY18h
         XWzNPqu0clwyUhCTECc8duszK/Pmu8b3znWEJGSGhbb1SY/OK5RcpJPgz9si4eFBM0
         aABYQjfh62VEg==
Date:   Tue, 4 Oct 2022 08:34:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <20221004083415.00de247f@kernel.org>
In-Reply-To: <20221004144603.obymbke3oarhgnnz@kashmir.localdomain>
References: <20221003190545.6b7c7aba@kernel.org>
        <20221003214941.6f6ea10d@kernel.org>
        <20221004144603.obymbke3oarhgnnz@kashmir.localdomain>
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

On Tue, 4 Oct 2022 08:46:03 -0600 Daniel Xu wrote:
> > WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using 92168
> > WARN: multiple IDs found for 'nf_conn': 92168, 121226 - using 92168  
> 
> I believe this is now-fixed pahole bug. See:
> https://lore.kernel.org/bpf/20220907023559.22juhtyl3qh2gsym@kashmir.localdomain/
> 
> That being said, I didn't manage to find a pahole commit that directly
> addresses the issue, so maybe upgrading pahole perturbed enough things
> for this warning to go away?
> 
> If the warning is back on pahole master I can take another look.

From-the-source pahole fixes it, thanks!
