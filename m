Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F386960D976
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 04:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiJZC7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 22:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiJZC7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 22:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0B09DDB1;
        Tue, 25 Oct 2022 19:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A83B61C5A;
        Wed, 26 Oct 2022 02:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60ACEC433C1;
        Wed, 26 Oct 2022 02:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753161;
        bh=vllgs2AG1tpKI1gg0HcH4n7qUUkQY3HHXYq8K7dTrPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JlCZLB/MPaRKUE4vvcIo/lC23QSE4ms+uuczeAQnf4Sx4SJyoXPASavQAjdRIQfBV
         hsHhkPm01VU84zuam4KpPK9NryIhXw9sD2o/woqfBKey6gLmiXhRmlGfKqboRmNZt9
         ZIly7wWkoCH+8hMUtm7T/uv/1eIjceuyz9b7BzUOiDrzfssL/SCdh4KCiqimI0SqVk
         UJBFH93FiRvucr9wk7rFnJIlY1HqjuE5nmyg90/kQiWH8V/EmF7eSuJx9D6S5vgNKq
         cq2rDzknKTYHWGbJTrfwE6YQmiyGR8JesAZIwTmHHX3aev4y5hY1/uzWihEFSjABPl
         +rsi8KTsrrMjA==
Date:   Tue, 25 Oct 2022 19:59:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: pull-request: ieee802154-next 2022-10-25
Message-ID: <20221025195920.68849bdd@kernel.org>
In-Reply-To: <20221025102029.534025-1-stefan@datenfreihafen.org>
References: <20221025102029.534025-1-stefan@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 12:20:29 +0200 Stefan Schmidt wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for *net-next*
> 
> One of the biggest cycles for ieee802154 in a long time. We are landing the
> first pieces of a big enhancements in managing PAN's. We might have another pull
> request ready for this cycle later on, but I want to get this one out first.
> 
> Miquel Raynal added support for sending frames synchronously as a dependency
> to handle MLME commands. Also introducing more filtering levels to match with
> the needs of a device when scanning or operating as a pan coordinator.
> To support development and testing the hwsim driver for ieee802154 was also
> enhanced for the new filtering levels and to update the PIB attributes.
> 
> Alexander Aring fixed quite a few bugs spotted during reviewing changes. He
> also added support for TRAC in the atusb driver to have better failure
> handling if the firmware provides the needed information.
> 
> Jilin Yuan fixed a comment with a repeated word in it.

nit: would you mind sorting these out before we pull ?

net/mac802154/util.c:27: warning: Function parameter or member 'hw' not described in 'ieee802154_wake_queue'
net/mac802154/util.c:27: warning: Excess function parameter 'local' description in 'ieee802154_wake_queue'
net/mac802154/util.c:53: warning: Function parameter or member 'hw' not described in 'ieee802154_stop_queue'
net/mac802154/util.c:53: warning: Excess function parameter 'local' description in 'ieee802154_stop_queue'
