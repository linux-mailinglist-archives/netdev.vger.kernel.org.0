Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1731EF4D11
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfKHNWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:22:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37905 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfKHNWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:22:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so130464wro.5
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 05:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cBsuV6lhsX+rIy99bACBsVO4uTxrbxnKAG7+zgmVfls=;
        b=ZVpa7tAZSw7YDtFqqf8LbpXzAeNODTzklSFa34o2mX8On1jsvwngEuswYT4VjGJRAv
         jA3qRVsei5odkquqC/GeG3J+Byr7mYEr7cRrzN8uSsmUWzIfuqHtmn9RL7wzpiS7ewFW
         XhidJiYXoMGghUtfPQSSRKfGKLxrZTvQK/OVkldNSRg4abQNssEKKEhU6ti2BHlkyksO
         jzCqylpDjwXZluzA7v5DzMAWaTdMJUaEUFhSbBiyTD8aSneF4eUQXGOoj+a5yuVEqRGe
         tvMV21VGpkqhePH/ixQDUdRc7MeNOKmuc1rKfcB9NTN6Wo+bXz/hWDGECDBO4XPcAanJ
         j6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cBsuV6lhsX+rIy99bACBsVO4uTxrbxnKAG7+zgmVfls=;
        b=I8vUG6bVJkcAcYeGjfl19aIQISM3k0FMVepCH3Tgbst9rRaKL0cjPFT4kRJ3bmPxeW
         7Gw1ReS7RkgFOK/e/v60jvOgx4/Lyp9w/YQtlkyD5+S8O6CbELNEd64JwFWTUAAQZt+C
         PVmIfiOzYkg2v/8VIZm3WFRYWLuX1GeSQ4iYFzpOnDNXeB8clGuVhiRzusfUgoIhniwS
         CG5wYYCnmYoKSa+ZhbXkI/DcY1zUDyVxlWO3zr7aUpfzxvYL9wNOn+fpWmbhXmhr4wht
         uPLmTU6V4tSkMcORRL2UsMZn3nfkItgvZbD13yX4Rqgxrk+HV9Tbh+elOURxX7SFAXMH
         D/Gg==
X-Gm-Message-State: APjAAAVZDF81gaJkGxRFV7kdu+b+H/tyqktQzCi+W2EHtsZQzOw6CJ6Y
        pgD7qxYQTlfVM2AKIQuIa9K67g==
X-Google-Smtp-Source: APXvYqyvpSQNfobxxQwiiXvZY3yr8ZcLuoARu9hecr9HmrkXZ0MbPJKjK3A1aoOdotynZTKYgs+/9Q==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr8305770wrr.75.1573219350956;
        Fri, 08 Nov 2019 05:22:30 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id m13sm5457672wmc.41.2019.11.08.05.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 05:22:30 -0800 (PST)
Date:   Fri, 8 Nov 2019 14:22:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 09/19] vfio/mdev: Expose mdev alias in sysfs tree
Message-ID: <20191108132230.GK6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-9-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-9-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 07, 2019 at 05:08:24PM CET, parav@mellanox.com wrote:

[...]

> 
>+static ssize_t alias_show(struct device *device,
>+			  struct device_attribute *attr, char *buf)
>+{
>+	struct mdev_device *dev = mdev_from_dev(device);
>+
>+	if (!dev->alias)
>+		return -EOPNOTSUPP;
>+
>+	return sprintf(buf, "%s\n", dev->alias);
>+}
>+static DEVICE_ATTR_RO(alias);

I wonder, rather than adding another sysfs file, why the alias can't be
simply a symlink to the aliased mdev directory?


>+
> static const struct attribute *mdev_device_attrs[] = {
>+	&dev_attr_alias.attr,
> 	&dev_attr_remove.attr,
> 	NULL,
> };
>-- 
>2.19.2
>
