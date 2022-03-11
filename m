Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA14D6ADF
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiCKWrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiCKWrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:47:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABEA2A556A;
        Fri, 11 Mar 2022 14:22:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C274B82D65;
        Fri, 11 Mar 2022 21:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04F0C340E9;
        Fri, 11 Mar 2022 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647032732;
        bh=rwZRetiCB1iMQt24hqu3DC9K4xI8O1XFeqKNAsJLCH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iq24VLHzEkTPAyrYpuWPSAkCAO/dmq9LZBGxymVqtKqe9945n6VbhGNFpChwC60MO
         4l6R7VefAH7JuWXKdwXlGcvYbR/15mTqdP/MSnLSSJQurBmBcC7zd/ydmrMwtZ25Ay
         fJIk5m/4vnLDZDaZgh9bzUewOZEmMUrDd9TinSG5zaSlHZGaRdkfJiEeG3SFrfh00l
         uSqfQtuqnoQdhb6+F23iEre74oR2f+0rXdrWwvJ7HmpxPiCJKyI33TYn8H/KJW2eBG
         maiFHps9QZ1Uh+9J26auYiE8mjdLBSjMeOdGyKtszFo2GSUL3eBXVMghJFY2Ivakdm
         wk64bGt0kMFSg==
Date:   Fri, 11 Mar 2022 13:05:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
Message-ID: <20220311130530.70d9faa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220311124029.213470-1-johannes@sipsolutions.net>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
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

On Fri, 11 Mar 2022 13:40:28 +0100 Johannes Berg wrote:
> Hi,
> 
> Here's another (almost certainly final for 5.8) set of
> patches for net-next.

5.18 ;)

> Note that there's a minor merge conflict - Stephen already
> noticed it and resolved it here:
> https://lore.kernel.org/linux-wireless/20220217110903.7f58acae@canb.auug.org.au/
> 
> I didn't resolve it explicitly by merging back since it's
> such a simple conflict, but let me know if you want me to
> do that (now or in the future).

Looks like commit e8e10a37c51c ("iwlwifi: acpi: move ppag code from mvm
to fw/acpi") uses spaces for indentation?
