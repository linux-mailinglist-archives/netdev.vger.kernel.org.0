Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D0E69D7A4
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjBUApO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBUApN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:45:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6A01C7E3;
        Mon, 20 Feb 2023 16:45:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7164E60F63;
        Tue, 21 Feb 2023 00:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C2FC433D2;
        Tue, 21 Feb 2023 00:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940311;
        bh=js365+NNX7eRxBHYfPJgI3NbMTtPK9v4tu2hoT2fVVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J75vK2WKJVlxaaxbG+V/3je7BYzeaLLPH2+zUbiiaKbNpJOCJYiLEnJm1Vc7sDE4h
         aI1iAZwo01JkXK15/D9cezxTKKI0c4eRjQVQtBKqxNjqeZrk3qieY1uZd2AuCoq5Qn
         S0IgPL8+HQQQEB/Gc8zeKdMN8tsyuFYPvzw8G10OKCf2FtL5qbycM9xvD1CB22pX/l
         6YEja7lSGWRzVt41+itUjcnUTdenQX8ZkExwo32sBAlSlQZH5cDKLZrnqkJN5uT7MJ
         Cw+PVP2FsxY5++beFg3ffMFFejsKELiMk5ZEf3S8ODkr1fYrH5hgYSyFXMrZEy2vxB
         zkOmlsVjGTCJw==
Date:   Mon, 20 Feb 2023 16:45:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <michal.simek@xilinx.com>, <radhey.shyam.pandey@xilinx.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
        <harini.katakam@amd.com>, <git@amd.com>
Subject: Re: [PATCH net-next V6] dt-bindings: net: xlnx,axi-ethernet:
 convert bindings document to yaml
Message-ID: <20230220164510.14b14139@kernel.org>
In-Reply-To: <20230220122252.3575380-1-sarath.babu.naidu.gaddam@amd.com>
References: <20230220122252.3575380-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Feb 2023 17:52:52 +0530 Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.
