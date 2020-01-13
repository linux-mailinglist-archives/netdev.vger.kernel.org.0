Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A20138F55
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgAMKir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:38:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726109AbgAMKir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:38:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578911926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NOav3ieR0s/6CTstR+MKPipRW3FfYup8JW4QaCjqx0c=;
        b=YmYtztf2YuvUvZBj2Bm2miB9jgpHGbatqon0Wi1qVxHYsV58atN58HtdCOzFtBd9idV9f4
        aitaQ1QN34KhNoTV9862qgERO71g2oiVSB/v9Kna6/hYLPWGzvjH0rOE0LioHgdti4qp0w
        jNjyEyuRzy3OXrcBmlPawDli5XFQGbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-_t8nVxy0NOqTJPcmPIQz9w-1; Mon, 13 Jan 2020 05:38:41 -0500
X-MC-Unique: _t8nVxy0NOqTJPcmPIQz9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74208184C70D;
        Mon, 13 Jan 2020 10:38:40 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0434A100EBAF;
        Mon, 13 Jan 2020 10:38:31 +0000 (UTC)
Date:   Mon, 13 Jan 2020 11:38:30 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, brouer@redhat.com
Subject: Re: [PATCH] net: mvneta: change page pool nid to NUMA_NO_NODE
Message-ID: <20200113113830.3b568160@carbon>
In-Reply-To: <70183613cb1a0253f25709e640d88cdd0584a813.1578907338.git.lorenzo@kernel.org>
References: <70183613cb1a0253f25709e640d88cdd0584a813.1578907338.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 10:28:12 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> With 'commit 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE
> condition")' we can safely change nid to NUMA_NO_NODE and accommodate
> future NUMA aware hardware using mvneta network interface
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

