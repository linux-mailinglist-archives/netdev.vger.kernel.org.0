Return-Path: <netdev+bounces-1544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CDF86FE3FA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AACF71C20E10
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C519174E4;
	Wed, 10 May 2023 18:22:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695DB3D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:22:29 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BE9E60;
	Wed, 10 May 2023 11:21:51 -0700 (PDT)
Received: from mercury (195-23-45-170.net.novis.pt [195.23.45.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sre)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id BE885660322C;
	Wed, 10 May 2023 19:19:56 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1683742796;
	bh=eNz9k0ZFGAVtn64i70ua1/fKbf1RGZgMHRVuolfOUIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Am3nN/FZFTe2zU8KP7oVVrXLkxrLlohJu/2xosyUg5cmtatB7EYfoplu16pOn5ctq
	 /X7HJFSuExe7Ny5BXaXlkO+SodlFqAzTXomsAslNwPCmdx3xu/pUx2aQxlqo/BOblw
	 lLOhvKpNtpKcUKgFKI18LxTxPWOod5J7Y9rE24QTs9CVNuVyfXvnXifFWbpOr/xzN6
	 GVTsNkGRFdM2IDdvK1EMY5EAQNE33FwQpo3ZpCzmliCfEPHUpjKzZPo5VYUJ7g0I0J
	 OXJezmsWeWddgUgJunOJoiChf7vT1c7v/EnmMPxPsJ8j0MTWZ4rmMunJx8tE7HI5bZ
	 uTMc3Wt6yevvQ==
Received: by mercury (Postfix, from userid 1000)
	id CC31210670DF; Wed, 10 May 2023 20:19:52 +0200 (CEST)
Date: Wed, 10 May 2023 20:19:52 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, linux-leds@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: Re: [PATCH RESEND 1/4] leds: Change led_trigger_blink[_oneshot]()
 delay parameters to pass-by-value
Message-ID: <20230510181952.i44ewicpps5xwa5b@mercury.elektranox.org>
References: <20230510162234.291439-1-hdegoede@redhat.com>
 <20230510162234.291439-2-hdegoede@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h3ijkowu2ox4cyqa"
Content-Disposition: inline
In-Reply-To: <20230510162234.291439-2-hdegoede@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--h3ijkowu2ox4cyqa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 10, 2023 at 06:22:31PM +0200, Hans de Goede wrote:
> led_blink_set[_oneshot]()'s delay_on and delay_off function parameters
> are pass by reference, so that hw-blink implementations can report
> back the actual achieved delays when the values have been rounded
> to something the hw supports.
>=20
> This is really only interesting for the sysfs API / the timer trigger.
> Other triggers don't really care about this and none of the callers of
> led_trigger_blink[_oneshot]() do anything with the returned delay values.
>=20
> Change the led_trigger_blink[_oneshot]() delay parameters to pass-by-valu=
e,
> there are 2 reasons for this:
>=20
> 1. led_cdev->blink_set() may sleep, while led_trigger_blink() may not.
> So on hw where led_cdev->blink_set() sleeps the call needs to be deferred
> to a workqueue, in which case the actual achieved delays are unknown
> (this is a preparation patch for the deferring).
>=20
> 2. Since the callers don't care about the actual achieved delays, allowing
> callers to directly pass a value leads to simpler code for most callers.
>=20
> Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Tested-by: Yauhen Kharuzhy <jekhor@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>

-- Sebastian

> ---
>  drivers/leds/led-triggers.c              | 16 ++++++++--------
>  drivers/leds/trigger/ledtrig-disk.c      |  9 +++------
>  drivers/leds/trigger/ledtrig-mtd.c       |  8 ++------
>  drivers/net/arcnet/arcnet.c              |  8 ++------
>  drivers/power/supply/power_supply_leds.c |  5 +----
>  drivers/usb/common/led.c                 |  4 +---
>  include/linux/leds.h                     | 16 ++++++++--------
>  net/mac80211/led.c                       |  2 +-
>  net/mac80211/led.h                       |  8 ++------
>  net/netfilter/xt_LED.c                   |  3 +--
>  10 files changed, 29 insertions(+), 50 deletions(-)
>=20
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 072491d3e17b..e06361165e9b 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -393,8 +393,8 @@ void led_trigger_event(struct led_trigger *trig,
>  EXPORT_SYMBOL_GPL(led_trigger_event);
> =20
>  static void led_trigger_blink_setup(struct led_trigger *trig,
> -			     unsigned long *delay_on,
> -			     unsigned long *delay_off,
> +			     unsigned long delay_on,
> +			     unsigned long delay_off,
>  			     int oneshot,
>  			     int invert)
>  {
> @@ -406,25 +406,25 @@ static void led_trigger_blink_setup(struct led_trig=
ger *trig,
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(led_cdev, &trig->led_cdevs, trig_list) {
>  		if (oneshot)
> -			led_blink_set_oneshot(led_cdev, delay_on, delay_off,
> +			led_blink_set_oneshot(led_cdev, &delay_on, &delay_off,
>  					      invert);
>  		else
> -			led_blink_set(led_cdev, delay_on, delay_off);
> +			led_blink_set(led_cdev, &delay_on, &delay_off);
>  	}
>  	rcu_read_unlock();
>  }
> =20
>  void led_trigger_blink(struct led_trigger *trig,
> -		       unsigned long *delay_on,
> -		       unsigned long *delay_off)
> +		       unsigned long delay_on,
> +		       unsigned long delay_off)
>  {
>  	led_trigger_blink_setup(trig, delay_on, delay_off, 0, 0);
>  }
>  EXPORT_SYMBOL_GPL(led_trigger_blink);
> =20
>  void led_trigger_blink_oneshot(struct led_trigger *trig,
> -			       unsigned long *delay_on,
> -			       unsigned long *delay_off,
> +			       unsigned long delay_on,
> +			       unsigned long delay_off,
>  			       int invert)
>  {
>  	led_trigger_blink_setup(trig, delay_on, delay_off, 1, invert);
> diff --git a/drivers/leds/trigger/ledtrig-disk.c b/drivers/leds/trigger/l=
edtrig-disk.c
> index 0b7dfbd04273..e9b87ee944f2 100644
> --- a/drivers/leds/trigger/ledtrig-disk.c
> +++ b/drivers/leds/trigger/ledtrig-disk.c
> @@ -19,16 +19,13 @@ DEFINE_LED_TRIGGER(ledtrig_disk_write);
> =20
>  void ledtrig_disk_activity(bool write)
>  {
> -	unsigned long blink_delay =3D BLINK_DELAY;
> -
> -	led_trigger_blink_oneshot(ledtrig_disk,
> -				  &blink_delay, &blink_delay, 0);
> +	led_trigger_blink_oneshot(ledtrig_disk, BLINK_DELAY, BLINK_DELAY, 0);
>  	if (write)
>  		led_trigger_blink_oneshot(ledtrig_disk_write,
> -					  &blink_delay, &blink_delay, 0);
> +					  BLINK_DELAY, BLINK_DELAY, 0);
>  	else
>  		led_trigger_blink_oneshot(ledtrig_disk_read,
> -					  &blink_delay, &blink_delay, 0);
> +					  BLINK_DELAY, BLINK_DELAY, 0);
>  }
>  EXPORT_SYMBOL(ledtrig_disk_activity);
> =20
> diff --git a/drivers/leds/trigger/ledtrig-mtd.c b/drivers/leds/trigger/le=
dtrig-mtd.c
> index 8fa763c2269b..bbe6876a249d 100644
> --- a/drivers/leds/trigger/ledtrig-mtd.c
> +++ b/drivers/leds/trigger/ledtrig-mtd.c
> @@ -22,12 +22,8 @@ DEFINE_LED_TRIGGER(ledtrig_nand);
> =20
>  void ledtrig_mtd_activity(void)
>  {
> -	unsigned long blink_delay =3D BLINK_DELAY;
> -
> -	led_trigger_blink_oneshot(ledtrig_mtd,
> -				  &blink_delay, &blink_delay, 0);
> -	led_trigger_blink_oneshot(ledtrig_nand,
> -				  &blink_delay, &blink_delay, 0);
> +	led_trigger_blink_oneshot(ledtrig_mtd, BLINK_DELAY, BLINK_DELAY, 0);
> +	led_trigger_blink_oneshot(ledtrig_nand, BLINK_DELAY, BLINK_DELAY, 0);
>  }
>  EXPORT_SYMBOL(ledtrig_mtd_activity);
> =20
> diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
> index 1bad1866ae46..99265667538c 100644
> --- a/drivers/net/arcnet/arcnet.c
> +++ b/drivers/net/arcnet/arcnet.c
> @@ -196,13 +196,10 @@ static void arcnet_dump_packet(struct net_device *d=
ev, int bufnum,
>  void arcnet_led_event(struct net_device *dev, enum arcnet_led_event even=
t)
>  {
>  	struct arcnet_local *lp =3D netdev_priv(dev);
> -	unsigned long led_delay =3D 350;
> -	unsigned long tx_delay =3D 50;
> =20
>  	switch (event) {
>  	case ARCNET_LED_EVENT_RECON:
> -		led_trigger_blink_oneshot(lp->recon_led_trig,
> -					  &led_delay, &led_delay, 0);
> +		led_trigger_blink_oneshot(lp->recon_led_trig, 350, 350, 0);
>  		break;
>  	case ARCNET_LED_EVENT_OPEN:
>  		led_trigger_event(lp->tx_led_trig, LED_OFF);
> @@ -213,8 +210,7 @@ void arcnet_led_event(struct net_device *dev, enum ar=
cnet_led_event event)
>  		led_trigger_event(lp->recon_led_trig, LED_OFF);
>  		break;
>  	case ARCNET_LED_EVENT_TX:
> -		led_trigger_blink_oneshot(lp->tx_led_trig,
> -					  &tx_delay, &tx_delay, 0);
> +		led_trigger_blink_oneshot(lp->tx_led_trig, 50, 50, 0);
>  		break;
>  	}
>  }
> diff --git a/drivers/power/supply/power_supply_leds.c b/drivers/power/sup=
ply/power_supply_leds.c
> index 702bf83f6e6d..e2f554e4e4e6 100644
> --- a/drivers/power/supply/power_supply_leds.c
> +++ b/drivers/power/supply/power_supply_leds.c
> @@ -22,8 +22,6 @@
>  static void power_supply_update_bat_leds(struct power_supply *psy)
>  {
>  	union power_supply_propval status;
> -	unsigned long delay_on =3D 0;
> -	unsigned long delay_off =3D 0;
> =20
>  	if (power_supply_get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
>  		return;
> @@ -42,8 +40,7 @@ static void power_supply_update_bat_leds(struct power_s=
upply *psy)
>  		led_trigger_event(psy->charging_full_trig, LED_FULL);
>  		led_trigger_event(psy->charging_trig, LED_FULL);
>  		led_trigger_event(psy->full_trig, LED_OFF);
> -		led_trigger_blink(psy->charging_blink_full_solid_trig,
> -			&delay_on, &delay_off);
> +		led_trigger_blink(psy->charging_blink_full_solid_trig, 0, 0);
>  		break;
>  	default:
>  		led_trigger_event(psy->charging_full_trig, LED_OFF);
> diff --git a/drivers/usb/common/led.c b/drivers/usb/common/led.c
> index 0865dd44a80a..1de18d90b134 100644
> --- a/drivers/usb/common/led.c
> +++ b/drivers/usb/common/led.c
> @@ -14,8 +14,6 @@
> =20
>  #define BLINK_DELAY 30
> =20
> -static unsigned long usb_blink_delay =3D BLINK_DELAY;
> -
>  DEFINE_LED_TRIGGER(ledtrig_usb_gadget);
>  DEFINE_LED_TRIGGER(ledtrig_usb_host);
> =20
> @@ -32,7 +30,7 @@ void usb_led_activity(enum usb_led_event ev)
>  		break;
>  	}
>  	/* led_trigger_blink_oneshot() handles trig =3D=3D NULL gracefully */
> -	led_trigger_blink_oneshot(trig, &usb_blink_delay, &usb_blink_delay, 0);
> +	led_trigger_blink_oneshot(trig, BLINK_DELAY, BLINK_DELAY, 0);
>  }
>  EXPORT_SYMBOL_GPL(usb_led_activity);
> =20
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index c39bbf17a25b..c3dc22d184e2 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -433,11 +433,11 @@ void led_trigger_register_simple(const char *name,
>  				struct led_trigger **trigger);
>  void led_trigger_unregister_simple(struct led_trigger *trigger);
>  void led_trigger_event(struct led_trigger *trigger,  enum led_brightness=
 event);
> -void led_trigger_blink(struct led_trigger *trigger, unsigned long *delay=
_on,
> -		       unsigned long *delay_off);
> +void led_trigger_blink(struct led_trigger *trigger, unsigned long delay_=
on,
> +		       unsigned long delay_off);
>  void led_trigger_blink_oneshot(struct led_trigger *trigger,
> -			       unsigned long *delay_on,
> -			       unsigned long *delay_off,
> +			       unsigned long delay_on,
> +			       unsigned long delay_off,
>  			       int invert);
>  void led_trigger_set_default(struct led_classdev *led_cdev);
>  int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *t=
rigger);
> @@ -487,11 +487,11 @@ static inline void led_trigger_unregister_simple(st=
ruct led_trigger *trigger) {}
>  static inline void led_trigger_event(struct led_trigger *trigger,
>  				enum led_brightness event) {}
>  static inline void led_trigger_blink(struct led_trigger *trigger,
> -				      unsigned long *delay_on,
> -				      unsigned long *delay_off) {}
> +				      unsigned long delay_on,
> +				      unsigned long delay_off) {}
>  static inline void led_trigger_blink_oneshot(struct led_trigger *trigger,
> -				      unsigned long *delay_on,
> -				      unsigned long *delay_off,
> +				      unsigned long delay_on,
> +				      unsigned long delay_off,
>  				      int invert) {}
>  static inline void led_trigger_set_default(struct led_classdev *led_cdev=
) {}
>  static inline int led_trigger_set(struct led_classdev *led_cdev,
> diff --git a/net/mac80211/led.c b/net/mac80211/led.c
> index 6de8d0ad5497..2dc732147e85 100644
> --- a/net/mac80211/led.c
> +++ b/net/mac80211/led.c
> @@ -282,7 +282,7 @@ static void tpt_trig_timer(struct timer_list *t)
>  		}
>  	}
> =20
> -	led_trigger_blink(&local->tpt_led, &on, &off);
> +	led_trigger_blink(&local->tpt_led, on, off);
>  }
> =20
>  const char *
> diff --git a/net/mac80211/led.h b/net/mac80211/led.h
> index b71a1428d883..d25f13346b82 100644
> --- a/net/mac80211/led.h
> +++ b/net/mac80211/led.h
> @@ -13,22 +13,18 @@
>  static inline void ieee80211_led_rx(struct ieee80211_local *local)
>  {
>  #ifdef CONFIG_MAC80211_LEDS
> -	unsigned long led_delay =3D MAC80211_BLINK_DELAY;
> -
>  	if (!atomic_read(&local->rx_led_active))
>  		return;
> -	led_trigger_blink_oneshot(&local->rx_led, &led_delay, &led_delay, 0);
> +	led_trigger_blink_oneshot(&local->rx_led, MAC80211_BLINK_DELAY, MAC8021=
1_BLINK_DELAY, 0);
>  #endif
>  }
> =20
>  static inline void ieee80211_led_tx(struct ieee80211_local *local)
>  {
>  #ifdef CONFIG_MAC80211_LEDS
> -	unsigned long led_delay =3D MAC80211_BLINK_DELAY;
> -
>  	if (!atomic_read(&local->tx_led_active))
>  		return;
> -	led_trigger_blink_oneshot(&local->tx_led, &led_delay, &led_delay, 0);
> +	led_trigger_blink_oneshot(&local->tx_led, MAC80211_BLINK_DELAY, MAC8021=
1_BLINK_DELAY, 0);
>  #endif
>  }
> =20
> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
> index 66b0f941d8fb..36c9720ad8d6 100644
> --- a/net/netfilter/xt_LED.c
> +++ b/net/netfilter/xt_LED.c
> @@ -43,7 +43,6 @@ led_tg(struct sk_buff *skb, const struct xt_action_para=
m *par)
>  {
>  	const struct xt_led_info *ledinfo =3D par->targinfo;
>  	struct xt_led_info_internal *ledinternal =3D ledinfo->internal_data;
> -	unsigned long led_delay =3D XT_LED_BLINK_DELAY;
> =20
>  	/*
>  	 * If "always blink" is enabled, and there's still some time until the
> @@ -52,7 +51,7 @@ led_tg(struct sk_buff *skb, const struct xt_action_para=
m *par)
>  	if ((ledinfo->delay > 0) && ledinfo->always_blink &&
>  	    timer_pending(&ledinternal->timer))
>  		led_trigger_blink_oneshot(&ledinternal->netfilter_led_trigger,
> -					  &led_delay, &led_delay, 1);
> +					  XT_LED_BLINK_DELAY, XT_LED_BLINK_DELAY, 1);
>  	else
>  		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
> =20
> --=20
> 2.40.1
>=20

--h3ijkowu2ox4cyqa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmRb4EUACgkQ2O7X88g7
+pqaow//cRYagkFI6m3MqQzq7/jWgq0c0xv3ChPRe34lVa/9mcBrDX+lqspJ0Ptx
xwZ0xcrJz6JP3SSPuUXkdWDWUPUeh2WXsthxz5Lu2aHFwyYpkL3Y6vx6wQ+wmNa0
imCRoMAXtKHlAaTkRvES9RrNEcyJQa6PN097AsUFuYnMswYlNikYch7upEG2mRvL
HMhjZhLM1ItVdrzYOPEkzZvmjhrrgqdl5c+noCx8fYntitPsZ4/RhhR5YULpdgL/
AGFHucjp9F3A9aQUMipDuHau3glYGVHx+ydqvxal15RggU2SFEiEQlqknEBFv2e/
kH0utxAB+OVk8deGjlaQaSBkj3AtIzq7DgjvrPktI/4a2BLVYymtoX6Cw/G2ARkg
vUR+vUBFwh2+J9IGv2DltrkHupbjrwK3RLzV4ryz//OQt1fHlQ2bUPuhitM4i2pm
Hbv4dqAS+Kr397FX1Afq8kJTKlUGsh0/jYubQx9ca5Cm5+xBaKAWtSk8pM/LkL3T
7W5hT48smxvu10C9i0hOtmw3Bals3lg1LDeluYjtdLMB1Tmb/teQpRhuMaQUxsQl
eLvonwfCA0lddn5XKVP8BmhcZVuxXfHFFhuKGqMOqiKWu9/m3mmfcCIJr9Ark5RC
orsPsaIwUqb68499MWTaGZLp1hydxzsjkZokx0vxE2VNti1KdPQ=
=5ywK
-----END PGP SIGNATURE-----

--h3ijkowu2ox4cyqa--

