Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF829562B77
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbiGAGUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiGAGU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:20:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F81403D0;
        Thu, 30 Jun 2022 23:19:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F218B82CF1;
        Fri,  1 Jul 2022 06:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC75AC341C7;
        Fri,  1 Jul 2022 06:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656656386;
        bh=+ViaVJjWMpMpS1nB1R8boXMVZzW7PnN47NlVUdux/Qs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FYnFEIP+ZAp/8faLIuDA8tKBNstJfBdzoGrifTrHBSWQmSTsCzBZCw3TAUvb52ajA
         FOzuikauP7tGvM23v+WcdcjLYKkiJl7M9J0Ss/R09lW25v2DGv7QBrKaeU6MneXKwE
         XkOkXkT5DK4EQ6wzvR0jJf+wQo2XpvuVuNwgQbZ0=
Date:   Fri, 1 Jul 2022 08:19:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: Fix typo in code
Message-ID: <Yr6R/wsl+HlOwOEm@kroah.com>
References: <20220701020751.3059-1-kunyu@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701020751.3059-1-kunyu@nfschina.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:07:51AM +0800, Li kunyu wrote:
> hasdata does not need to be initialized to zero. It will be assigned a
> value in the following judgment conditions.
> Remove the repeated ';' from code.

That is a lot of different things all in the same commit.  Please break
this up into one-change-per-commit like is required.

You also do something in here that you do not document :(

thanks,

greg k-h
