Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADEC3104
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfJAKMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:12:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54373 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbfJAKMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:12:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so2658575wmp.4
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 03:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8hy45pyP7kv6EXfVxQmzNrFK2VbFBW1Lka/Gmb0X5J0=;
        b=J7AYTjPqD5jXOPq7aic9RA8CQUOWh4TzXM79Ki6WY5pV+NU0lcnsopzWRK734enmtS
         aIN8K2zIIsNuDNokBRn5ANOCSDxrJASgmDumtnQiAFlKDHCYPR9QLokvRL1+7pI+r5eG
         EgGd8Zbkw0NIMKrY90aFXTCqcOLlhj0wWeSYELbaGGKRRS1HeVoTBbyueR2JdfkEsQ8r
         6x2jjpafrgoFux01vRuGQqxDlqebtdUR0AK8nda/osYxrW+JA9rma3mZbCbek0UG6lT1
         jg0Gi4EF4iTC25c+QTBfhRILf7Zc2pdnFte2FmXGPfpyRrxO8+pWrfYewQD8hrKfCeH9
         f29w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hy45pyP7kv6EXfVxQmzNrFK2VbFBW1Lka/Gmb0X5J0=;
        b=lICL1pjsxMrA1Mx/J711E5F7ml7AiX0JGFNLAkGzC2mDH++ySsUGyC+llMD1RmRy48
         1r52sbPFPIG6EKYb6+kYIGha9hL+/dM12uyLrZchhAsXMHE+luvVfpSNiSAk6Lkz4a2q
         hVQsBAWcG4mobkh/IUctlP5gXXVOmwyryzQ79GuZGpZOcxB19vWp+725B1rktxfXHSds
         hOnxt1KQ6Ip7h8eITjkoS3NjDTQquIwBbUTyWpXCEX88zWy4Eq/3ozWd/a/uX3n5aE1j
         EN6nD3TRU+UgCQIcpDF4fmzMtkSwu7XDkYlRMvXkjOVR5DAGTVMisEI3qJ/k3REBhH+v
         7vcA==
X-Gm-Message-State: APjAAAXYl0FlxxHjDlXpXLMMrIIE9EtZz7y42XEVvtFcSPdv5OHnZPp1
        mL53UAZ1HkoJtc0TP4OYgOp1jQ==
X-Google-Smtp-Source: APXvYqyce6kLiNa02VTrU6yr/ckelEv9Vwx7Pd1FX7YNYnZ2gxLu2G+aiD+MbyaODltXlPmlKz4Vqg==
X-Received: by 2002:a7b:cf12:: with SMTP id l18mr3198121wmg.25.1569924720081;
        Tue, 01 Oct 2019 03:12:00 -0700 (PDT)
Received: from [192.168.86.34] (cpc89974-aztw32-2-0-cust43.18-1.cable.virginm.net. [86.30.250.44])
        by smtp.googlemail.com with ESMTPSA id r2sm4155309wma.1.2019.10.01.03.11.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 03:11:59 -0700 (PDT)
Subject: Re: [PATCH v6 1/4] nvmem: core: add nvmem_device_find
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <20190923114636.6748-1-tbogendoerfer@suse.de>
 <20190923114636.6748-2-tbogendoerfer@suse.de>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <ce44c762-f9a6-b4ef-fa8a-19ee4a6d391f@linaro.org>
Date:   Tue, 1 Oct 2019 11:11:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923114636.6748-2-tbogendoerfer@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/09/2019 12:46, Thomas Bogendoerfer wrote:
> nvmem_device_find provides a way to search for nvmem devices with
> the help of a match function simlair to bus_find_device.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---


Thanks for the patch,
This patch looks good for me.

Do you know which tree is going to pick this series up?

I can either apply this patch to nvmem tree

or here is my Ack for this patch to take it via other trees.

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


--srini
>   Documentation/driver-api/nvmem.rst |  2 ++
>   drivers/nvmem/core.c               | 61 +++++++++++++++++---------------------
>   include/linux/nvmem-consumer.h     |  9 ++++++
>   3 files changed, 38 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/driver-api/nvmem.rst b/Documentation/driver-api/nvmem.rst
> index d9d958d5c824..287e86819640 100644
> --- a/Documentation/driver-api/nvmem.rst
> +++ b/Documentation/driver-api/nvmem.rst
> @@ -129,6 +129,8 @@ To facilitate such consumers NVMEM framework provides below apis::
>     struct nvmem_device *nvmem_device_get(struct device *dev, const char *name);
>     struct nvmem_device *devm_nvmem_device_get(struct device *dev,
>   					   const char *name);
> +  struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data));
>     void nvmem_device_put(struct nvmem_device *nvmem);
>     int nvmem_device_read(struct nvmem_device *nvmem, unsigned int offset,
>   		      size_t bytes, void *buf);
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index 057d1ff87d5d..9f1ee9c766ec 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -76,33 +76,6 @@ static struct bus_type nvmem_bus_type = {
>   	.name		= "nvmem",
>   };
>   
> -static struct nvmem_device *of_nvmem_find(struct device_node *nvmem_np)
> -{
> -	struct device *d;
> -
> -	if (!nvmem_np)
> -		return NULL;
> -
> -	d = bus_find_device_by_of_node(&nvmem_bus_type, nvmem_np);
> -
> -	if (!d)
> -		return NULL;
> -
> -	return to_nvmem_device(d);
> -}
> -
> -static struct nvmem_device *nvmem_find(const char *name)
> -{
> -	struct device *d;
> -
> -	d = bus_find_device_by_name(&nvmem_bus_type, NULL, name);
> -
> -	if (!d)
> -		return NULL;
> -
> -	return to_nvmem_device(d);
> -}
> -
>   static void nvmem_cell_drop(struct nvmem_cell *cell)
>   {
>   	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_CELL_REMOVE, cell);
> @@ -532,13 +505,16 @@ int devm_nvmem_unregister(struct device *dev, struct nvmem_device *nvmem)
>   }
>   EXPORT_SYMBOL(devm_nvmem_unregister);
>   
> -static struct nvmem_device *__nvmem_device_get(struct device_node *np,
> -					       const char *nvmem_name)
> +static struct nvmem_device *__nvmem_device_get(void *data,
> +			int (*match)(struct device *dev, const void *data))
>   {
>   	struct nvmem_device *nvmem = NULL;
> +	struct device *dev;
>   
>   	mutex_lock(&nvmem_mutex);
> -	nvmem = np ? of_nvmem_find(np) : nvmem_find(nvmem_name);
> +	dev = bus_find_device(&nvmem_bus_type, NULL, data, match);
> +	if (dev)
> +		nvmem = to_nvmem_device(dev);
>   	mutex_unlock(&nvmem_mutex);
>   	if (!nvmem)
>   		return ERR_PTR(-EPROBE_DEFER);
> @@ -587,7 +563,7 @@ struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
>   	if (!nvmem_np)
>   		return ERR_PTR(-ENOENT);
>   
> -	return __nvmem_device_get(nvmem_np, NULL);
> +	return __nvmem_device_get(nvmem_np, device_match_of_node);
>   }
>   EXPORT_SYMBOL_GPL(of_nvmem_device_get);
>   #endif
> @@ -613,10 +589,26 @@ struct nvmem_device *nvmem_device_get(struct device *dev, const char *dev_name)
>   
>   	}
>   
> -	return __nvmem_device_get(NULL, dev_name);
> +	return __nvmem_device_get((void *)dev_name, device_match_name);
>   }
>   EXPORT_SYMBOL_GPL(nvmem_device_get);
>   
> +/**
> + * nvmem_device_find() - Find nvmem device with matching function
> + *
> + * @data: Data to pass to match function
> + * @match: Callback function to check device
> + *
> + * Return: ERR_PTR() on error or a valid pointer to a struct nvmem_device
> + * on success.
> + */
> +struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data))
> +{
> +	return __nvmem_device_get(data, match);
> +}
> +EXPORT_SYMBOL_GPL(nvmem_device_find);
> +
>   static int devm_nvmem_device_match(struct device *dev, void *res, void *data)
>   {
>   	struct nvmem_device **nvmem = res;
> @@ -710,7 +702,8 @@ nvmem_cell_get_from_lookup(struct device *dev, const char *con_id)
>   		if ((strcmp(lookup->dev_id, dev_id) == 0) &&
>   		    (strcmp(lookup->con_id, con_id) == 0)) {
>   			/* This is the right entry. */
> -			nvmem = __nvmem_device_get(NULL, lookup->nvmem_name);
> +			nvmem = __nvmem_device_get((void *)lookup->nvmem_name,
> +						   device_match_name);
>   			if (IS_ERR(nvmem)) {
>   				/* Provider may not be registered yet. */
>   				cell = ERR_CAST(nvmem);
> @@ -780,7 +773,7 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
>   	if (!nvmem_np)
>   		return ERR_PTR(-EINVAL);
>   
> -	nvmem = __nvmem_device_get(nvmem_np, NULL);
> +	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
>   	of_node_put(nvmem_np);
>   	if (IS_ERR(nvmem))
>   		return ERR_CAST(nvmem);
> diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
> index 8f8be5b00060..02dc4aa992b2 100644
> --- a/include/linux/nvmem-consumer.h
> +++ b/include/linux/nvmem-consumer.h
> @@ -89,6 +89,9 @@ void nvmem_del_cell_lookups(struct nvmem_cell_lookup *entries,
>   int nvmem_register_notifier(struct notifier_block *nb);
>   int nvmem_unregister_notifier(struct notifier_block *nb);
>   
> +struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data));
> +
>   #else
>   
>   static inline struct nvmem_cell *nvmem_cell_get(struct device *dev,
> @@ -204,6 +207,12 @@ static inline int nvmem_unregister_notifier(struct notifier_block *nb)
>   	return -EOPNOTSUPP;
>   }
>   
> +static inline struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data))
> +{
> +	return NULL;
> +}
> +
>   #endif /* CONFIG_NVMEM */
>   
>   #if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)
> 
