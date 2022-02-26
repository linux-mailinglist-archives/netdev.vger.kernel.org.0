Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBC04C55F6
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 13:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiBZM5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 07:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiBZM5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 07:57:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F20B249136;
        Sat, 26 Feb 2022 04:56:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB31611C1;
        Sat, 26 Feb 2022 12:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C2FC340E8;
        Sat, 26 Feb 2022 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645880207;
        bh=ErmV24WkvOMnp37HiuWsv2j69OgPJxdDVLKwg5mrsoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1uocR33JVqwcXl9YbOUGIC7f3c2haGv8tdCN6Yhmjza30QGo7BuduXRvmVDVYmpFr
         IT6KDvp7EgwCM0sBjNjl4rpEe2ZDlGPqYmUAmjvXq19n3p25ks8MbvalhgRWYkxDN5
         XO5gi4kFAmFjJcgGDpey3yAIxeBlrDf/G7mTWFt8=
Date:   Sat, 26 Feb 2022 13:56:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
Message-ID: <YhojjHGp4EfsTpnG@kroah.com>
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
 <871qzpucyi.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qzpucyi.fsf@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 26, 2022 at 12:41:41PM +0200, Kalle Valo wrote:
> + jakub
> 
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> 
> > The firmware and the PDS files (= antenna configurations) are now a part of
> > the linux-firmware repository.
> >
> > All the issues have been fixed in staging tree. I think we are ready to get
> > out from the staging tree for the kernel 5.18.
> 
> [...]
> 
> >  rename Documentation/devicetree/bindings/{staging => }/net/wireless/silabs,wfx.yaml (98%)
> 
> I lost track, is this file acked by the DT maintainers now?
> 
> What I suggest is that we queue this for v5.19. After v5.18-rc1 is
> released I could create an immutable branch containing this one commit.
> Then I would merge the branch to wireless-next and Greg could merge it
> to the staging tree, that way we would minimise the chance of conflicts
> between trees.
> 
> Greg, what do you think? Would this work for you? IIRC we did the same
> with wilc1000 back in 2020 and I recall it went without hiccups.

That sounds great to me, let's plan on that happening after 5.18-rc1 is
out.

thanks,

greg k-h
