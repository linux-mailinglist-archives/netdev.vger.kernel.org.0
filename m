Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7343D47D848
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 21:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhLVU0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 15:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhLVU0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 15:26:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA27BC061574;
        Wed, 22 Dec 2021 12:26:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02DB261CF3;
        Wed, 22 Dec 2021 20:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE5EC36AE8;
        Wed, 22 Dec 2021 20:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640204778;
        bh=RxKIkjafrTOBZF0gKzWFST49aq7+J+yevpRaTaZzeII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iQC55m1khm59SL3Wcc3x+BEunTwJH95fjfF9h49TWatuG3TXdMbHVKg2rjzaRQ0fr
         cOeG5H6BTtXvtZIUy8DwIeCI1A8tJT7+5g9vrfxuT/vFcMYKn9EeoIvxWVkFD5R0dZ
         Lxq0Ef9zP8xE/owY0z0/z4FKu5Rf6yM4ZMq3ir3hGKyleNbt/bO1qOueLSHcfq9+Ro
         iJSO9cxbU/9en8rIphdr4JbmC2uRHC7mamouyGENmoqhzPGc+91fxtLkvo8HjBTjUE
         Q28t9dJClBNDFzlNhDNRBcZCEB46PgEADNKq1MT1wkTgG2x96E1ZRuKgkhwyp8YLGm
         PvaYTzarKt5Kg==
Date:   Wed, 22 Dec 2021 12:26:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] sfc: Check null pointer of rx_queue->page_ring
Message-ID: <20211222122616.79fb1f34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222130356.xlzmhoyexrnctkrs@gmail.com>
References: <20211220135603.954944-1-jiasheng@iscas.ac.cn>
        <20211222130356.xlzmhoyexrnctkrs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Dec 2021 13:03:56 +0000 Martin Habets wrote:
> On Mon, Dec 20, 2021 at 09:56:03PM +0800, Jiasheng Jiang wrote:
> > Because of the possible failure of the kcalloc, it should be better to
> > set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> > the consistency.
> > 
> > Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
> > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>  
> 
> Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

Applied, thanks!
