Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF97D8D315
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfHNM3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfHNM3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 08:29:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04F34308FEDF;
        Wed, 14 Aug 2019 12:29:33 +0000 (UTC)
Received: from carbon (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E31017AB75;
        Wed, 14 Aug 2019 12:29:27 +0000 (UTC)
Date:   Wed, 14 Aug 2019 14:29:26 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <ilias.apalodimas@linaro.org>, <saeedm@mellanox.com>,
        <ttoukan.linux@gmail.com>, <kernel-team@fb.com>, brouer@redhat.com
Subject: Re: [PATCH net-next] page_pool: fix logic in __page_pool_get_cached
Message-ID: <20190814142926.3f4b149a@carbon>
In-Reply-To: <20190813174509.494723-1-jonathan.lemon@gmail.com>
References: <20190813174509.494723-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 14 Aug 2019 12:29:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 10:45:09 -0700
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> __page_pool_get_cached() will return NULL when the ring is
> empty, even if there are pages present in the lookaside cache.
> 
> It is also possible to refill the cache, and then return a
> NULL page.
> 
> Restructure the logic so eliminate both cases.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for catching and improving this!

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
