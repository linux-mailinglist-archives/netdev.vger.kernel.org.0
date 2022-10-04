Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EDC5F3A58
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiJDAIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiJDAIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:08:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA0F5AE;
        Mon,  3 Oct 2022 17:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 778FCCE0F7F;
        Tue,  4 Oct 2022 00:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3DDC433C1;
        Tue,  4 Oct 2022 00:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664842126;
        bh=YNqwNduPcb5thmEiOwSsCHdrAP2D+Xzxs6/sckI4nI8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mQi4ybdpjq2Vt0bvLT682IVB4ICnquisO8ekuTRRQ4XG3kXB34jKCKngUOyH2F9XK
         Z4c/QxaQlNsgMgT1kHuzKJMFRS3nn5HMtBTobnPebEEES6+yXCJQbPtrQQY6rF7DoZ
         ETqzD+VDJOh8QD7Tz63C1BUlh1dNX4YhEmO1wJhUREx5vAb5aqEPPLPG7Brn/z1mtE
         1k7ia8ECHD9KdLbmbSIimnwBDJhCI7mYnTiEU1QMGXG4ZyFXg/0H/q1VZZHXtwC0ty
         7GJgzoojgtpkrazTSai+GNNZm8FKfuTKsx5c/OhTrq76EBRoKGCochLYmLoO0sxo2H
         bvVf/hvi9iTkQ==
Date:   Mon, 3 Oct 2022 17:08:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
Message-ID: <20221003170845.1fec4353@kernel.org>
In-Reply-To: <20221003063130.17782-1-Divya.Koppera@microchip.com>
References: <20221003063130.17782-1-Divya.Koppera@microchip.com>
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

On Mon, 3 Oct 2022 12:01:30 +0530 Divya Koppera wrote:
> FIELD_GET() must only be used with a mask that is a compile-time
> constant. Mark the functions as __always_inline to avoid the problem.
> 
> Fixes: 21b688dabecb6a ("net: phy: micrel: Cable Diag feature for lan8814 phy")

Does not apply cleanly to net, please rebase & resend.
