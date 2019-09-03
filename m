Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD7A6305
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfICHri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:47:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45327 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfICHri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 03:47:38 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 243427EBC4
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 07:47:38 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id f10so6610976wmh.8
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 00:47:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CnmnWhc2qfmsJ3pZ+ytXKy1jqPtAf/8RAcu/rZxBpOA=;
        b=tPxbQq9qYArj4xor1ib0MpPZlAiZcpZe7il4I3AFA+PLUmIyn5BEqrZAPGHQEHLr+q
         iapZJneWMjLbDypBZ8kqgt4a5Ia2SdAmBLxc6ZrG4m9eXv7AJ+2UeNUmrqpetPmDovtr
         h+OH7SUsR8ImYE8vhKkQm24LN8wSm9YvvoBAkifVl4u8KLAhFzYHLkPcUbWZus2LqvQl
         29R173Wn778UTHkiPLXo8apygTlaZjbbUz8NdmYA3tEosPGT+6qqc0wDoWUlVCc0tmhS
         3bcK40b3FryMyYbgzOlDlm/W4oXP+13Kb4vOgSHvhLBIla4/6VmjlCuIJ9EuU8y4u47J
         0nvA==
X-Gm-Message-State: APjAAAWpgOxUW8K3mDBozJp99AOxJ1dFv5h8I4tln9gT0gDCwpN9eAql
        Z/a/IeEwjWPy04XPtc+5PY6bQGiRO+YUpLIuteFEYZ8STlXM3ONnohyB4pkwbbHDrMRLUjNolbc
        8XxHW97onWz/r8/ak
X-Received: by 2002:adf:8444:: with SMTP id 62mr40065118wrf.202.1567496856834;
        Tue, 03 Sep 2019 00:47:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtF6KOYuQGW6Yd+ADmoPQoTuiB5O/upqyGyY9YWt/HZCmo1caE/75ccLGalCenEsB8+yq/Dg==
X-Received: by 2002:adf:8444:: with SMTP id 62mr40065094wrf.202.1567496856630;
        Tue, 03 Sep 2019 00:47:36 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id x15sm11040612wmc.16.2019.09.03.00.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 00:47:36 -0700 (PDT)
Date:   Tue, 3 Sep 2019 09:47:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] vsock/virtio: a better comment on credit update
Message-ID: <20190903074733.dg55ucs7jh5zvfbh@steredhat>
References: <20190903073748.25214-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903073748.25214-1-mst@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 03:38:16AM -0400, Michael S. Tsirkin wrote:
> The comment we have is just repeating what the code does.
> Include the *reason* for the condition instead.
> 
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 94cc0fa3e848..5bb70c692b1e 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -307,8 +307,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  
>  	spin_unlock_bh(&vvs->rx_lock);
>  
> -	/* We send a credit update only when the space available seen
> -	 * by the transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE
> +	/* To reduce the number of credit update messages,
> +	 * don't update credits as long as lots of space is available.
> +	 * Note: the limit chosen here is arbitrary. Setting the limit
> +	 * too high causes extra messages. Too low causes transmitter
> +	 * stalls. As stalls are in theory more expensive than extra
> +	 * messages, we set the limit to a high value. TODO: experiment
> +	 * with different values.
>  	 */
>  	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
>  		virtio_transport_send_credit_update(vsk,

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


