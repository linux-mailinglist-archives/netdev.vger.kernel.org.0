Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3629D64ABCA
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiLLXtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiLLXte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:49:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B452A959B
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:49:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E93D61277
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A2C433F0;
        Mon, 12 Dec 2022 23:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670888972;
        bh=ORV4KQ45g8ddn0p3gDoqfFEntHmTWcgpJkxXxKrN2+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZHtLAcj5W5QBw8rJGZyhzUPFPN5euNZmLeqCKC6cGFFZnR8nZIevBdz8UeWHlp5Hc
         /fUof3aD50aorod4shTfmT37bP2rtsnCCcYDRZ0d33n/4saQaqEJ98JSz5MZbYNjkp
         C9BUhFf02H7fZYT5o5HsyWW+laki3aF2qDhxJIjh1mW2hDV4H1QnbqG1p+DuiMu9qB
         xr7DXLojh33AUh4NvVOmQbuO96GncdRIOleDhHReEF9B/3lanNveeiLkuchn0y5uRF
         QLeKCaxoZfHUrPhhNUlDvSXNIO8yxKYZV2YQ+4WRK/7Iu/xU1dkLNNvXjzZfroRDSj
         2r3mQrSn8qh4A==
Date:   Mon, 12 Dec 2022 15:49:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v5] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <20221212154931.3066376f@kernel.org>
In-Reply-To: <20221212104152.40082-1-mengyuanlou@net-swift.com>
References: <20221212104152.40082-1-mengyuanlou@net-swift.com>
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

On Mon, 12 Dec 2022 18:41:52 +0800 Mengyuan Lou wrote:
> Add mdio bus register for ngbe.
> The internal phy and external phy need to be handled separately.
> Add phy changed event detection.

v6.1 has been tagged upstream, so for the next two weeks (until 6.2-rc1
is pushed by Linus) we will only be accepting fixes. Please repost in
two weeks or so. (You can keep posting as RFC in the meantime if you
want to get the code reviewed and ready for merging.)
