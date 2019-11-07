Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B96F38C2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfKGThO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:37:14 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10167 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfKGThN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 14:37:13 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc4722b0000>; Thu, 07 Nov 2019 11:36:11 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 07 Nov 2019 11:37:11 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 07 Nov 2019 11:37:11 -0800
Received: from [10.25.75.102] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Nov
 2019 19:36:46 +0000
Subject: Re: [PATCH V11 2/6] modpost: add support for mdev class id
To:     Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <alex.williamson@redhat.com>, <mst@redhat.com>,
        <tiwei.bie@intel.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <cohuck@redhat.com>,
        <maxime.coquelin@redhat.com>, <cunming.liang@intel.com>,
        <zhihong.wang@intel.com>, <rob.miller@broadcom.com>,
        <xiao.w.wang@intel.com>, <haotian.wang@sifive.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
        <farman@linux.ibm.com>, <pasic@linux.ibm.com>,
        <sebott@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <heiko.carstens@de.ibm.com>, <gor@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <akrowiak@linux.ibm.com>,
        <freude@linux.ibm.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <lulu@redhat.com>, <parav@mellanox.com>,
        <christophe.de.dinechin@gmail.com>, <kevin.tian@intel.com>,
        <stefanha@redhat.com>, <rdunlap@infradead.org>
References: <20191107151109.23261-1-jasowang@redhat.com>
 <20191107151109.23261-3-jasowang@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <89d87e49-e7ee-f3c4-0b81-1c5fba14959b@nvidia.com>
Date:   Fri, 8 Nov 2019 01:06:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191107151109.23261-3-jasowang@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573155371; bh=C2IiKLCi5MxuqQL+UTo7qPQFnl5cEfi56SIRvfy2YGM=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ifafetc69TFDlF+u0W/mHtbNzRQR/osuovOIreTBgk1lhGdLJNjFu5Bk9mrqxjrEb
         d1FRJReVeAsawZC6zhQags+JTG3PbB4NaENHsEBOVclHToJF9KJYSdYyTM3Z7wqYR5
         Cu9861xR9tSSBHvKUTxcCRHz5x9gpw5qk6WPOuXEMV72OgwdkmPUN3jeB+StDQGHhb
         +wKc7iPQF/2NZVTfiK+OWuFpP8SvJP0SX8lNSbUxipwIAHaqMSicwHEX95dJVMXWfD
         AOKSQbVbqm5uT31bTnxX1B7X9/QhlnNUl9r6dHEo7JVXMUWexHbp1Po2Kr1dgK4HFH
         UhKKQJREHZIgQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/2019 8:41 PM, Jason Wang wrote:
> Add support to parse mdev class id table.
> 
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

Thanks,
Kirti

> ---
>   drivers/vfio/mdev/vfio_mdev.c     |  2 ++
>   scripts/mod/devicetable-offsets.c |  3 +++
>   scripts/mod/file2alias.c          | 11 +++++++++++
>   3 files changed, 16 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index 38431e9ef7f5..a6641cd8b5a3 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -125,6 +125,8 @@ static const struct mdev_class_id vfio_id_table[] = {
>   	{ 0 },
>   };
>   
> +MODULE_DEVICE_TABLE(mdev, vfio_id_table);
> +
>   static struct mdev_driver vfio_mdev_driver = {
>   	.name	= "vfio_mdev",
>   	.probe	= vfio_mdev_probe,
> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
> index 054405b90ba4..6cbb1062488a 100644
> --- a/scripts/mod/devicetable-offsets.c
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -231,5 +231,8 @@ int main(void)
>   	DEVID(wmi_device_id);
>   	DEVID_FIELD(wmi_device_id, guid_string);
>   
> +	DEVID(mdev_class_id);
> +	DEVID_FIELD(mdev_class_id, id);
> +
>   	return 0;
>   }
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index c91eba751804..45f1c22f49be 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -1335,6 +1335,16 @@ static int do_wmi_entry(const char *filename, void *symval, char *alias)
>   	return 1;
>   }
>   
> +/* looks like: "mdev:cN" */
> +static int do_mdev_entry(const char *filename, void *symval, char *alias)
> +{
> +	DEF_FIELD(symval, mdev_class_id, id);
> +
> +	sprintf(alias, "mdev:c%02X", id);
> +	add_wildcard(alias);
> +	return 1;
> +}
> +
>   /* Does namelen bytes of name exactly match the symbol? */
>   static bool sym_is(const char *name, unsigned namelen, const char *symbol)
>   {
> @@ -1407,6 +1417,7 @@ static const struct devtable devtable[] = {
>   	{"typec", SIZE_typec_device_id, do_typec_entry},
>   	{"tee", SIZE_tee_client_device_id, do_tee_entry},
>   	{"wmi", SIZE_wmi_device_id, do_wmi_entry},
> +	{"mdev", SIZE_mdev_class_id, do_mdev_entry},
>   };
>   
>   /* Create MODULE_ALIAS() statements.
> 
