Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFFB4C19F7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbiBWRkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240243AbiBWRkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024EF2705
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE09B8211C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7255C340E7;
        Wed, 23 Feb 2022 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645638012;
        bh=jcbqWXBbp+urdrrrbc/nVjXje/KKuf5zjDSvMj1PerI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JogTLNMcZgaSFyCVMvmHoHrvov0xE9GLn5ABXaBP9L1P15W8TS1RCgSza4Q9ANL5h
         gjh9ZYTpsPkT1YDhae0Ukq9jWc8xxlawRhblInXAaJQZYUYaMl/1niyU/IJqrD9r1b
         qs8C3ic5xMZsafD8fQ0F1BBk0xGuSiDUaG3MiUxRqN+6cXXgorAFzr61auLmsUwT1j
         I42R81VhOd5rluYSShBlu3PPB5BclgUzh0eMV1CyuEM9Ay3PfgW8Nans6LWYc2sNPl
         ICgUK3ffKF5Gt8udozjuuTFa/n8YwBCQLGystnLchG9y/zK7bSqjotWPUr77IAhjIq
         WKO+GJDEvkSkA==
Date:   Wed, 23 Feb 2022 09:40:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, hawk@kernel.org, saeed@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com
Subject: Re: [net-next v6 1/2] page_pool: Add page_pool stats
Message-ID: <20220223094010.326b0a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALALjgwqLhTe8zFPugbW7XcMqnhRTKevv-zuVY+CWOjSYTLQRQ@mail.gmail.com>
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
        <1645574424-60857-2-git-send-email-jdamato@fastly.com>
        <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
        <CALALjgwqLhTe8zFPugbW7XcMqnhRTKevv-zuVY+CWOjSYTLQRQ@mail.gmail.com>
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

On Wed, 23 Feb 2022 09:05:06 -0800 Joe Damato wrote:
> Are the cache-line placement and per-cpu designations the only
> remaining issues with this change?

page_pool_get_stats() has no callers as is, I'm not sure how we can
merge it in current form. 

Maybe I'm missing bigger picture or some former discussion.
