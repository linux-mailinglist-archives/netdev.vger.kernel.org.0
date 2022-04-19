Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D84250706F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350617AbiDSO0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353233AbiDSOZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:25:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16CF2A70F;
        Tue, 19 Apr 2022 07:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DDDCB819F8;
        Tue, 19 Apr 2022 14:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F073C385A7;
        Tue, 19 Apr 2022 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650378192;
        bh=aiGxtGTp5nyHVHRV0EjWzCJvj9vEOik/M83Lyow6xjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DnV5WZABRCdtuCroViG594OvUepodUEFfE61uzImopUDDqfSHeqcUPVlFt8WYzTk3
         AHVGdEoooWjY6s5IkIvRk4Pq5Uhc3aLfDN3cdcj22nBaIvGJDlkAA8p/GK9YKU1IoD
         OWE0bJYSp3VVTaCiDNPdVjzScm7Df+IY02cejh72dy3BEybAb/1hYLQtv4FRnbf3tn
         yyQAwa0k5OS3xZgRj3BxB1IoRb0YGiAqllCZoLPAQVvy6O/qPQTBi9xLd2H4mvtk1c
         fG8Q/g/CLoaGNabaLNUFe+7vKJeB6HSAA7KK5/+pS/RvC4oNPItrSb95utwVmsKNBv
         1xRqeEcvZChvA==
Date:   Tue, 19 Apr 2022 09:23:10 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next] PCI: add Corigine vendor ID into pci_ids.h
Message-ID: <20220419142310.GA1197793@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650362568-11119-1-git-send-email-yinjun.zhang@corigine.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 06:02:48PM +0800, Yinjun Zhang wrote:
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I'd be happy to apply this, but since I'm in the cc: line, I assume it
will be applied with other patches that use this.  Let me know if
otherwise.

I see that you also added the ID at
https://pci-ids.ucw.cz/read/PC/1da8; thank you for that!  

But it looks like the "name" part isn't quite correct -- at
https://pci-ids.ucw.cz/read/PC?restrict=1, "Corigine" isn't shown, so
I think lspci won't show the right thing yet.

> ---
>  include/linux/pci_ids.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 0178823ce8c2..6d12b6d71c61 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2568,6 +2568,8 @@
>  
>  #define PCI_VENDOR_ID_HYGON		0x1d94
>  
> +#define PCI_VENDOR_ID_CORIGINE		0x1da8
> +
>  #define PCI_VENDOR_ID_FUNGIBLE		0x1dad
>  
>  #define PCI_VENDOR_ID_HXT		0x1dbf
> -- 
> 1.8.3.1
> 
