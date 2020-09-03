Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D58A25CDBE
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgICWk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgICWk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:40:57 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0756AC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:40:57 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id h11so4651412ilj.11
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 15:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6vO52kM7+CgWooNDmbE4rJP2O+8wO8JVZ+LsbdjSdEw=;
        b=qQfnMphz7IKSeGoX3EyYhL9xgfUOpEcmptBRqGMNax3bzYGdrM4hp8gbdp2ggFlH/1
         4iB0++1vkMAcP6VEQw5CPJPf9RCadcJ0wK9Rqufm6Jer4gZI9zs31NG/DDNIKYk2Gk0k
         sN38GigBdTDBqthQVN8XoG9r23n1LhOiVS8r8MHK1SO3Tq8umUP/A2irRSZCFjiGkLn9
         ZzSIsuC/uyXtGOy+GsKJzw584X3HVB/FcTIeAb0NfDngniSYKoTtgy5dVsSb0C40qZbT
         ykcA9wsqIbwje7OYcYDBM5RgslnrI14EEwg+32f3VrbmU0Ba8yBeGisJAv/H/jYpy1gR
         GjZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6vO52kM7+CgWooNDmbE4rJP2O+8wO8JVZ+LsbdjSdEw=;
        b=WzVO7yUaTz8Ytj06k5W3qUnfIM/tpfXecR+SyPnknZa48BYkF9oFqy9aLayut35N23
         hB/pddQU0RS3kcXADtkIAq4n5SmKRaFVoR1kow3iOmtkelEIqn1wQI+E5T0LGz+rKL97
         67cTJqKtDHJrOys9jup1vgfzzv5QhN8+Ua/Hpq0t91Py2YgROHSG5HoQRV3F0IabjOJv
         DpflHmTV2l7CtM6Pyrvt1JWfyWk5cFDYkVLjXN41z/eP+jWnHWmTGnDRWUdSrb811B8d
         ChTI1iCNcJYaJMzGZHvGN/mGv3gi9CWbm6vAOT82BO9iDDdVz47v/YG4j66uP4Bz801z
         lf/A==
X-Gm-Message-State: AOAM531+wXSd1XJIJIOdBgaO/a8iVjpSX9VxHzURWIdo+zTW7vRqUP2C
        wkv98XcEvWo7YcbebkRYiJU=
X-Google-Smtp-Source: ABdhPJxNnWd8510JuH3uTyuJOREp4E0I60+4Q6Y+N9nqcZ1RP0gd1nXjxXwfQUHhOLbqVls+jvRZgg==
X-Received: by 2002:a92:6c06:: with SMTP id h6mr5396825ilc.49.1599172856291;
        Thu, 03 Sep 2020 15:40:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f0f5:2ac7:fcf1:16a7])
        by smtp.googlemail.com with ESMTPSA id l144sm2219229ill.6.2020.09.03.15.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 15:40:55 -0700 (PDT)
Subject: Re: [PATCH net-next] net: tighten the definition of interface
 statistics
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jwi@linux.ibm.com, f.fainelli@gmail.com,
        andrew@lunn.ch, mkubecek@suse.cz, edwin.peer@broadcom.com,
        michael.chan@broadcom.com, saeedm@mellanox.com,
        rmk+kernel@armlinux.org.uk
References: <20200903020336.2302858-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <01db6af0-611d-2391-d661-60cfb4ba2031@gmail.com>
Date:   Thu, 3 Sep 2020 16:40:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903020336.2302858-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 8:03 PM, Jakub Kicinski wrote:
> diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
> new file mode 100644
> index 000000000000..487b17c166e8
> --- /dev/null
> +++ b/Documentation/networking/statistics.rst

...

> +
> +sysfs
> +-----
> +
> +Each device directory in sysfs contains a `statistics` directory (e.g.
> +`/sys/class/net/lo/statistics/`) with files corresponding to
> +members of :c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`.
> +
> +This simple interface is convenient especially in constrained/embedded
> +environments without access to tools. However, it's sightly inefficient

sightly seems like the wrong word. Did you mean 'highly inefficient'?

> +when reading multiple stats as it internally performs a full dump of
> +:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`
> +and reports only the stat corresponding to the accessed file.
> +
> +Sysfs files are documented in
> +`Documentation/ABI/testing/sysfs-class-net-statistics`.
> +
> +
> +netlink
> +-------
> +
> +`rtnetlink` (`NETLINK_ROUTE`) is the preferred method of accessing
> +:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>` stats.
> +
> +Statistics are reported both in the responses to link information
> +requests (`RTM_GETLINK`) and statistic requests (`RTM_GETSTATS`,
> +when `IFLA_STATS_LINK_64` bit is set in the `.filter_mask` of the request).
> +
> +ethtool
> +-------
> +
> +Ethtool IOCTL interface allows drivers to report implementation
> +specific statistics.

an example here would be helpful. e.g., I use `ethool -S` primarily for
per queue stats which show more details than the other APIs which show
aggregated stats.



> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 7fba4de511de..6ea0fb48739e 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -40,26 +40,191 @@ struct rtnl_link_stats {
>  	__u32	rx_nohandler;		/* dropped, no handler found	*/
>  };
>  
> -/* The main device statistics structure */
> +/**
> + * struct rtnl_link_stats64 - The main device statistics structure.
> + *
> + * @rx_packets: Number of good packets received by the interface.
> + *   For hardware interfaces counts all good packets seen by the host,> + *   including packets which host had to drop at various stages of
processing
> + *   (even in the driver).
> + *
> + * @tx_packets: Number of packets successfully transmitted.
> + *   For hardware interfaces counts packets which host was able to successfully
> + *   hand over to the device, which does not necessarily mean that packets
> + *   had been successfully transmitted out of the device, only that device
> + *   acknowledged it copied them out of host memory.
> + *
> + * @rx_bytes: Number of good incoming bytes, corresponding to @rx_packets.

s/incoming/received/?

> + *
> + * @tx_bytes: Number of good incoming bytes, corresponding to @tx_packets.

s/incoming/transmitted/

Thanks for taking the time to work on this; I'm sure you spent a LOT of
hours going through all of the drivers and APIs.

