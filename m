Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F6766A389
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjAMTmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjAMTlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:41:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E390088DF4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 11:40:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8825DB821CB
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A117CC433D2;
        Fri, 13 Jan 2023 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638831;
        bh=iFZmCH9dEwfXvKLExyE3ZEjDmjvSj/bRPrHmWQrGCcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lC65TpRgwAsjCFLaMvABrsfupxxbvouAaDmlF0f7GkablXC8axLdkSULsTR0GNk22
         gsbISixwEunMzkqVRhpGAqo3n+6PYNn/IvF3E+e+SlUjY5nyzBn9l36nN088KFZVrA
         iyBsCUq6jdPayTw4r3+8IdEzQxnpDcsy0hNXcCza2KiURYNQqMnjQb+hwY4BNuFEJi
         gP0N4N6vnYfn7C2dLdMqOoZ1mMSQvbVNpP2MkpaXBXodHBgUvdt0WAKUr6rv1oduxx
         XcOEYtXKAimXeTSJE56cS7pTGPIb4ENC4EiXCrfWxLfcpbX6YeyJ3kKmqFWDEEDHi2
         BWgQM3C2579Ww==
Date:   Fri, 13 Jan 2023 11:40:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net] ethtool:add netlink attr in rss get reply only if
 value is not null
Message-ID: <20230113114029.0ed9f618@kernel.org>
In-Reply-To: <20230111235607.85509-1-sudheer.mogilappagari@intel.com>
References: <20230111235607.85509-1-sudheer.mogilappagari@intel.com>
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

On Wed, 11 Jan 2023 15:56:07 -0800 Sudheer Mogilappagari wrote:
> Current code for RSS_GET ethtool command includes netlink attributes
> in reply message to user space even if they are null. Added checks
> to include netlink attribute in reply message only if a value is
> received from driver. Drivers might return null for RSS indirection
> table or hash key. Instead of including attributes with empty value
> in the reply message, add netlink attribute only if there is content.
> 
> Fixes: 7112a04664bf ("ethtool: add netlink based get rss support")
> Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>

Applied, thanks!
