Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F32666F04
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbjALKEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjALKB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:01:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4C4BE9;
        Thu, 12 Jan 2023 02:01:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9B01B81DFA;
        Thu, 12 Jan 2023 10:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA67DC433F0;
        Thu, 12 Jan 2023 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673517662;
        bh=ta1TXKart3YYPPYz0mR+WLhfw0PKz6L3SAs42cjv2ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVTX+opcOFix6jJXYjOtVpNC1w/w5RrTRcBPd1PdwvuRmrNckLUvbeNHutibNrjLY
         rzgfpybLkiqWPyiZk43uD6j0iMst9RY0NUq72yFDReiPA9rXBC4Gxoq9YRSffFi5R8
         LtEytBo5qnxz7xIFmfI1AHbOsEfSLhiUfArr1bZQ=
Date:   Thu, 12 Jan 2023 11:00:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: add vendor/device ID pair for Microsoft
 Devkit
Message-ID: <Y7/aW65pyGeebM/6@kroah.com>
References: <20230111133228.190801-1-andre.przywara@arm.com>
 <20230111213143.71f2ad7e@kernel.org>
 <87k01s6tkr.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k01s6tkr.fsf@miraculix.mork.no>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 09:33:08AM +0100, Bjørn Mork wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Wed, 11 Jan 2023 13:32:28 +0000 Andre Przywara wrote:
> >> The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
> >> Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
> >> machines, Microsoft uses a custom USB device ID.
> >> 
> >> Add the respective ID values to the driver. This makes Ethernet work on
> >> the MS Devkit device. The chip has been visually confirmed to be a
> >> RTL8153.
> >
> > Hm, we have a patch in net-next which reformats the entries:
> > ec51fbd1b8a2bca2948dede99c14ec63dc57ff6b
> >
> > Would you like this ID to be also added in stable? We could just 
> > apply it to net, and deal with the conflict locally. But if you 
> > don't care about older kernels then better if you rebase.
> 
> And now I started worrying about consequences of that reformatting...
> Maybe I didn't give this enough thought?

Just send a reformatting patch for stable as well.  I've taken patches
like that many times for other drivers/subsystems to make backports
trivial.

thanks,

greg k-h
