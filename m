Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EC66A21DC
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBXSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjBXSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:55:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E806D1B56B;
        Fri, 24 Feb 2023 10:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8009B81CFF;
        Fri, 24 Feb 2023 18:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B5C433EF;
        Fri, 24 Feb 2023 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677264955;
        bh=dSnt4vKkQeOjrjqKV+ktgoR48SmmbPpZVVm5iiB21Ek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MRvzvqV6ILQNAtqJ5WMSyAzgpoPClTeTJDIuuSxwCPOtbVfwhA2BDOtgYde6Oz8Q+
         WRSqWOcYGlvo942tCQUmybBFhPJV9o/SwR+CAv7vhNpzNc0doShXttX42MuHaHlhIx
         baR5uzOhlFxUe+r+8xMrRzVA4j8R3s8FYg2d99bXTq8AH+2OXl2e1LButlxu9O0BZL
         FFhSuKcvyDWKr2IJOKwHK4DKfrKj49H00KLcJhxXZfrIa1UZ1Stixp65F0vDE6Gh67
         bzJLkK7yBmoVKnQ1sUVGgaDpbLaol7139Sbn8fcwztGrMyhbG7+cjpjqi27vFQANRZ
         YGRBi8H0D+XZQ==
Date:   Fri, 24 Feb 2023 10:55:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] net: netlink: full range policy improvements
Message-ID: <20230224105550.7077a674@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20230224124553.94730-1-johannes@sipsolutions.net>
References: <20230224124553.94730-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 13:45:51 +0100 Johannes Berg wrote:
> Sending this as an RFC since we're in the middle of the merge window,
> and patches depend on an nl80211 patch that isn't in the tree yet.
> 
> But I think it's worthwhile doing this later.

LGTM, FWIW!
