Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0DF6D180E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjCaHEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjCaHEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:04:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471741287A;
        Fri, 31 Mar 2023 00:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B571B623DB;
        Fri, 31 Mar 2023 07:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2649C433EF;
        Fri, 31 Mar 2023 07:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680246258;
        bh=PYv7G/JmT/Gc/Y1YyWLWV64SIhGDqKdAn7gQpNDA+Ns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hlwD5XEj/jkDer6k1vhP5m32/gDFw/SppN6Samg+2pVeWd45ozFZwSiyZ4xrOa35r
         V1uTSps+nuw5laWwPoOP+fKn6oLhcmY5Sf6V0KvvzTzwGn/VtVM+qr476kqTCzmYg4
         omNic+e9tf0lnIAS+h4/lIW2K7yjr3bdBj2K9LZM=
Date:   Fri, 31 Mar 2023 09:04:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mISDN: remove unneeded mISDN_class_release()
Message-ID: <ZCaF73pUr_aVsARz@kroah.com>
References: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
 <20230330231739.14ead816@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330231739.14ead816@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:17:39PM -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 08:01:27 +0200 Greg Kroah-Hartman wrote:
> > Note: I would like to take this through the driver-core tree as I have
> > later struct class cleanups that depend on this change being made to the
> > tree if that's ok with the maintainer of this file.
> 
> It must be on top of .owner removal? Cause it doesn't apply for us:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Ah, yeah, it is, that's in my tree already.

thanks for the ack!

greg k-h
