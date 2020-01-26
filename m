Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E44149C5F
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 19:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgAZSzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 13:55:24 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46855 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZSzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 13:55:23 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so2927173pll.13
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 10:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SwkUwKYIYvLUqX5JaWLXfEVl6YlHqss44QQbPFczvoA=;
        b=5AfoRmiQo00AZ3wCsaekrCQmEDM91vVTOJpso5+ZXBQvvyf04qCa0HqC+f1AP0Cenp
         uSKOX+t/9sI6VyHYq17WFP4tJNF84jrk1dSnffsZgfH63NyL0HRQbpBzNBVB32HaqNbV
         5o157eRxEDDBlxh1OuihQj60I1fXNeBjr+DwPHWO1rRjwciUAPvoFPEAFhzRQw1wFxj7
         H2UufXMCeu6DJU9aO/jwKCJWdmCZPy97EtVHdFQg6erZY+r5+JCBs3DnE9WFzsaXSFZR
         w/v6tBIu0ORf5FTXdt31F/MAQvF7BRerahPwN2I47WaZABgn9feaUGvBqGKZ+4u57lIx
         Y8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SwkUwKYIYvLUqX5JaWLXfEVl6YlHqss44QQbPFczvoA=;
        b=GaKHtCeZmdzc6SALrDT1teFdYLZGH2KeBUZPOuPN+kHW82N4XlmvtkkEC33fnB0JMC
         9Ye36/sJESE+Q24n3JUIWPazO3jjj5316g0spK1Lb2wV1NFmvEP5MnNSFl5Ftat1x1Eo
         VtKzCpDlyAlDqg8D1iXsxHjCDs97BueLHv45psTMeL5oJAbbo9YLmj7XPwbtrYc2Kljf
         WPdublDRTMhjmfJEdKn7ol61/dKsGARj+BNK2Yrt75v4OC5kNHSnKUnOGwN5KPqUP1SE
         fl50qtWCMf3VGrGFvH4h+HZaFMknc5ScS9UuV0YnhxxASozYES73wB03pu2cbGpTsHZS
         2Nwg==
X-Gm-Message-State: APjAAAXMsHD0VflFSUePH6KZzZH76Dt6Sk1dSA+qxv082RU8qgR5MNMQ
        wIIDpZv6L/52+N2s7xlvnJXeHj1dnoXLqw==
X-Google-Smtp-Source: APXvYqxRaXVAnSukkGVGodMg09oPLJgO0PUjp7Nnhym1S35cDxgomDzeIJ4/L3Yl5/7tLwyYw+T5pg==
X-Received: by 2002:a17:902:904c:: with SMTP id w12mr14649211plz.35.1580064922790;
        Sun, 26 Jan 2020 10:55:22 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id s1sm12871406pgv.87.2020.01.26.10.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 10:55:22 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
Message-ID: <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
Date:   Sun, 26 Jan 2020 10:56:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200123130541.30473-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 5:05 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky<leonro@mellanox.com>
>
> In order to stop useless driver version bumps and unify output
> presented by ethtool -i, let's overwrite the version string.
>
> Before this change:
> [leonro@erver ~]$ ethtool -i eth0
> driver: virtio_net
> version: 1.0.0
> After this change:
> [leonro@server ~]$ ethtool -i eth0
> driver: virtio_net
> version: 5.5.0-rc6+
>
> Signed-off-by: Leon Romanovsky<leonro@mellanox.com>
> ---
> I wanted to change to VERMAGIC_STRING, but the output doesn't
> look pleasant to my taste and on my system is truncated to be
> "version: 5.5.0-rc6+ SMP mod_unload modve".
>
> After this patch, we can drop all those version assignments
> from the drivers.
>
> Inspired by nfp and hns code.
> ---
>   net/core/ethtool.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index cd9bc67381b2..3c6fb13a78bf 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -17,6 +17,7 @@
>   #include <linux/phy.h>
>   #include <linux/bitops.h>
>   #include <linux/uaccess.h>
> +#include <linux/vermagic.h>
>   #include <linux/vmalloc.h>
>   #include <linux/sfp.h>
>   #include <linux/slab.h>
> @@ -776,6 +777,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
>   		return -EOPNOTSUPP;
>   	}
>
> +	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
> +
>   	/*
>   	 * this method of obtaining string set info is deprecated;
>   	 * Use ETHTOOL_GSSET_INFO instead.
> --
> 2.20.1
>

First of all, although I've seen some of the arguments about distros and 
their backporting, I still believe that the driver version number is 
useful.  In most cases it at least gets us in the ballpark of what 
generation the driver happens to be and is still useful. I'd really 
prefer that it is just left alone for the device manufactures and their 
support folks to deal with.

Fine, I'm sure I lose that argument since there's already been plenty of 
discussion about it.

Meanwhile, there is some non-zero number of support scripts and 
processes, possibly internal testing chains, that use that driver/vendor 
specific version information and will be broken by this change.  Small 
number?  Large number?  I don't know, but we're breaking them.

Sure, I probably easily lose that argument too, but it still should be 
stated.

This will end up affecting out-of-tree drivers as well, where it is 
useful to know what the version number is, most especially since it is 
different from what the kernel provided driver is.  How else are we to 
get this information out to the user?  If this feature gets squashed, 
we'll end up having to abuse some other mechanism so we can get the live 
information from the driver, and probably each vendor will find a 
different way to sneak it out, giving us more chaos than where we 
started.  At least the ethtool version field is a known and consistent 
place for the version info.

Of course, out-of-tree drivers are not first class citizens, so I 
probably lose that argument as well.

So if you are so all fired up about not allowing the drivers to report 
their own version number, then why report anything at all? Maybe just 
report a blank field.  As some have said, the uname info is already 
available else where, why are we sticking it here?

Personally, I think this is a rather arbitrary, heavy handed and 
unnecessary slam on the drivers, and will make support more difficult in 
the long run.

sln

