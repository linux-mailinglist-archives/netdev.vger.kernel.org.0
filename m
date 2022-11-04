Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C083618F4B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKDDy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiKDDy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:54:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669361901F;
        Thu,  3 Nov 2022 20:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17EA2B82B60;
        Fri,  4 Nov 2022 03:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD4EC433D6;
        Fri,  4 Nov 2022 03:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667534093;
        bh=cgk8bAGCXjLTHkp04F3M3kpC5CeHKGy0POfMeBP5xJE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V2zukL0zGIOtipmrzaVTryTfLf58o0EAuhaxZJYTtQWPX4uhkBRX/9Vf0iiPk4wab
         x7Obgs+Zp51C6rNXa5OKw5rT7n4EW8WB+j2SjoTtnRizDkCEVQ0XiisoKzUscXomch
         +vPoqRORXxgYsW/e1ozjbbnZUGLW1PVuFFeuQozvkWpKyqDC63FV+M/Ay1D2L+SR7v
         SYxHcVFIjJy77cALMlVsdQ+tQOMisf+AJ9YZy24NirLLIRRSrYND5OLDDNYZEBpMN+
         OipiOeV6c1EGzy0go6hMdAF/nlHr2kZiB5wNBj2YR5PO1J2nTPPEaj8nsdGYHbBqWj
         I4UBRul/bvk5w==
Date:   Thu, 3 Nov 2022 20:54:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <sgoutham@marvell.com>
Subject: Re: [net PATCH] octeontx2-pf: Fix SQE threshold checking
Message-ID: <20221103205452.6d58cbf9@kernel.org>
In-Reply-To: <20221102033240.1923677-1-rkannoth@marvell.com>
References: <20221102033240.1923677-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 09:02:40 +0530 Ratheesh Kannoth wrote:
> @@ -1599,7 +1600,6 @@ int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable)
>  	req->bpid_per_chan = 0;
>  #endif
>  
> -
>  	return otx2_sync_mbox_msg(&pfvf->mbox);
>  }
>  EXPORT_SYMBOL(otx2_nix_config_bp);

The patch looks good but we can't have spurious cleanups in fixes,
please repost without this chunk.
