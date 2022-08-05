Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58FA58AFB7
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 20:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiHES0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 14:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiHES0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 14:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD886405;
        Fri,  5 Aug 2022 11:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59C2961990;
        Fri,  5 Aug 2022 18:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65407C433B5;
        Fri,  5 Aug 2022 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659724008;
        bh=gdb1iesT2gOLQt75hbwS/xJ5t2EsK69K+aF9s6eWF2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dL4b6P9Zl0qXto7n2eoz3en8v7s3C3462Ynvc1Ald5wFJqphfJZR8lgI7jQwx2lx8
         kuf28oFbHY03I2QNb85AHxpPoZjWjN0afQF2Ofs/rwxZaU1NW2GUx5r2j0s9TB9jpD
         RNYy4dZFAX99/LkzjjxAo1KiyhS4yv0XQP0JJ/0g=
Date:   Fri, 5 Aug 2022 20:26:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Subject: Re: [PATCH net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
Message-ID: <Yu1g5rjY9kkib1YV@kroah.com>
References: <dc920ea721a8846c49e7a8752e8d3209edd94f4e.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc920ea721a8846c49e7a8752e8d3209edd94f4e.camel@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 03:08:40PM -0300, Jose Alonso wrote:
> The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware versions
> that have no issues.
> 
> This patch is reverting 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
> because using FLAG_SEND_ZLP in this context is not safe.
> See:
> https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378

Please wrap (but not the url) at 72 columns like your editor asked you
to :)

> 
> reported by:
> Ronald Wahl <ronald.wahl@raritan.com>

Should be:

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>

> https://bugzilla.kernel.org/show_bug.cgi?id=216327
> https://bugs.archlinux.org/task/75491

Those should be "Link:" references.

And you need a cc: stable and/or a "Fixes:" tag please.

Also there is a normal template that 'git revert' gives you, why not use
that?

thanks,

greg k-h
