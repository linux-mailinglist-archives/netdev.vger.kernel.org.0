Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED785FDD37
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJMPcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJMPcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:32:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8CA38681;
        Thu, 13 Oct 2022 08:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17C55B81ECC;
        Thu, 13 Oct 2022 15:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F4CC433D6;
        Thu, 13 Oct 2022 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665675125;
        bh=rHpwPOsp0EIb1Ksg7tMaB49yF9SyZndLpZaM2gxL33g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KDh45mWywPWMhlRevvmNR6iv2gac+EvS8IFBNGMnsd9nkmpZYFa4akcWBbJAFkszj
         uNVNLVPVXOTuuKWuGt4ah9wEV8WGPtcTbrhcxxTJ3GNyw8fpsHx29GYCorIIZ170eR
         Z4edw3Tk3rdBVSbp7AyHm9uEc8adCUKDGSJRogTuTnGcsHB890jwcAl0tCIOCwiA0J
         ZuQo6SI1yMORyPDEQKEPcmNtJxaCZcd9cK1byW+gjqkMlrmgiQ2bAGkqIHmWZtFa8A
         b9Lq8hXVWCf5rXJjqPVYEJbK8iDYI+abp4s1ZSWSPryINhVo4laWOj5pZgj+8pbMzC
         T3/pR2739oIvg==
Date:   Thu, 13 Oct 2022 08:32:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-2022-10-13
Message-ID: <20221013083204.41c28a6e@kernel.org>
In-Reply-To: <20221013100522.46346-1-johannes@sipsolutions.net>
References: <20221013100522.46346-1-johannes@sipsolutions.net>
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

On Thu, 13 Oct 2022 12:04:51 +0200 Johannes Berg wrote:
> So as discussed previously, here are the fixes for the
> scan parsing issues. I had to create a merge commit to
> keep the stable commit IDs that we'd already used for
> communication.
> 
> Please pull and let me know if there's any problem.

Odd, bot doesn't want to reply. Paolo pulled this a few hours ago FWIW.
