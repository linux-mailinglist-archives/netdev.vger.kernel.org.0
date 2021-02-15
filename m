Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A07A31B819
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 12:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBOLhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 06:37:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbhBOLhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 06:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613388943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sF9dZJuqlvEevgCfQYdSkQXkmgKjtqzSRW7Dqt0w1yM=;
        b=XTl0Ergn2+3T6CSludaMIAcnTF4zbMFXfWtAehZM3fRQlEhy/XM0FdJCGg3Qjk1oORHT2U
        T8Eg5QyK3Yf4pgYfSEqGgs1L6ZZ+eyCQajR9DP/aVSLEiDp83Newy6k71JBvcLwQilLb0r
        PWTNWLcSzhabVN7iHR7UsJBEwt3m1vo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-vHJ4j4Z-Me2HQsaEmEXUpA-1; Mon, 15 Feb 2021 06:35:42 -0500
X-MC-Unique: vHJ4j4Z-Me2HQsaEmEXUpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8BF910066EF;
        Mon, 15 Feb 2021 11:35:40 +0000 (UTC)
Received: from [10.40.194.204] (unknown [10.40.194.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09D285C3F8;
        Mon, 15 Feb 2021 11:35:38 +0000 (UTC)
Message-ID: <72bb7b9fc0cf7afc308e284c72c363e80df8e734.camel@redhat.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From:   Davide Caratti <dcaratti@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
In-Reply-To: <20210215110154.GA28453@linux.home>
References: <20210215114354.6ddc94c7@canb.auug.org.au>
         <20210215110154.GA28453@linux.home>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 15 Feb 2021 12:35:37 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-15 at 12:01 +0100, Guillaume Nault wrote:
> Before these commits, ALL_TESTS listed the tests in the order they were
> implemented in the rest of the file. So I'd rather continue following
> this implicit rule, if at all possible. Also it makes sense to keep
> grouping all match_ip_*_test together.

yes, it makes sense. I can follow-up with a commit for net-next (when
tree re-opens), where the "ordering" in ALL_TESTS is restored. Ok?

thanks,
-- 
davide

