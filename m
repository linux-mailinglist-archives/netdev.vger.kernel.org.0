Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071E63B8FD2
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 11:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhGAJg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 05:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235168AbhGAJg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 05:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A775161418;
        Thu,  1 Jul 2021 09:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625132038;
        bh=GWa1rUlQqZUIdCsRmaxyeRV7dbVCIq8Z4FSKsT43KIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=geAnbwpr0+mX6noIop5LNVdaqat2i77pftZv9Bq0m5Jo95MY9YLyXusO2n0NKgUS8
         GCPxTie2cH4Q/zrRI1U1NUBCkDhobRjefWL77QXyoBTULEe2UhxCg3lb14fxKfGEUX
         l0AhDUD1dtUnHjKDXSQ+MyFbDtMCMJrtW3/s3Q6Q=
Date:   Thu, 1 Jul 2021 11:33:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH, resend] net: remove the caif_hsi driver
Message-ID: <YN2MA1CkwzadQf6l@kroah.com>
References: <20210701081509.246467-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701081509.246467-1-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 10:15:09AM +0200, Christoph Hellwig wrote:
> The caif_hsi driver relies on a cfhsi_get_ops symbol using symbol_get,
> but this symbol is not provided anywhere in the kernel tree.  Remove
> this driver given that it is dead code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
