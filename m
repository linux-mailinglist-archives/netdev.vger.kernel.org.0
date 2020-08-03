Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E627E23A122
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgHCIiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgHCIix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 04:38:53 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90843C06174A;
        Mon,  3 Aug 2020 01:38:53 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id x24so2713198lfe.11;
        Mon, 03 Aug 2020 01:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=npiAot/ESE5mhly/NaC6fJlIGXLDCeDJyZ85G/ASWIU=;
        b=tmBmBbr7oGARNTJ1j3DW1ktq5cxSaT5AUui4HZEQw22InmC7w3mRMgM3YZI0sxxYIq
         3HPRbpfrMzib43mP50XuHVYLCuyRPU8S+W5uRdrgFlMTo99Vqwf1r5COYtXrNKhoHLtZ
         YMdCFj5wM9XOghbfngD1hOofNl3MvVW2fcj+FwoE9HjWys4uFviJ0bV9Oefcb1D+r0rV
         bQoAHgXasLhEr+5UhNx66i9BnuomgXjvIahd5Tbj/IBX0e4sQ0f2Y05UXzd5/prr7PMF
         OinXfHE20O+xI/dzThW1Ytim99j1eL7v6z1kaiWlluqEKCNlz98Z7NvDJAu1RkvF99uf
         Ai9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=npiAot/ESE5mhly/NaC6fJlIGXLDCeDJyZ85G/ASWIU=;
        b=HlYGOfZhWsBX5FdTJP5z+Z4wjJM4IzHx8mT1QlJ/74xiDOT1oo48CsLNGzC4uxTsZt
         CB91IhVvFlSlqA64Jt0zcFnkb22FJLKA50hgKYh2mBQvKCP/lD0pSTWISImDVfzuWZIg
         +cfysciInpfsnmvFjsWAtNBSqAateJfBXl3+OZdDDSMKydonKzRu2frgrYn9vrwSQPU4
         UDESmKT9r+eJe3OR5LwqAQjEm2rcn1Siu9B3bDxs4RYntz+PsYrUUD2/bf43LXkmv1Pp
         yD8EwAlzlbskjPBKKLYkYHRpQvr0x257+hLYgUCxkG1bSJoWnc7G2gsXTBHOE9mq7hIo
         sU8w==
X-Gm-Message-State: AOAM533CneLNmFXb0ZIYV+hU94x1p/XWUp3hbtvSjMCLw0PCB8susQQM
        m/uBHHl3/BvrzZcIfUTbGuQ=
X-Google-Smtp-Source: ABdhPJy+zto/pN/N51x74qxXDYQPUzbXI44kmi8sTGPRL+P65odKDO3+CPgYLAFpPpixQMB/sV7WcA==
X-Received: by 2002:a19:c806:: with SMTP id y6mr1590436lff.156.1596443930855;
        Mon, 03 Aug 2020 01:38:50 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:25e:e39f:415e:ce79:1f52:c7? ([2a00:1fa0:25e:e39f:415e:ce79:1f52:c7])
        by smtp.gmail.com with ESMTPSA id s9sm3958409ljh.46.2020.08.03.01.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 01:38:50 -0700 (PDT)
Subject: Re: [PATCH] qmi_wwan: support modify usbnet's rx_urb_size
To:     yzc666@netease.com, bjorn@mork.no
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, carl <carl.yin@quectel.com>
References: <20200803065105.8997-1-yzc666@netease.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <5a3c7567-da1a-7676-2516-de7681652643@gmail.com>
Date:   Mon, 3 Aug 2020 11:38:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200803065105.8997-1-yzc666@netease.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.08.2020 9:51, yzc666@netease.com wrote:
> From: carl <carl.yin@quectel.com>

    Prefrrably a full name, matching that one in the signoff tag.

> 
>      When QMUX enabled, the 'dl-datagram-max-size' can be 4KB/16KB/31KB depend on QUALCOMM's chipsets.

    No indentation here please, start at column 1 and respect the length limit 
of 75 columns as script/checkpatch.pl says...

>      User can set 'dl-datagram-max-size' by 'QMI_WDA_SET_DATA_FORMAT'.
>      The usbnet's rx_urb_size must lager than or equal to the 'dl-datagram-max-size'.
>      This patch allow user to modify usbnet's rx_urb_size by next command.
> 
> 		echo 4096 > /sys/class/net/wwan0/qmi/rx_urb_size
> 
> 		Next commnds show how to set and query 'dl-datagram-max-size' by qmicli
> 		# qmicli -d /dev/cdc-wdm1 --wda-set-data-format="link-layer-protocol=raw-ip, ul-protocol=qmap,
> 				dl-protocol=qmap, dl-max-datagrams=32, dl-datagram-max-size=31744, ep-type=hsusb, ep-iface-number=4"
> 		[/dev/cdc-wdm1] Successfully set data format
> 		                        QoS flow header: no
> 		                    Link layer protocol: 'raw-ip'
> 		       Uplink data aggregation protocol: 'qmap'
> 		     Downlink data aggregation protocol: 'qmap'
> 		                          NDP signature: '0'
> 		Downlink data aggregation max datagrams: '10'
> 		     Downlink data aggregation max size: '4096'
> 
> 	    # qmicli -d /dev/cdc-wdm1 --wda-get-data-format
> 		[/dev/cdc-wdm1] Successfully got data format
> 		                   QoS flow header: no
> 		               Link layer protocol: 'raw-ip'
> 		  Uplink data aggregation protocol: 'qmap'
> 		Downlink data aggregation protocol: 'qmap'
> 		                     NDP signature: '0'
> 		Downlink data aggregation max datagrams: '10'
> 		Downlink data aggregation max size: '4096'
> 
> Signed-off-by: carl <carl.yin@quectel.com>

    Need your full name.

> ---
>   drivers/net/usb/qmi_wwan.c | 39 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 39 insertions(+)
> 
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 07c42c0719f5b..8ea57fd99ae43 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -400,6 +400,44 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
>   	return ret;
>   }
>   
> +static ssize_t rx_urb_size_show(struct device *d, struct device_attribute *attr, char *buf)
> +{
> +	struct usbnet *dev = netdev_priv(to_net_dev(d));
> +
> +	return sprintf(buf, "%zd\n", dev->rx_urb_size);

   Is dev->rx_urb_size really declared as size_t?

> +}
> +
> +static ssize_t rx_urb_size_store(struct device *d,  struct device_attribute *attr,
> +				 const char *buf, size_t len)
> +{
> +	struct usbnet *dev = netdev_priv(to_net_dev(d));
> +	u32 rx_urb_size;

    ... in this case, sholdn't this variable be also declared as size_t?

> +	int ret;
> +
> +	if (kstrtou32(buf, 0, &rx_urb_size))
> +		return -EINVAL;
> +
> +	/* no change? */
> +	if (rx_urb_size == dev->rx_urb_size)
> +		return len;
> +
> +	if (!rtnl_trylock())
> +		return restart_syscall();
> +
> +	/* we don't want to modify a running netdev */
> +	if (netif_running(dev->net)) {
> +		netdev_err(dev->net, "Cannot change a running device\n");
> +		ret = -EBUSY;
> +		goto err;
> +	}
> +
> +	dev->rx_urb_size = rx_urb_size;
> +	ret = len;
> +err:
> +	rtnl_unlock();
> +	return ret;
> +}
> +
>   static ssize_t add_mux_show(struct device *d, struct device_attribute *attr, char *buf)
>   {
>   	struct net_device *dev = to_net_dev(d);
> @@ -505,6 +543,7 @@ static DEVICE_ATTR_RW(add_mux);
>   static DEVICE_ATTR_RW(del_mux);
>   
>   static struct attribute *qmi_wwan_sysfs_attrs[] = {
> +	&dev_attr_rx_urb_size.attr,
>   	&dev_attr_raw_ip.attr,
>   	&dev_attr_add_mux.attr,
>   	&dev_attr_del_mux.attr,
> 

