Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826A535A7F7
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhDIUke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:40:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231946AbhDIUkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 16:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618000819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q193xZr1BMYRCl6sJseS6djVgHOxLnB/RXmKWcvH1Ro=;
        b=RICn4UlyJws681foM51ayuyHoY92Yq/WlHkF9axS57L85V1gqZy7I9yVTMXmXQ/7f91t2P
        GYqLjTY4VKerT8rFr6fLQCALHoC5xBdJZVBgS9RY6AsqWKJ6pvZHUMOoL21CoBNTCM0/pK
        UJLdp1ouOGlKCxPJ97tKQMux5w9P+jk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-tXkxNBTDO2CqPBZqDhxCrg-1; Fri, 09 Apr 2021 16:40:15 -0400
X-MC-Unique: tXkxNBTDO2CqPBZqDhxCrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1978A107ACCD;
        Fri,  9 Apr 2021 20:40:13 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D29B16EF50;
        Fri,  9 Apr 2021 20:40:06 +0000 (UTC)
Date:   Fri, 9 Apr 2021 22:40:05 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <20210409224005.6dc6dcd6@carbon>
In-Reply-To: <YHCknwlzJHPFXm2j@apalos.home>
References: <20210402181733.32250-1-mcroce@linux.microsoft.com>
        <20210402181733.32250-4-mcroce@linux.microsoft.com>
        <20210409115648.169523fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YHCknwlzJHPFXm2j@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 22:01:51 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Fri, Apr 09, 2021 at 11:56:48AM -0700, Jakub Kicinski wrote:
> > On Fri,  2 Apr 2021 20:17:31 +0200 Matteo Croce wrote:  
> > > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Co-developed-by: Matteo Croce <mcroce@microsoft.com>
> > > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>  
> > 
> > Checkpatch says we need sign-offs from all authors.
> > Especially you since you're posting.  
> 
> Yes it does, we forgot that.  Let me take a chance on this one. 
> The patch is changing the default skb return path and while we've done enough
> testing, I would really prefer this going in on a future -rc1 (assuming we even
> consider merging it), allowing enough time to have wider tests.

You can have my:

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

But as Ilias suggested in IRC lets send a V3, and Cc the MM-people, as
this also dig into their area.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

