Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A601932B1
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 22:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYVcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 17:32:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:43577 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbgCYVcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 17:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585171960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS0xjvpbRT2rkvzGCAvomy0d2K/R3wj7p9gmm6Y/jww=;
        b=WkI2O+j6GcBICDqSI5DMgQrxQIP0CqE6/LHaqYkAlCwKEknGN9Q2WgsLU7qAXgTV2iZ9XD
        l7NyejlbYbAM5Ov4leW9btH2slwqB7RS4TlfmH76QoxsBlzbJl4ydp84Q+ecFVen2Kb94D
        Q7I0q6z+U8x2EBS/wMmyKZj8pGvKoLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-SoXQA6RSO3iXroM3NA7Cog-1; Wed, 25 Mar 2020 17:32:37 -0400
X-MC-Unique: SoXQA6RSO3iXroM3NA7Cog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC507477;
        Wed, 25 Mar 2020 21:32:35 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C18010002A7;
        Wed, 25 Mar 2020 21:32:31 +0000 (UTC)
Date:   Wed, 25 Mar 2020 22:32:29 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v2 net-next] net: page pool: allow to pass zero flags to
 page_pool_init()
Message-ID: <20200325223229.0d7b802e@carbon>
In-Reply-To: <1585168528-2445-1-git-send-email-kda@linux-powerpc.org>
References: <1585168528-2445-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 23:35:28 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> page pool API can be useful for non-DMA cases like
> xen-netfront driver so let's allow to pass zero flags to
> page pool flags.
> 
> v2: check DMA direction only if PP_FLAG_DMA_MAP is set
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

