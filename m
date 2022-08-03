Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069B358869B
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 06:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbiHCEo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 00:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiHCEoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 00:44:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130815466A;
        Tue,  2 Aug 2022 21:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A892AB82121;
        Wed,  3 Aug 2022 04:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17747C433D6;
        Wed,  3 Aug 2022 04:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659501861;
        bh=qNhAjkWChYcsU7/MOSqPHejwDx/8CxVQxhg1mDnne/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T9gdpg0JgQVftFbTzc6T4CNznlJHxRNpb4xq29L7BTalMysulr6gX7ENWJzgBsua/
         GWdkagVjqJrnTEj1s2Ce99OkER0Qs4jmXyocPA9ExGucH08da+KLiBhEKdZ3YbFD+Z
         N+mApMVhLCq27tzhZTe+cQwuYvaKirKPnQOT3DRT8VhpazchEcA2RuE0UAuTnKBbj1
         /9bJfuxoBTOeRMaJyIk5MR5Y9fsi3OBvfeLL3225c4N21OYmhMoeqPfSo76BQCqm0l
         c6F3Ezcss4okYCsBkeE9s+hUaBN0it+COkKm0jvuQGk7AK/L4RSvlRZvsS/iz79Egn
         VSVqyuy1Fnsqw==
Date:   Tue, 2 Aug 2022 21:44:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <richardcochran@gmail.com>
Cc:     Naveen Mamindlapalli <naveenm@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
Subject: Re: [net-next PATCH v2 0/4] Add PTP support for CN10K silicon
Message-ID: <20220802214420.10e3750f@kernel.org>
In-Reply-To: <20220802121439.4d784f47@kernel.org>
References: <20220730115758.16787-1-naveenm@marvell.com>
        <20220802121439.4d784f47@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 12:14:39 -0700 Jakub Kicinski wrote:
> On Sat, 30 Jul 2022 17:27:54 +0530 Naveen Mamindlapalli wrote:
> > This patchset adds PTP support for CN10K silicon, specifically
> > to workaround few hardware issues and to add 1-step mode.  
> 
> Hi Richard, any thoughts on this one? We have to make a go/no-go
> decision on it for 6.0.

Oh, well. These will have to wait until after the merge window then :(
