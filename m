Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B41666AE9
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbjALFnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbjALFm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:42:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C92FCFC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F08C6B81DD4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADDEC433EF;
        Thu, 12 Jan 2023 05:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673502175;
        bh=UKG47D/0BaNASY2bPV0r0qUYHxd8tGa4Xe5fFKkkoCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lx6BEsgG8SHDSHj6j90R2w6TqEqjd2/qPjnEA+4ff44ZZq8f7CiHXGI/EnFmYP6Vp
         apzsmaZz3dWMo88nZFSGZi44jVV7BSjWw4uWCqH7Q8JYkP4LW+Q7MpEGz66jOdKaKO
         oZMK+BjMdUK7ugRmgF8n+p8dSSEvxtX1I8aPuxjw5oigUXJrY81iBn+GciANSn/gtm
         2OvqLO7kPMLkgz8yfnHHuTlj7CpP73dp+nvmGZbEo4B5s4o81HjgE8fH4QPVMqnFD1
         dUEMqwiB2r1zW3tz7DBQQcT2zUtp3436g3h0cpHc51MbHwtU2/igW2lIx29HtDWsME
         ODMzGEofovASg==
Date:   Wed, 11 Jan 2023 21:42:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <Shyam-sundar.S-k@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH net 0/2] amd-xgbe: PFC and KR-Training fixes
Message-ID: <20230111214254.4e5644a4@kernel.org>
In-Reply-To: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
References: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
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

On Wed, 11 Jan 2023 22:58:50 +0530 Raju Rangoju wrote:
> 0001 - There is difference in the TX Flow Control registers (TFCR)
> between the revisions of the hardware. Update the driver to use the
> TFCR based on the reported version of the hardware.
> 
> 0002 - AN restart triggered during KR training not only aborts the KR
> training process but also move the HW to unstable state. Add the
> necessary changes to fix kr-taining.

Please err on the side of CCing people. Here the patches under Fixes
have Tom's sign off which makes our automation complain that he's not
CCed. No tag from him either.
