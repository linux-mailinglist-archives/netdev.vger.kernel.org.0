Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE57A3E48
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfH3TSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:18:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40135 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfH3TSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:18:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so3997857pgj.7
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 12:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dBHIS9lDOaPDJPn3yzTPrCwalw3hsDnKaWJ1UqhoWu8=;
        b=vkXilRjxD3LXolI8XYwnSWptPkWuyDKNao80m5+sd8OreFCS8StvBYJXL+/mKkbcu9
         DwWDWdJvBW7Gawuu8rc+r0sYWagBozNwM9y47Ym2qMz1lJog36uBAmhVnMRWoN5LUAOE
         2fWsP5fasaaVPA8F56uqP8n0ECATcDAzCTYyq9pQH+EG97AGq5BTbJKusUYKtkRkmLIP
         4+w3/ANSEh0g7UTrnpEGwveM3j41FBb5u9RFPfnLSdvwEu9UFSS6aXSKptk9B7jYVs9q
         nDsxhlBIpfJwp0sz7t26CbyucNZIq1g294JB3FUTSFbfF3A8FlfnsYL2qA+24k4LIYEF
         Pz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dBHIS9lDOaPDJPn3yzTPrCwalw3hsDnKaWJ1UqhoWu8=;
        b=Evn/8WgpRuSirFOD0rGbLIEJm2lzqCQEBCF0qgh71jqlg7dSTiJ8joxEPx3q/XW1tD
         A6iCxSkqLHzgZ661xY9JZo72SSuRDQyNjmQdiQtwoySdBHml+QHDYHbVfDaAZ2yBp3g6
         Nr0lm+ZrENnpJafcIQELEQkpHoXF3uwcvus3ocnNBzk7H1cq5RE0zZR9AgG+FH1TI7hn
         cGm0tQkJuTj/R6Hu/dB09pezpWGaqS2fw/p+p9ucbzBExYgKtoTZ7WME24YLPEslsHoy
         RKeEi41WcrK/Y/QPjzxvKaXR09c5hPCOgVntVclvj90IvdBI5zaVPwKtt39b3jUZ3nML
         sJkQ==
X-Gm-Message-State: APjAAAXbNYBx0fq86I71xTSdGZ9uhoKyphbzLbtBIDxPAPMuh3Sk1Wly
        /lSQ0LRY6asqg9HvA2CwXKtGjQ==
X-Google-Smtp-Source: APXvYqw3obCqmSQhhnSO9d8KsfGHcUGSV3NKWx0fNmrrsmQyOMxkxzOudR4ZIJ7HorcBp1cKkf4LJQ==
X-Received: by 2002:aa7:934f:: with SMTP id 15mr19671931pfn.22.1567192713607;
        Fri, 30 Aug 2019 12:18:33 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q2sm4595963pfg.144.2019.08.30.12.18.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 12:18:33 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 04/19] ionic: Add port management commands
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-5-snelson@pensando.io>
 <20190829154613.4e2b479a@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <def6e99b-7224-abfc-88c7-f2c1932e12c2@pensando.io>
Date:   Fri, 30 Aug 2019 12:18:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829154613.4e2b479a@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 3:46 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:05 -0700, Shannon Nelson wrote:
>> The port management commands apply to the physical port
>> associated with the PCI device, which might be shared among
>> several logical interfaces.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic.h   |  4 +
>>   .../ethernet/pensando/ionic/ionic_bus_pci.c   | 16 ++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.c   | 92 +++++++++++++++++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   | 13 +++
>>   .../net/ethernet/pensando/ionic/ionic_main.c  | 86 +++++++++++++++++
>>   5 files changed, 211 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index 89ad9c590736..4960effd2bcc 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -42,4 +42,8 @@ int ionic_identify(struct ionic *ionic);
>>   int ionic_init(struct ionic *ionic);
>>   int ionic_reset(struct ionic *ionic);
>>   
>> +int ionic_port_identify(struct ionic *ionic);
>> +int ionic_port_init(struct ionic *ionic);
>> +int ionic_port_reset(struct ionic *ionic);
>> +
>>   #endif /* _IONIC_H_ */
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> index 286b4b450a73..804dd43e92a6 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> @@ -138,12 +138,27 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   		goto err_out_teardown;
>>   	}
>>   
>> +	/* Configure the ports */
>> +	err = ionic_port_identify(ionic);
>> +	if (err) {
>> +		dev_err(dev, "Cannot identify port: %d, aborting\n", err);
>> +		goto err_out_reset;
>> +	}
>> +
>> +	err = ionic_port_init(ionic);
>> +	if (err) {
>> +		dev_err(dev, "Cannot init port: %d, aborting\n", err);
>> +		goto err_out_reset;
>> +	}
>> +
>>   	err = ionic_devlink_register(ionic);
>>   	if (err)
>>   		dev_err(dev, "Cannot register devlink: %d\n", err);
>>   
>>   	return 0;
>>   
>> +err_out_reset:
>> +	ionic_reset(ionic);
>>   err_out_teardown:
>>   	ionic_dev_teardown(ionic);
>>   err_out_unmap_bars:
>> @@ -170,6 +185,7 @@ static void ionic_remove(struct pci_dev *pdev)
>>   		return;
>>   
>>   	ionic_devlink_unregister(ionic);
>> +	ionic_port_reset(ionic);
>>   	ionic_reset(ionic);
>>   	ionic_dev_teardown(ionic);
>>   	ionic_unmap_bars(ionic);
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> index 0bf1bd6bd7b1..3137776e9191 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> @@ -134,3 +134,95 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
>>   
>>   	ionic_dev_cmd_go(idev, &cmd);
>>   }
>> +
>> +/* Port commands */
>> +void ionic_dev_cmd_port_identify(struct ionic_dev *idev)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_init.opcode = IONIC_CMD_PORT_IDENTIFY,
>> +		.port_init.index = 0,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_port_init(struct ionic_dev *idev)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_init.opcode = IONIC_CMD_PORT_INIT,
>> +		.port_init.index = 0,
>> +		.port_init.info_pa = cpu_to_le64(idev->port_info_pa),
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_port_reset(struct ionic_dev *idev)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_reset.opcode = IONIC_CMD_PORT_RESET,
>> +		.port_reset.index = 0,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
>> +		.port_setattr.index = 0,
>> +		.port_setattr.attr = IONIC_PORT_ATTR_STATE,
>> +		.port_setattr.state = state,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
>> +		.port_setattr.index = 0,
>> +		.port_setattr.attr = IONIC_PORT_ATTR_SPEED,
>> +		.port_setattr.speed = cpu_to_le32(speed),
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
>> +		.port_setattr.index = 0,
>> +		.port_setattr.attr = IONIC_PORT_ATTR_AUTONEG,
>> +		.port_setattr.an_enable = an_enable,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
>> +		.port_setattr.index = 0,
>> +		.port_setattr.attr = IONIC_PORT_ATTR_FEC,
>> +		.port_setattr.fec_type = fec_type,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
>> +		.port_setattr.index = 0,
>> +		.port_setattr.attr = IONIC_PORT_ATTR_PAUSE,
>> +		.port_setattr.pause_type = pause_type,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
> Hm. So you haven't moved those?

They make for a nice consistent bundle of service routines that get used 
in a later patch in this patchset, and helps keep that other patch a 
little leaner and perhaps easier to review.

>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> index 7050545a83aa..81b6910aabc1 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> @@ -117,6 +117,10 @@ struct ionic_dev {
>>   	struct ionic_intr __iomem *intr_ctrl;
>>   	u64 __iomem *intr_status;
>>   
>> +	u32 port_info_sz;
>> +	struct ionic_port_info *port_info;
>> +	dma_addr_t port_info_pa;
>> +
>>   	struct ionic_devinfo dev_info;
>>   };
>>   
>> @@ -135,4 +139,13 @@ void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
>>   void ionic_dev_cmd_init(struct ionic_dev *idev);
>>   void ionic_dev_cmd_reset(struct ionic_dev *idev);
>>   
>> +void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
>> +void ionic_dev_cmd_port_init(struct ionic_dev *idev);
>> +void ionic_dev_cmd_port_reset(struct ionic_dev *idev);
>> +void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state);
>> +void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed);
>> +void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
>> +void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
>> +void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
>> +
>>   #endif /* _IONIC_DEV_H_ */
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> index 5c311b9241ee..96de2789587d 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> @@ -317,6 +317,92 @@ int ionic_reset(struct ionic *ionic)
>>   	return err;
>>   }
>>   
>> +int ionic_port_identify(struct ionic *ionic)
>> +{
>> +	struct ionic_identity *ident = &ionic->ident;
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	size_t sz;
>> +	int err;
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +
>> +	ionic_dev_cmd_port_identify(idev);
>> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
>> +	if (!err) {
>> +		sz = min(sizeof(ident->port), sizeof(idev->dev_cmd_regs->data));
>> +		memcpy_fromio(&ident->port, &idev->dev_cmd_regs->data, sz);
>> +	}
>> +
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +
>> +	return err;
>> +}
>> +
>> +int ionic_port_init(struct ionic *ionic)
>> +{
>> +	struct ionic_identity *ident = &ionic->ident;
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	size_t sz;
>> +	int err;
>> +
>> +	if (idev->port_info)
>> +		return 0;
>> +
>> +	idev->port_info_sz = ALIGN(sizeof(*idev->port_info), PAGE_SIZE);
>> +	idev->port_info = dma_alloc_coherent(ionic->dev, idev->port_info_sz,
>> +					     &idev->port_info_pa,
>> +					     GFP_KERNEL);
>> +	if (!idev->port_info) {
>> +		dev_err(ionic->dev, "Failed to allocate port info, aborting\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +
>> +	memcpy_toio(&idev->dev_cmd_regs->data, &ident->port.config, sz);
>> +	ionic_dev_cmd_port_init(idev);
>> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
>> +
>> +	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
>> +	(void)ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
>> +
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +	if (err) {
>> +		dev_err(ionic->dev, "Failed to init port\n");
>> +		dma_free_coherent(ionic->dev, idev->port_info_sz,
>> +				  idev->port_info, idev->port_info_pa);
> idev->port_info = NULL;

Yep

Thanks,
sln


