Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D63575264
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbiGNQFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiGNQFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6401023162;
        Thu, 14 Jul 2022 09:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0280261FD7;
        Thu, 14 Jul 2022 16:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB89C3411C;
        Thu, 14 Jul 2022 16:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657814709;
        bh=FGElCCXjvgdL/db7AgDojqXt2q/LMKeFmfNSRiC1OFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AvPxNW1ADkZ0OHFOVTzkNIKRqWK9ODGiIXXC6zIkvM+VeBGw+dnpTG8QwTIp0sw6s
         N2sHvP/ftilL13SFKMgZBMkM/XZxroFkPWL4CCthdxUMbwos6jwdRBQanpUsXt6vp+
         RomG3q4NSgGQo6TE0bAApUH/hXl84uGJ93TZ6OimfydzT3YYWsW9OFZmGPIGDL+Dup
         yh6HB5Zn7Z468YzPlcxAG3hSS/ca5j2Ly1b/OGDetSN4mifxGcPzw+zlBIrXu/IogL
         6HE4lN1sVxCiXRlmMyS4V3ealA2+KI2LdKjNYkWucf79gxPeEnMhEcCSu0EAMYNgAf
         FBYlXKLizs4vw==
Date:   Thu, 14 Jul 2022 09:05:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <20220714090500.356846ea@kernel.org>
In-Reply-To: <Ys/+vCNAfh/AKuJv@gmail.com>
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
        <20220707155500.GA305857@bhelgaas>
        <Yswn7p+OWODbT7AR@gmail.com>
        <20220711114806.2724b349@kernel.org>
        <Ys6E4fvoufokIFqk@gmail.com>
        <20220713114804.11c7517e@kernel.org>
        <Ys/+vCNAfh/AKuJv@gmail.com>
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

On Thu, 14 Jul 2022 12:32:12 +0100 Martin Habets wrote:
> > Okay. Indeed, we could easily bolt something onto devlink, I'd think
> > but I don't know the space enough to push for one solution over
> > another. 
> > 
> > Please try to document the problem and the solution... somewhere, tho.
> > Otherwise the chances that the next vendor with this problem follows
> > the same approach fall from low to none.  
> 
> Yeah, good point. The obvious thing would be to create a
>  Documentation/networking/device_drivers/ethernet/sfc/sfc/rst
> Is that generic enough for other vendors to find out, or there a better place?

Documentation/vdpa.rst ? I don't see any kernel level notes on
implementing vDPA perhaps virt folks can suggest something.
I don't think people would be looking into driver-specific docs
when trying to implement an interface, so sfc is not a great option
IMHO.

> I can do a follow-up patch for this.

Let's make it part of the same series.
