Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2025612E9BB
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgABSJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:09:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55921 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgABSJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:09:27 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so3552880pjz.5
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 10:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=Hsa6HNMn6Ns+kMNNDfSdNyRm6Y38XpdWCcqqAc/ZZDE=;
        b=Hshz1Xn/slCz4X6TsPEP9kuaaVensm9Hr+tfCPXddgm5Z4FQZW5k90GUDgwrfpEqCw
         04ty+KlhyrRv1DEreG3uTWjUJi1d38kVqCH/P7rQcndCZcevwel4qagboDEtCmYM5ELv
         vAEM87a+MITbStpewj5rJsv1DcULWY/BWgCeuu/1s34zaUQmwfcH4P5iLmzaQ6BozE6q
         Xrzvvyc9tpGxeCFt+7O/+KwsZMkD6BV2YOggxEKUPpCOb37beBpfm6LZ5OHCzR6tNwfe
         qiJ6N89Ta+L5E5AbOBbk6VHLooAk62lhUcpxb+KsvB1hwmT5Ie9phLLzjS/zAAZ0eKgs
         Peeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Hsa6HNMn6Ns+kMNNDfSdNyRm6Y38XpdWCcqqAc/ZZDE=;
        b=VoVyhdGZ/rW1+zMW4NSsocAZwZKNDZKi4IM2rYYOKKC1S/2fYttcpDLv7Zqd1vhW0M
         grgbceRn1JW6CT3zkDErfZ4YVja3u/O1h1dV53XTsyF65BpAuO6oAps89Mx3Cl5XCF39
         MnEn4j9zFad4WOv+kDGFvUZRJi9k3nPqfB0OTcj9jZwtr0+bKDVmLOyxnsslmo74R7h9
         92Cl6Yutj9//hrEJQDMHx8LBlUJt4jCza7C9dXog9E5VcWqo0M8vMSPz61TqnC9RCb7w
         OAsyyEoGi359NlzKTNo+SgNz4hXIv65gUn8Fi3TN55dNP3i8Lrl4uxz7O+WflUi81iFv
         +tmQ==
X-Gm-Message-State: APjAAAVgbZbABmYviJVBDENwDxV1wF+QYXb4mVxGRp4PRxlVCzThRWhn
        NYgfW0x7uequbooW7I68AW7Asg==
X-Google-Smtp-Source: APXvYqxZIHbLA9yBX3FxyRkKYYl272yrE8HGEzLNuTZN/5CHV4WZz02PxBIsqqrCGJS9g8wC+4/QNg==
X-Received: by 2002:a17:90b:1115:: with SMTP id gi21mr21373708pjb.95.1577988566232;
        Thu, 02 Jan 2020 10:09:26 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id d14sm69390169pfq.117.2020.01.02.10.09.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jan 2020 10:09:25 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/2] ionic: support sr-iov operations
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20191213185516.52087-1-snelson@pensando.io>
 <20191213185516.52087-3-snelson@pensando.io>
 <5f85701b-278e-e7f9-dc43-d7572cc788d4@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d178c09a-7ef5-c3ea-f2f5-0ff314ce2ced@pensando.io>
Date:   Thu, 2 Jan 2020 10:09:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <5f85701b-278e-e7f9-dc43-d7572cc788d4@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 1:01 AM, Parav Pandit wrote:
> On 12/14/2019 12:25 AM, Shannon Nelson wrote:
>> Add the netdev ops for managing VFs.  Since most of the
>> management work happens in the NIC firmware, the driver becomes
>> mostly a pass-through for the network stack commands that want
>> to control and configure the VFs.
>>
>> We also tweak ionic_station_set() a little to allow for
>> the VFs that start off with a zero'd mac address.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic.h   |  17 +-
>>   .../ethernet/pensando/ionic/ionic_bus_pci.c   | 101 ++++++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 +++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 222 +++++++++++++++++-
>>   .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
>>   6 files changed, 401 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index 98e102af7756..74b358f03599 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -12,7 +12,7 @@ struct ionic_lif;
>>   
>>   #define IONIC_DRV_NAME		"ionic"
>>   #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
>> -#define IONIC_DRV_VERSION	"0.18.0-k"
>> +#define IONIC_DRV_VERSION	"0.20.0-k"
>>   
>>   #define PCI_VENDOR_ID_PENSANDO			0x1dd8
>>   
>> @@ -25,12 +25,25 @@ struct ionic_lif;
>>   
>>   #define DEVCMD_TIMEOUT  10
>>   
>> +struct ionic_vf {
>> +	u16	 index;
>> +	u8	 macaddr[6];
>> +	__le32	 maxrate;
>> +	__le16	 vlanid;
>> +	u8	 spoofchk;
>> +	u8	 trusted;
>> +	u8	 linkstate;
>> +	dma_addr_t       stats_pa;
>> +	struct ionic_lif_stats stats;
>> +};
>> +
>>   struct ionic {
>>   	struct pci_dev *pdev;
>>   	struct device *dev;
>>   	struct devlink_port dl_port;
>>   	struct ionic_dev idev;
>>   	struct mutex dev_cmd_lock;	/* lock for dev_cmd operations */
>> +	struct rw_semaphore vf_op_lock;	/* lock for VF operations */
> It is better to place this semaphore adjucent to other related VF fields
> you have below as they are all used together.

Sure

>>   	struct dentry *dentry;
>>   	struct ionic_dev_bar bars[IONIC_BARS_MAX];
>>   	unsigned int num_bars;
>> @@ -46,6 +59,8 @@ struct ionic {
>>   	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
>>   	struct work_struct nb_work;
>>   	struct notifier_block nb;
>> +	unsigned int num_vfs;
> If you intent to store this, store is as 'int' because that is what is
> coming from sriov_configure() at the moment.
> But it sholdn't be stored. More below.

I've worked out a way that we can both be happy - thanks.

>
>> +	struct ionic_vf **vf;
>>   	struct timer_list watchdog_timer;
>>   	int watchdog_period;
>>   };
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> index 9a9ab8cb2cb3..b9a3e1e1d41e 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> @@ -104,10 +104,101 @@ void ionic_bus_unmap_dbpage(struct ionic *ionic, void __iomem *page)
>>   	iounmap(page);
>>   }
>>   
>> +static void ionic_vf_dealloc(struct ionic *ionic)
>> +{
>> +	struct ionic_vf *v;
>> +	int i;
>> +
>> +	for (i = ionic->num_vfs - 1; i >= 0; i--) {
> Here you are checking for >= 0, so it must be 'int'.

Yep

>
>> +		v = ionic->vf[i];
>> +		dma_unmap_single(ionic->dev, v->stats_pa,
>> +				 sizeof(v->stats), DMA_FROM_DEVICE);
>> +		kfree(v);
>> +		ionic->vf[i] = NULL;
>> +	}
>> +
>> +	ionic->num_vfs = 0;
>> +	kfree(ionic->vf);
>> +	ionic->vf = NULL;
>> +}
>> +
>> +static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
>> +{
>> +	struct ionic_vf *v;
>> +	int err, i;
>> +
> int err;
> int i;

Sure

>
>> +	ionic->vf = kcalloc(num_vfs, sizeof(struct ionic_vf *), GFP_KERNEL);
>> +	if (!ionic->vf)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < num_vfs; i++) {
>> +		v = kzalloc(sizeof(*v), GFP_KERNEL);
>> +		if (!v) {
>> +			err = -ENOMEM;
>> +			goto err_out;
>> +		}
>> +
>> +		v->stats_pa = dma_map_single(ionic->dev, &v->stats,
>> +					     sizeof(v->stats), DMA_FROM_DEVICE);
>> +		if (dma_mapping_error(ionic->dev, v->stats_pa)) {
>> +			err = -ENODEV;
>> +			kfree(v);
>> +			ionic->vf[i] = NULL;
>> +			goto err_out;
>> +		}
>> +
>> +		ionic->vf[i] = v;
>> +		ionic->num_vfs++;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_out:
>> +	ionic_vf_dealloc(ionic);
>> +	return err;
>> +}
>> +
>> +static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
>> +{
>> +	struct ionic *ionic = pci_get_drvdata(pdev);
>> +	struct device *dev = ionic->dev;
>> +	int ret = 0;
>> +
>> +	down_write(&ionic->vf_op_lock);
>> +
>> +	if (num_vfs > 0) {
>> +		ret = pci_enable_sriov(pdev, num_vfs);
>> +		if (ret) {
>> +			dev_err(dev, "Cannot enable SRIOV: %d\n", ret);
>> +			goto out;
>> +		}
>> +
>> +		ret = ionic_vf_alloc(ionic, num_vfs);
>> +		if (ret) {
>> +			dev_err(dev, "Cannot alloc VFs: %d\n", ret);
>> +			pci_disable_sriov(pdev);
>> +			goto out;
>> +		}
>> +
>> +		ret = num_vfs;
>> +		goto out;
>> +	}
>> +
>> +	if (num_vfs == 0) {
> It should be the else of num_vfs > 0.

Done

>
>> +		pci_disable_sriov(pdev);
>> +		ionic_vf_dealloc(ionic);
>> +	}
>> +
>> +out:
>> +	up_write(&ionic->vf_op_lock);
>> +	return ret;
>> +}
>> +
>>   static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   {
>>   	struct device *dev = &pdev->dev;
>>   	struct ionic *ionic;
>> +	int num_vfs;
>>   	int err;
>>   
>>   	ionic = ionic_devlink_alloc(dev);
>> @@ -118,6 +209,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   	ionic->dev = dev;
>>   	pci_set_drvdata(pdev, ionic);
>>   	mutex_init(&ionic->dev_cmd_lock);
>> +	init_rwsem(&ionic->vf_op_lock);
>>   
> Better to initialize below before reading num_vfs, so all VF config code
> is adjcent to each other.

I normally like to prep my locks early, but fine.

>
>>   	/* Query system for DMA addressing limitation for the device. */
>>   	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(IONIC_ADDR_LEN));
>> @@ -206,6 +298,14 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   		goto err_out_free_lifs;
>>   	}
>>   
>> +	num_vfs = pci_num_vf(pdev);
>> +	if (num_vfs) {
>> +		dev_info(dev, "%d VFs found already enabled\n", num_vfs);
>> +		err = ionic_vf_alloc(ionic, num_vfs);
>> +		if (err)
>> +			dev_err(dev, "Cannot enable existing VFs: %d\n", err);
>> +	}
>> +
>>   	err = ionic_lifs_register(ionic);
>>   	if (err) {
>>   		dev_err(dev, "Cannot register LIFs: %d, aborting\n", err);
> There should be error unwinding to perform vf_dealloc() where
> lifs_register or other functions fail in the probe sequence. Otherwise
> its memory leak bug.

Yep

>
>> @@ -279,6 +379,7 @@ static struct pci_driver ionic_driver = {
>>   	.id_table = ionic_id_table,
>>   	.probe = ionic_probe,
>>   	.remove = ionic_remove,
>> +	.sriov_configure = ionic_sriov_configure,
>>   };
>>   
>>   int ionic_bus_register_driver(void)
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> index 5f9d2ec70446..87f82f36812f 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> @@ -286,6 +286,64 @@ void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
>>   	ionic_dev_cmd_go(idev, &cmd);
>>   }
>>   
>> +/* VF commands */
>> +int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
>> +{
>> +	union ionic_dev_cmd cmd = {
>> +		.vf_setattr.opcode = IONIC_CMD_VF_SETATTR,
>> +		.vf_setattr.attr = attr,
>> +		.vf_setattr.vf_index = vf,
>> +	};
>> +	int err;
>> +
>> +	switch (attr) {
>> +	case IONIC_VF_ATTR_SPOOFCHK:
>> +		cmd.vf_setattr.spoofchk = *data;
>> +		dev_dbg(ionic->dev, "%s: vf %d spoof %d\n",
>> +			__func__, vf, *data);
>> +		break;
>> +	case IONIC_VF_ATTR_TRUST:
>> +		cmd.vf_setattr.trust = *data;
>> +		dev_dbg(ionic->dev, "%s: vf %d trust %d\n",
>> +			__func__, vf, *data);
>> +		break;
>> +	case IONIC_VF_ATTR_LINKSTATE:
>> +		cmd.vf_setattr.linkstate = *data;
>> +		dev_dbg(ionic->dev, "%s: vf %d linkstate %d\n",
>> +			__func__, vf, *data);
>> +		break;
>> +	case IONIC_VF_ATTR_MAC:
>> +		ether_addr_copy(cmd.vf_setattr.macaddr, data);
>> +		dev_dbg(ionic->dev, "%s: vf %d macaddr %pM\n",
>> +			__func__, vf, data);
>> +		break;
>> +	case IONIC_VF_ATTR_VLAN:
>> +		cmd.vf_setattr.vlanid = cpu_to_le16(*(u16 *)data);
>> +		dev_dbg(ionic->dev, "%s: vf %d vlan %d\n",
>> +			__func__, vf, *(u16 *)data);
>> +		break;
>> +	case IONIC_VF_ATTR_RATE:
>> +		cmd.vf_setattr.maxrate = cpu_to_le32(*(u32 *)data);
>> +		dev_dbg(ionic->dev, "%s: vf %d maxrate %d\n",
>> +			__func__, vf, *(u32 *)data);
>> +		break;
>> +	case IONIC_VF_ATTR_STATSADDR:
>> +		cmd.vf_setattr.stats_pa = cpu_to_le64(*(u64 *)data);
>> +		dev_dbg(ionic->dev, "%s: vf %d stats_pa 0x%08llx\n",
>> +			__func__, vf, *(u64 *)data);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +	ionic_dev_cmd_go(&ionic->idev, &cmd);
>> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +
>> +	return err;
>> +}
>> +
>>   /* LIF commands */
>>   void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver)
>>   {
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> index 4665c5dc5324..7838e342c4fd 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> @@ -113,6 +113,12 @@ static_assert(sizeof(struct ionic_rxq_desc) == 16);
>>   static_assert(sizeof(struct ionic_rxq_sg_desc) == 128);
>>   static_assert(sizeof(struct ionic_rxq_comp) == 16);
>>   
>> +/* SR/IOV */
>> +static_assert(sizeof(struct ionic_vf_setattr_cmd) == 64);
>> +static_assert(sizeof(struct ionic_vf_setattr_comp) == 16);
>> +static_assert(sizeof(struct ionic_vf_getattr_cmd) == 64);
>> +static_assert(sizeof(struct ionic_vf_getattr_comp) == 16);
>> +
>>   struct ionic_devinfo {
>>   	u8 asic_type;
>>   	u8 asic_rev;
>> @@ -275,6 +281,7 @@ void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
>>   void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
>>   void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
>>   
>> +int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data);
>>   void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
>>   void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
>>   			    dma_addr_t addr);
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 60fd14df49d7..6cd6ac1fff81 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1616,6 +1616,202 @@ int ionic_stop(struct net_device *netdev)
>>   	return err;
>>   }
>>   
>> +static int ionic_get_vf_config(struct net_device *netdev,
>> +			       int vf, struct ifla_vf_info *ivf)
>> +{
>> +	struct ionic_lif *lif = netdev_priv(netdev);
>> +	struct ionic *ionic = lif->ionic;
>> +
>> +	if (vf >= ionic->num_vfs)
>> +		return -EINVAL;
>> +
> Move this check as below after vf_op_lock as
>
> if (vf >= pci_num_vfs(pci_dev)
> 	return -EINVAL;
>
> Similarly for other friends function below.

Done.

Thanks for your time, now that the holidays are over I'll have an 
updated patch out soon.

sln


