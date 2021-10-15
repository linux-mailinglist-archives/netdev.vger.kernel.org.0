Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0378E42E6CC
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhJOCtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232214AbhJOCty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4D066058D;
        Fri, 15 Oct 2021 02:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634266069;
        bh=dLW/K3saCOQF8/JZgMDs33SAQB+ux4qQ4wODXNlR9cY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UFoiSn14jAm5Z9jeo80DDVcV99i84VkTbBGCOIOMZCXNH2zRG2xkuUQM8Mazr2Uls
         4e+SL4H7toUOcEXIxgxhS4jJnmK9zSHhsSigRkEaVu1EC05MkCbKS8DN6hITQT3wxS
         uyrwJ6MfUmCLdkJea7vFz9fyNPx7p1Okr7vtgrBt7oDiI9rk2iybnmZnvqONF2U3mI
         UD6EnCsJqRC4P+tn42mZTzB6AwGNcsi9WqEodzL52bdu6H7uCtO2FRTgo6TT7FT25N
         aODcCB5YR9v63+H3YxBmFZQ3CwFjbDMGTELjJk/sBuOT3kgagNn1s/q3eCmuON63Dh
         C2x6djkZSfdLA==
Date:   Thu, 14 Oct 2021 19:47:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, youri.querry_1@nxp.com, leoyang.li@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] soc: fsl: dpio: extract the QBMAN clock
 frequency from the attributes
Message-ID: <20211014194747.1015d46d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211014170215.132687-2-ioana.ciornei@nxp.com>
References: <20211014170215.132687-1-ioana.ciornei@nxp.com>
        <20211014170215.132687-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 20:02:11 +0300 Ioana Ciornei wrote:
> diff --git a/include/soc/fsl/dpaa2-io.h b/include/soc/fsl/dpaa2-io.h
> index c9d849924f89..45de23daefb7 100644
> --- a/include/soc/fsl/dpaa2-io.h
> +++ b/include/soc/fsl/dpaa2-io.h
> @@ -55,6 +55,7 @@ struct dpaa2_io_desc {
>  	void __iomem *regs_cinh;
>  	int dpio_id;
>  	u32 qman_version;
> +	u32 qman_clk;
>  };

include/soc/fsl/dpaa2-io.h:60: warning: Function parameter or member 'qman_clk' not described in 'dpaa2_io_desc'
