Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B66149FE2
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgA0IbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:31:08 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40031 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgA0IbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 03:31:07 -0500
Received: by mail-pj1-f66.google.com with SMTP id 12so1409846pjb.5
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 00:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=awPROk4SsGjpTvApNjNWcP8+DHFatBpFC1zasBo2Y0U=;
        b=itclDd248DMvDEFDSHfCW1Z+t96Z86nJn7qJ60CxOVK9yiKKDBxNC0qUvME/65IQ2m
         sItojReh0hb7YZXysnO2g2uK867Ibm0K+xhSkg8sb/yXkjnunkZFIdObAJzo2nf+LmJH
         C8c/+gE/awnigMmBJVW60bS2uz2ndx2BPkE9urz6F3PccHr1LkHdVHLw9lLhXrhI/lrh
         6rZAqIKHg6PfTPr2kY/9HQ+WKasSbETWHuLO0YDxty3hWyBob9OniXNZRt3aHI2Uf6gu
         zkBObAEJMWczz/VWizvQP3zrzFG9Yalg9YJqWCXYpG5yI/7mI0Dz46Ca0jNDwWC0rpfR
         eukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=awPROk4SsGjpTvApNjNWcP8+DHFatBpFC1zasBo2Y0U=;
        b=iisSXfzMevq7vFhVHrf3qvGBysvJRKw1aKuYSMZ6/bPoGHNL/ukzTyiwL13Ic/4mCJ
         Cdd5Wi429YV9J6C2yRD5+oRpxJ6W+y8Liu6hNZcBUbKEVGVM8YOoDk65UnR8hZZBzqma
         Ac8TT1FroWXwVQ4fQ5vduDh9VKyTEPf5/kFtEqxiz/gXcFRxZkUK7BjGF/5fdZ5W7Mpq
         /YgavcCUs2kPjCRhCCtGwfYysg2u2gdjZpejKXyJJAu7KUHQ5P8JHmB6T8B2j8+nfYNR
         cwE1zGSAIf0E2Zg+NlwwHGq9JukGUU714E3jf4H2eDqmdAuIRRzEDZ0kWl0ZflleLnjA
         xFxg==
X-Gm-Message-State: APjAAAXYDEnldev3PYCekX/4SdYyVycr8PXDq15EM86/QAgWiHdyZyvg
        QQeSx63rVKilhB6uWgLJ70QtXw==
X-Google-Smtp-Source: APXvYqxy/teUoTvUqEaafc/ZwBdaXb8i05urjXU3BhLm06QZDnFKVYExD7Rw1WCyCc+q+TgUGeVr9w==
X-Received: by 2002:a17:90a:f0cf:: with SMTP id fa15mr1359484pjb.94.1580113866435;
        Mon, 27 Jan 2020 00:31:06 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id z30sm14986752pff.131.2020.01.27.00.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 00:31:05 -0800 (PST)
Subject: Re: [PATCH net-next v4] net/core: Replace driver version to be kernel
 version
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200127072028.19123-1-leon@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <c6dedfe5-d284-f38e-c5c8-ff82047f650d@pensando.io>
Date:   Mon, 27 Jan 2020 00:32:01 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200127072028.19123-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 11:20 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> In order to stop useless driver version bumps and unify output
> presented by ethtool -i, let's set default version string.
>
> As Linus said in [1]: "Things are supposed to be backwards and
> forwards compatible, because we don't accept breakage in user
> space anyway. So versioning is pointless, and only causes
> problems."
>
> They cause problems when users start to see version changes
> and expect specific set of features which will be different
> for stable@, vanilla and distribution kernels.
>
> Distribution kernels are based on some kernel version with extra
> patches on top, for example, in RedHat world this "extra" is a lot
> and for them your driver version say nothing. Users who run vanilla
> kernels won't use driver version information too, because running
> such kernels requires knowledge and understanding.
>
> Another set of problems are related to difference in versioning scheme
> and such doesn't allow to write meaningful automation which will work
> sanely on all ethtool capable devices.
>
> Before this change:
> [leonro@erver ~]$ ethtool -i eth0
> driver: virtio_net
> version: 1.0.0
> After this change and once ->version assignment will be deleted
> from virtio_net:
> [leonro@server ~]$ ethtool -i eth0
> driver: virtio_net
> version: 5.5.0-rc6+
>
> Link: https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/
> Link: https://lore.kernel.org/linux-rdma/20200122152627.14903-1-michal.kalderon@marvell.com/T/#md460ff8f976c532a89d6860411c3c50bb811038b
> Link: https://lore.kernel.org/linux-rdma/20200127060835.GA570@unicorn.suse.cz
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>   Changelog:
>   v4: Set default driver version prior to calling ->get_drvinfo(). This will allow
>       us to remove all in-the-tree version assignments, while keeping ability
>       to overwrite it for out-of-tree drivers.
>   v3: https://lore.kernel.org/linux-rdma/20200126105422.86969-1-leon@kernel.org
>       Used wrong target branch, changed from rdma-next to net-next.
>   v2: https://lore.kernel.org/linux-rdma/20200126100124.86014-1-leon@kernel.org
>       Updated commit message.
>   v1: https://lore.kernel.org/linux-rdma/20200125161401.40683-1-leon@kernel.org
>       Resend per-Dave's request
>       https://lore.kernel.org/linux-rdma/20200125.101311.1924780619716720495.davem@davemloft.net
>       No changes at all and applied cleanly on top of "3333e50b64fe Merge branch 'mlxsw-Offload-TBF'"
>   v0: https://lore.kernel.org/linux-rdma/20200123130541.30473-1-leon@kernel.org
> ---
>   net/ethtool/ioctl.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 182bffbffa78..0501b615e920 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -17,6 +17,7 @@
>   #include <linux/phy.h>
>   #include <linux/bitops.h>
>   #include <linux/uaccess.h>
> +#include <linux/vermagic.h>
>   #include <linux/vmalloc.h>
>   #include <linux/sfp.h>
>   #include <linux/slab.h>
> @@ -655,6 +656,7 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
>
>   	memset(&info, 0, sizeof(info));
>   	info.cmd = ETHTOOL_GDRVINFO;
> +	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
>   	if (ops->get_drvinfo) {
>   		ops->get_drvinfo(dev, &info);
>   	} else if (dev->dev.parent && dev->dev.parent->driver) {
> --
> 2.24.1
>
I can work with this - thanks.

Acked-by: Shannon Nelson <snelson@pensando.io>


