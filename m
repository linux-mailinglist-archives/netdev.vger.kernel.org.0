Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5A31FA0A
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBSNmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 08:42:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBSNmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 08:42:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613742051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbHH1DNgzHBzFNL9zWmxvGHaI2yFfSwoc3pemEGSlHk=;
        b=O6tucRyegTVkfKt8Twd4JB9rwmErL6heCVffiVxNZzFTGtMopZ6DL84YORwACA9gFxcZn9
        pXRSnrXHinvIu07c0pdy4O6OrzgKWCYMJeDug3y/dEoKAAP1jTTj0HFXXjHXMCu4pX2XkY
        bAzXMGeHeG5BrU0vY5BRHmJ8XeICxq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-h9DHtUFVPpCvPRySZazD_g-1; Fri, 19 Feb 2021 08:40:47 -0500
X-MC-Unique: h9DHtUFVPpCvPRySZazD_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11712107ACC7;
        Fri, 19 Feb 2021 13:40:46 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20B4B5C1BB;
        Fri, 19 Feb 2021 13:40:40 +0000 (UTC)
Date:   Fri, 19 Feb 2021 14:40:39 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, davem@davemloft.net, s.hauer@pengutronix.de,
        madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net] dpaa_eth: fix the access method for the
 dpaa_napi_portal
Message-ID: <20210219144039.27be6e13@carbon>
In-Reply-To: <20210218182106.22613-1-camelia.groza@nxp.com>
References: <20210218182106.22613-1-camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 20:21:06 +0200
Camelia Groza <camelia.groza@nxp.com> wrote:

> The current use of container_of is flawed and unnecessary. Obtain
> the dpaa_napi_portal reference from the private percpu data instead.
> 
> Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
> Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

