Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94555823EE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiG0KND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiG0KNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178B91277B;
        Wed, 27 Jul 2022 03:13:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A806361857;
        Wed, 27 Jul 2022 10:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EE8C433C1;
        Wed, 27 Jul 2022 10:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658916780;
        bh=4szT5U15c5+9pTdV+xk+SkcAswRYUYjvXanNrRSXjLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RE+PBbEOhP0CeHMlY8YGwehdqsu5IszQRisiMX3YZqGlXVsnUEzZWpXcwVQDv6Hhu
         KKtL1pbtclRCw3o1eLOLor2njFE1B7PTNmSyvx0n5vtxeiHlgZWxq4QwG9NjBQnsIi
         lnIaew5JJHlOR2ZGT8DtkN2Yr2Wjdz48i3JYdYPk=
Date:   Wed, 27 Jul 2022 12:12:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Patch for 4.9 stable tree "net: usb: ax88179_178a needs
 FLAG_SEND_ZLP"
Message-ID: <YuEPqcmikE2Aau8F@kroah.com>
References: <4c11b3866f5dfc787fa477a6307096db9319c454.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c11b3866f5dfc787fa477a6307096db9319c454.camel@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 11:57:04PM -0300, Jose Alonso wrote:
> For 4.9 stable tree:
> --------------------

All backports now queued up, thanks.

greg k-h
