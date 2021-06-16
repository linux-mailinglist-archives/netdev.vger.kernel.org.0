Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F223A9780
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhFPKhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:37:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232483AbhFPKgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623839667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUya9eeSq3UP9kfNh+/n74nM/o9pJ4U6PKD15KvqXqA=;
        b=DWIZyt7q7jwpqjYieBcikEyLV2ToEfKKiP3dK2lS0el/sFWb/QKKVtcsq6kKYn+oJhZuKL
        3oG3yFvru+pWrXhbWzQ41hVizg3h2YErLP1lOiUjcrNwJzCiiFrKaat4jHwCIogxVNLJi6
        CjhatgOYeD80n7aZeinVmGPxfTKpO+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-digoLIL1ObCEtjdoGDM3BQ-1; Wed, 16 Jun 2021 06:34:24 -0400
X-MC-Unique: digoLIL1ObCEtjdoGDM3BQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8D74802690;
        Wed, 16 Jun 2021 10:34:22 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F90F5C1C5;
        Wed, 16 Jun 2021 10:34:13 +0000 (UTC)
Date:   Wed, 16 Jun 2021 12:34:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, grygorii.strashko@ti.com,
        mcroce@linux.microsoft.com, ilias.apalodimas@linaro.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next] net: ti: add pp skb recycling support
Message-ID: <20210616123412.126cda90@carbon>
In-Reply-To: <fa2ec166605fc2a60d9ed5e74bc349bd1e322b8d.1623763509.git.lorenzo@kernel.org>
References: <fa2ec166605fc2a60d9ed5e74bc349bd1e322b8d.1623763509.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 15:27:41 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> As already done for mvneta and mvpp2, enable skb recycling for ti
> ethernet drivers
> 
[...]
> 
> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/ti/cpsw.c     | 4 ++--
>  drivers/net/ethernet/ti/cpsw_new.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

