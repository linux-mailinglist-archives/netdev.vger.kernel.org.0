Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C278C5A0732
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiHYCPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHYCPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:15:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC17313D40;
        Wed, 24 Aug 2022 19:15:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 833FF61291;
        Thu, 25 Aug 2022 02:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92571C433C1;
        Thu, 25 Aug 2022 02:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661393701;
        bh=A2LwdsRQetDCq00t+zA9apj32d3XRA5ilI4BwEv6Azc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYkQ6pLQsuzAtL6iUtZQsgr2IMdGy5nx8huo2j49bMa+pnY4j1G2wpeNuK0ea74sZ
         Q6AOut81OLmnnXDgDeCRNUazbO5RiBkCJcRKY9Yz+gFhL19K2Dv/M5CbUikhfYAgR5
         LIyGoZ+cHLr1zc7trZapC+OOsTb3DWFsHskI4F7IWUb3OpaFzjcdUSpHiABBUdk0fP
         LaZEFTUcZHfsMzZT/HQFjyqIE7a0ilWdbIvMsuopaVzLkA4ZeTnOs95CmA0vjko5vu
         wDWtRQy2txHl5Ho2g7Oxp1fMLWE24e8mlHyTEml0AiFvVxnmYdij5/JdSpY3v1O9h0
         G4diXNSSIhjBQ==
Date:   Wed, 24 Aug 2022 19:15:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: taprio vs. wireless/mac80211
Message-ID: <20220824191500.6f4e3fb7@kernel.org>
In-Reply-To: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
References: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
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

On Wed, 24 Aug 2022 23:50:18 +0200 Johannes Berg wrote:
> Anyone have recommendations what we should do?

Likely lack of sleep or intelligence on my side but I could not grok
from the email what the stacking is, and what the goal is.

Are you putting taprio inside mac80211, or leaving it at the netdev
layer but taking the fq/codel out?
