Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC78667062
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbjALLBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjALLAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:00:41 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE15D32255;
        Thu, 12 Jan 2023 02:51:41 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0BD0AD7;
        Thu, 12 Jan 2023 02:52:23 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FF183F67D;
        Thu, 12 Jan 2023 02:51:40 -0800 (PST)
Date:   Thu, 12 Jan 2023 10:51:37 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] r8152: add vendor/device ID pair for Microsoft
 Devkit
Message-ID: <20230112105137.7b09e70b@donnerap.cambridge.arm.com>
In-Reply-To: <20230111213143.71f2ad7e@kernel.org>
References: <20230111133228.190801-1-andre.przywara@arm.com>
        <20230111213143.71f2ad7e@kernel.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 21:31:43 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

Hi,

> On Wed, 11 Jan 2023 13:32:28 +0000 Andre Przywara wrote:
> > The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
> > Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
> > machines, Microsoft uses a custom USB device ID.
> > 
> > Add the respective ID values to the driver. This makes Ethernet work on
> > the MS Devkit device. The chip has been visually confirmed to be a
> > RTL8153.  
> 
> Hm, we have a patch in net-next which reformats the entries:
> ec51fbd1b8a2bca2948dede99c14ec63dc57ff6b
> 
> Would you like this ID to be also added in stable? We could just 
> apply it to net, and deal with the conflict locally. But if you 
> don't care about older kernels then better if you rebase.

Stable would be nice, but only to v6.1. I think I don't care
about older kernels.
So what about if I resend this one here, based on top of the reformat
patch, with a:
Cc: <stable@vger.kernel.org> # 6.1.x
line in there, and then reply to the email that the automatic backport
failed, with a tailored patch for v6.1?
Alternatively I can send an explicit stable backport email once this one
is merged.

Cheers,
Andre


