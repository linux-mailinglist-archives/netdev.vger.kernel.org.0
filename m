Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00F84E30C7
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352693AbiCUT3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352683AbiCUT3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:29:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AC9B44;
        Mon, 21 Mar 2022 12:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 964B1B819C2;
        Mon, 21 Mar 2022 19:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F53C340E8;
        Mon, 21 Mar 2022 19:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647890890;
        bh=2DJ2Ykmemas9uAd8SgNaZWXrO/X4eO+ejMl3uWdMH7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fwnb1bdv9WmgMmHlUZAq7N+pYfeOf8Vf1ZMuH9E+LkaMXbYXekCBVrWevSq+mGE6Z
         aPmXdfDFeyCDlpB4iMpFIkjIlg7RgLouMpEjTMVMAH8R3HgoWss6/CXRApfZsASQ//
         gkfsDDyCxgLmMik4ljcMDYT8T/SDG55wjdOZDP5Wku6fxBXHmj40p/HdmEqSv/8B53
         /323YNGreXoK17wUsFqE9HkpVFLp7QK3NKzvKrIFa2iK5fpbyb00ASrMkF4e1rlC5G
         rm8aUmZqys2mUXJVwtGMnxC/G52rndWfV6TuC/wtEmh0MkwxEgXfPx9EgyjfRHfChL
         a3uzxx/FxH1tQ==
Date:   Mon, 21 Mar 2022 12:28:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     <davem@davemloft.net>, <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [net-next PATCH v4 1/7] octeon_ep: Add driver framework and
 device initialization
Message-ID: <20220321122808.427d7872@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220321055337.4488-2-vburru@marvell.com>
References: <20220321055337.4488-1-vburru@marvell.com>
        <20220321055337.4488-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Mar 2022 22:53:31 -0700 Veerasenareddy Burru wrote:
> Add driver framework and device setup and initialization for Octeon
> PCI Endpoint NIC.
> 
> Add implementation to load module, initilaize, register network device,
> cleanup and unload module.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> Signed-off-by: Satananda Burla <sburla@marvell.com>

Clang says:

drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c:51:19: warning: unused function 'octep_ctrl_mbox_circq_inc' [-Wunused-function]
static inline u32 octep_ctrl_mbox_circq_inc(u32 index, u32 mask)
                  ^
drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c:56:19: warning: unused function 'octep_ctrl_mbox_circq_space' [-Wunused-function]
static inline u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 mask)
                  ^
drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c:61:19: warning: unused function 'octep_ctrl_mbox_circq_depth' [-Wunused-function]
static inline u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 mask)
                  ^

Please don't use static inlines in C files, static is enough for 
the compiler to do a reasonable job.

Please fix and repost in 2 weeks we're currently in the merge window
so networking trees are not accepting new drivers.

Thanks.
