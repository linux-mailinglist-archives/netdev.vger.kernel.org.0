Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418486448E2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiLFQLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbiLFQLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD9431239;
        Tue,  6 Dec 2022 08:06:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A661617C5;
        Tue,  6 Dec 2022 16:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23122C433D6;
        Tue,  6 Dec 2022 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670342762;
        bh=C0bx6vi/gRXjNXUOZ9nMGq7EzykYTJEDdg6PGsAeyk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zeKA7DMgG1d/yunOh6MGw4FDadG2X3PvUjexzRCP2P02OIvnUqANVxbhzg4W6hF/I
         aCYcdPR/CtqjYr5iYggxIfx50fFe56+A7zjj8eTAsuomSN2iCG2zaELyFjvYpJBdGs
         /XRvyjXADoBY/BxfLfdhhT4ul5jiYQDnPwHrvdHo=
Date:   Tue, 6 Dec 2022 17:06:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, Radu Pirea <radu-nicolae.pirea@nxp.com>
Subject: Re: [PATCH] net: dsa: sja1105: fix slab-out-of-bounds in
 sja1105_setup
Message-ID: <Y49oaMcgstaa+l5G@kroah.com>
References: <20221206151136.802344-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206151136.802344-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:11:36PM +0200, Radu Nicolae Pirea (OSS) wrote:
> From: Radu Pirea <radu-nicolae.pirea@nxp.com>
> 
> Fix slab-out-of-bounds in sja1105_setup.
> 
> Kernel log:

<snip>

This log doesn't say much, sorry.  Please read the kernel documentation
for how to write a good changelog text and how to submit a patch to the
stable trees (hint, this isn't how...)

thanks,

greg k-h
