Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08D81EE132
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 11:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgFDJYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 05:24:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48552 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgFDJYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 05:24:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591262660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nR0wIr618d0NA7vk86060M6Wg7pHdGa//KaPoRiJhh4=;
        b=COvU3oW7zGsh4fECDu2XxhkgVVFXYnFQmpfr155yOstUjqUovqoOMo49VHVZVRKCJCnRMU
        DL9CQq5lurR9kBGZfTgAtCd/O11u+Lo6IllnYzoU6By6KQNF5LnOJa9MqPah+ce2xVWyYb
        rgzcN2z4JXy5QtDFZsAafkzluic0Mrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-rsr0gMLJNEqf-Wc57c9VyA-1; Thu, 04 Jun 2020 05:24:16 -0400
X-MC-Unique: rsr0gMLJNEqf-Wc57c9VyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2E81835B42;
        Thu,  4 Jun 2020 09:24:13 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AE6860CD1;
        Thu,  4 Jun 2020 09:24:05 +0000 (UTC)
Date:   Thu, 4 Jun 2020 11:24:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     <sameehj@amazon.com>
Cc:     brouer@redhat.com, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <dwmw@amazon.com>, <zorik@amazon.com>, <matua@amazon.com>,
        <saeedb@amazon.com>, <msw@amazon.com>, <aliguori@amazon.com>,
        <nafea@amazon.com>, <gtzalik@amazon.com>, <netanel@amazon.com>,
        <alisaidi@amazon.com>, <benh@amazon.com>, <akiyano@amazon.com>,
        <ndagan@amazon.com>
Subject: Re: [PATCH V2 net 0/2] Fix xdp in ena driver
Message-ID: <20200604112404.05cdc073@carbon>
In-Reply-To: <20200603085023.24221-1-sameehj@amazon.com>
References: <20200603085023.24221-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jun 2020 08:50:21 +0000
<sameehj@amazon.com> wrote:

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset includes 2 XDP related bug fixes
> 
> Difference from v1:
> * Fixed "Fixes" tag
> 
> Sameeh Jubran (2):
>   net: ena: xdp: XDP_TX: fix memory leak
>   net: ena: xdp: update napi budget for DROP and ABORTED
> 
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

