Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A5D8D01
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 11:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404301AbfJPJx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 05:53:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37224 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392149AbfJPJx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 05:53:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id f22so2045000wmc.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 02:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qf9NtBZ5qTpIFRAmXNYU6K97H3JPME374v8E9COonjY=;
        b=vNkqxt5exdbVHHvpMk5DT+NV5A5XTTJwiyTBj+DEkDxey0L/i/SgkOSf0uacmL7y0h
         Ec7FNxehc5tTW5L6FTuD+mauaVLWFgd9CI2gmc89VGZgvGgPskUb0nBMqvw+iWz4w4IM
         Cm0WGuFERXTOaHALut2hTXc52efbUGn1Gq04hUD16y1ANsu0bXMbeiTg7DrY/ooljSJ+
         YBFmHTtqtROL8ftP22E0bLk+qmg991oHIsA/U012c7ljMiM/zOJ/o8LQQDpkiPv6i9q3
         RQ+ru5rNAxuApcmqD62Mon/yvRNiGzZ4PPWArHQ9QU6dhJ4f/P8q7kQWPMroskhhQli+
         jr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qf9NtBZ5qTpIFRAmXNYU6K97H3JPME374v8E9COonjY=;
        b=D39iav54BBbtwdpl/bRFOgdiQiTyWv9mxJ2oQ5n9sdCP2INzJrvOb/OstoDDkAcQ36
         ZYGf9RoOLmypDhui8ibhJ23vsYPZAjQig003Z/U+PXt7d4Q+qUcGNscLB17kP9/Vap0r
         OORttg6J0tWmkcrbbfBaSUo2fw+QxIBxCpzwfdTK5wBupaleV7u8zUYKVuR5skecHsxC
         Lt06eM3E89cbJbH4KSQMlxgFAmF+1zqSDqAVBMJqxdPWsN+Fc1nuAG4NI6WrsGXDslax
         Sdxb3xu29YfTB8nG0xeGDz9eO5qPY4YrlqJLiENbgIG+3cN7WSSCZScidRdX96zuwCMc
         EDYQ==
X-Gm-Message-State: APjAAAWqFh3o5O2L7bJODKsst/akFoz2H5cMB92LJCpofhIyOhsK3jeo
        5NrsDz3eqbh58+j65rX3WL04rg==
X-Google-Smtp-Source: APXvYqxbbbENME/xmqfG7vp6qgZNi7CeYcPlqOf0zIogc5C/uiyQmK5E8F8QfjByn+c7btmQJ2JMVw==
X-Received: by 2002:a1c:2cc4:: with SMTP id s187mr2669566wms.166.1571219633514;
        Wed, 16 Oct 2019 02:53:53 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id q124sm3279085wma.5.2019.10.16.02.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 02:53:52 -0700 (PDT)
Date:   Wed, 16 Oct 2019 11:53:51 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com, tiwei.bie@intel.com,
        jason.zeng@intel.com, zhiyuan.lv@intel.com
Subject: Re: [RFC 2/2] vhost: IFC VF vdpa layer
Message-ID: <20191016095350.fydss6jj6t77a5qk@netronome.com>
References: <20191016010318.3199-1-lingshan.zhu@intel.com>
 <20191016010318.3199-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016010318.3199-3-lingshan.zhu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhu,

thanks for your patch.

On Wed, Oct 16, 2019 at 09:03:18AM +0800, Zhu Lingshan wrote:
> This commit introduced IFC VF operations for vdpa, which complys to
> vhost_mdev interfaces, handles IFC VF initialization,
> configuration and removal.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vhost/ifcvf/ifcvf_main.c | 541 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 541 insertions(+)
>  create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
> 
> diff --git a/drivers/vhost/ifcvf/ifcvf_main.c b/drivers/vhost/ifcvf/ifcvf_main.c
> new file mode 100644
> index 000000000000..c48a29969a85
> --- /dev/null
> +++ b/drivers/vhost/ifcvf/ifcvf_main.c
> @@ -0,0 +1,541 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2019 Intel Corporation.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/mdev.h>
> +#include <linux/pci.h>
> +#include <linux/sysfs.h>
> +
> +#include "ifcvf_base.h"
> +
> +#define VERSION_STRING	"0.1"
> +#define DRIVER_AUTHOR	"Intel Corporation"
> +#define IFCVF_DRIVER_NAME	"ifcvf"
> +
> +static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
> +{
> +	struct vring_info *vring = arg;
> +
> +	if (vring->cb.callback)
> +		return vring->cb.callback(vring->cb.private);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static u64 ifcvf_mdev_get_features(struct mdev_device *mdev)
> +{
> +	return IFC_SUPPORTED_FEATURES;
> +}
> +
> +static int ifcvf_mdev_set_features(struct mdev_device *mdev, u64 features)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);

Perhaps a helper that takes a struct mdev_device would be useful.
The pattern above seems to be repeated many times.

> +
> +	vf->req_features = features;
> +
> +	return 0;
> +}
> +
> +static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev, u16 qid)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->vring[qid].last_avail_idx;
> +}
> +
> +static int ifcvf_mdev_set_vq_state(struct mdev_device *mdev, u16 qid, u64 num)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[qid].last_used_idx = num;
> +	vf->vring[qid].last_avail_idx = num;
> +
> +	return 0;
> +}
> +
> +static int ifcvf_mdev_set_vq_address(struct mdev_device *mdev, u16 idx,
> +				     u64 desc_area, u64 driver_area,
> +				     u64 device_area)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[idx].desc = desc_area;
> +	vf->vring[idx].avail = driver_area;
> +	vf->vring[idx].used = device_area;
> +
> +	return 0;
> +}
> +
> +static void ifcvf_mdev_set_vq_num(struct mdev_device *mdev, u16 qid, u32 num)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[qid].size = num;
> +}
> +
> +static void ifcvf_mdev_set_vq_ready(struct mdev_device *mdev,
> +				u16 qid, bool ready)

u16 should be vertically whitespace aligned with struct mdev_device.

> +{
> +
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[qid].ready = ready;
> +}
> +
> +static bool ifcvf_mdev_get_vq_ready(struct mdev_device *mdev, u16 qid)
> +{
> +
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->vring[qid].ready;
> +}
> +
> +static void ifcvf_mdev_set_vq_cb(struct mdev_device *mdev, u16 idx,
> +				 struct virtio_mdev_callback *cb)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->vring[idx].cb = *cb;
> +}
> +
> +static void ifcvf_mdev_kick_vq(struct mdev_device *mdev, u16 idx)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	ifcvf_notify_queue(vf, idx);
> +}
> +
> +static u8 ifcvf_mdev_get_status(struct mdev_device *mdev)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->status;
> +}
> +
> +static u32 ifcvf_mdev_get_generation(struct mdev_device *mdev)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	return vf->generation;
> +}
> +
> +static int ifcvf_mdev_get_version(struct mdev_device *mdev)
> +{
> +	return VIRTIO_MDEV_VERSION;
> +}
> +
> +static u32 ifcvf_mdev_get_device_id(struct mdev_device *mdev)
> +{
> +	return IFCVF_DEVICE_ID;
> +}
> +
> +static u32 ifcvf_mdev_get_vendor_id(struct mdev_device *mdev)
> +{
> +	return IFCVF_VENDOR_ID;
> +}
> +
> +static u16 ifcvf_mdev_get_vq_align(struct mdev_device *mdev)
> +{
> +	return IFCVF_QUEUE_ALIGNMENT;
> +}
> +
> +static int ifcvf_start_datapath(void *private)
> +{
> +	int i, ret;
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(private);
> +
> +	for (i = 0; i < (IFCVF_MAX_QUEUE_PAIRS * 2); i++) {

The inner parentheses above seem unnecessary.

> +		if (!vf->vring[i].ready)
> +			break;
> +
> +		if (!vf->vring[i].size)
> +			break;
> +
> +		if (!vf->vring[i].desc || !vf->vring[i].avail ||
> +			!vf->vring[i].used)
> +			break;
> +	}
> +	vf->nr_vring = i;
> +
> +	ret = ifcvf_start_hw(vf);
> +	return ret;
> +}
> +
> +static int ifcvf_stop_datapath(void *private)
> +{
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(private);
> +	int i;
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUES; i++)
> +		vf->vring[i].cb.callback = NULL;
> +
> +	ifcvf_stop_hw(vf);
> +
> +	return 0;
> +}
> +
> +static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
> +{
> +	int i;
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		vf->vring[i].last_used_idx = 0;
> +		vf->vring[i].last_avail_idx = 0;
> +		vf->vring[i].desc = 0;
> +		vf->vring[i].avail = 0;
> +		vf->vring[i].used = 0;
> +		vf->vring[i].ready = 0;
> +		vf->vring->cb.callback = NULL;
> +		vf->vring->cb.private = NULL;
> +	}
> +}
> +
> +static void ifcvf_mdev_set_status(struct mdev_device *mdev, u8 status)
> +{
> +	struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +
> +	vf->status = status;
> +
> +	if (status == 0) {
> +		ifcvf_stop_datapath(adapter);
> +		ifcvf_reset_vring(adapter);
> +		return;
> +	}
> +
> +	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
> +		ifcvf_start_datapath(adapter);
> +		return;
> +	}
> +}
> +
> +static u16 ifcvf_mdev_get_queue_max(struct mdev_device *mdev)
> +{
> +	return IFCVF_MAX_QUEUES;
> +}
> +
> +static struct virtio_mdev_device_ops ifc_mdev_ops = {
> +	.get_features  = ifcvf_mdev_get_features,
> +	.set_features  = ifcvf_mdev_set_features,
> +	.get_status    = ifcvf_mdev_get_status,
> +	.set_status    = ifcvf_mdev_set_status,
> +	.get_queue_max = ifcvf_mdev_get_queue_max,
> +	.get_vq_state   = ifcvf_mdev_get_vq_state,
> +	.set_vq_state   = ifcvf_mdev_set_vq_state,
> +	.set_vq_cb      = ifcvf_mdev_set_vq_cb,
> +	.set_vq_ready   = ifcvf_mdev_set_vq_ready,
> +	.get_vq_ready	= ifcvf_mdev_get_vq_ready,
> +	.set_vq_num     = ifcvf_mdev_set_vq_num,
> +	.set_vq_address = ifcvf_mdev_set_vq_address,
> +	.kick_vq        = ifcvf_mdev_kick_vq,
> +	.get_generation	= ifcvf_mdev_get_generation,
> +	.get_version	= ifcvf_mdev_get_version,
> +	.get_device_id	= ifcvf_mdev_get_device_id,
> +	.get_vendor_id	= ifcvf_mdev_get_vendor_id,
> +	.get_vq_align	= ifcvf_mdev_get_vq_align,
> +};
> +
> +static int ifcvf_init_msix(struct ifcvf_adapter *adapter)
> +{
> +	int vector, i, ret, irq;
> +	struct pci_dev *pdev = to_pci_dev(adapter->dev);
> +	struct ifcvf_hw *vf = &adapter->vf;
> +
> +	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> +			IFCVF_MAX_INTR, PCI_IRQ_MSIX);
> +	if (ret < 0) {
> +		IFC_ERR(adapter->dev, "Failed to alloc irq vectors.\n");
> +		return ret;
> +	}
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		vector = i + IFCVF_MSI_QUEUE_OFF;
> +		irq = pci_irq_vector(pdev, vector);
> +		ret = request_irq(irq, ifcvf_intr_handler, 0,
> +				pci_name(pdev), &vf->vring[i]);
> +		if (ret) {
> +			IFC_ERR(adapter->dev,
> +				"Failed to request irq for vq %d.\n", i);
> +			return ret;

Is it worthwhile unwinding earlier successful calls to
request_irq() and pci_alloc_irq_vectors() here?
It seems that some resources may be leaked and
the system can otherwise continue.

> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void ifcvf_destroy_adapter(struct ifcvf_adapter *adapter)
> +{
> +	int i, vector, irq;
> +	struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
> +	struct pci_dev *pdev = to_pci_dev(adapter->dev);
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		vector = i + IFCVF_MSI_QUEUE_OFF;
> +		irq = pci_irq_vector(pdev, vector);
> +		free_irq(irq, &vf->vring[i]);
> +	}
> +}
> +
> +static ssize_t name_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	const char *name = "vhost accelerator (virtio ring compatible)";
> +
> +	return sprintf(buf, "%s\n", name);
> +}
> +MDEV_TYPE_ATTR_RO(name);
> +
> +static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
> +			       char *buf)
> +{
> +	return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_STRING);
> +}
> +MDEV_TYPE_ATTR_RO(device_api);
> +
> +static ssize_t available_instances_show(struct kobject *kobj,
> +					struct device *dev, char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", adapter->mdev_count);
> +}
> +
> +MDEV_TYPE_ATTR_RO(available_instances);
> +
> +static ssize_t type_show(struct kobject *kobj,
> +			struct device *dev, char *buf)
> +{
> +	return sprintf(buf, "%s\n", "net");
> +}
> +
> +MDEV_TYPE_ATTR_RO(type);
> +
> +
> +static struct attribute *mdev_types_attrs[] = {
> +	&mdev_type_attr_name.attr,
> +	&mdev_type_attr_device_api.attr,
> +	&mdev_type_attr_available_instances.attr,
> +	&mdev_type_attr_type.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_group = {
> +	.name  = "vdpa_virtio",
> +	.attrs = mdev_types_attrs,
> +};
> +
> +static struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_group,
> +	NULL,
> +};
> +
> +const struct attribute_group *mdev_dev_groups[] = {
> +	NULL,
> +};
> +
> +static int ifcvf_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
> +{
> +	struct device *dev = mdev_parent_dev(mdev);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +	int ret = 0;
> +
> +	mutex_lock(&adapter->mdev_lock);
> +
> +	if (adapter->mdev_count < 1) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	mdev_set_class_id(mdev, MDEV_ID_VHOST);
> +	mdev_set_dev_ops(mdev, &ifc_mdev_ops);
> +
> +	mdev_set_drvdata(mdev, adapter);
> +	mdev_set_iommu_device(mdev_dev(mdev), dev);
> +
> +	INIT_LIST_HEAD(&adapter->dma_maps);

dma_maps appears to be initialised but otherwise unused.

If it is needed would it make more sense to initialise it in the probe
function? That seems to be where adapter is initialised.

> +	adapter->mdev_count--;
> +
> +out:
> +	mutex_unlock(&adapter->mdev_lock);
> +	return ret;
> +}
> +
> +static int ifcvf_mdev_remove(struct mdev_device *mdev)
> +{
> +	struct device *dev = mdev_parent_dev(mdev);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +
> +	mutex_lock(&adapter->mdev_lock);
> +	adapter->mdev_count++;
> +	mutex_unlock(&adapter->mdev_lock);
> +
> +	return 0;
> +}
> +
> +static struct mdev_parent_ops ifcvf_mdev_fops = {
> +	.owner			= THIS_MODULE,
> +	.supported_type_groups	= mdev_type_groups,
> +	.mdev_attr_groups	= mdev_dev_groups,
> +	.create			= ifcvf_mdev_create,
> +	.remove			= ifcvf_mdev_remove,
> +};
> +
> +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ifcvf_adapter *adapter;
> +	struct ifcvf_hw *vf;
> +	int ret, i;
> +
> +	adapter = kzalloc(sizeof(struct ifcvf_adapter), GFP_KERNEL);
> +	if (adapter == NULL) {
> +		ret = -ENOMEM;
> +		goto fail;

I think it would be cleaner to just return here.

> +	}
> +
> +	mutex_init(&adapter->mdev_lock);
> +	adapter->mdev_count = 1;
> +	adapter->dev = dev;
> +
> +	pci_set_drvdata(pdev, adapter);
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		IFC_ERR(adapter->dev, "Failed to enable device.\n");
> +		goto free_adapter;
> +	}
> +
> +	ret = pci_request_regions(pdev, IFCVF_DRIVER_NAME);
> +	if (ret) {
> +		IFC_ERR(adapter->dev, "Failed to request MMIO region.\n");
> +		goto disable_device;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	ret = ifcvf_init_msix(adapter);
> +	if (ret) {
> +		IFC_ERR(adapter->dev, "Failed to initialize MSIX.\n");
> +		goto free_msix;
> +	}
> +
> +	vf = &adapter->vf;
> +	for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
> +		vf->mem_resource[i].phys_addr = pci_resource_start(pdev, i);
> +		vf->mem_resource[i].len = pci_resource_len(pdev, i);
> +		if (!vf->mem_resource[i].len) {
> +			vf->mem_resource[i].addr = NULL;
> +			continue;
> +		}
> +
> +		vf->mem_resource[i].addr = pci_iomap_range(pdev, i, 0,
> +				vf->mem_resource[i].len);
> +		if (!vf->mem_resource[i].addr) {
> +			IFC_ERR(adapter->dev, "Failed to map IO resource %d\n",
> +				i);

There is cleanup code in this function. But in this case, and one more
below, the function simply returns on error. At the very least this seems
inconsistent.

> +			return -1;
> +		}
> +	}
> +
> +	if (ifcvf_init_hw(vf, pdev) < 0)
> +		return -1;
> +
> +	ret = mdev_register_device(dev, &ifcvf_mdev_fops);
> +	if (ret) {
> +		IFC_ERR(adapter->dev,  "Failed to register mdev device\n");
> +		goto destroy_adapter;
> +	}
> +
> +	return 0;
> +
> +destroy_adapter:
> +	ifcvf_destroy_adapter(adapter);
> +free_msix:
> +	pci_free_irq_vectors(pdev);
> +	pci_release_regions(pdev);
> +disable_device:
> +	pci_disable_device(pdev);
> +free_adapter:
> +	kfree(adapter);
> +fail:
> +	return ret;
> +}
> +
> +static void ifcvf_remove(struct pci_dev *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +	struct ifcvf_hw *vf;
> +	int i;
> +
> +	mdev_unregister_device(dev);
> +
> +	vf = &adapter->vf;
> +	for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
> +		if (vf->mem_resource[i].addr) {
> +			pci_iounmap(pdev, vf->mem_resource[i].addr);
> +			vf->mem_resource[i].addr = NULL;
> +		}
> +	}
> +
> +	ifcvf_destroy_adapter(adapter);
> +	pci_free_irq_vectors(pdev);
> +
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +
> +	kfree(adapter);
> +}
> +
> +static struct pci_device_id ifcvf_pci_ids[] = {
> +	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
> +			IFCVF_DEVICE_ID,
> +			IFCVF_SUBSYS_VENDOR_ID,
> +			IFCVF_SUBSYS_DEVICE_ID) },
> +	{ 0 },
> +};
> +MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
> +
> +static struct pci_driver ifcvf_driver = {
> +	.name     = IFCVF_DRIVER_NAME,
> +	.id_table = ifcvf_pci_ids,
> +	.probe    = ifcvf_probe,
> +	.remove   = ifcvf_remove,
> +};
> +
> +static int __init ifcvf_init_module(void)
> +{
> +	int ret;
> +
> +	ret = pci_register_driver(&ifcvf_driver);
> +	return ret;
> +}
> +
> +static void __exit ifcvf_exit_module(void)
> +{
> +	pci_unregister_driver(&ifcvf_driver);
> +}
> +
> +module_init(ifcvf_init_module);
> +module_exit(ifcvf_exit_module);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION(VERSION_STRING);
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> -- 
> 2.16.4
> 
