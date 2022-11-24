Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE7E637C72
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKXPDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiKXPDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:03:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33D21025D3;
        Thu, 24 Nov 2022 07:03:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EB7D6219C;
        Thu, 24 Nov 2022 15:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E78C433D7;
        Thu, 24 Nov 2022 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669302210;
        bh=WEp+jDmYygg4BKht0oSBWsr2zvVnkEYtlZsd10oYCJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSwuAfDab/LLOAKJOtVgXAFIS0d4UIRdyOBT6aFE0Mm6vS3TTOVFw6VGDbXK8Vq8y
         k8W6OsIfjjBjix4cDS930cAQjaszkTq7GFYbLq63Hhfn31qoxyfSRjhbGHTMORb0w8
         lXZLYsN/mm9uy0BbWgR10XHyIu2aZAfzr5kk0riGCu3XzSAwo2UfzQwq7qOc8OaKA8
         TTG6YW3UTLyiEodv+CwsWJE+mkXfm3Wbln4tdG3HvFxscxZzD33fDUm7edfi7HDIL0
         ad8LaNG9pB0Ms/aW0XZKu9QLlrErBHlbJy+jGTDh2ijn5s8XBSbg2f9igsgYrYbL5U
         HhkcXbP+kQZlw==
Received: by mercury (Postfix, from userid 1000)
        id CE982106092A; Thu, 24 Nov 2022 16:03:27 +0100 (CET)
Date:   Thu, 24 Nov 2022 16:03:27 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Raed Salem <raeds@nvidia.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Avihai Horon <avihaih@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Colin Ian King <colin.i.king@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Wang Yufen <wangyufen@huawei.com>, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] driver core: make struct class.dev_uevent() take a
 const *
Message-ID: <20221124150327.cfkyaiqia7rnzede@mercury.elektranox.org>
References: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bs7hk5wyocggvlcf"
Content-Disposition: inline
In-Reply-To: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bs7hk5wyocggvlcf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 23, 2022 at 01:25:19PM +0100, Greg Kroah-Hartman wrote:
> The dev_uevent() in struct class should not be modifying the device that
> is passed into it, so mark it as a const * and propagate the function
> signature changes out into all relevant subsystems that use this
> callback.
>=20
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Russ Weight <russell.h.weight@intel.com>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Cc: Raed Salem <raeds@nvidia.com>
> Cc: Chen Zhongjin <chenzhongjin@huawei.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Avihai Horon <avihaih@nvidia.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Colin Ian King <colin.i.king@gmail.com>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Jakob Koschel <jakobkoschel@gmail.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Wang Yufen <wangyufen@huawei.com>
> Cc: linux-block@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-nvme@lists.infradead.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

>  block/genhd.c                             | 4 ++--
>  drivers/base/firmware_loader/sysfs.c      | 6 +++---
>  drivers/base/firmware_loader/sysfs.h      | 2 +-
>  drivers/firmware/dmi-id.c                 | 2 +-
>  drivers/gnss/core.c                       | 6 +++---
>  drivers/infiniband/core/device.c          | 2 +-
>  drivers/isdn/mISDN/core.c                 | 4 ++--
>  drivers/media/dvb-core/dvbdev.c           | 4 ++--
>  drivers/nvme/host/core.c                  | 4 ++--
>  drivers/pcmcia/cs.c                       | 4 ++--
>  drivers/power/supply/power_supply.h       | 2 +-
>  drivers/power/supply/power_supply_sysfs.c | 8 ++++----
>  drivers/usb/gadget/udc/core.c             | 4 ++--
>  include/linux/device/class.h              | 2 +-
>  include/linux/mISDNif.h                   | 2 +-
>  net/atm/atm_sysfs.c                       | 4 ++--
>  net/core/net-sysfs.c                      | 4 ++--
>  net/rfkill/core.c                         | 2 +-
>  18 files changed, 33 insertions(+), 33 deletions(-)
>=20
> diff --git a/block/genhd.c b/block/genhd.c
> index 0f9769db2de8..3f1124713442 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1181,9 +1181,9 @@ static void disk_release(struct device *dev)
>  	iput(disk->part0->bd_inode);	/* frees the disk */
>  }
> =20
> -static int block_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int block_uevent(const struct device *dev, struct kobj_uevent_env=
 *env)
>  {
> -	struct gendisk *disk =3D dev_to_disk(dev);
> +	const struct gendisk *disk =3D dev_to_disk(dev);
> =20
>  	return add_uevent_var(env, "DISKSEQ=3D%llu", disk->diskseq);
>  }
> diff --git a/drivers/base/firmware_loader/sysfs.c b/drivers/base/firmware=
_loader/sysfs.c
> index 5b66b3d1fa16..56911d75b90a 100644
> --- a/drivers/base/firmware_loader/sysfs.c
> +++ b/drivers/base/firmware_loader/sysfs.c
> @@ -64,7 +64,7 @@ static struct attribute *firmware_class_attrs[] =3D {
>  };
>  ATTRIBUTE_GROUPS(firmware_class);
> =20
> -static int do_firmware_uevent(struct fw_sysfs *fw_sysfs, struct kobj_uev=
ent_env *env)
> +static int do_firmware_uevent(const struct fw_sysfs *fw_sysfs, struct ko=
bj_uevent_env *env)
>  {
>  	if (add_uevent_var(env, "FIRMWARE=3D%s", fw_sysfs->fw_priv->fw_name))
>  		return -ENOMEM;
> @@ -76,9 +76,9 @@ static int do_firmware_uevent(struct fw_sysfs *fw_sysfs=
, struct kobj_uevent_env
>  	return 0;
>  }
> =20
> -static int firmware_uevent(struct device *dev, struct kobj_uevent_env *e=
nv)
> +static int firmware_uevent(const struct device *dev, struct kobj_uevent_=
env *env)
>  {
> -	struct fw_sysfs *fw_sysfs =3D to_fw_sysfs(dev);
> +	const struct fw_sysfs *fw_sysfs =3D to_fw_sysfs(dev);
>  	int err =3D 0;
> =20
>  	mutex_lock(&fw_lock);
> diff --git a/drivers/base/firmware_loader/sysfs.h b/drivers/base/firmware=
_loader/sysfs.h
> index df1d5add698f..fd0b4ad9bdbb 100644
> --- a/drivers/base/firmware_loader/sysfs.h
> +++ b/drivers/base/firmware_loader/sysfs.h
> @@ -81,7 +81,7 @@ struct fw_sysfs {
>  	void *fw_upload_priv;
>  };
> =20
> -static inline struct fw_sysfs *to_fw_sysfs(struct device *dev)
> +static inline struct fw_sysfs *to_fw_sysfs(const struct device *dev)
>  {
>  	return container_of(dev, struct fw_sysfs, dev);
>  }
> diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
> index 940ddf916202..5f3a3e913d28 100644
> --- a/drivers/firmware/dmi-id.c
> +++ b/drivers/firmware/dmi-id.c
> @@ -155,7 +155,7 @@ static const struct attribute_group* sys_dmi_attribut=
e_groups[] =3D {
>  	NULL
>  };
> =20
> -static int dmi_dev_uevent(struct device *dev, struct kobj_uevent_env *en=
v)
> +static int dmi_dev_uevent(const struct device *dev, struct kobj_uevent_e=
nv *env)
>  {
>  	ssize_t len;
> =20
> diff --git a/drivers/gnss/core.c b/drivers/gnss/core.c
> index 1e82b7967570..77a4b280c552 100644
> --- a/drivers/gnss/core.c
> +++ b/drivers/gnss/core.c
> @@ -337,7 +337,7 @@ static const char * const gnss_type_names[GNSS_TYPE_C=
OUNT] =3D {
>  	[GNSS_TYPE_MTK]		=3D "MTK",
>  };
> =20
> -static const char *gnss_type_name(struct gnss_device *gdev)
> +static const char *gnss_type_name(const struct gnss_device *gdev)
>  {
>  	const char *name =3D NULL;
> =20
> @@ -365,9 +365,9 @@ static struct attribute *gnss_attrs[] =3D {
>  };
>  ATTRIBUTE_GROUPS(gnss);
> =20
> -static int gnss_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int gnss_uevent(const struct device *dev, struct kobj_uevent_env =
*env)
>  {
> -	struct gnss_device *gdev =3D to_gnss_device(dev);
> +	const struct gnss_device *gdev =3D to_gnss_device(dev);
>  	int ret;
> =20
>  	ret =3D add_uevent_var(env, "GNSS_TYPE=3D%s", gnss_type_name(gdev));
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/d=
evice.c
> index fa65c5d3d395..4186dbf9377f 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -511,7 +511,7 @@ static void ib_device_release(struct device *device)
>  	kfree_rcu(dev, rcu_head);
>  }
> =20
> -static int ib_device_uevent(struct device *device,
> +static int ib_device_uevent(const struct device *device,
>  			    struct kobj_uevent_env *env)
>  {
>  	if (add_uevent_var(env, "NAME=3D%s", dev_name(device)))
> diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
> index 90ee56d07a6e..9120be590325 100644
> --- a/drivers/isdn/mISDN/core.c
> +++ b/drivers/isdn/mISDN/core.c
> @@ -139,9 +139,9 @@ static struct attribute *mISDN_attrs[] =3D {
>  };
>  ATTRIBUTE_GROUPS(mISDN);
> =20
> -static int mISDN_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int mISDN_uevent(const struct device *dev, struct kobj_uevent_env=
 *env)
>  {
> -	struct mISDNdevice *mdev =3D dev_to_mISDN(dev);
> +	const struct mISDNdevice *mdev =3D dev_to_mISDN(dev);
> =20
>  	if (!mdev)
>  		return 0;
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvb=
dev.c
> index 675d877a67b2..6ef18bab9648 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -1008,9 +1008,9 @@ void dvb_module_release(struct i2c_client *client)
>  EXPORT_SYMBOL_GPL(dvb_module_release);
>  #endif
> =20
> -static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int dvb_uevent(const struct device *dev, struct kobj_uevent_env *=
env)
>  {
> -	struct dvb_device *dvbdev =3D dev_get_drvdata(dev);
> +	const struct dvb_device *dvbdev =3D dev_get_drvdata(dev);
> =20
>  	add_uevent_var(env, "DVB_ADAPTER_NUM=3D%d", dvbdev->adapter->num);
>  	add_uevent_var(env, "DVB_DEVICE_TYPE=3D%s", dnames[dvbdev->type]);
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index da55ce45ac70..b4778b970dd4 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -4580,9 +4580,9 @@ void nvme_remove_namespaces(struct nvme_ctrl *ctrl)
>  }
>  EXPORT_SYMBOL_GPL(nvme_remove_namespaces);
> =20
> -static int nvme_class_uevent(struct device *dev, struct kobj_uevent_env =
*env)
> +static int nvme_class_uevent(const struct device *dev, struct kobj_ueven=
t_env *env)
>  {
> -	struct nvme_ctrl *ctrl =3D
> +	const struct nvme_ctrl *ctrl =3D
>  		container_of(dev, struct nvme_ctrl, ctrl_device);
>  	struct nvmf_ctrl_options *opts =3D ctrl->opts;
>  	int ret;
> diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
> index f70197154a36..e3224e49c43f 100644
> --- a/drivers/pcmcia/cs.c
> +++ b/drivers/pcmcia/cs.c
> @@ -810,10 +810,10 @@ int pcmcia_reset_card(struct pcmcia_socket *skt)
>  EXPORT_SYMBOL(pcmcia_reset_card);
> =20
> =20
> -static int pcmcia_socket_uevent(struct device *dev,
> +static int pcmcia_socket_uevent(const struct device *dev,
>  				struct kobj_uevent_env *env)
>  {
> -	struct pcmcia_socket *s =3D container_of(dev, struct pcmcia_socket, dev=
);
> +	const struct pcmcia_socket *s =3D container_of(dev, struct pcmcia_socke=
t, dev);
> =20
>  	if (add_uevent_var(env, "SOCKET_NO=3D%u", s->sock))
>  		return -ENOMEM;
> diff --git a/drivers/power/supply/power_supply.h b/drivers/power/supply/p=
ower_supply.h
> index c310d4f36c10..645eee4d6b6a 100644
> --- a/drivers/power/supply/power_supply.h
> +++ b/drivers/power/supply/power_supply.h
> @@ -16,7 +16,7 @@ struct power_supply;
>  #ifdef CONFIG_SYSFS
> =20
>  extern void power_supply_init_attrs(struct device_type *dev_type);
> -extern int power_supply_uevent(struct device *dev, struct kobj_uevent_en=
v *env);
> +extern int power_supply_uevent(const struct device *dev, struct kobj_uev=
ent_env *env);
> =20
>  #else
> =20
> diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/su=
pply/power_supply_sysfs.c
> index 5369abaceb5c..6ca7d3985a40 100644
> --- a/drivers/power/supply/power_supply_sysfs.c
> +++ b/drivers/power/supply/power_supply_sysfs.c
> @@ -427,7 +427,7 @@ void power_supply_init_attrs(struct device_type *dev_=
type)
>  	}
>  }
> =20
> -static int add_prop_uevent(struct device *dev, struct kobj_uevent_env *e=
nv,
> +static int add_prop_uevent(const struct device *dev, struct kobj_uevent_=
env *env,
>  			   enum power_supply_property prop, char *prop_buf)
>  {
>  	int ret =3D 0;
> @@ -438,7 +438,7 @@ static int add_prop_uevent(struct device *dev, struct=
 kobj_uevent_env *env,
>  	pwr_attr =3D &power_supply_attrs[prop];
>  	dev_attr =3D &pwr_attr->dev_attr;
> =20
> -	ret =3D power_supply_show_property(dev, dev_attr, prop_buf);
> +	ret =3D power_supply_show_property((struct device *)dev, dev_attr, prop=
_buf);
>  	if (ret =3D=3D -ENODEV || ret =3D=3D -ENODATA) {
>  		/*
>  		 * When a battery is absent, we expect -ENODEV. Don't abort;
> @@ -458,9 +458,9 @@ static int add_prop_uevent(struct device *dev, struct=
 kobj_uevent_env *env,
>  			      pwr_attr->prop_name, prop_buf);
>  }
> =20
> -int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
> +int power_supply_uevent(const struct device *dev, struct kobj_uevent_env=
 *env)
>  {
> -	struct power_supply *psy =3D dev_get_drvdata(dev);
> +	const struct power_supply *psy =3D dev_get_drvdata(dev);
>  	int ret =3D 0, j;
>  	char *prop_buf;
> =20
> diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
> index c63c0c2cf649..b5994a0604f6 100644
> --- a/drivers/usb/gadget/udc/core.c
> +++ b/drivers/usb/gadget/udc/core.c
> @@ -1723,9 +1723,9 @@ static const struct attribute_group *usb_udc_attr_g=
roups[] =3D {
>  	NULL,
>  };
> =20
> -static int usb_udc_uevent(struct device *dev, struct kobj_uevent_env *en=
v)
> +static int usb_udc_uevent(const struct device *dev, struct kobj_uevent_e=
nv *env)
>  {
> -	struct usb_udc		*udc =3D container_of(dev, struct usb_udc, dev);
> +	const struct usb_udc	*udc =3D container_of(dev, struct usb_udc, dev);
>  	int			ret;
> =20
>  	ret =3D add_uevent_var(env, "USB_UDC_NAME=3D%s", udc->gadget->name);
> diff --git a/include/linux/device/class.h b/include/linux/device/class.h
> index 20103e0b03c3..94b1107258e5 100644
> --- a/include/linux/device/class.h
> +++ b/include/linux/device/class.h
> @@ -59,7 +59,7 @@ struct class {
>  	const struct attribute_group	**dev_groups;
>  	struct kobject			*dev_kobj;
> =20
> -	int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
> +	int (*dev_uevent)(const struct device *dev, struct kobj_uevent_env *env=
);
>  	char *(*devnode)(struct device *dev, umode_t *mode);
> =20
>  	void (*class_release)(struct class *class);
> diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
> index 7dd1f01ec4f9..7aab4a769736 100644
> --- a/include/linux/mISDNif.h
> +++ b/include/linux/mISDNif.h
> @@ -586,7 +586,7 @@ extern struct mISDNclock *mISDN_register_clock(char *=
, int, clockctl_func_t *,
>  						void *);
>  extern void	mISDN_unregister_clock(struct mISDNclock *);
> =20
> -static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
> +static inline struct mISDNdevice *dev_to_mISDN(const struct device *dev)
>  {
>  	if (dev)
>  		return dev_get_drvdata(dev);
> diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
> index 0fdbdfd19474..466353b3dde4 100644
> --- a/net/atm/atm_sysfs.c
> +++ b/net/atm/atm_sysfs.c
> @@ -108,9 +108,9 @@ static struct device_attribute *atm_attrs[] =3D {
>  };
> =20
> =20
> -static int atm_uevent(struct device *cdev, struct kobj_uevent_env *env)
> +static int atm_uevent(const struct device *cdev, struct kobj_uevent_env =
*env)
>  {
> -	struct atm_dev *adev;
> +	const struct atm_dev *adev;
> =20
>  	if (!cdev)
>  		return -ENODEV;
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 9cfc80b8ed25..03a61d1dffbd 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1873,9 +1873,9 @@ const struct kobj_ns_type_operations net_ns_type_op=
erations =3D {
>  };
>  EXPORT_SYMBOL_GPL(net_ns_type_operations);
> =20
> -static int netdev_uevent(struct device *d, struct kobj_uevent_env *env)
> +static int netdev_uevent(const struct device *d, struct kobj_uevent_env =
*env)
>  {
> -	struct net_device *dev =3D to_net_dev(d);
> +	const struct net_device *dev =3D to_net_dev(d);
>  	int retval;
> =20
>  	/* pass interface to uevent. */
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index dac4fdc7488a..b390ff245d5e 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -832,7 +832,7 @@ static void rfkill_release(struct device *dev)
>  	kfree(rfkill);
>  }
> =20
> -static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env =
*env)
> +static int rfkill_dev_uevent(const struct device *dev, struct kobj_ueven=
t_env *env)
>  {
>  	struct rfkill *rfkill =3D to_rfkill(dev);
>  	unsigned long flags;
> --=20
> 2.38.1
>=20

--bs7hk5wyocggvlcf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmN/h78ACgkQ2O7X88g7
+pprAxAAkqAcA9NSStrxx2tLRglpsPq5nYSSACe864aQHi6FGUtxei/0LKoSAU4x
Nh853Go7v6b1AYoUh5N/Sc6iybWr69R6NbHrGtIZtIhjFJ6bY3gQgfWDuy0WS0o+
/GvGc5+iBJ2NW7XYJwFIebODPDvvHyJ5+pXT8go7aQl/VmUCyrRpNmoH2XS+omU/
Wk0fZYRlw5E8hmpt3UcNb6vL1idMJj83pqnPGQy+Nq9q+6Zlz1qW5yl9XOnlkqt7
CcdutSSQZ5bHxS7y1+fZ1Y8BoEaQdvIGqtA0LUvMPEtgY0zpCBZyLMGCQraV/3Y2
pwd6Gh5g64Bg7BUuh2R1p+FwiZm3nEab+/P7XiSV5qAOOWbASDJ8ntEPKI6IgLic
tdO9lybotG3V3DAPCJ78zlw0HUJcA28OZsi0+EIYNjSQL9bJ14rOQZ0HkXfO4/ry
cw8/T+y2A6IG2ufSmNJ9iYd4QQ8jmqKjnLdzdDg08cYmDU7RI7+g/DgcwuTVOzpJ
yr+DLizj5BJvNl80rrZTOPGcsJw3zdVHBMn/EmWYKZnvYssx3N+auxcXy9cwN64x
sx+fYHRC75JWnyy+AAmLGJT1bxbBBifZ8oX+v33k7/iLfvNuikQZu2MIopaCoCMD
zY7N5iWTh5ry09muYmzbkR7C5xX+hXZoAcGmk0zwuws8v2xeTPg=
=X62i
-----END PGP SIGNATURE-----

--bs7hk5wyocggvlcf--
