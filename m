Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E061B1391F4
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgAMNRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:17:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29165 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbgAMNQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:16:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578921418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVIKp31E2iTSA1+b8+M/9DwbQysAZoH56z84RxZqUZY=;
        b=ALtNgNDscTGR2hcRI0BCIrRo+huqgzGYs63K9Qqk5rWRsZXjJRCaSz+bmGtd+6+5flAf3B
        wiK+vyYOKI8LPXFYmmJhR+8s//hZ6JKjAQu7vXjeNtaRLOWQYfQXRLVzEtGTe//gUfEQ/w
        eJ9pd6j4bYCY9uh3M6cqNOUH3c0UuFo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-D7yixyPsPs2D8y7pFg_NKQ-1; Mon, 13 Jan 2020 08:16:56 -0500
X-MC-Unique: D7yixyPsPs2D8y7pFg_NKQ-1
Received: by mail-qt1-f199.google.com with SMTP id l1so6442540qtp.21
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 05:16:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uVIKp31E2iTSA1+b8+M/9DwbQysAZoH56z84RxZqUZY=;
        b=Aenbbxz+fDrNbOi8tgtEzS/eq9AVQImyxUaNcSGnc1MyBvOV8mQTYozbB+Ph65FH8n
         JLlDxw3Kqr6ExDkgsKicX7bQstnKkGLAVX9BHatbtwn5vlSq4GPVAEGZ4O/lQ2Ker4Mm
         rIDQ196O6N8XkU9YJrMLXpTETlq3uk94V88id3AuRgWJursrQgM8Rdybt84Hy9RKSUla
         DQYtMSCci3uBuWb3sDGcimbwR6Kjm+Coik7YOS3jQoowi+8t55V92dNhUE55q0zda2hi
         IXA7+60108L3XMkJUrHnd/lZteyCHWpHXhwlZEdK7GWcXbyVbHNYxZseG8U9GORDBaSC
         w7Jw==
X-Gm-Message-State: APjAAAWImTzuxIpvNWMFFKidP7X6LY7mOHxwlnOQ2h691xesHzwAYsPi
        VILgc2DYnPZHTBeHiJscaqNDlS1XYGDOhHpRGk1rayM0zJ3EZdOn3JxL4fL3a3PXWLgsc8NMxAH
        bqu21mg4judH6u+Tj
X-Received: by 2002:ae9:eb13:: with SMTP id b19mr15751269qkg.6.1578921416547;
        Mon, 13 Jan 2020 05:16:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwsVe2kwuA4+b1eGJwaPgwpGhdr8PoaezWxEg8iiv/Xwg61pAq9lN5rj20l7mxBkjjCaMBE1Q==
X-Received: by 2002:ae9:eb13:: with SMTP id b19mr15751253qkg.6.1578921416356;
        Mon, 13 Jan 2020 05:16:56 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id y26sm5781414qtc.94.2020.01.13.05.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 05:16:55 -0800 (PST)
Date:   Mon, 13 Jan 2020 08:16:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net-next] ptr_ring: add include of linux/mm.h
Message-ID: <20200113081641-mutt-send-email-mst@kernel.org>
References: <157891093662.53334.15580647502551818360.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157891093662.53334.15580647502551818360.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 11:22:16AM +0100, Jesper Dangaard Brouer wrote:
> Commit 0bf7800f1799 ("ptr_ring: try vmalloc() when kmalloc() fails")
> started to use kvmalloc_array and kvfree, which are defined in mm.h,
> the previous functions kcalloc and kfree, which are defined in slab.h.
> 
> Add the missing include of linux/mm.h.  This went unnoticed as other
> include files happened to include mm.h.
> 
> Fixes: 0bf7800f1799 ("ptr_ring: try vmalloc() when kmalloc() fails")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/linux/ptr_ring.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 0abe9a4fc842..417db0a79a62 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -23,6 +23,7 @@
>  #include <linux/types.h>
>  #include <linux/compiler.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>  #include <asm/errno.h>
>  #endif
>  
> 

