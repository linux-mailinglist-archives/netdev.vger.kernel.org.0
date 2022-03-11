Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615964D6668
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349604AbiCKQf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiCKQf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:35:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79698157216
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:34:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35BB4B80EA4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9074C340E9;
        Fri, 11 Mar 2022 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647016462;
        bh=ZX39Xm30qu9T44plVWXo0u/KrbWvZMd6Jmm2G1x8m6c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sg7PalUBqh+pfkDy5H1OOGzn8Qhp+TY264mZijs+bTFGuJ1L2WaIcZPNsSZ0GZdfu
         OJlfYlnDZpmTrqf9i14lNrcrzGmmFOA2cp4Kt1bs8LHhNonMjEsoDhpeAdUdDp7mDx
         15w15xXL3P5HnDxdfIi5Iw6hz7pXCjp+gnIDuSwL/qsDv1XUoVgNPzchvqKEbjT4lh
         cHx6aPTtGi5FASa/9jpNzkQ1UgvE8gZCbY/hk4jCs4uK5QXa7ktCivK6aW+sF7Iq9p
         8bxeUmswz5irJi5EfskNR7ruHhCJ81ypK04HTifCLg3jLS6YtdtpFfZqkifEwX8R9E
         4mm9HoDhczi1A==
Date:   Fri, 11 Mar 2022 08:34:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     idosch@nvidia.com, petrm@nvidia.com, netdev@vger.kernel.org,
        leonro@nvidia.com, jiri@resnulli.us
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and
 simplify port splitting
Message-ID: <20220311083420.487bbba6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YispFfBergpOXltY@corigine.com>
References: <20220310001632.470337-1-kuba@kernel.org>
        <YispFfBergpOXltY@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 11:48:53 +0100 Simon Horman wrote:
> Thanks Jakub,
> 
> this looks like a nice improvement :)
> 
> We have exercised this patch-set on NFP-based NICs and have not observed
> any regressions.

Awesome, thanks a lot for testing! :)
