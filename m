Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82C84B3255
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354514AbiBLBK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:10:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiBLBK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:10:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA66D5C;
        Fri, 11 Feb 2022 17:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17A9A61CC2;
        Sat, 12 Feb 2022 01:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C21FC340E9;
        Sat, 12 Feb 2022 01:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644628254;
        bh=kqcOMOsxjbbgsBPbRm53qHDnqoQSTMf7ix9oeKkKXhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nARPpw94twCbhOWdXeX0XF/E5hpCSCfJyiET1/fJN0BNXV9WVIfLXsruPkuX34Rfy
         jZKz0iCMsU2LpMetEIYECR2MMTX3Ill5o1WK2xHmHXbDEfIDcZzpJXIB4nC2927Jnr
         YNRCCCsgV2dt55zAjfsJ86k5O3XubxbsCOHPbWetnwF432TxdeA4Es7V63n4nbdhp4
         jf0CR3vr+VAk7nYq9e6qITxmlyMNMORRwSnksk+gYVDFoq9Dzlxx5AJUzF8HMYETne
         3kXqGkzl3995A/J2MVQhJpfCjEowaBQAUHljnQxCCoFwxSKsoQ1+R3FjzWzeXMQpEl
         e2vOur9Du0zWQ==
Date:   Fri, 11 Feb 2022 17:10:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: Re: [net-next PATCH V2] octeontx2-af: fix array bound error
Message-ID: <20220211171053.5044fa8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211155539.13931-1-hkelam@marvell.com>
References: <20220211155539.13931-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Feb 2022 21:25:39 +0530 Hariprasad Kelam wrote:
> This patch fixes below error by using proper data type.
> 
> drivers/net/ethernet/marvell/octeontx2/af/rpm.c: In function
> 'rpm_cfg_pfc_quanta_thresh':
> include/linux/find.h:40:23: error: array subscript 'long unsigned
> int[0]' is partly outside array bounds of 'u16[1]' {aka 'short unsigned
> int[1]'} [-Werror=array-bounds]
>    40 |                 val = *addr & GENMASK(size - 1, offset);
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Applied, tnx!
