Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E737C2845
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbfI3VIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:08:42 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39678 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732460AbfI3VIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:08:41 -0400
Received: by mail-io1-f66.google.com with SMTP id a1so42160273ioc.6
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8UG6ubf00QEBoj2u8S0MzAyUPZUDQ7ejqxWGw5PiB9E=;
        b=tk6TSzw8L2ILAFurzGi4KqD/3G+ELTBiGn/ns8G2LLDCcOcgq+4XeftXUrfNDzBqNl
         kFl9iP9fa3FEn7ChW6s+JWHKua1t1ZkKOUbbjQwaowxkC8pGLFcdOOZGBPuiOKRcmbmh
         pgKuP0KP9SpxyZkDDtFK2U4tjs7fKXmG916yXRXYSXkeBeLyAq9mu+M8bNSzmFhjeqbj
         HU46UcqNS4iJNw8NQOns5pjC6YfIJnd+oKRvFe7xga4McIUqUqZWUo4RY7NHvun3K+4i
         Q8nZ681uPENOKZmc3qPajCBxOlqcoe94Pu6sgmoTKgGQW/ctrg9XEIr7NDaippF1vZuB
         2e4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8UG6ubf00QEBoj2u8S0MzAyUPZUDQ7ejqxWGw5PiB9E=;
        b=SnuOjHkM016uIAzwparj1eXtQLh97AhzF9XoxqSXvCV9xsP6BF4ugA3JxIzzeLI1ca
         NJEBsGzz6nvf1RhtC7b/LrUZYqqCqmXIGNpU8+U/LWD/zDlfpZBPUGtUH2E0/jg2qW12
         NFhpDqhbZrkUNa0va2huUGv+x3F20JW4SXNrqCGWX+01LfwMnC/fiWPGkVssVBBWjFka
         FIjM3MrEnydcGCdwkhPgeLklukRN/vROp/wJHtGNgBOV+ZNnivj8afRVdjAW/JxVHFzN
         jeV0Zl2AJ2ytMGz/iR0oe5T62VJlg0CfrAFzI/f6WpEgUT8vIu+W64QFMp/4AYSj6GLd
         r42Q==
X-Gm-Message-State: APjAAAXqfDcVjjOh3LPwI/YvS+TuKhe1S7JVvPLVpu/KLbZCZ4qYDRIp
        obIub0gbd/xPM6azjHKJrawXUxZOrwU=
X-Google-Smtp-Source: APXvYqxoAIHCtD2x3pMB/55kf/9JqrPP46YGyZlS/Simp2lbX8WneKOKuIB2YfDnGTez2aNAhwtqtw==
X-Received: by 2002:a37:9fcd:: with SMTP id i196mr1631322qke.92.1569868678872;
        Mon, 30 Sep 2019 11:37:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b1sm6021904qtr.17.2019.09.30.11.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 11:37:58 -0700 (PDT)
Date:   Mon, 30 Sep 2019 11:37:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Adam Zerella <adam.zerella@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs: networking: Add title caret and missing doc
Message-ID: <20190930113754.5902855e@cakuba.netronome.com>
In-Reply-To: <20190928123917.GA6876@gmail.com>
References: <20190928123917.GA6876@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Sep 2019 22:39:17 +1000, Adam Zerella wrote:
> Resolving a couple of Sphinx documentation warnings
> that are generated in the networking section.
> 
> - WARNING: document isn't included in any toctree
> - WARNING: Title underline too short.
> 
> Signed-off-by: Adam Zerella <adam.zerella@gmail.com>
> ---
>  Documentation/networking/device_drivers/index.rst | 1 +
>  Documentation/networking/j1939.rst                | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
> index f51f92571e39..1f4a629e7caa 100644
> --- a/Documentation/networking/device_drivers/index.rst
> +++ b/Documentation/networking/device_drivers/index.rst
> @@ -24,6 +24,7 @@ Contents:
>     google/gve
>     mellanox/mlx5
>     pensando/ionic
> +   netronome/nfp

I wonder if it's worth keeping the entries in a roughly alphabetic
order?

>  .. only::  subproject and html
>  
> diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
> index ce7e7a044e08..dc60b13fcd09 100644
> --- a/Documentation/networking/j1939.rst
> +++ b/Documentation/networking/j1939.rst
> @@ -272,7 +272,7 @@ supported flags are:
>  * MSG_DONTWAIT, i.e. non-blocking operation.
>  
>  recvmsg(2)
> -^^^^^^^^^
> +^^^^^^^^^^
>  
>  In most cases recvmsg(2) is needed if you want to extract more information than
>  recvfrom(2) can provide. For example package priority and timestamp. The

