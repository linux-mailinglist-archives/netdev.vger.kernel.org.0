Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE023AD17
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 21:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgHCTcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 15:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgHCTcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 15:32:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30B0C06174A;
        Mon,  3 Aug 2020 12:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=tl6E9v7JdT5SPY6RMUgVUsix1wSI4Y22duyU2Vp5sVk=; b=o3dXV7G8FYbZAU/4Lg96+dolTO
        DqoRG7LfpQE59kto5q1iSKTjpcj2KQjfXZvxPUY16QRZkDh7epiAhndKeQOJYEiwZDH1dLpThI/RR
        0YXyYXpcpSyy2fQ0jAJYg9rXXvRnUnHGYc5zpTunKPoXC3O0yYG26lWEpt9G2IWLHnVvFgCSFzVcF
        jbo+wP7Ibc7+21WihDdd6g+lxpyPGp4pvZ+8jYUpZvt70+bLfXqzb4A4vFPXTrE2EcmXq2wTl0Syo
        qC20FgOvl8Ap6ocJcc4CrqRs6Spg1jZj35h998IC7L+Ntb6bGxopuich+GSzDEWTijX8DvWlpmqU8
        91LjJiSg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k2gC2-0003qo-VT; Mon, 03 Aug 2020 19:32:25 +0000
Subject: Re: [PATCH v4 4/6] can: ctucanfd: CTU CAN FD open-source IP core -
 PCI bus support.
To:     pisa@cmp.felk.cvut.cz, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org, mkl@pengutronix.de,
        socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, c.emde@osadl.org, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
 <bad059402032f82fa63aa51d2122589a8a2cf6fd.1596408856.git.pisa@cmp.felk.cvut.cz>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e4378bd9-6484-88bc-48d3-d7fdda62c844@infradead.org>
Date:   Mon, 3 Aug 2020 12:32:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bad059402032f82fa63aa51d2122589a8a2cf6fd.1596408856.git.pisa@cmp.felk.cvut.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 11:34 AM, pisa@cmp.felk.cvut.cz wrote:
> diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
> index 0620111d57fd..8a5f5d05fa72 100644
> --- a/drivers/net/can/ctucanfd/Kconfig
> +++ b/drivers/net/can/ctucanfd/Kconfig
> @@ -15,4 +15,13 @@ config CAN_CTUCANFD
>  
>  if CAN_CTUCANFD
>  
> +config CAN_CTUCANFD_PCI
> +    tristate "CTU CAN-FD IP core PCI/PCIe driver"
> +    depends on PCI
> +	help

"help" should be indented with one tab only (no spaces).

> +	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
> +	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
> +	  PCIe board with PiKRON.com designed transceiver riser shield is available
> +	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .

help text should be indented with one tab + 2 spaces according to
Documentation/process/coding-style.rst.

> +
>  endif

thanks.
-- 
~Randy

