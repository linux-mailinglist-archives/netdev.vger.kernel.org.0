Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4100160675B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiJTR4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJTR4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:56:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765381D3C50
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 10:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FF7FB828D6
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 17:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D3DC433D6;
        Thu, 20 Oct 2022 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666288589;
        bh=e2J0EPLMAcSKC2UNmzxb14KcfVIctUO8VUMct3XnSc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c3eYEaPs9IJxJjH9Kwix+wyxLpiYz+kk8179zMR6UI/zTIsMLaX8j9eWIyIGWV4/i
         AX4lPGPuAb8lBwE0mVW4PNWRCWFnGD9uOuse7OUmY5S3xmr5mncazCRaP9INEJ2v2D
         SvI/icufsIwhtLvBUnJm1g96Lplk7TzyFjy4Xv8T2FAVYg/ZBkHePxyJcw1i3lRPGr
         h/yGBVpK02p4PWah60z0e49HGCkOg2jH9QnUUbUjX45khIWNLYi4xOW9YY22sTUH3T
         3dT0rfDakj688U91jMhE+tZCKAmuGu4F8MOqxUxUsDofdnQye2sHhqi+QmEOcCTUXq
         F2u3J9cmtUAMQ==
Date:   Thu, 20 Oct 2022 10:56:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net] MAINTAINERS: add keyword match on PTP
Message-ID: <20221020105628.184765b0@kernel.org>
In-Reply-To: <Y1DmxBUCOYpWn5GY@unreal>
References: <20221020021913.1203867-1-kuba@kernel.org>
        <Y1Dh8kFNicjxzNHn@unreal>
        <Y1DmxBUCOYpWn5GY@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Oct 2022 09:12:20 +0300 Leon Romanovsky wrote:
> > Should I try it differently?  

I think these are supposed to be Perl regexps:

	K: *Content regex* (perl extended) pattern match in a patch or file.

IOW try grep -P rather than grep -E.

> And maybe "K: ptp" will be even better.

That may be too wide, for instance it matches PPTP :(
