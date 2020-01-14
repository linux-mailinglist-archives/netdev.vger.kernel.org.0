Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E26139F69
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgANCTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:19:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728931AbgANCTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 21:19:04 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C92152084D;
        Tue, 14 Jan 2020 02:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578968344;
        bh=/7XiK/uPOiJRxksFzKq9jeiJpcSnzKDJ9EasZvOcx/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DnaqhJGNCTEc+LdYANv5kYZEtRGxiklTwub8QXQByRppzoM+PNPJjC7j88yMzCUy/
         zr0B6wAcl3zQbZ4ElGZfpYm0JumbfrdBGBQxcjCG2/vwpdb38S0hqggQKrGBQU0vZA
         V6g/gaLSXWNHdqKwNeDb540wVJaj5I+TjMo4EY/0=
Date:   Mon, 13 Jan 2020 18:19:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net-next] ptr_ring: add include of linux/mm.h
Message-ID: <20200113181853.37d998cb@cakuba>
In-Reply-To: <157891093662.53334.15580647502551818360.stgit@firesoul>
References: <157891093662.53334.15580647502551818360.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 11:22:16 +0100, Jesper Dangaard Brouer wrote:
> Commit 0bf7800f1799 ("ptr_ring: try vmalloc() when kmalloc() fails")
> started to use kvmalloc_array and kvfree, which are defined in mm.h,
> the previous functions kcalloc and kfree, which are defined in slab.h.
> 
> Add the missing include of linux/mm.h.  This went unnoticed as other
> include files happened to include mm.h.
> 
> Fixes: 0bf7800f1799 ("ptr_ring: try vmalloc() when kmalloc() fails")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied to net-next as specified, let's see if bots pull it into stable
for no good reason :)  Thank you!
