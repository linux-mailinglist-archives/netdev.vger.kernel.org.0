Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B6A5C773
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfGBCrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:47:43 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37267 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBCrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:47:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so16940205qtk.4
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 19:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MQzR3fjX6v2BSqpODp5CGAU1l2dzMzUGcheadijH8mk=;
        b=Wea3CxpPOPWvq3qFsqQAwyicHnE3JmqKGgx+BxW2xmwytPAorimZzrw62ewLgqWNsV
         A0qc5+Pzliu7fhLer0LpkabyT2LlyAeJSocYf/+zxq2kcbk88Fj+Kxpt7mMKD0ncU8/D
         A9zw4lGtB7RqUwuza7k2ESewBUbccs4I1JC03Nn02q9PgxADv0+2a7/Eb1ugfGcD8/El
         kl73HpOp71PRVjlBZxkre116BQO/LQC80Zd1puPo0OQjFqC1fIERSxyn2Ac99x1SnGdj
         GLCVdwFDbdS9Rq/KvIKKgOeSKc90cs7Eqm9Lv7v2aSUNulML9ehhfKjit+7+Ea9ukoRj
         U/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MQzR3fjX6v2BSqpODp5CGAU1l2dzMzUGcheadijH8mk=;
        b=dhGvnYsaVD+V/M81pRRljKQpGVBB0DocRI1ZI1007TXfIYX8qN3cMBPy+gNyiq3efT
         rlX/OAr9BiMf/h+Woe2BttEQRlR30AP1SXBZ+fpoV8uLwVzhlZaK/bYfL7VmoRu2Y8kY
         FmG/f/+pb0Apq4PwrAEDjL4DzPmiGpqOdPNmllg5g31IAbJr96vwlTc3znUaqT1Tb+YT
         +pH1e/x98bQWp428COYnG7hpXLLKBdaE0vQoNhx5tnz8sy4BFgxzBXV1a9nFZ4inmqmp
         a7dq4JF+mQfSiJYVt/hOgSsgiLW8lF05LlccRHOjgvB6NYOPa+kJq8QCTM9ica1kUkaU
         osOg==
X-Gm-Message-State: APjAAAUGWyJfMW7/sFDCW4XNREXBSuvQvy835QVUYw3IdlQirJPiWjMH
        WrKCGdy5wBF7fYKABp9GXhtzbQ==
X-Google-Smtp-Source: APXvYqwTKsOItYK2sAOT+ARxTNQMjW3m8J961ktBF5JEhpuekFnQegbmncGaGNrzpZiiKQnHvBwL7A==
X-Received: by 2002:ac8:26d5:: with SMTP id 21mr23363970qtp.266.1562035661337;
        Mon, 01 Jul 2019 19:47:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q29sm6026547qkq.77.2019.07.01.19.47.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 19:47:41 -0700 (PDT)
Date:   Mon, 1 Jul 2019 19:47:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [PATCH net-next v4 1/4] gve: Add basic driver framework for
 Compute Engine Virtual NIC
Message-ID: <20190701194736.6af1f2ed@cakuba.netronome.com>
In-Reply-To: <20190701225755.209250-2-csully@google.com>
References: <20190701225755.209250-1-csully@google.com>
        <20190701225755.209250-2-csully@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Jul 2019 15:57:52 -0700, Catherine Sullivan wrote:
> Add a driver framework for the Compute Engine Virtual NIC that will be
> available in the future.
> 
> At this point the only functionality is loading the driver.
> 
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> Signed-off-by: Jon Olson <jonolson@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Luigi Rizzo <lrizzo@google.com>

> +Admin Queue (AQ)
> +----------------
> +The Admin Queue is a PAGE_SIZE memory block, treated as an array of AQ
> +commands, used by the driver to issue commands to the device and set up
> +resources.The driver and the device maintain a count of how many commands
> +have been submitted and executed. To issue AQ commands, the driver must do
> +the following (with proper locking):
> +
> +1)  Copy new commands into next available slots in the AQ array
> +2)  Increment its counter by he number of new commands

s/he/the/

> +3)  Write the counter into the GVE_ADMIN_QUEUE_DOORBELL register
> +4)  Poll the ADMIN_QUEUE_EVENT_COUNTER register until it equals
> +    the value written to the doorbell, or until a timeout.
> +
> +The device will update the status field in each AQ command reported as
> +executed through the ADMIN_QUEUE_EVENT_COUNTER register.
> +

> +/* This function is not threadsafe - the caller is responsible for any
> + * necessary locks.
> + */
> +int gve_adminq_execute_cmd(struct gve_priv *priv,
> +			   union gve_adminq_command *cmd_orig)
> +{
> +	union gve_adminq_command *cmd;
> +	u32 status = 0;
> +	u32 prod_cnt;
> +
> +	cmd = &priv->adminq[priv->adminq_prod_cnt & priv->adminq_mask];
> +	priv->adminq_prod_cnt++;
> +	prod_cnt = priv->adminq_prod_cnt;
> +
> +	memcpy(cmd, cmd_orig, sizeof(*cmd_orig));

Eh, I guess you don't even need memory barriers around the data movement
to the DMA buffer because of the restriction to x86? :)

> +	gve_adminq_kick_cmd(priv, prod_cnt);
> +	if (!gve_adminq_wait_for_cmd(priv, prod_cnt)) {
> +		dev_err(&priv->pdev->dev, "AQ command timed out, need to reset AQ\n");
> +		return -ENOTRECOVERABLE;
> +	}

> +	memcpy(cmd_orig, cmd, sizeof(*cmd));
> +	status = be32_to_cpu(READ_ONCE(cmd->status));
> +	return gve_adminq_parse_err(&priv->pdev->dev, status);
> +}

> +int gve_adminq_describe_device(struct gve_priv *priv)
> +{
> +	struct gve_device_descriptor *descriptor;
> +	union gve_adminq_command cmd;
> +	dma_addr_t descriptor_bus;
> +	int err = 0;
> +	u8 *mac;
> +	u16 mtu;
> +
> +	memset(&cmd, 0, sizeof(cmd));
> +	descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
> +					&descriptor_bus, GFP_KERNEL);
> +	if (!descriptor)
> +		return -ENOMEM;
> +	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DESCRIBE_DEVICE);
> +	cmd.describe_device.device_descriptor_addr =
> +						cpu_to_be64(descriptor_bus);
> +	cmd.describe_device.device_descriptor_version =
> +			cpu_to_be32(GVE_ADMINQ_DEVICE_DESCRIPTOR_VERSION);
> +	cmd.describe_device.available_length = cpu_to_be32(PAGE_SIZE);
> +
> +	err = gve_adminq_execute_cmd(priv, &cmd);
> +	if (err)
> +		goto free_device_descriptor;
> +
> +	mtu = be16_to_cpu(descriptor->mtu);
> +	if (mtu < ETH_MIN_MTU) {
> +		netif_err(priv, drv, priv->dev, "MTU %d below minimum MTU\n",
> +			  mtu);
> +		err = -EINVAL;
> +		goto free_device_descriptor;
> +	}
> +	priv->dev->max_mtu = mtu;
> +	priv->num_event_counters = be16_to_cpu(descriptor->counters);
> +	ether_addr_copy(priv->dev->dev_addr, descriptor->mac);

Since you check MTU you can check the address with
is_valid_ether_addr().

Also it's common practice to copy the provisioned MAC to
netdev->perm_addr as well as dev_addr for VFs.

> +	mac = descriptor->mac;
> +	netif_info(priv, drv, priv->dev, "MAC addr: %pM\n", mac);
> +
> +free_device_descriptor:
> +	dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
> +			  descriptor_bus);
> +	return err;
> +}

Oh, okay, David already applied..
