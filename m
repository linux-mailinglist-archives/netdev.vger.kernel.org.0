Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52449F454F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfKHLFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:05:00 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35796 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730144AbfKHLFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 06:05:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id p2so6586510wro.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 03:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qClGC0T3WH5YyB2W/OoTwP1eHOuHk4Y1TEFsfgduaWc=;
        b=chcx5uv0rVk59KY2cl6bY8LK0AqQ/S85R+yppY4oXhEKz5mmPXkKqudB65t2eLuHm1
         8HH4I6Aw6+6maTO8Va0rwSZTkp/hL3TITy0RstUz50FGBDEPdpZokLrLDdJz2VlLJCJn
         8QmQr3ux014JLe7996RWQ6ihLk/OfEYgZ4CTPgreGGXUIzPbDLbx/+G40+UzcSGCHXUH
         ruz67el5Y/wfDb/+CkciJ8cQFa8sIu+xFDSL/DCsoRLvGnTxmfyC4Roqgp/AfsLjawh6
         6yXt0sOWFC2RMHyD4XleCtkMCawIYaEdCk3PyElh+2tOR0gwvlPkiPqohWo9xwWRgWdo
         2Jvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qClGC0T3WH5YyB2W/OoTwP1eHOuHk4Y1TEFsfgduaWc=;
        b=itmjy51hnXUvJIwv2Ks9JMZYi6eranegyPzOkw9FnyiwJTilntl1kIzrHeD6pV63V7
         Ho36YmJsOyK8BHvykDSdEaemz7co0VBG0I6cTJot69Z88mVnYM8r7XnOiWERPZYCnYhv
         VvYVlEnL68iBzbNppVNDR5xhyNRaBo/xHxm6JSWBUVRUjnVVDLGpcXWSmfjUUHg9iQrU
         yes1lrMPb2N1rIyNNCQ1sSolXbSNQwev+H7JVFL6zqpf5gM6yNKEwzYbNDkUE5Tkwxfa
         JvoEv3r4pChutgcG8yB9iBprwKYRf0rgP6DxQ6JMbHIKbvXQLKVbCqBhdXOirXsCbLtj
         po1g==
X-Gm-Message-State: APjAAAXWxOtUX6T81XmU5aDM8okUThWcxkiaxhzVwOpS/dd4B7TD3V3M
        8zNiCVBlfZ4NIS6gfeQpPsYKrg==
X-Google-Smtp-Source: APXvYqy4xDzWBuhG8DOWAK4WtbpTNb+/wPpK2qQlweCMDw1a9VMOKPVNMnOfFKjI8k8V82B1bXRD+A==
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr7856314wrm.366.1573211097343;
        Fri, 08 Nov 2019 03:04:57 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id a206sm5605113wmf.15.2019.11.08.03.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 03:04:56 -0800 (PST)
Date:   Fri, 8 Nov 2019 12:04:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev alias
Message-ID: <20191108110456.GH6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-7-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-7-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 07, 2019 at 05:08:22PM CET, parav@mellanox.com wrote:
>Some vendor drivers want an identifier for an mdev device that is
>shorter than the UUID, due to length restrictions in the consumers of
>that identifier.
>
>Add a callback that allows a vendor driver to request an alias of a
>specified length to be generated for an mdev device. If generated,
>that alias is checked for collisions.
>
>It is an optional attribute.
>mdev alias is generated using sha1 from the mdev name.
>
>Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>Signed-off-by: Parav Pandit <parav@mellanox.com>
>---
> drivers/vfio/mdev/mdev_core.c    | 123 ++++++++++++++++++++++++++++++-
> drivers/vfio/mdev/mdev_private.h |   5 +-
> drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
> include/linux/mdev.h             |   4 +
> 4 files changed, 135 insertions(+), 10 deletions(-)
>
>diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>index b558d4cfd082..3bdff0469607 100644
>--- a/drivers/vfio/mdev/mdev_core.c
>+++ b/drivers/vfio/mdev/mdev_core.c
>@@ -10,9 +10,11 @@

[...]


>-int mdev_device_create(struct kobject *kobj,
>-		       struct device *dev, const guid_t *uuid)
>+static const char *
>+generate_alias(const char *uuid, unsigned int max_alias_len)
>+{
>+	struct shash_desc *hash_desc;
>+	unsigned int digest_size;
>+	unsigned char *digest;
>+	unsigned int alias_len;
>+	char *alias;
>+	int ret;
>+
>+	/*
>+	 * Align to multiple of 2 as bin2hex will generate
>+	 * even number of bytes.
>+	 */
>+	alias_len = roundup(max_alias_len, 2);

This is odd, see below.


>+	alias = kzalloc(alias_len + 1, GFP_KERNEL);
>+	if (!alias)
>+		return ERR_PTR(-ENOMEM);
>+
>+	/* Allocate and init descriptor */
>+	hash_desc = kvzalloc(sizeof(*hash_desc) +
>+			     crypto_shash_descsize(alias_hash),
>+			     GFP_KERNEL);
>+	if (!hash_desc) {
>+		ret = -ENOMEM;
>+		goto desc_err;
>+	}
>+
>+	hash_desc->tfm = alias_hash;
>+
>+	digest_size = crypto_shash_digestsize(alias_hash);
>+
>+	digest = kzalloc(digest_size, GFP_KERNEL);
>+	if (!digest) {
>+		ret = -ENOMEM;
>+		goto digest_err;
>+	}
>+	ret = crypto_shash_init(hash_desc);
>+	if (ret)
>+		goto hash_err;
>+
>+	ret = crypto_shash_update(hash_desc, uuid, UUID_STRING_LEN);
>+	if (ret)
>+		goto hash_err;
>+
>+	ret = crypto_shash_final(hash_desc, digest);
>+	if (ret)
>+		goto hash_err;
>+
>+	bin2hex(alias, digest, min_t(unsigned int, digest_size, alias_len / 2));
>+	/*
>+	 * When alias length is odd, zero out an additional last byte
>+	 * that bin2hex has copied.
>+	 */
>+	if (max_alias_len % 2)
>+		alias[max_alias_len] = 0;
>+
>+	kfree(digest);
>+	kvfree(hash_desc);
>+	return alias;
>+
>+hash_err:
>+	kfree(digest);
>+digest_err:
>+	kvfree(hash_desc);
>+desc_err:
>+	kfree(alias);
>+	return ERR_PTR(ret);
>+}
>+
>+int mdev_device_create(struct kobject *kobj, struct device *dev,
>+		       const char *uuid_str, const guid_t *uuid)
> {
> 	int ret;
> 	struct mdev_device *mdev, *tmp;
> 	struct mdev_parent *parent;
> 	struct mdev_type *type = to_mdev_type(kobj);
>+	const char *alias = NULL;
> 
> 	parent = mdev_get_parent(type->parent);
> 	if (!parent)
> 		return -EINVAL;
> 
>+	if (parent->ops->get_alias_length) {
>+		unsigned int alias_len;
>+
>+		alias_len = parent->ops->get_alias_length();
>+		if (alias_len) {

I think this should be with WARN_ON. Driver should not never return such
0 and if it does, it's a bug.

Also I think this check should be extended by checking value is multiple
of 2. Then you can avoid the roundup() above. No need to allow even len.


>+			alias = generate_alias(uuid_str, alias_len);
>+			if (IS_ERR(alias)) {
>+				ret = PTR_ERR(alias);
>+				goto alias_fail;
>+			}
>+		}
>+	}
> 	mutex_lock(&mdev_list_lock);
> 
> 	/* Check for duplicate */


[...]

>diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
>index 7570c7602ab4..43afe0e80b76 100644
>--- a/drivers/vfio/mdev/mdev_sysfs.c
>+++ b/drivers/vfio/mdev/mdev_sysfs.c
>@@ -63,15 +63,18 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
> 		return -ENOMEM;
> 
> 	ret = guid_parse(str, &uuid);
>-	kfree(str);
> 	if (ret)
>-		return ret;
>+		goto err;
> 
>-	ret = mdev_device_create(kobj, dev, &uuid);
>+	ret = mdev_device_create(kobj, dev, str, &uuid);

Why to pass the same thing twice? Move the guid_parse() call to the
beginning of mdev_device_create() function.


> 	if (ret)
>-		return ret;
>+		goto err;
> 
>-	return count;
>+	ret = count;
>+
>+err:
>+	kfree(str);
>+	return ret;
> }
> 
> MDEV_TYPE_ATTR_WO(create);

[...]
