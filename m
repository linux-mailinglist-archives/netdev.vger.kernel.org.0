Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E29D37DD2
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfFFUG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:06:28 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40989 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfFFUG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:06:28 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so5050592eds.8;
        Thu, 06 Jun 2019 13:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fKoBABNUkCBeoWcN3BB4mAKSq62cz70yQSacxGxsGFc=;
        b=NDCKEI/RYiZCejraQ4pA3/blft0AGjyUEblNUUYKerTg8wmYi8n93ZXUNAUpJCKF3z
         20X0CM2nsNucYryIixtGheZZNLlIk7HbS+1JTXdITy8utZREwu9KjGSE63vkSpB7890K
         VDQAkCjGnSDYE3bS74Q+dbwBlWsQqX+dNOWBiUt5pMEvXRV63aufujwZsed+3BJq3vbb
         ZlfAqHz3TlzljUxZACUgRZARSB2qug1H3SO4ou+4sa9S4bkgyupCoeAE3bN/pbRq+1zG
         eiZHVv6/Kdsev1X8QP2yTRePtDdx1rmuqvTvM/xfBTp0Vb+gQrusWhynOXMOrd7N1FkP
         1zWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fKoBABNUkCBeoWcN3BB4mAKSq62cz70yQSacxGxsGFc=;
        b=DEL2VMEXXK5J8q9BrwTsDaxQw8TxhNjBCmSvn5DTQ6s1PvZGQFuiVFeMc3wvyetQQS
         IqUhK4AvoCz4VNHgyWNTXoD1UEx8IPu5Xot9KWqQqVZN+vCp0N6SM1L9FmfPgbn5EtUh
         saQT9AwxSDO/896IqwZjcreENq+LSpcc9cY5FmnW9R4aEfwDWSJliG+GKlAAqrf87/BK
         O1WqelbqrP8fnwMzsWkduyERoHX3vsLaCCDQ4epmPYzeL4pLAzkVIXdF2wMVJEmq6WuL
         MIhCb9BR62jq9B8c/PNsk2k0/u/64kdKDugRP7kvTqDyEInsrVYpNeaay0kxy0gmQCQN
         YJDQ==
X-Gm-Message-State: APjAAAXvSDeFwA11sRvEI6qbomrQ5PeglnkKRvan8q/rOB8d/yWJmIDN
        VegDh2+ecNWZzvRPDTKCtcI=
X-Google-Smtp-Source: APXvYqx7REg+H//KW6T/w1Ar/5mEf3ZqsGGG5JRSRXtG5RKWIoZSD9VJF2oR+CPvdQkvfQak4CXcVw==
X-Received: by 2002:a17:906:3551:: with SMTP id s17mr42857015eja.19.1559851586295;
        Thu, 06 Jun 2019 13:06:26 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id c21sm1735ejk.79.2019.06.06.13.06.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 13:06:25 -0700 (PDT)
Date:   Thu, 6 Jun 2019 13:06:23 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] vhost: Don't use defined in VHOST_ARCH_CAN_ACCEL_UACCESS
 definition
Message-ID: <20190606200623.GA12580@archlinux-epyc>
References: <20190606161223.67979-1-natechancellor@gmail.com>
 <20190606142606-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606142606-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 02:28:55PM -0400, Michael S. Tsirkin wrote:
> I'd prefer just changing the definition.
> ifdefs have a disadvantage that it's easy to get
> wrong code if you forget to include a header.
> 
> I queued the below - pls confirm it works for you.

Fine by me, I figured that might be preferred (since clang will warn if
VHOST_ARCH_CAN_ACCEL_UACCESS is not defined so you'd know if the header
was forgotten). Thank you for the fix :)

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>

> 
> 
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index c5d950cf7627..819296332913 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -95,8 +95,11 @@ struct vhost_uaddr {
>  	bool write;
>  };
>  
> -#define VHOST_ARCH_CAN_ACCEL_UACCESS defined(CONFIG_MMU_NOTIFIER) && \
> -	ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
> +#if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
> +#define VHOST_ARCH_CAN_ACCEL_UACCESS 1
> +#else
> +#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
> +#endif
>  
>  /* The virtqueue structure describes a queue attached to a device. */
>  struct vhost_virtqueue {
