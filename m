Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A444E17EC66
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 00:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgCIXFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 19:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgCIXF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 19:05:29 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0DA320727;
        Mon,  9 Mar 2020 23:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583795129;
        bh=zxRXzKIXw9OS24s1Nb9Cg+bWi4PXZHRpjnKGtr/fhto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l2yFP0XCDgMvbWgyc+PSVsLFoj34EODjikaRUzaJbbT6F4oyoM+K/vuYvf9njsxdc
         oekh4X0Q3mGVh3hVO5+NMWio2lRnV9RKT0u2hyaYsWRUDX9jW4r+S//gRzfEhskYzM
         rQnmX2BpgqJZ0DFytKktM/HHELpvuSw1cSLquisQ=
Date:   Mon, 9 Mar 2020 16:05:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, secdev@chelsio.com, varun@chelsio.com
Subject: Re: [PATCH net-next v4 1/6] cxgb4/chcr : Register to tls add and
 del callback
Message-ID: <20200309160526.26845f55@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200307143608.13109-2-rohitm@chelsio.com>
References: <20200307143608.13109-1-rohitm@chelsio.com>
        <20200307143608.13109-2-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Mar 2020 20:06:03 +0530 Rohit Maheshwari wrote:
> A new macro is defined to enable ktls tx offload support on Chelsio
> T6 adapter. And if this macro is enabled, cxgb4 will send mailbox to
> enable or disable ktls settings on HW.
> In chcr, enabled tx offload flag in netdev and registered tls_dev_add
> and tls_dev_del.
> 
> v1->v2:
> - mark tcb state to close in tls_dev_del.
> - u_ctx is now picked from adapter structure.
> - clear atid in case of failure.
> - corrected ULP_CRYPTO_KTLS_INLINE value.
> 
> v2->v3:
> - add empty line after variable declaration.
> - local variable declaration in reverse christmas tree ordering.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

What ciphers do you support? You never check cipher type.
