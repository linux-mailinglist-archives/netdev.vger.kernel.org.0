Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0FA2A17
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfH2Wqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:46:40 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36810 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfH2Wqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:46:40 -0400
Received: by mail-ed1-f68.google.com with SMTP id g24so5832258edu.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 15:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=exlW1dZxQJqOLesaNBM8as18llHyeCbqlAlwVT67YTQ=;
        b=fPFgNT5O+sefc8cG7Bi4a7ef96kKWSz312tv6YlwEuZp9L6BFAYuHBfDjIGnRtABsQ
         n7e0qlYXiqLKtkFqyIgZ9atQd8rFceuEk+7AnGFSaqeNzi9BORtyXwH/4CxcfoM6/FtY
         zQ7lC8hz09Wn7PvrUyKnX2rh9jv9N1awMegdde8SoyYe7t2QddAO2Cy1sYWqBXmohVEe
         ZBgpKFGSloYxLz3kbHrn6IxHzKVBRKYJfZm+KAWXf7e0C+Hs6595lSM0oJsuSfiEFXFg
         2YkxZXAQP8mo1FjN4LOYybBZWIEIk9Cel+S/P4Zh5zVwZ7cfpQXc6o7gTz2igCPtj6Ei
         rRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=exlW1dZxQJqOLesaNBM8as18llHyeCbqlAlwVT67YTQ=;
        b=dV77EIkhvZNwcNukC/Ny+j/e67XJJDnujahlJXbNuwuXX2dvC+W+Y2BfBJmmaLr8qI
         cw0dU+eA9v+mVSWSyXtkVl+r9TvI9quQGM4PqIzAPLR3rvEzLbqKqYS4UlQFud10VvsW
         OjLw9AWAD0pCbwptOBxpEQmD9fvBZ3QQHsqNaDp2FUSt4itdPeDjdmw7MLUQGCiNPZW6
         fsbfkVZw846DR6PYhsS/cGNPNdMBRGI+nCNEiNjKneM6OL4dtf5ZmoIQVOXWKkZCmE3v
         JWNdcVVGyTVDxHXG8rSeGrQxikEYdfFH90KiYBVpnJaaF0pkq5VkCBMmQ7WYd3XRvjJ9
         DZNw==
X-Gm-Message-State: APjAAAVNb+AUc07SrQnvhddKyn2vWsb9hfwDv9/vg+iCJC32KohlThUl
        ayZTBVhyiA3Sl1VQhex5pWb1i6Hex/s=
X-Google-Smtp-Source: APXvYqxWYMWtg6UTJIIf4czWq16alSDB5NbjY+cJewIpePfz0nTnWioDjUUb4vAB+3LGIiuADRkrVg==
X-Received: by 2002:aa7:c2ca:: with SMTP id m10mr12534926edp.297.1567118796991;
        Thu, 29 Aug 2019 15:46:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm680874eds.39.2019.08.29.15.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 15:46:36 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:46:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 04/19] ionic: Add port management commands
Message-ID: <20190829154613.4e2b479a@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-5-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-5-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:05 -0700, Shannon Nelson wrote:
> The port management commands apply to the physical port
> associated with the PCI device, which might be shared among
> several logical interfaces.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic.h   |  4 +
>  .../ethernet/pensando/ionic/ionic_bus_pci.c   | 16 ++++
>  .../net/ethernet/pensando/ionic/ionic_dev.c   | 92 +++++++++++++++++++
>  .../net/ethernet/pensando/ionic/ionic_dev.h   | 13 +++
>  .../net/ethernet/pensando/ionic/ionic_main.c  | 86 +++++++++++++++++
>  5 files changed, 211 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
> index 89ad9c590736..4960effd2bcc 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
> @@ -42,4 +42,8 @@ int ionic_identify(struct ionic *ionic);
>  int ionic_init(struct ionic *ionic);
>  int ionic_reset(struct ionic *ionic);
>  
> +int ionic_port_identify(struct ionic *ionic);
> +int ionic_port_init(struct ionic *ionic);
> +int ionic_port_reset(struct ionic *ionic);
> +
>  #endif /* _IONIC_H_ */
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> index 286b4b450a73..804dd43e92a6 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> @@ -138,12 +138,27 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		goto err_out_teardown;
>  	}
>  
> +	/* Configure the ports */
> +	err = ionic_port_identify(ionic);
> +	if (err) {
> +		dev_err(dev, "Cannot identify port: %d, aborting\n", err);
> +		goto err_out_reset;
> +	}
> +
> +	err = ionic_port_init(ionic);
> +	if (err) {
> +		dev_err(dev, "Cannot init port: %d, aborting\n", err);
> +		goto err_out_reset;
> +	}
> +
>  	err = ionic_devlink_register(ionic);
>  	if (err)
>  		dev_err(dev, "Cannot register devlink: %d\n", err);
>  
>  	return 0;
>  
> +err_out_reset:
> +	ionic_reset(ionic);
>  err_out_teardown:
>  	ionic_dev_teardown(ionic);
>  err_out_unmap_bars:
> @@ -170,6 +185,7 @@ static void ionic_remove(struct pci_dev *pdev)
>  		return;
>  
>  	ionic_devlink_unregister(ionic);
> +	ionic_port_reset(ionic);
>  	ionic_reset(ionic);
>  	ionic_dev_teardown(ionic);
>  	ionic_unmap_bars(ionic);
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> index 0bf1bd6bd7b1..3137776e9191 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> @@ -134,3 +134,95 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
>  
>  	ionic_dev_cmd_go(idev, &cmd);
>  }
> +
> +/* Port commands */
> +void ionic_dev_cmd_port_identify(struct ionic_dev *idev)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_init.opcode = IONIC_CMD_PORT_IDENTIFY,
> +		.port_init.index = 0,
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +void ionic_dev_cmd_port_init(struct ionic_dev *idev)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_init.opcode = IONIC_CMD_PORT_INIT,
> +		.port_init.index = 0,
> +		.port_init.info_pa = cpu_to_le64(idev->port_info_pa),
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +void ionic_dev_cmd_port_reset(struct ionic_dev *idev)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_reset.opcode = IONIC_CMD_PORT_RESET,
> +		.port_reset.index = 0,
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
> +		.port_setattr.index = 0,
> +		.port_setattr.attr = IONIC_PORT_ATTR_STATE,
> +		.port_setattr.state = state,
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
> +		.port_setattr.index = 0,
> +		.port_setattr.attr = IONIC_PORT_ATTR_SPEED,
> +		.port_setattr.speed = cpu_to_le32(speed),
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
> +		.port_setattr.index = 0,
> +		.port_setattr.attr = IONIC_PORT_ATTR_AUTONEG,
> +		.port_setattr.an_enable = an_enable,
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
> +		.port_setattr.index = 0,
> +		.port_setattr.attr = IONIC_PORT_ATTR_FEC,
> +		.port_setattr.fec_type = fec_type,
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
> +		.port_setattr.index = 0,
> +		.port_setattr.attr = IONIC_PORT_ATTR_PAUSE,
> +		.port_setattr.pause_type = pause_type,
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}

Hm. So you haven't moved those?

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> index 7050545a83aa..81b6910aabc1 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> @@ -117,6 +117,10 @@ struct ionic_dev {
>  	struct ionic_intr __iomem *intr_ctrl;
>  	u64 __iomem *intr_status;
>  
> +	u32 port_info_sz;
> +	struct ionic_port_info *port_info;
> +	dma_addr_t port_info_pa;
> +
>  	struct ionic_devinfo dev_info;
>  };
>  
> @@ -135,4 +139,13 @@ void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
>  void ionic_dev_cmd_init(struct ionic_dev *idev);
>  void ionic_dev_cmd_reset(struct ionic_dev *idev);
>  
> +void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
> +void ionic_dev_cmd_port_init(struct ionic_dev *idev);
> +void ionic_dev_cmd_port_reset(struct ionic_dev *idev);
> +void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state);
> +void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed);
> +void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
> +void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
> +void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
> +
>  #endif /* _IONIC_DEV_H_ */
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index 5c311b9241ee..96de2789587d 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -317,6 +317,92 @@ int ionic_reset(struct ionic *ionic)
>  	return err;
>  }
>  
> +int ionic_port_identify(struct ionic *ionic)
> +{
> +	struct ionic_identity *ident = &ionic->ident;
> +	struct ionic_dev *idev = &ionic->idev;
> +	size_t sz;
> +	int err;
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +
> +	ionic_dev_cmd_port_identify(idev);
> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +	if (!err) {
> +		sz = min(sizeof(ident->port), sizeof(idev->dev_cmd_regs->data));
> +		memcpy_fromio(&ident->port, &idev->dev_cmd_regs->data, sz);
> +	}
> +
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +
> +	return err;
> +}
> +
> +int ionic_port_init(struct ionic *ionic)
> +{
> +	struct ionic_identity *ident = &ionic->ident;
> +	struct ionic_dev *idev = &ionic->idev;
> +	size_t sz;
> +	int err;
> +
> +	if (idev->port_info)
> +		return 0;
> +
> +	idev->port_info_sz = ALIGN(sizeof(*idev->port_info), PAGE_SIZE);
> +	idev->port_info = dma_alloc_coherent(ionic->dev, idev->port_info_sz,
> +					     &idev->port_info_pa,
> +					     GFP_KERNEL);
> +	if (!idev->port_info) {
> +		dev_err(ionic->dev, "Failed to allocate port info, aborting\n");
> +		return -ENOMEM;
> +	}
> +
> +	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +
> +	memcpy_toio(&idev->dev_cmd_regs->data, &ident->port.config, sz);
> +	ionic_dev_cmd_port_init(idev);
> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +
> +	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
> +	(void)ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +	if (err) {
> +		dev_err(ionic->dev, "Failed to init port\n");
> +		dma_free_coherent(ionic->dev, idev->port_info_sz,
> +				  idev->port_info, idev->port_info_pa);

idev->port_info = NULL;

> +	}
> +
> +	return err;
> +}
> +
> +int ionic_port_reset(struct ionic *ionic)
> +{
> +	struct ionic_dev *idev = &ionic->idev;
> +	int err;
> +
> +	if (!idev->port_info)
> +		return 0;
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +	ionic_dev_cmd_port_reset(idev);
> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +
> +	dma_free_coherent(ionic->dev, idev->port_info_sz,
> +			  idev->port_info, idev->port_info_pa);
> +
> +	idev->port_info = NULL;
> +	idev->port_info_pa = 0;
> +
> +	if (err)
> +		dev_err(ionic->dev, "Failed to reset port\n");
> +
> +	return err;
> +}
> +
>  static int __init ionic_init_module(void)
>  {
>  	pr_info("%s %s, ver %s\n",

