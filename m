Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD79DCAB
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 06:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfH0Egt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 00:36:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43446 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfH0Egt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 00:36:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so13251244pfn.10
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 21:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cMdTTBTk78bUmoE2jHHhOIbCDhgFlUny4s73id0o04w=;
        b=TMZcvHh5ox+Fk84Pdv5WJsw8Rt9sx+/Z7j8EZCAC+bzi+xfnSmrtr/3kQFJ8nocvYf
         94zFkGgTb/r2tcnqZ3nGLybZE+UwqcQkRci50BV51NWPAUGY9MTAtaNVLiSVEOEVQACg
         z9U9TP9dmJCFB1BBXiwW10e+QnY/uE4yxHAZ4IIU0roCLMaHD3X6JSdP8aN+MgT6ibLd
         3jpBBhoapxPxqaWhKvZ77Vw+28P5Bft2R377Jm96x5VDElRnMWu4DK+yelpD9gomLJdD
         zJI7BQVqTZYCR7YX/93hSWNJ7Eout0sPxifLNPkr9cO0HbH5Fv9vcIPxxkCFIpE5w9eX
         zHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cMdTTBTk78bUmoE2jHHhOIbCDhgFlUny4s73id0o04w=;
        b=fQF/6xb561qc+yASH3Zr8t8hv9oNrNIkn2mbie0GvnW1L0rs81GMmbNIqdr8DIOmJQ
         qssOsZKjLPMrBj17EcN8gkLB2Ge3G4TCKZc42ftPUW9QaPbCxwaxboRBe9Qbd+6H2lZP
         rQTr/JW0b8gDmy62WoPAWM2r+I0ZPH+yP9mZ8E2R4nNh1z9BH3KNiKPNroTEE06e3Dv2
         gh9PIuenCSM0xbGkj780FyaYH7KG8soeuuBmdsDzkfiB8V7JV4+XgfFZ27/XLpVY1lNo
         5eFQSPZAwXlaH1yD36rR2v1lrRpZHJor2Kxi2U2vPzb+MXCmsWyEJwu6++Z3TBCf9foE
         R1+g==
X-Gm-Message-State: APjAAAXPENYcH8jpeQISTwnaPW/2SE2S5ROoQJ9GWKeNajvf53NpxtA8
        AFyAgB8kpkj2nEyqZ94Ig8TeaZOg6fw=
X-Google-Smtp-Source: APXvYqzTSw+vugwoKFc6HvwPwdnWS/mJ4c5WPgoENDObV7I6uKMVoIu7mTheTpMS5jGgOF3eGiv3ZA==
X-Received: by 2002:a17:90a:36ad:: with SMTP id t42mr23067826pjb.21.1566880607864;
        Mon, 26 Aug 2019 21:36:47 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id v189sm13967062pfv.176.2019.08.26.21.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 21:36:47 -0700 (PDT)
Date:   Mon, 26 Aug 2019 21:36:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 03/18] ionic: Add port management commands
Message-ID: <20190826213631.37b8f56d@cakuba.netronome.com>
In-Reply-To: <20190826213339.56909-4-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
        <20190826213339.56909-4-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 14:33:24 -0700, Shannon Nelson wrote:
> The port management commands apply to the physical port
> associated with the PCI device, which might be shared among
> several logical interfaces.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +
>  .../ethernet/pensando/ionic/ionic_bus_pci.c   |  16 +++
>  .../net/ethernet/pensando/ionic/ionic_dev.c   | 116 ++++++++++++++++++
>  .../net/ethernet/pensando/ionic/ionic_dev.h   |  15 +++
>  .../net/ethernet/pensando/ionic/ionic_main.c  |  86 +++++++++++++
>  5 files changed, 237 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
> index 1f3c4a916849..db2ad14899d3 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
> @@ -44,4 +44,8 @@ int ionic_identify(struct ionic *ionic);
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
> index 0bf1bd6bd7b1..cddd41a43550 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> @@ -134,3 +134,119 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
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
> +void ionic_dev_cmd_port_mtu(struct ionic_dev *idev, u32 mtu)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
> +		.port_setattr.index = 0,
> +		.port_setattr.attr = IONIC_PORT_ATTR_MTU,
> +		.port_setattr.mtu = cpu_to_le32(mtu),
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
> +
> +void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
> +		.port_setattr.index = 0,
> +		.port_setattr.attr = IONIC_PORT_ATTR_LOOPBACK,
> +		.port_setattr.loopback_mode = loopback_mode,
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> index 30a5206bba4e..5b83f21af18a 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> @@ -122,6 +122,10 @@ struct ionic_dev {
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
> @@ -140,4 +144,15 @@ void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
>  void ionic_dev_cmd_init(struct ionic_dev *idev);
>  void ionic_dev_cmd_reset(struct ionic_dev *idev);
>  
> +void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
> +void ionic_dev_cmd_port_init(struct ionic_dev *idev);
> +void ionic_dev_cmd_port_reset(struct ionic_dev *idev);
> +void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state);
> +void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed);
> +void ionic_dev_cmd_port_mtu(struct ionic_dev *idev, u32 mtu);
> +void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
> +void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
> +void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
> +void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode);

I don't think you call most of these functions in this patch.

>  #endif /* _IONIC_DEV_H_ */
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index f52eb6c50358..47928f184230 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -309,6 +309,92 @@ int ionic_reset(struct ionic *ionic)
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
> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
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
> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +
> +	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
> +	(void)ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +	if (err) {
> +		dev_err(ionic->dev, "Failed to init port\n");

The lifetime of port_info seems a little strange. Why is it left in
place even if the command failed? Doesn't this leak memory?

> +		return err;
> +	}
> +
> +	return 0;

return err; work for both paths

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
> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +	if (err) {
> +		dev_err(ionic->dev, "Failed to reset port\n");
> +		return err;

Again, memory leak if command fails? (nothing frees port_info)

> +	}
> +
> +	dma_free_coherent(ionic->dev, idev->port_info_sz,
> +			  idev->port_info, idev->port_info_pa);
> +
> +	idev->port_info = NULL;
> +	idev->port_info_pa = 0;
> +
> +	return err;

Well, with current code err can only be 0 at this point.

> +}
> +
>  static int __init ionic_init_module(void)
>  {
>  	pr_info("%s %s, ver %s\n",

