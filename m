Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788C44B5398
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355283AbiBNOnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:43:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355284AbiBNOnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:43:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AE64BFD8;
        Mon, 14 Feb 2022 06:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3138DB8101C;
        Mon, 14 Feb 2022 14:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5394EC340E9;
        Mon, 14 Feb 2022 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644849820;
        bh=15gbK0UgikMlWQdpbVsPePpAzv+diNwGJtXcoXJx8Jc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUvZty3chOBysfPJbS4rjaZEiWfERMbqldaS3sq06UCEMZsIrr6KASthzabkyoIUF
         OaPxOR/vQLbK89okLqTKlg7Dj4KnqctME8cC0dMzK74Esc5fY5HmL9XNmXawSx8riT
         6zxAX0FipxSa+jgidMg9uq/VVvCEeykCV262NY+Q=
Date:   Mon, 14 Feb 2022 15:43:37 +0100
From:   Greg KH <gregKH@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Ross Maynard <bids.7405@bigpond.com>
Subject: Re: [PATCHv3] USB: zaurus: support another broken Zaurus
Message-ID: <YgpqmZy2k/99n96d@kroah.com>
References: <20220214140818.26600-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214140818.26600-1-oneukum@suse.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 03:08:18PM +0100, Oliver Neukum wrote:
> This SL-6000 says Direct Line, not Ethernet
> 
> v2: added Reporter and Link
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: Ross Maynard <bids.7405@bigpond.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215361

Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
