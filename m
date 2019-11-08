Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071ACF4488
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbfKHKcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:32:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33612 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731569AbfKHKcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 05:32:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id a17so6243738wmb.0
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 02:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/1599gDqgQT4+/ACcw8+n9g4WwihJtSkWdJ83xtYrrs=;
        b=tb4sJLDi3Exe9JAsUa23Y+q1nk0BHHKEf85IQjE8dNvtPaxihDfBjebMrPHoN/i/nR
         re4YFq0qshzrfoskQMQ6QXs9iloB9UOmtKTi4RyZTaX1HZZYNynxRU5WmeROLB5HNUhT
         REcqzGm6BBj0Lh7ByTWCfz3V3pSZQh7tDnSEipHlxYO+e6+jWLPN78gtUqUlXlNOfH7o
         Q4pHpeAewlMluV03h3vVb2Nk+rVOf8Wfd7+FnAxvEoLKsbAyftjMv2Zpeb9F9/Q+wqvn
         8dgi9Lz7CnUVVshn17/hHQgRMiNIGdcoLjpURMVK6oT0AHZt2hVJrLj7i/S3khN7AfsW
         m5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/1599gDqgQT4+/ACcw8+n9g4WwihJtSkWdJ83xtYrrs=;
        b=N65ekhqOO9hpM6XUY2s+NF983K/yQ4qkV7JvL6LHwJnMo2INK6zaSLs7HhAOAbR/E2
         XK/EtxoUcEadXoZ1iBBatDrLiqcwZslSet8aumeE+lndrO4KXdRT00ERmYK+VCEj0Cj6
         uPbxAvXZu/OxGCA0zv6xbjh2ieSB5FJMopYrLhbyY3C1sNfOokGzTLBrxb3YrUVKfMAa
         p/vfhcvS3bv6MYGP3ORgS7vBnP6ogpO0uKdAMT/M23QfIA/qOZcRgDRPhnnanjUesJJe
         aAMqeK9roWErW2RC+b6HoYcdB++uzcz4slAXzdH9V9kN/YAnJc45KK2b1BvzOc34ELZb
         z70g==
X-Gm-Message-State: APjAAAVbjK+Pw7JJZfOE3LrjSp+pYIIStk5+ImoQGfGr59PpwDjjCGGK
        nWDles4TKPZ8CZRqea2XFWvPvA==
X-Google-Smtp-Source: APXvYqxP9nvHJSdV76uw+81FjfoIdq73P2BH1K7A+UszgAXvHwfbJNXN8UNx4RKJgQCCFfnklok1PQ==
X-Received: by 2002:a1c:6885:: with SMTP id d127mr7243732wmc.64.1573209170449;
        Fri, 08 Nov 2019 02:32:50 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id a5sm5462412wrv.56.2019.11.08.02.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 02:32:50 -0800 (PST)
Date:   Fri, 8 Nov 2019 11:32:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Vu Pham <vuhuong@mellanox.com>
Subject: Re: [PATCH net-next 06/19] net/mlx5: Add support for mediated
 devices in switchdev mode
Message-ID: <20191108103249.GE6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-6-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-6-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 07, 2019 at 05:08:21PM CET, parav@mellanox.com wrote:
>From: Vu Pham <vuhuong@mellanox.com>

[...]

	
>+static ssize_t
>+max_mdevs_show(struct kobject *kobj, struct device *dev, char *buf)
>+{
>+	struct pci_dev *pdev = to_pci_dev(dev);
>+	struct mlx5_core_dev *coredev;
>+	struct mlx5_mdev_table *table;
>+	u16 max_sfs;
>+
>+	coredev = pci_get_drvdata(pdev);
>+	table = coredev->priv.eswitch->mdev_table;
>+	max_sfs = mlx5_core_max_sfs(coredev, &table->sf_table);
>+
>+	return sprintf(buf, "%d\n", max_sfs);
>+}
>+static MDEV_TYPE_ATTR_RO(max_mdevs);
>+
>+static ssize_t
>+available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
>+{
>+	struct pci_dev *pdev = to_pci_dev(dev);
>+	struct mlx5_core_dev *coredev;
>+	struct mlx5_mdev_table *table;
>+	u16 free_sfs;
>+
>+	coredev = pci_get_drvdata(pdev);
>+	table = coredev->priv.eswitch->mdev_table;
>+	free_sfs = mlx5_get_free_sfs(coredev, &table->sf_table);
>+	return sprintf(buf, "%d\n", free_sfs);
>+}
>+static MDEV_TYPE_ATTR_RO(available_instances);

These 2 arbitrary sysfs files are showing resource size/usage for
the whole eswitch/asic. That is a job for "devlink resource". Please
implement that.


>+
>+static struct attribute *mdev_dev_attrs[] = {
>+	&mdev_type_attr_max_mdevs.attr,
>+	&mdev_type_attr_available_instances.attr,
>+	NULL,
>+};
>+
>+static struct attribute_group mdev_mgmt_group = {
>+	.name  = "local",
>+	.attrs = mdev_dev_attrs,
>+};
>+
>+static struct attribute_group *mlx5_meddev_groups[] = {
>+	&mdev_mgmt_group,
>+	NULL,
>+};

[...]
