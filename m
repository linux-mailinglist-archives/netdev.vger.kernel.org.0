Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC786608A2
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjAFVMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbjAFVMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:12:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBD0736E8
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:12:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4CA761F7D
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 21:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3586C433D2;
        Fri,  6 Jan 2023 21:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673039536;
        bh=4jGKulgMymK4yuSpDvl2mPFyWUSdjmHIMwjB2voPjfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C6+1v4qeCKwRklfqaD0t/0vdGQ7fiV9yhKGkFruClJRPPOY3Z3nzG9KWR6CnBFpy0
         z1WIKqOgzqn7zgcKPdFlE+wv2Xi+EdU0Sx5CCItdUGsGEsRJG3jGSr/E+E2RQ9VCpe
         EbJu0DqUnXuf0dTmGF3jSr5Sl8rRcDMpyOqvIa1FbRim2S9GGLtJ3GHxAVMAdBwGFf
         E7PMQK6l3EW6kmZ3Mn3gdxunCHEqdbvjafaRmxhjLVIjboWXGXTNd2ihqUrfpO9xtN
         N1qZQSj9ftntBwgyqC3/vh8sjGeoOBM1pzszCFu4yifctMNlZbhwnpd9CO5Ys51F3j
         zfaNj4qOFLi1Q==
Date:   Fri, 6 Jan 2023 13:12:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <20230106131214.79abb95c@kernel.org>
In-Reply-To: <Y7fiRHoucfua+Erz@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-14-kuba@kernel.org>
        <Y7WuWd2jfifQ3E8A@nanopsycho>
        <20230104194604.545646c5@kernel.org>
        <Y7aSPuRPQxxQKQGN@nanopsycho>
        <20230105102437.0d2bf14e@kernel.org>
        <Y7fiRHoucfua+Erz@nanopsycho>
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

On Fri, 6 Jan 2023 09:56:36 +0100 Jiri Pirko wrote:
>> Oh, just the "it" at the end? Sorry, I don't see the point.  
> 
> The point is simple. Ops is a struct of callback by name X. If someone
> implements this ops struct, it is nice to assign the callbacks functions
> of name y_X so it is obvious from the first sight, what the function
> is related to.
> 
> I'm not sure what's wrong about having this sort of consistency. I
> believe that you as a maintainer should rather enforce it than to be
> against it. Am I missing something?

IMO you have a tendency to form names by concatenating adjacent
information rather than reflecting on what matters to the reader.
I believe the low readability of the devlink code is sufficient 
evidence to disagree with that direction.
