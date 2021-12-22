Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0965747D84A
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 21:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhLVU0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 15:26:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47104 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhLVU0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 15:26:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB49261CE3;
        Wed, 22 Dec 2021 20:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D26C36AE5;
        Wed, 22 Dec 2021 20:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640204792;
        bh=YorGKlqDes8lYouhz8jPIgBPO4J+mlheZK/ui1yifaE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TdtK07fTLmjrFlLBr6bJyCctBwvxSBTi4NnI1lHl/PESLIA03itE1Wa7R3WPL5AiX
         04wj8qn94/P/KmIHJ7pq6bOfFLBABxgOtw6dP/gOstdP0oe3QTuCl9kbsZFrjdfXGb
         nljFIYGradsAN8JWr6GlQ7F4qSo8LJBHjcikZO+T/2HIAGaGulDPg36vAyqtjz7QQd
         tuWyHQPSWL7MRhv4MDpe8mQ67HR9fVv4DicLmhD80lWQM4JfMOuGqjk7uoOml8okF2
         fKgYNQNDTWdozoIbleSdqNzWWEkUqVLRfzVWtJL4zTf8DPDP9HM8HUR7vb/FQL6EzY
         PdwfOUBft5c1Q==
Date:   Wed, 22 Dec 2021 12:26:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: falcon: Check null pointer of rx_queue->page_ring
Message-ID: <20211222122630.6c3f5ae9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222130456.3lbrgx3p47fzjnzi@gmail.com>
References: <20211220140344.978408-1-jiasheng@iscas.ac.cn>
        <20211222130456.3lbrgx3p47fzjnzi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Dec 2021 13:04:56 +0000 Martin Habets wrote:
> On Mon, Dec 20, 2021 at 10:03:44PM +0800, Jiasheng Jiang wrote:
> > Because of the possible failure of the kcalloc, it should be better to
> > set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> > the consistency.
> > 
> > Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
> > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>  
> 
> Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

Applied, thanks!
