Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E53525834
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359431AbiELXXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359444AbiELXXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:23:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D16E1D6750;
        Thu, 12 May 2022 16:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B09960F5D;
        Thu, 12 May 2022 23:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A167C385B8;
        Thu, 12 May 2022 23:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652397816;
        bh=1+VKeKmeev1IPlg54X6Ohnlzj3mt4SWjDIWp2UZ8ZYo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FA1sjBTUgB8e/ET0IAKIpJMhlUsNa7YIlaMA9o/UTKyLGHBzs1HgM7rwapg4zRl+n
         vkcB7Kokd0u7vw+rHli0ndid/ODTu7B0wRs5x/31yvfqvaV5KmJGe/14blXoWCy36g
         cQCGJdYU/CFaXbbseoWbqZSUOAMLQPKUXOwoPwSD7vCyvucQp4AKJjdnhG8dEcD4Vj
         5sIZWaPI0RLOrSDPDP+eAaibaYHEzRvbjyKttowFfYtaXZsS/qRjMp+kmryeb4maGn
         ZEc2swUI4xU8iq7RQ/DqZGczO8GKTQ6tBw8bIsDU7OSvHPE2NGjYxlle3DMO88Wse+
         WEC0OoIyi2ibw==
Date:   Thu, 12 May 2022 16:23:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        davem@davemloft.net, edumazet@google.com
Subject: Re: [PATCH] net: tulip: convert to devres
Message-ID: <20220512162334.6e669feb@kernel.org>
In-Reply-To: <2240900.ElGaqSPkdT@daneel.sf-tec.de>
References: <2240900.ElGaqSPkdT@daneel.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 23:57:30 +0200 Rolf Eike Beer wrote:
> Works fine on my HP C3600:
> 
> [  274.452394] tulip0: no phy info, aborting mtable build
> [  274.499041] tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
> [  274.750691] net eth0: Digital DS21142/43 Tulip rev 65 at MMIO 0xf4008000, 00:30:6e:08:7d:21, IRQ 17
> [  283.104520] net eth0: Setting full-duplex based on MII#1 link partner capability of c1e1
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

Does not apply cleanly any more since the fix came in thru net.
Please rebase / repost.
