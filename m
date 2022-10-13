Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7A45FDE42
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJMQ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJMQ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:29:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1114144E14;
        Thu, 13 Oct 2022 09:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CC83B81F73;
        Thu, 13 Oct 2022 16:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B56DC433C1;
        Thu, 13 Oct 2022 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665678550;
        bh=X4ydEZ3OMc9zoR6cYYvRZzP14NONb0zzDRztPWYSzSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CyNaJCy7pCyIBbcMfIEn9Bx/9drOb8aVDoghCbhUhNemlVZ0eBt3lp1nCLMfMWHb5
         7+ZD5XPZx8fe9pVSafD0eZkI6HgI4lIO8DqtnNI/e6U6eFSZNg05+Vfpp8E1b1+/tv
         R+iC1umdkZiqGhBuVQ/89TjVp/B0rpPojFaV+VH95DVF1sAnfexJ56+yyjIN0uso1F
         mWwqOnwJ0CDR5yUDNHkO4ODU1iLyZqMkmiceXyxPsFqWRanizYNAVluwkr66Ba3R3u
         Hk66V1LBnA/7JcZeUiU1Nm1OQfvL2taQU6Ex2zzMT+hCWs4fRjW62yWZJypeejNkov
         o8ulD1JlIPVSQ==
Date:   Thu, 13 Oct 2022 09:29:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-2022-10-13
Message-ID: <20221013092909.2a15c52e@kernel.org>
In-Reply-To: <e012c43378b21fe9a9753d3d1a1f550df8de60a0.camel@sipsolutions.net>
References: <20221013100522.46346-1-johannes@sipsolutions.net>
        <20221013083254.5d302a5e@kernel.org>
        <e012c43378b21fe9a9753d3d1a1f550df8de60a0.camel@sipsolutions.net>
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

On Thu, 13 Oct 2022 18:13:00 +0200 Johannes Berg wrote:
> FWIW, it's harmless, but we do need to silence the sparse warning. I'll
> add a follow-up patch for our next pull request, unless you want it
> quickly, then I can send it to you directly?

Next PR is perfectly fine, I reckon.
