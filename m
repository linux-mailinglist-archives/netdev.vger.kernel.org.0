Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EAB27D6E0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgI2T1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2T1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:27:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E5FC061755;
        Tue, 29 Sep 2020 12:27:40 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601407659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wJ1qyY7jDkW+3C7cu3ELBYPJyjIPnO9bcBY7ay153cw=;
        b=1IVUUKatatMgwT9hBqzolQ9HwFPjr5+Kl+UsD2fUgkUFSw9idfYJxLjEYno39KdBeXfLtj
        2mKl44/p8IXvM6CPFe2bTKwerGoPvqlYNqljOnB1fHvDQM48Vmlx0CRhhXeY8Pzs88twxB
        szAWq/sQFtXltHepYe2cdh8l+l0NeXVq2v4BXOsw1OIJBYnzBIDiPQ9YGWNTNU8nV26Fas
        4eVhHKQJyrsOJfQ5+hKzZTg1FzebyXpSKhG72BoTdKDCYxoAuixMarb2uVslLcq2AGcxVT
        9QiwlZozmscQOkL2dplsNToENGGyQcUjZM4n89ojanr17igW6erRFzM8vgevPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601407659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wJ1qyY7jDkW+3C7cu3ELBYPJyjIPnO9bcBY7ay153cw=;
        b=GPLf73/FDvrOorX45S3+L4AuFSHVdpfp3GxBhPTmRPh/3b9sTLZpvuJ3yN9H37bEs2Dd7l
        lsat9yjeu4S4EkBQ==
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] sfc: replace in_interrupt() usage
In-Reply-To: <d098eea1-6390-3900-b819-0c03e1872609@solarflare.com>
References: <168a1f9e-cba4-69a8-9b29-5c121295e960@solarflare.com> <e45d9556-2759-6f33-01a0-d1739ce5760d@solarflare.com> <87k0wdk5t2.fsf@nanos.tec.linutronix.de> <d098eea1-6390-3900-b819-0c03e1872609@solarflare.com>
Date:   Tue, 29 Sep 2020 21:27:38 +0200
Message-ID: <87eemkjsd1.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29 2020 at 16:15, Edward Cree wrote:
>> On Mon, Sep 28 2020 at 21:05, Edward Cree wrote:
>>> Only compile-tested so far, because I'm waiting for my kernel to
>>>  finish rebuilding with CONFIG_DEBUG_ATOMIC_SLEEP
>
> I've now tested and confirmed that the might_sleep warning goes
>  away with this patch.
>
> Thomas, do you want to pull it into v2 of your series, or should
>  I submit it separately to David?

I have it already, but if Dave applies it right away, that's fine.

Thanks,

        tglx
