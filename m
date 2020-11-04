Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EE22A63D0
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgKDMBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:01:00 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36584 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgKDMBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:01:00 -0500
Received: by mail-wr1-f67.google.com with SMTP id x7so21774894wrl.3;
        Wed, 04 Nov 2020 04:00:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QUSmpWIO++p+EaBmzWHWB9j11K6ZCt/BSPj+8TR1MOs=;
        b=f79KrGMlxesFNUiOai4quZrkJvRhdOFnvzrETivqjHFMtCbXF+7sqSw5i0S2+YOJwJ
         kCR6BxySGkumQ6dzoW5XcqE5iCWx3Q0ZcYE/36sUWSUs3tbm95Hi+udJDAcwgqZ0jFnV
         aio1ogK+jqv9C0wn1dx6F4MHTI6zmwIjsLA3HPwj8h9mzpTs6UeQzr5wCAq/o+mJ2dc0
         jU+wHxEw35yGmUy5ta0dGPKjsG+6kxFFJ8lVNgRMFJYgY3OaSY0F2CV3AhhzFv4PltPP
         me6GDiwdgTAyDpl1jIjEA1+3Y7QQtBT8E2s+eyNS4hlrOFP1EgW2IQbUo/cRFVXQmHIA
         rXyw==
X-Gm-Message-State: AOAM532PAfKpeDsPVCZuYOcj3iwuPInKOZpdc5H7eHG7dMFErKqM2kjD
        +ukalBdj3VL27kGyXsf8gNM=
X-Google-Smtp-Source: ABdhPJyP8064AZcp00/CMnWH1Yf6wcBkvvv9giu/iKtPrEyY0N09EFUoBTXsieznUVpGwXIewZnkPQ==
X-Received: by 2002:a5d:4148:: with SMTP id c8mr31429901wrq.261.1604491256613;
        Wed, 04 Nov 2020 04:00:56 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id t199sm1871437wmt.46.2020.11.04.04.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 04:00:56 -0800 (PST)
Date:   Wed, 4 Nov 2020 12:00:54 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 05/12] net: xen-netback: xenbus: Demote nonconformant
 kernel-doc headers
Message-ID: <20201104120054.jaukbhblpooi5hwf@liuwe-devbox-debian-v2>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-6-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104090610.1446616-6-lee.jones@linaro.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:06:03AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'dev' not described in 'frontend_changed'
>  drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'frontend_state' not described in 'frontend_changed'
>  drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'dev' not described in 'netback_probe'
>  drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'id' not described in 'netback_probe'
> 
> Cc: Wei Liu <wei.liu@kernel.org>

If this is ever needed:

Acked-by: Wei Liu <wei.liu@kernel.org>
