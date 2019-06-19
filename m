Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AA14C265
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 22:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfFSU1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 16:27:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSU1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 16:27:55 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3732412D8E1E6;
        Wed, 19 Jun 2019 13:27:54 -0700 (PDT)
Date:   Wed, 19 Jun 2019 16:27:49 -0400 (EDT)
Message-Id: <20190619.162749.1687527787908840319.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] net/af_iucv: fixes 2019-06-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618184301.96472-1-jwi@linux.ibm.com>
References: <20190618184301.96472-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 13:27:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 18 Jun 2019 20:42:58 +0200

> I spent a few cycles on transmit problems for af_iucv over regular
> netdevices - please apply the following fixes to -net.
> 
> The first patch allows for skb allocations outside of GFP_DMA, while the
> second patch respects that drivers might use skb_cow_head() and/or want
> additional dev->needed_headroom.
> Patch 3 is for a separate issue, where we didn't setup some of the
> netdevice-specific infrastructure when running as a z/VM guest.

Series applied.
