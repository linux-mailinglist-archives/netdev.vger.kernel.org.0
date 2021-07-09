Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A853C1D81
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhGICcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:32:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230235AbhGICcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625797789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jC8ebqLDwty//t4KfVA7RFoJa+JDs1zz/7ayauIgC5s=;
        b=T2dZn3qqtixeMaAy9fnk6V/vRgwfEGGCntCSTFc1K1+rluxWA88zsW5MNUwXvo873ngYDt
        gS0HKuAT9OkYe0WkeuGmdTLlGLnspsI09t8SH3iO7kaRjEUYkAEtNcEzTltSpxaO52l8Sd
        WvSAT1RQ9bXXbRoO4rh1mWW0eWs0jtI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-KiFCdRtSO8eQrdiczewWPA-1; Thu, 08 Jul 2021 22:29:47 -0400
X-MC-Unique: KiFCdRtSO8eQrdiczewWPA-1
Received: by mail-pg1-f200.google.com with SMTP id 1-20020a6317410000b0290228062f22a0so6056836pgx.22
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 19:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jC8ebqLDwty//t4KfVA7RFoJa+JDs1zz/7ayauIgC5s=;
        b=bp61ANPE66xn+2FAgE7rvi1V6ZK03dJa9VG42Tf15aDEjlj4WZzETJKrwz1FKWavfP
         Yl7EDiyCW/UMgQW19Bc6jNPSJLisfcd0OGR+RFG5Nq6nlysndusj9fx4jsiGru41kZxo
         tMcZRArpNnqmsq27KGK27h5ZwQaC90QGk7bkVtR23T6LYsHfYyFyLKl9YkTCovTT1plE
         jRoA5wqGVQISEr8wRjUGjTApS5MSoaHbRd6tcxkbhMo/G43rN9KU9GFMeVyDZUSwKeWp
         nza60Mui+vZzuEk7D9Ske3cbO5LDTjpGOmTmnMRrQLKzOlqbcrqzBSAhlKXlp9CRaWFI
         Zc9g==
X-Gm-Message-State: AOAM531pcBF8Y+vI2QYkKvnGnD9dTD4dAWkw5dH/7pVUDQ2U7kp/ouxc
        1ZX4R1GRwAY2PrOub9TIFlrDPtKHJy6kl8jXwvOjqXlgJLAGyuGNziM0Ue/9Ugezix4/mZMDxUw
        2/fRLQVFINJehlq0L
X-Received: by 2002:a62:1708:0:b029:31b:113f:174a with SMTP id 8-20020a6217080000b029031b113f174amr30557492pfx.68.1625797786912;
        Thu, 08 Jul 2021 19:29:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcSNDEpisA7AaUQv65sNC7SSxSvR5Hd5rr7dX1Ad3A6kno6Tgb6OvZoPwEHv5RC/WjWhzHRg==
X-Received: by 2002:a62:1708:0:b029:31b:113f:174a with SMTP id 8-20020a6217080000b029031b113f174amr30557471pfx.68.1625797786688;
        Thu, 08 Jul 2021 19:29:46 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v6sm4947769pgk.33.2021.07.08.19.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 19:29:46 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] vDPA/ifcvf: introduce get_dev_type() which returns
 virtio dev id
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210706023649.23360-1-lingshan.zhu@intel.com>
 <20210706023649.23360-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <abe284e0-7f0a-2cca-04ad-ef69fa1cc1d7@redhat.com>
Date:   Fri, 9 Jul 2021 10:29:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706023649.23360-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/6 ÉÏÎç10:36, Zhu Lingshan Ð´µÀ:
> This commit introduces a new function get_dev_type() which returns
> the virtio device id of a device, to avoid duplicated code.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 34 ++++++++++++++++++++-------------
>   1 file changed, 21 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index bc1d59f316d1..5f70ab1283a0 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -442,6 +442,26 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
>   };
>   
> +static u32 get_dev_type(struct pci_dev *pdev)
> +{
> +	u32 dev_type;
> +
> +	/* This drirver drives both modern virtio devices and transitional
> +	 * devices in modern mode.
> +	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
> +	 * so legacy devices and transitional devices in legacy
> +	 * mode will not work for vDPA, this driver will not
> +	 * drive devices with legacy interface.
> +	 */
> +
> +	if (pdev->device < 0x1040)
> +		dev_type =  pdev->subsystem_device;
> +	else
> +		dev_type =  pdev->device - 0x1040;
> +
> +	return dev_type;
> +}
> +
>   static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   {
>   	struct device *dev = &pdev->dev;
> @@ -486,19 +506,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	pci_set_drvdata(pdev, adapter);
>   
>   	vf = &adapter->vf;
> -
> -	/* This drirver drives both modern virtio devices and transitional
> -	 * devices in modern mode.
> -	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
> -	 * so legacy devices and transitional devices in legacy
> -	 * mode will not work for vDPA, this driver will not
> -	 * drive devices with legacy interface.
> -	 */
> -	if (pdev->device < 0x1040)
> -		vf->dev_type =  pdev->subsystem_device;
> -	else
> -		vf->dev_type =  pdev->device - 0x1040;
> -
> +	vf->dev_type = get_dev_type(pdev);
>   	vf->base = pcim_iomap_table(pdev);
>   
>   	adapter->pdev = pdev;

