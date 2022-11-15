Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6287629045
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiKODAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237904AbiKOC7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 21:59:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BDE1D310
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 18:57:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A91CDB81677
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F7C433B5;
        Tue, 15 Nov 2022 02:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668481025;
        bh=nslhrH/fmUqMtQKRxqTztxpVHpa9/tH/05Kg+CEcu+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TldKbkHEWe/5h9bsX9c3+4b87WRN714Jj9INgrqMtlDDSThlMKbx2OaRljEfYCiys
         Ve5T0iP0/w1mD3aQMnKCyLo6Nub45ln4AAUTpleMqib5mELPZ48xJsRw5q3k5zcS8X
         1Vfd2e+VrPeWZIDFNfnBy6xv1KSHxGTFjSPqcFg+M6qNButdm1V2PRP2KbHaJQEzq9
         wgEErHlSbQFh7DOkv1C/VkxCT3Ce2U1gWkQxxwSUBzRujDhx2jXIxSOHb+q44QDonL
         z1WFIBmnRVNUg0Y4WrEzOeekbQQfJ9qJSUDGSm4ogHh0kIMY9qGzvudjYJB86I8Y6/
         WCyobYW45cT6A==
Date:   Mon, 14 Nov 2022 18:57:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221114185704.796b5c14@kernel.org>
In-Reply-To: <20221112203748.68995-1-netdev@kapio-technology.com>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
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

On Sat, 12 Nov 2022 21:37:46 +0100 Hans J. Schultz wrote:
> This patchset adds MAB [1] offload support in mv88e6xxx.
> 
> Patch #1: Fix a problem when reading the FID needed to get the VID.
> 
> Patch #2: The MAB implementation for mv88e6xxx.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a35ec8e38cdd1766f29924ca391a01de20163931

Vladimir, Ido, ack?
