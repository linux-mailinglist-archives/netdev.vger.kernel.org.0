Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A3E51432B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346514AbiD2HXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbiD2HXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:23:00 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C63BF958
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:19:39 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k23so13767096ejd.3
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W1qTXQHkAUTgIS5H0qkRUjmUVz3cheTFAjxA6UltZ10=;
        b=VaqWAtqBsb8Z3atRuosBuidY7OP62YvuZ+sVu8KD7DgOfq3jjkKx6UP9I0axEDWuuV
         CaW2zRJ29cyD0aHpRIr8M69irsU0pAGRiyYVR8iBHZw27lVgPsUVmJGJeOy6xy4s+9vn
         h64W332vI6oY5Hzaf169RRPxUwSzeks2jEdWj2Kv9edvjIB8kphDlfl+kvb67IJV1ksH
         wPOS81v49Ho1P1cGqEmVqHH+4i6pd8PlWQBHVh+BH6/FGY0vo+E3tnckiCiqkIOUCO4m
         pxgg7Pi7CfVAtOXv/9H7Podp1JyFNjDa8ZioS26/5Q12rITjC8s3HW8tX8UB8pqYehZj
         tSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W1qTXQHkAUTgIS5H0qkRUjmUVz3cheTFAjxA6UltZ10=;
        b=pZ5m+qPcjkwH4hmvZDnGykRX5yjIJ8M2lsh2HiNY4pVzEnUOTSIlZLzJ/bZi7dmi62
         yJphNh4x7T1WwwZlhHBUG2lGfYQ9L5GNCfiX9k0BANALtaGeDZOryVL2aUDCUNP+A/7t
         64l0v69ExxROlcDx4vXjmzz4IIf2rnZRnaJlvFuPvtsDNIYkALZE67EWiQn95zQLNGV8
         nRCRBT9IhCRuoLSQN4t90pnr4fGeFlbrTdBig0E/UqqBcvM8rcZhej1i7ocTEZ2iZs21
         nXddf5WGHXIXYI+JZSN7vSLjbKma6wG0CpBBuFQJgQE1p1gzwp5D9NNx5JsqiA83vAMp
         eBzA==
X-Gm-Message-State: AOAM530Pxl/yysuHAEV24JHe24ouqdzOWa+75JKkWTxs7qlXFPRQOtnw
        nSA7WgIaIzUCJ3IMfWZX3pp9uw==
X-Google-Smtp-Source: ABdhPJyAcOzo78/7vNbS/EM8tjt1S6GONjFd3lsVUIY7OyzfjiTXJMjrA6sK33YCY/EOFrTfJzb7nw==
X-Received: by 2002:a17:907:3d89:b0:6ef:eebf:1708 with SMTP id he9-20020a1709073d8900b006efeebf1708mr36257371ejc.620.1651216777725;
        Fri, 29 Apr 2022 00:19:37 -0700 (PDT)
Received: from [192.168.0.169] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id mm25-20020a170906cc5900b006f3ef214dddsm369629ejb.67.2022.04.29.00.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 00:19:36 -0700 (PDT)
Message-ID: <aedb4e56-99c4-4f33-bb9c-e122fb87f45b@linaro.org>
Date:   Fri, 29 Apr 2022 09:19:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v5 1/2] nfc: replace improper check
 device_is_registered() in netlink related functions
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org,
        kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org, linma@zju.edu.cn
References: <cover.1651194245.git.duoming@zju.edu.cn>
 <33a282a82c18f942f1f5f9ee0ffcb16c2c7b0ece.1651194245.git.duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <33a282a82c18f942f1f5f9ee0ffcb16c2c7b0ece.1651194245.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2022 03:14, Duoming Zhou wrote:
> The device_is_registered() in nfc core is used to check whether
> nfc device is registered in netlink related functions such as
> nfc_fw_download(), nfc_dev_up() and so on. Although device_is_registered()
> is protected by device_lock, there is still a race condition between
> device_del() and device_is_registered(). The root cause is that
> kobject_del() in device_del() is not protected by device_lock.
> 
>    (cleanup task)         |     (netlink task)
>                           |
> nfc_unregister_device     | nfc_fw_download
>  device_del               |  device_lock
>   ...                     |   if (!device_is_registered)//(1)
>   kobject_del//(2)        |   ...
>  ...                      |  device_unlock
> 
> The device_is_registered() returns the value of state_in_sysfs and
> the state_in_sysfs is set to zero in kobject_del(). If we pass check in
> position (1), then set zero in position (2). As a result, the check
> in position (1) is useless.
> 
> This patch uses bool variable instead of device_is_registered() to judge
> whether the nfc device is registered, which is well synchronized.
> 
> Fixes: 3e256b8f8dfa ("NFC: add nfc subsystem core")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v5:
>   - Replace device_is_registered() to bool variable.
> 
>  include/net/nfc/nfc.h |  1 +
>  net/nfc/core.c        | 26 ++++++++++++++------------
>  2 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
> index 5dee575fbe8..7bb4ccb1830 100644
> --- a/include/net/nfc/nfc.h
> +++ b/include/net/nfc/nfc.h
> @@ -167,6 +167,7 @@ struct nfc_dev {
>  	int n_targets;
>  	int targets_generation;
>  	struct device dev;
> +	bool dev_register;
>  	bool dev_up;
>  	bool fw_download_in_progress;
>  	u8 rf_mode;
> diff --git a/net/nfc/core.c b/net/nfc/core.c
> index dc7a2404efd..52147da2286 100644
> --- a/net/nfc/core.c
> +++ b/net/nfc/core.c
> @@ -38,7 +38,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -94,7 +94,7 @@ int nfc_dev_up(struct nfc_dev *dev)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -142,7 +142,7 @@ int nfc_dev_down(struct nfc_dev *dev)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -207,7 +207,7 @@ int nfc_start_poll(struct nfc_dev *dev, u32 im_protocols, u32 tm_protocols)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -246,7 +246,7 @@ int nfc_stop_poll(struct nfc_dev *dev)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -291,7 +291,7 @@ int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -335,7 +335,7 @@ int nfc_dep_link_down(struct nfc_dev *dev)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -401,7 +401,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -448,7 +448,7 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx, u8 mode)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -495,7 +495,7 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		kfree_skb(skb);
>  		goto error;
> @@ -552,7 +552,7 @@ int nfc_enable_se(struct nfc_dev *dev, u32 se_idx)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -601,7 +601,7 @@ int nfc_disable_se(struct nfc_dev *dev, u32 se_idx)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -1134,6 +1134,7 @@ int nfc_register_device(struct nfc_dev *dev)
>  			dev->rfkill = NULL;
>  		}
>  	}
> +	dev->dev_register = true;
>  	device_unlock(&dev->dev);
>  
>  	rc = nfc_genl_device_added(dev);
> @@ -1166,6 +1167,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
>  		rfkill_unregister(dev->rfkill);
>  		rfkill_destroy(dev->rfkill);
>  	}
> +	dev->dev_register = false;

We already have flag for it - dev->shutting_down. Currently it is used
only in if device implements check_presence but I think it can be easily
moved to common path.

Having multiple fields for similar, but slightly different cases, is
getting us closer and closer to spaghetti code.


Best regards,
Krzysztof
