Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F1528CD0
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbiEPSWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiEPSWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:22:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D392D1E6
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6E4612FD
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50672C385AA;
        Mon, 16 May 2022 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652725359;
        bh=+o6GMQuyqS1Zer9MG+e26QDA3qpA6xWk4JR6kEnjG9w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mEfitIUvU+QpJeYZLxCR0gWSqY6gZ6YqO682HF+2T8KWtB4idCdMv5wA4+R3UjoTV
         hbsI3ED1djYYAbNwKNmQZgZlJaotJeLeGr75K3aBnuxsKu9Uv0ua6+GKidGwC/Z8jx
         J3b9FDgGySxEQrgnmQ1spnswDtQopzLHysQEa9OP+c4KSeG03ym3fFW4caoA/Tk2Rp
         by6u3T8NVfUwB8fX6HUXGoJ0x2OAIZwd7LSE0NCEUILgpt2zbjNO8/JHd7cvLzokLe
         VoChxVXMFI5paC5eB/GIvKUz9iR/XFiUfkHoGlWZsvtEGjIKuNyvVaGTlyxEYpubtM
         fATpwyCIjo0Ew==
Date:   Mon, 16 May 2022 11:22:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <gakula@marvell.com>, <Sunil.Goutham@cavium.com>,
        <hkelam@marvell.com>, <colin.king@intel.com>,
        <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH V2] octeontx2-pf: Add support for adaptive
 interrupt coalescing
Message-ID: <20220516112238.2ca48916@kernel.org>
In-Reply-To: <20220516044614.731395-1-sumang@marvell.com>
References: <20220516044614.731395-1-sumang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 10:16:14 +0530 Suman Ghosh wrote:
> Added support for adaptive IRQ coalescing. It uses net_dim
> algorithm to find the suitable delay/IRQ count based on the
> current packet rate.
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

Can you share uname -r of the kernel you're testing this on?
