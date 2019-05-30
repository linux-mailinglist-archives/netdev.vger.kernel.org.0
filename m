Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BDF30180
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfE3SHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:07:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfE3SHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:07:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6B4114D85C6F;
        Thu, 30 May 2019 11:07:30 -0700 (PDT)
Date:   Thu, 30 May 2019 11:07:30 -0700 (PDT)
Message-Id: <20190530.110730.2064393163616673523.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com,
        James.Bottomley@hansenpartnership.com, hch@infradead.org,
        jglisse@redhat.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        christophe.de.dinechin@gmail.com, jrdr.linux@gmail.com
Subject: Re: [PATCH net-next 0/6] vhost: accelerate metadata access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524081218.2502-1-jasowang@redhat.com>
References: <20190524081218.2502-1-jasowang@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:07:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 24 May 2019 04:12:12 -0400

> This series tries to access virtqueue metadata through kernel virtual
> address instead of copy_user() friends since they had too much
> overheads like checks, spec barriers or even hardware feature
> toggling like SMAP. This is done through setup kernel address through
> direct mapping and co-opreate VM management with MMU notifiers.
> 
> Test shows about 23% improvement on TX PPS. TCP_STREAM doesn't see
> obvious improvement.

I'm still waiting for some review from mst.

If I don't see any review soon I will just wipe these changes from
patchwork as it serves no purpose to just let them rot there.

Thank you.
