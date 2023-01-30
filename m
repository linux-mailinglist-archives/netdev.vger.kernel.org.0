Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89215680C0B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbjA3Lch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbjA3Lc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:32:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196373346A;
        Mon, 30 Jan 2023 03:32:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E72B80F9F;
        Mon, 30 Jan 2023 11:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B96C433D2;
        Mon, 30 Jan 2023 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675078346;
        bh=6XI6zgRYqIg/bSErmwXqT/Itie5Q/+BahKbvCx4Lfnk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kj7K/X7zUsazsx7bq3reSvtouS+BNiIaBE6hZQ8+J63BCn1pf6aCTUlQ45JAR2CjK
         JX3epKmZnnYPAAL2LcxOBVEB485sJfux0JsOGGqZbsf+8LMjce585BktNy0w33NQ1z
         gYUczvy48oIiZ2JkljjnNpxDDnfmm7HPPWpBLA98=
Date:   Mon, 30 Jan 2023 12:32:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nick black <dankamongmen@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: add rx_otherhost_dropped stat entry
Message-ID: <Y9eqxxeC+WrLmSf5@kroah.com>
References: <20230130112919.273446-1-dankamongmen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130112919.273446-1-dankamongmen@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 06:29:20AM -0500, nick black wrote:
> Add the sysfs export for rx_otherhost_dropped, added
> in 794c24e9921f32ded4422833a990ccf11dc3c00e
> ("rx_otherhost_dropped to core_stats").

Please read the kernel documentation for how to properly refer to a
commit in the tree.

But more importantly, this changelog does not describe why this is
needed, or even what this is doing at all.

And if it's a sysfs file you are adding, where is the Documentation/ABI/
entry?

Also, why me?  I'm not the maintainer of this file :)

thanks,

greg k-h
