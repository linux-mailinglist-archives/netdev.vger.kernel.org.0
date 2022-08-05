Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BDA58ABAB
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 15:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiHENcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 09:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiHENcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 09:32:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC473F30E;
        Fri,  5 Aug 2022 06:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64F28B828C9;
        Fri,  5 Aug 2022 13:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C9FC433C1;
        Fri,  5 Aug 2022 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659706337;
        bh=IsQfq6P7Lg2XjHtu5LieMWsw0VBQmAmkXwoxo+RRUH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KVS0qJ2Y7xpTWRbM9cOq86E8DUTfPbP8quKJtJWCoDWboGbdspvDk2Qq34IEjDdIr
         0OnYitpHISKxMCsAW4PRsLufmBm7sKbCXPlT5Bov8i2Dz37uY0nRXx4yqLXmrdCij0
         xcus4xfXzXq/n2c6RjFsyh6LuNtSuvhYCcoYnvAE=
Date:   Fri, 5 Aug 2022 15:32:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Subject: Re: [revert PATCH net stable-tree] net: usb: ax88179_178a needs
 FLAG_SEND_ZLP
Message-ID: <Yu0b314PsAlSXxoL@kroah.com>
References: <3da70b16068fdda4607b364cc8fb5c70579f778b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3da70b16068fdda4607b364cc8fb5c70579f778b.camel@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 10:11:18AM -0300, Jose Alonso wrote:
> Please revert the commits.
> 
> The usage of FLAG_SEND_ZLP cause problems with other firmware/hardware
> versions that have no issues.
> 
> The patch needs reworking because using FLAG_SEND_ZLP in this context is not safe.
> 
> See:
> https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
> 
> reported by:
> Ronald Wahl <ronald.wahl@raritan.com>
> https://bugzilla.kernel.org/show_bug.cgi?id=216327
> https://bugs.archlinux.org/task/75491
> 
> Signed-off-by: Jose Alonso <joalonsof@gmail.com>

Please send a patch that does the revert, there's not much we can just
do with this type of report.

thanks,

greg k-h
