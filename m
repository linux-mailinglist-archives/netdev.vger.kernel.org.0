Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A69D4EB7F8
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbiC3Bva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiC3Bva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8E61163;
        Tue, 29 Mar 2022 18:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7137C61328;
        Wed, 30 Mar 2022 01:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED46C340ED;
        Wed, 30 Mar 2022 01:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648604985;
        bh=pD+OuaMoyfzVLYMupUlBOgRVp5jcLwA38LsyPhemrK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iglSqGD6EWjp7mKzN6Ig6XQWmJm63/XyohPc923H5i2f2lUkRfz3OAw8awG4p4i39
         0b93687qZXqRrlZEicL7XfHVlCKzP0wWYXGXiOSrf3BUm1CZH8H6B2q+ymmXiSX4lL
         xa463FEIDr140chqc2UrimsJRCHM9bU+Jgai8RH9FmYTNmcRT10kWBpbNUbfXAFGmx
         NsJKqVhhtiTfx8ysuFdxWTn0zz/9YxxZCx+La5EgPjwHV+mXhf8zV76rfn2pmiQTu9
         +5T1IYlh1PlQ8Y1kj+mKW+kQCjiju4Bt5GitX12kRH9/S/jNT7yCgJY6CjCeSrD43k
         F30tTeEbjOwww==
Date:   Tue, 29 Mar 2022 18:49:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] sctp: count singleton chunks in assoc user stats
Message-ID: <20220329184944.2cfac27b@kernel.org>
In-Reply-To: <c2abe2f2ba779cbb453e65a7ddae1654baa17623.1648595611.git.jamie.bainbridge@gmail.com>
References: <c2abe2f2ba779cbb453e65a7ddae1654baa17623.1648595611.git.jamie.bainbridge@gmail.com>
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

On Wed, 30 Mar 2022 09:13:42 +1000 Jamie Bainbridge wrote:
> Fixes: 196d67593439 ("sctp: Add support to per-association
> statistics via a new SCTP_GET_ASSOC_STATS call")
> 
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>

The Fixes tag should not be line-wrapped, and there should be no
empty line before the Fixes tag and the sign-off (or between any 
tags, really). Please fix and repost once more.
