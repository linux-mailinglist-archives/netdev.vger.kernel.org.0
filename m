Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408B26A14B3
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 02:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBXBxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 20:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBXBxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 20:53:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904F9CA28
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 17:53:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C7D7B8091C
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81A6C433EF;
        Fri, 24 Feb 2023 01:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677203584;
        bh=i32PYCmD1Y5F92yWcLS6OzgN2FHlaPee1dcNv08xTnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JGP6yo7T97io7Ozq2Fit9gE/iJacI/6AELEwCmvzZ9T3tB4Dqv5OB4bMmwlAif+ou
         4b8seibsw7NsJ5fqFiNrjTNJBrF+8uMeeYsiwtw7i2Is07Xaz4cuZRB1qINx81YXTb
         G5BfGIgkzr/fR0kpYFNXJHffQj5bzkpC/lUTWrcI1n5VpfWo6F4DEDvZ7nrx2hpoDw
         o1nr4GmbfXIjr/cY6Yt4XuzPT2X0FjHDt8dDntbh48vac19nvzjt134ee86EYpPhvN
         cAdyZP3v74yQRQJGX3U60ZRj26lniJQOjhdw4gp3RpAd4vs0mui0pYrf6TZuzlo/gT
         sNmGK9JRg00vw==
Date:   Thu, 23 Feb 2023 17:53:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH intel-net v2] ice: remove unnecessary CONFIG_ICE_GNSS
Message-ID: <20230223175302.2032b66e@kernel.org>
In-Reply-To: <20230224004627.2281371-1-jacob.e.keller@intel.com>
References: <20230224004627.2281371-1-jacob.e.keller@intel.com>
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

On Thu, 23 Feb 2023 16:46:27 -0800 Jacob Keller wrote:
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Fixes: c7ef8221ca7d ("ice: use GNSS subsystem instead of TTY")
> Cc: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Anthony Nguyen <anthony.l.nguyen@intel.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
