Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA861A3A7B
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgDITV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgDITV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 15:21:57 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D024206F5;
        Thu,  9 Apr 2020 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586460117;
        bh=lSQWaEQWgnHmtSWjR18IPvPCkKAFsxx45uCf+BNYRHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EsaXhYbWhiic4+d2CBEZZ4tSfmsWQRqDcamWiPhe+4yTw0re0efXh/Ym20trfnLmE
         96RfouGJZ9MnSP3Im4V9HzZnysJeOjntCe2Uv8H5FkaEMX7f733YP/KoSGYiphFpeM
         MH2UivQ6h18qjnk2VIHWWR6NPJY7tsQgkaIynxJY=
Date:   Thu, 9 Apr 2020 12:21:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
Subject: Re: [PATCH net] docs: networking: convert DIM to RST
Message-ID: <20200409122155.5c4e9b12@kicinski-fedora-PC1C0HJN>
In-Reply-To: <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
References: <20200409175704.305241-1-kuba@kernel.org>
        <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 12:17:52 -0700 Randy Dunlap wrote:
> On 4/9/20 10:57 AM, Jakub Kicinski wrote:
> > Convert the Dynamic Interrupt Moderation doc to RST and
> > use the RST features like syntax highlight, function and
> > structure documentation, enumerations, table of contents.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Hi,
> 
> Tested-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Sorry I dropped the ball on this.

No worries at all! I had to read through this doc so I thought 
I'd convert it to RST at the same time. Thanks for the review!
