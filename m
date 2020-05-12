Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F50D1CFB46
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 18:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgELQrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 12:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgELQrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 12:47:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B67520714;
        Tue, 12 May 2020 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589302053;
        bh=S74IfW6d9xHjFO1YUG2+zr5LC3F6yhCnZ+RQj+1ctpY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QHcNqwsBaDdmBRULiz4GEMY0cnr7puhD6VuY6ZzWBsRTTGYcFKIpgTirtGW2j2Rd7
         fsOC29IJ+xuY80AyPdzNIEeioM21vyRz8K+C9OP1W3eOU5lFax3t5yXm9v8NnoABTx
         Gl1cE9qUzwWmfOLeIdKaMslbbOaSancVedsMBiMY=
Date:   Tue, 12 May 2020 09:47:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luo bin <luobin9@huawei.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200512094731.346c0d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200512133051.7d740613@canb.auug.org.au>
References: <20200512133051.7d740613@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 13:30:51 +1000 Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got conflicts in:
> 
>   drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
>   drivers/net/ethernet/huawei/hinic/hinic_main.c
> 
> between commit:
> 
>   e8a1b0efd632 ("hinic: fix a bug of ndo_stop")
> 
> from the net tree and commit:
> 
>   7dd29ee12865 ("hinic: add sriov feature support")
> 
> from the net-next tree.
> 
> I fixed it up (I think, see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

I had a feeling this was gonna happen :(

Resolution looks correct, thank you!

Luo bin, if you want to adjust the timeouts (you had slightly different
ones depending on the command in the first version of the fix) - you can
follow up with a patch to net-next once Dave merges net into net-next
(usually happens every two weeks).
