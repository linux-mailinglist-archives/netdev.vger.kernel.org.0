Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770F717EC71
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 00:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCIXKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 19:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgCIXKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 19:10:24 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D743D2146E;
        Mon,  9 Mar 2020 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583795424;
        bh=YBB7DGg17+hzW3ViWJNeTdimdOwEdf/Y44L63ZUpldQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=why2zXcI37efGl9gX5r+derJDSeS8N1Zbb2Cw70Daq3HL244gck0OSUetAm65HWnP
         WPoL46yjirJyWcGgwJiQyAvYj56w6aI16q6yVphtqQeBARZJcJ82nAbSQuJjcSGxUg
         cpmAaG6YgNL/tYBP9zGODcywaWBKFGOOPSkHQt8w=
Date:   Mon, 9 Mar 2020 16:10:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, secdev@chelsio.com, varun@chelsio.com
Subject: Re: [PATCH net-next v4 1/6] cxgb4/chcr : Register to tls add and
 del callback
Message-ID: <20200309161021.0e58ee24@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200309160526.26845f55@kicinski-fedora-PC1C0HJN>
References: <20200307143608.13109-1-rohitm@chelsio.com>
        <20200307143608.13109-2-rohitm@chelsio.com>
        <20200309160526.26845f55@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Mar 2020 16:05:26 -0700 Jakub Kicinski wrote:
> On Sat,  7 Mar 2020 20:06:03 +0530 Rohit Maheshwari wrote:
> > A new macro is defined to enable ktls tx offload support on Chelsio
> > T6 adapter. And if this macro is enabled, cxgb4 will send mailbox to
> > enable or disable ktls settings on HW.
> > In chcr, enabled tx offload flag in netdev and registered tls_dev_add
> > and tls_dev_del.
> > 
> > v1->v2:
> > - mark tcb state to close in tls_dev_del.
> > - u_ctx is now picked from adapter structure.
> > - clear atid in case of failure.
> > - corrected ULP_CRYPTO_KTLS_INLINE value.
> > 
> > v2->v3:
> > - add empty line after variable declaration.
> > - local variable declaration in reverse christmas tree ordering.
> > 
> > Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>  
> 
> What ciphers do you support? You never check cipher type.

Ugh, next patch. Which contains three changes and half of what should
have been here. 

And the driver lives in drivers/crypto for some inexplicable reason.
