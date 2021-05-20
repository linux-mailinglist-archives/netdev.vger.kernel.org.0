Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774D238ADCF
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 14:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhETMSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 08:18:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235280AbhETMS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 08:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621513024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SSkwtvHcPBbTlvpNE9P+HcbJy0FqLXXvauvAW90G6bk=;
        b=gs7rBJl2yc39U9js+XUDYZ83utACMfZqFgveRcYFQ1K0FzNbn/U6jvNkNIsKcFZb1DHuTL
        FOt0kYHMdIeXCdkeEdBBdVp/RUexnkQ83m+tAkwZkvZU9FAK7IxxUYwjeZeKcO2IOD/M4b
        7FEl3e+qR+pWQ85l/P5lMZRI7avtoAE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-UvDoJzVyNO-rnKNXZHSbXg-1; Thu, 20 May 2021 08:17:02 -0400
X-MC-Unique: UvDoJzVyNO-rnKNXZHSbXg-1
Received: by mail-ej1-f69.google.com with SMTP id n25-20020a170906b319b02903d4dc1bc46cso4920082ejz.2
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 05:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SSkwtvHcPBbTlvpNE9P+HcbJy0FqLXXvauvAW90G6bk=;
        b=XSL+AZrb5pCRRV6DFKA7/1xIh9Kcx7+Gqslrv531ArxGkNVki0zPTDdrJDnG6PjVTy
         C3qjbGfN5RpP68LC8xuSZAvts648xETPFVC90VKsKfsc+MRwEFGLOzyJZXHI+IxmF74N
         CAx7sPEOTTC4MaPl3WP7YpU15ctbxpO6Y0mf2TeQiF7c9l+Y3Jo01nSZxONNlFpsW9rO
         L5+6KYR4dFaKutAe6VSRtxFKGucEZP5Vg50Es/rOSnosux8zndohmL3swOm96mTFMIIs
         PSC2u4ur3DhEi8aZoO+LQadFCXWF1iCtHbJoYCeU2yKZj1Ggeh5PdqA9XlrOhPu+LZ6A
         y32A==
X-Gm-Message-State: AOAM533CxbAMzjhicd2ikhkKHb3MuozzQ1smfneuOzvohnEieMw0wbTc
        +h0NLEnblShwS/aW8B8Q8tlUSpOGa8fQl9Mv3JSsyJUedFXdpPdTN8zcM8cZ4XpxZGgxCqIXEfZ
        JdNqBBEVszZINbHk8
X-Received: by 2002:a17:906:840c:: with SMTP id n12mr4354642ejx.431.1621513021170;
        Thu, 20 May 2021 05:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYRlXW+ZzxjyWeSpV6egjtivjstTDXAl9TErIaluCjDw6hm9zvdw07z+DPMeDdbCwLW03zZw==
X-Received: by 2002:a17:906:840c:: with SMTP id n12mr4354633ejx.431.1621513021072;
        Thu, 20 May 2021 05:17:01 -0700 (PDT)
Received: from localhost (host-95-245-155-88.retail.telecomitalia.it. [95.245.155.88])
        by smtp.gmail.com with ESMTPSA id i25sm1327747eje.6.2021.05.20.05.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 05:17:00 -0700 (PDT)
Date:   Thu, 20 May 2021 14:16:56 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, mleitner@redhat.com
Subject: Re: [PATCH iproute2-next 0/2] tc: Add missing ct_state flags
Message-ID: <YKZTOM3bNJQjvwoC@renaissance-vector>
References: <20210520112518.15304-1-lariel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520112518.15304-1-lariel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 02:25:16PM +0300, Ariel Levkovich wrote:
> This short series is:
> 
> 1. Adding support for matching on ct_state flag rel in tc flower
> classifier.
> 
> 2. Adding some missing description of ct_state flags rpl and inv.
> 
> Ariel Levkovich (2):
>   tc: f_flower: Add option to match on related ct state
>   tc: f_flower: Add missing ct_state flags to usage description
> 
>  man/man8/tc-flower.8 | 2 ++
>  tc/f_flower.c        | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
Thanks, Ariel.

Acked-by: Andrea Claudi <aclaudi@redhat.com>

