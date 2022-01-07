Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474AE487BA2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348636AbiAGRsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiAGRsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:48:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040BFC061574;
        Fri,  7 Jan 2022 09:48:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2C9461752;
        Fri,  7 Jan 2022 17:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F97C36AE0;
        Fri,  7 Jan 2022 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641577718;
        bh=SsjFNCidoubLbPKEUTCypbD6/AK0PkAfB7rfFG1sTl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=pLNwa3rEnjJGM4+Cv4xTQ/Vhy4DhdmtgttX2GtAQhrLP3JZpMbl4jsUSy3+Z+Mr5D
         m4Y//jiDIO9wo0Nqz0fgPDR+iWfMotnl4X/m2NP4gA3WuzA3cZB/7w9nlu2Yr1lvd+
         WLdoi46UZu158PIcu3a8IdLKiP7A7wysTbHxTVJHj+2b8HpVebR/36/AwUq7Hf/SRn
         6YXbaVWMGYeSxyAe1m0D459w6Nt0M63v+10UU+QwpCodAtGLiK3m4ytE+Oy9dBQ18m
         LuR/QORCIuaWwhaGq4HRYjXPAxX7r/v1U3qACyJArK2JY3lP9SyLlsCmV77JWD4M01
         pVko+3LQ6+x9g==
Date:   Fri, 7 Jan 2022 11:48:36 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/8] PCI: add Fungible vendor ID to pci_ids.h
Message-ID: <20220107174836.GA388004@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107043612.21342-2-dmichail@fungible.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 08:36:05PM -0800, Dimitris Michailidis wrote:
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

If you repost this for any reason, please capitalize the subject line
so it matches the history, e.g.,

  3375590623e4 ("PCI: Add Zhaoxin Vendor ID")
  4460d68f0b2f ("PCI: Add Genesys Logic, Inc. Vendor ID")

> ---
>  include/linux/pci_ids.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 011f2f1ea5bb..c4299dbade98 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2578,6 +2578,8 @@
>  
>  #define PCI_VENDOR_ID_HYGON		0x1d94
>  
> +#define PCI_VENDOR_ID_FUNGIBLE		0x1dad
> +
>  #define PCI_VENDOR_ID_HXT		0x1dbf
>  
>  #define PCI_VENDOR_ID_TEKRAM		0x1de1
> -- 
> 2.25.1
> 
