Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80D2E90AE
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 08:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbhADHCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 02:02:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726924AbhADHCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 02:02:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609743655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m95EV6wkqZdUunicOxOCYJRjT+GcrUdr9jvQjDQWdyw=;
        b=NYGFSjQ7pEh7gTQ5eX9BbsZsU6TTDJB+0VyG1374V6LBKuO7vy7RJtvdZnyu70xH0O4bR/
        BI6sYVNpxCkbY2fIFlsfaQuJIg17Mc4ceOmyd0LKAqQcwxTHEpdbuGw9i6ea7eN3xMHGaJ
        flLlC3uEG12g9dhqmXbUckJDOT9HKcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-WqFmXLEtP7KvW6vt9Cgmmg-1; Mon, 04 Jan 2021 02:00:51 -0500
X-MC-Unique: WqFmXLEtP7KvW6vt9Cgmmg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 507F78018AF;
        Mon,  4 Jan 2021 07:00:50 +0000 (UTC)
Received: from [10.72.13.91] (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8945E27C4E;
        Mon,  4 Jan 2021 07:00:45 +0000 (UTC)
Subject: Re: [PATCH linux-next v2 1/7] vdpa_sim_net: Make mac address array
 static
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, elic@nvidia.com, netdev@vger.kernel.org
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-2-parav@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b3832d82-7c32-52fd-cebc-1cbe2119ecfc@redhat.com>
Date:   Mon, 4 Jan 2021 15:00:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104033141.105876-2-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/4 上午11:31, Parav Pandit wrote:
> MAC address array is used only in vdpa_sim_net.c.
> Hence, keep it static.
>
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
> Changelog:
> v1->v2:
>   - new patch
> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index c10b6981fdab..f0482427186b 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -33,7 +33,7 @@ static char *macaddr;
>   module_param(macaddr, charp, 0);
>   MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
>   
> -u8 macaddr_buf[ETH_ALEN];
> +static u8 macaddr_buf[ETH_ALEN];
>   
>   static struct vdpasim *vdpasim_net_dev;
>   


Acked-by: Jason Wang <jasowang@redhat.com>


