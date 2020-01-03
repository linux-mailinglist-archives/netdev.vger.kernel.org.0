Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D074212F885
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgACMvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:51:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22814 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727350AbgACMvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 07:51:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578055864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9lCCYvOg5BH2AMYj/qtyamOLZTE6sPOH4MySHd4rkIM=;
        b=iP3HUMZz31V9cyk0+bScNGiXlKMI56cebRiQXV7NMA3Le2Bug7d/wNmBuTmN4MOpFp/poi
        9zOub4fvJGpCPw6NeXFGP4llg7THsZjqpYm4RzPFF0QqQ2C5jHqf0PhWGKKQzXozJuFeGE
        sOGYO7X376Khn1ivk+VvPP8Ztrp4zww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-tsHSRCwzMdODI-NfpYSQHQ-1; Fri, 03 Jan 2020 07:50:55 -0500
X-MC-Unique: tsHSRCwzMdODI-NfpYSQHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 981FB10054E3;
        Fri,  3 Jan 2020 12:50:53 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A485F60BF1;
        Fri,  3 Jan 2020 12:50:49 +0000 (UTC)
Date:   Fri, 3 Jan 2020 13:50:47 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, davem@davemloft.net, lorenzo@kernel.org
Subject: Re: [PATCH] net: netsec: Change page pool nid to NUMA_NO_NODE
Message-ID: <20200103135047.21d58104@carbon>
In-Reply-To: <20200103114032.46444-1-ilias.apalodimas@linaro.org>
References: <20200103114032.46444-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Jan 2020 13:40:32 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> The current driver only exists on a non NUMA aware machine.
> With 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")
> applied we can safely change that to NUMA_NO_NODE and accommodate future
> NUMA aware hardware using netsec network interface
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

