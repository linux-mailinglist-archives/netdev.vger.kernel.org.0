Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BAD226EC3
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 21:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgGTTOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 15:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729237AbgGTTOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 15:14:17 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1022CC061794;
        Mon, 20 Jul 2020 12:14:17 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w9so5094877ejc.8;
        Mon, 20 Jul 2020 12:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JjyHryxAwSxTQ0ittGP+rXGKdRNTM53Fze7YdhzbkuA=;
        b=cSV1VzkU9Nkb6qqoBJknZ7LmzOwMz4bYV44z158KTB1lynYP2d1eMjou69dsfdYNKJ
         HAMCI0/UmycnxC+uLP6rH/JfKfGfnlAGoiWE9Vs+tRekP9PfHWUc8vvQJbBGrTxoFZVr
         9zfthvQw1KqMBLrFhWO0CaTmcn3Xlr797NVuuIR4zCXsXf9VVKQADK6zvery3k705iVX
         KUO6l3we7oskzPldLPNwOBBSSQGS7K/U6TmPk9tejbkt2uiLStDzPi8MDgeAwB7GzbT4
         EAPxXkbtVceOdntNvpeNRdBRcR4FRqTtrMs7KLR2a1hH7o5Qsj6k1NMLZvqjSEGz6tc9
         l4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JjyHryxAwSxTQ0ittGP+rXGKdRNTM53Fze7YdhzbkuA=;
        b=WLB1Itl1kfkOKfyTcgSnTV3i+QlwWSR19oEC1j0ww0nZceURvyeLDW495VU2WRrO6h
         UzNaez+TZfXk6SBjsUBNjqEGAh9K/PcbSyw/aYCdam2chQ7aAbJxZ4+7W0WUBvpT0bGo
         vCvVLmohZWi3yG/bd6an4JCKVdiAvC2pI6NWhGWd/90g0efiVp1XunNBbkkFuHrH/Y5g
         1AzRN55dXol0gNa6WEva6aB2+ujSd5ci21Ic3Hmq6gV3nAme4OYeoH/6aiXMnrHv3sv+
         vO5rs5HR4QF9thd0nlNu/6g9/oOhjm1bOXGDWWNQqUBLrl3lRBdW0cb06ZHvcs1BDyuz
         PTMA==
X-Gm-Message-State: AOAM531Vsosdqnz9yR82kPfAjRUfEEd6LR29ULuyLygQVH5gtDiGEqDZ
        zNOJYuzI5+dfPoc4CoLCWAwKvPcV
X-Google-Smtp-Source: ABdhPJwMjH9Ys/3UaSvWYhIy7bpfQ7RCMAWq3nHCUEJ+/O76pprqlE8t9rTblRD8bjroXJ6mN6r1fg==
X-Received: by 2002:a17:906:4158:: with SMTP id l24mr19384470ejk.101.1595272455521;
        Mon, 20 Jul 2020 12:14:15 -0700 (PDT)
Received: from ?IPv6:2a01:110f:b59:fd00:79a2:4d96:30bb:bcee? ([2a01:110f:b59:fd00:79a2:4d96:30bb:bcee])
        by smtp.gmail.com with ESMTPSA id c10sm15971215edt.22.2020.07.20.12.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 12:14:14 -0700 (PDT)
Subject: Re: [PATCH RFC leds + net-next 1/3] leds: trigger: add support for
 LED-private device triggers
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        linux-leds@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=c5=99ej_Jirman?= <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
References: <20200716171730.13227-1-marek.behun@nic.cz>
 <20200716171730.13227-2-marek.behun@nic.cz>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <fe339634-bf0a-cbb0-cc46-223195482ea6@gmail.com>
Date:   Mon, 20 Jul 2020 21:14:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716171730.13227-2-marek.behun@nic.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On 7/16/20 7:17 PM, Marek Behún wrote:
> Some LED controllers may come with an internal HW triggering mechanism
> for the LED and the ability to switch between SW control and the
> internal HW control. This includes most PHYs, various ethernet switches,
> the Turris Omnia LED controller or AXP20X PMIC.
> 
> This adds support for registering such triggers.
> 
> This code is based on work by Pavel Machek <pavel@ucw.cz> and
> Ondřej Jirman <megous@megous.com>.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> ---
>   drivers/leds/led-triggers.c | 26 ++++++++++++++++++++------
>   include/linux/leds.h        | 10 ++++++++++
>   2 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 79e30d2cb7a5..81e758d5a048 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -27,6 +27,12 @@ LIST_HEAD(trigger_list);
>   
>    /* Used by LED Class */
>   
> +static inline bool
> +trigger_relevant(struct led_classdev *led_cdev, struct led_trigger *trig)
> +{
> +	return !trig->trigger_type || trig->trigger_type == led_cdev->trigger_type;
> +}
> +
>   ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
>   			  struct bin_attribute *bin_attr, char *buf,
>   			  loff_t pos, size_t count)
> @@ -50,7 +56,7 @@ ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
>   
>   	down_read(&triggers_list_lock);
>   	list_for_each_entry(trig, &trigger_list, next_trig) {
> -		if (sysfs_streq(buf, trig->name)) {
> +		if (sysfs_streq(buf, trig->name) && trigger_relevant(led_cdev, trig)) {
>   			down_write(&led_cdev->trigger_lock);
>   			led_trigger_set(led_cdev, trig);
>   			up_write(&led_cdev->trigger_lock);
> @@ -93,8 +99,12 @@ static int led_trigger_format(char *buf, size_t size,
>   				       led_cdev->trigger ? "none" : "[none]");
>   
>   	list_for_each_entry(trig, &trigger_list, next_trig) {
> -		bool hit = led_cdev->trigger &&
> -			!strcmp(led_cdev->trigger->name, trig->name);
> +		bool hit;
> +
> +		if (!trigger_relevant(led_cdev, trig))
> +			continue;
> +
> +		hit = led_cdev->trigger && !strcmp(led_cdev->trigger->name, trig->name);
>   
>   		len += led_trigger_snprintf(buf + len, size - len,
>   					    " %s%s%s", hit ? "[" : "",
> @@ -243,7 +253,8 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
>   	down_read(&triggers_list_lock);
>   	down_write(&led_cdev->trigger_lock);
>   	list_for_each_entry(trig, &trigger_list, next_trig) {
> -		if (!strcmp(led_cdev->default_trigger, trig->name)) {
> +		if (!strcmp(led_cdev->default_trigger, trig->name) &&
> +		    trigger_relevant(led_cdev, trig)) {
>   			led_cdev->flags |= LED_INIT_DEFAULT_TRIGGER;
>   			led_trigger_set(led_cdev, trig);
>   			break;
> @@ -280,7 +291,9 @@ int led_trigger_register(struct led_trigger *trig)
>   	down_write(&triggers_list_lock);
>   	/* Make sure the trigger's name isn't already in use */
>   	list_for_each_entry(_trig, &trigger_list, next_trig) {
> -		if (!strcmp(_trig->name, trig->name)) {
> +		if (!strcmp(_trig->name, trig->name) &&
> +		    (trig->trigger_type == _trig->trigger_type ||
> +		     !trig->trigger_type || !_trig->trigger_type)) {
>   			up_write(&triggers_list_lock);
>   			return -EEXIST;
>   		}
> @@ -294,7 +307,8 @@ int led_trigger_register(struct led_trigger *trig)
>   	list_for_each_entry(led_cdev, &leds_list, node) {
>   		down_write(&led_cdev->trigger_lock);
>   		if (!led_cdev->trigger && led_cdev->default_trigger &&
> -			    !strcmp(led_cdev->default_trigger, trig->name)) {
> +		    !strcmp(led_cdev->default_trigger, trig->name) &&
> +		    trigger_relevant(led_cdev, trig)) {
>   			led_cdev->flags |= LED_INIT_DEFAULT_TRIGGER;
>   			led_trigger_set(led_cdev, trig);
>   		}
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 2451962d1ec5..6a8d6409c993 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -57,6 +57,10 @@ struct led_init_data {
>   	bool devname_mandatory;
>   };
>   
> +struct led_hw_trigger_type {
> +	int dummy;
> +};
> +
>   struct led_classdev {
>   	const char		*name;
>   	enum led_brightness	 brightness;
> @@ -141,6 +145,9 @@ struct led_classdev {
>   	void			*trigger_data;
>   	/* true if activated - deactivate routine uses it to do cleanup */
>   	bool			activated;
> +
> +	/* LEDs that have private triggers have this set */
> +	struct led_hw_trigger_type	*trigger_type;
>   #endif
>   
>   #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
> @@ -345,6 +352,9 @@ struct led_trigger {
>   	int		(*activate)(struct led_classdev *led_cdev);
>   	void		(*deactivate)(struct led_classdev *led_cdev);
>   
> +	/* LED-private triggers have this set */
> +	struct led_hw_trigger_type *trigger_type;
> +
>   	/* LEDs under control by this trigger (for simple triggers) */
>   	rwlock_t	  leddev_list_lock;
>   	struct list_head  led_cdevs;

Looks good to me:

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
