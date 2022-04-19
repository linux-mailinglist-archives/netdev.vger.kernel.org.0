Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5965A506421
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 08:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiDSGFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 02:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiDSGFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 02:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3D12DA8D;
        Mon, 18 Apr 2022 23:02:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E707161326;
        Tue, 19 Apr 2022 06:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E466C385AA;
        Tue, 19 Apr 2022 06:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650348171;
        bh=kdG4M4WrEhJjgI9i8hRCmSVOeeMxsvC6h/Fcjl+xWgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yGD2xVeG5i3JmEfueiGEJjM+z8AZ0EISwyLALNdp+n+Cdva+XbwnRIdfzyCn07S8z
         PU3U7TrlZGz2/UOI3sa2gQp3ih548zr5RXEo3MXmF54jSmDe2VGqIw5+B0X3tLbypE
         lvpe1AEqyRbb/LefRUH3Xb8g9SiwbR6LRUC2e9FE=
Date:   Tue, 19 Apr 2022 08:02:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Solomon Tan <solomonbstoner@protonmail.ch>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rdunlap@infradead.org,
        miriam.rachel.korenblit@intel.com, johannes.berg@intel.com,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        kvalo@kernel.org, luciano.coelho@intel.com
Subject: Re: [PATCH 0/3] iwlwifi: Address whitespace coding style errors
Message-ID: <Yl5QhzP75YB0K470@kroah.com>
References: <20220419011340.14954-1-solomonbstoner@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419011340.14954-1-solomonbstoner@protonmail.ch>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:14:20AM +0000, Solomon Tan wrote:
> This series of three patches addresses the whitespace coding style
> errors marked by checkpatch.pl as an "ERROR". In order of sequence,
> the following edits are made:
> 1. Removal of prohibited spaces
> 2. Addition of required space
> 3. Replacement of space with tabs as code indent.
> 
> Signed-off-by: Solomon Tan <solomonbstoner@protonmail.ch>
> 

No need to ever sign off on a 0/X email.

Also, not all of these were threaded properly, and are you sure that
coding style "fixes" like these are welcome for this part of the kernel?
I recommend starting out in drivers/staging/ first to learn the process
before going anywhere else.

And finally, why cc: me at all?  I am not a wireless developer :)

good luck!

greg k-h
