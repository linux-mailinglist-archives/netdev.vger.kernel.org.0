Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011AF5FDE46
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJMQce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJMQce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:32:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BBB10F8A2
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 234FEB81DEE
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 16:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6531DC433D6;
        Thu, 13 Oct 2022 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665678749;
        bh=6ImRUimXPX0tU7zNgRMr2rZlgQ+CB1OkiGrwhzOo6jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IrUIkk0zHObtTVobfNbTyXCJ+wgX1MBU1gh9RZRazSEnpjSV+rEmI0Zanr+VKzJyi
         V35gbULHqRyRsmt995ZYVzA5pLinvZK9PfddN/i4kD4I0GSKSF2TxICZLmStMMRFVW
         hOBjt1ndrYD28iowAKxQctF0IxX8wlkjNHw73UHBNbMEKR/sZUrE8YGpQRlN9QNr4U
         zWMWux01phTM58NbVK12quZfjVHcEqXcrVMZOAKI/4gG+RMgTKUoEMTFP33h2BzKc1
         vAhdLA/PHT+ExGr9gljVYnyMLyQJV9sGIfCP74u2M4A6dcbUnXHgmurA55p4f2frAY
         7oKdgFVJveUAA==
Date:   Thu, 13 Oct 2022 09:32:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     edward.cree@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        marcelo.leitner@gmail.com, Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <20221013093228.607a9eee@kernel.org>
In-Reply-To: <873a9e2e933cd811a72f9a06cc97e9f014bc94cd.camel@sipsolutions.net>
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
        <26c2cf2e699de83905e2c21491b71af0e34d00d8.1665567166.git.ecree.xilinx@gmail.com>
        <20221013082913.0719721e@kernel.org>
        <873a9e2e933cd811a72f9a06cc97e9f014bc94cd.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Oct 2022 18:16:47 +0200 Johannes Berg wrote:
> If you worry about the strings (and sizes) then you probably shouldn't
> advocate always having __FILE__ and __func__ ;-)

To be clear I meant to pass those as arguments to a common format
string. Are you saying just using them will bloat the binary?
Oh well, I guess :(
