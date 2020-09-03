Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA72425C816
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgICRae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICRad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:30:33 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0462FC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 10:30:33 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n22so3500550edt.4
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 10:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3CriIrg29zPQdpJx8RyXLAcXPj9EmZPOmtbr6LTJqXY=;
        b=LfYvdojvB117F+NhniCKsPhEObZj6dHb4D7nXuWZUb5pHGDvnI4efFUAhDX6iJDpnO
         UMEW+qB2PlkGjdtwUD7jqO1WZDT//XnzloIOYQQMVrkjLL1bbwzRxVcxJY53OyCJJKNc
         cjBkxdIKNONIsgwB59XxQdkRYOtipAHftPrlLVGviqTodelq0ksnbNSV34MirTNXM+7e
         On/5Iwj7JOcWgr/0WYOhiXCj5fjMWpOYgobOWbnhlX1SN1SdaTIVbtnAAPxNcqhFgF2x
         ex6OfHH70tAxzs8T2O+4NHYcWgWV6af3DPpqC9ilaNaHHy/N2L/AyOOS4Rtwx23JCcD+
         UMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3CriIrg29zPQdpJx8RyXLAcXPj9EmZPOmtbr6LTJqXY=;
        b=LhdFxbzmk1nmFhE/O9H69E8plqTmMAY/L3uo6qnAmddA5NH9G69F6bNZvbsckAaCN9
         vV9ofWV02dAtgzYJMwJtdJ0+CIEsqo2OR3EyDycxdKYy/C92+wi9sdVozd5S84CWdVPq
         FP6DpjtJTyYNRaWU48N5/z+OVHM34d4oFf32CZ5F9qcVbfZ3QXBkT6P4LppGi+pWR4Y+
         fpm+oJPZXdcaML+AT+87/KvXreV8GrBA7kmCe19ddIM0KsyDui8qZDriwye5/YYgR1ds
         OcGO0uCn4rSjw4LR9uqM1+bCe/2/ND2Nb1eSRV2aoHFfLvb6VS+FHCXh9fFIk3M1pt5L
         S/sQ==
X-Gm-Message-State: AOAM533Oykt69VIZFjh3h0khhMIyV1PwL2xHJ2yokhAaEKW9BZ632a3z
        iWCtoEVATq7cJ9EGGS7i3YWF/Q==
X-Google-Smtp-Source: ABdhPJzKFaq5q5XZmASpBuvHXJHyTbNrGi72WYJBYsZg2BrmOGdJmVor20S9V7N+4GiI8lOIEAQgkw==
X-Received: by 2002:aa7:d5d2:: with SMTP id d18mr163317eds.115.1599154231122;
        Thu, 03 Sep 2020 10:30:31 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y14sm3625360eje.10.2020.09.03.10.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 10:30:30 -0700 (PDT)
Date:   Thu, 3 Sep 2020 19:30:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200903173029.GD2997@nanopsycho.orion>
References: <20200902195717.56830-1-snelson@pensando.io>
 <20200902195717.56830-3-snelson@pensando.io>
 <20200903060128.GC2997@nanopsycho.orion>
 <9937d5f2-21a1-53cc-e7fb-075b3014a344@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9937d5f2-21a1-53cc-e7fb-075b3014a344@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 03, 2020 at 05:58:42PM CEST, snelson@pensando.io wrote:
>On 9/2/20 11:01 PM, Jiri Pirko wrote:
>> Wed, Sep 02, 2020 at 09:57:17PM CEST, snelson@pensando.io wrote:
>> > Add support for firmware update through the devlink interface.
>> > This update copies the firmware object into the device, asks
>> > the current firmware to install it, then asks the firmware to
>> > set the device to use the new firmware on the next boot-up.
>> > 
>> > The install and activate steps are launched as asynchronous
>> > requests, which are then followed up with status requests
>> > commands.  These status request commands will be answered with
>> > an EAGAIN return value and will try again until the request
>> > has completed or reached the timeout specified.
>> > 
>> > Signed-off-by: Shannon Nelson <snelson@pensando.io>
>[...]
>> > +
>> > +	netdev_info(netdev, "Installing firmware %s\n", fw_name);
>> You don't need this dmesg messagel.
>> 
>> 
>> > +
>> > +	dl = priv_to_devlink(ionic);
>> > +	devlink_flash_update_begin_notify(dl);
>> > +	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
>> > +
>[...]
>> > +		if (err) {
>> > +			netdev_err(netdev,
>> > +				   "download failed offset 0x%x addr 0x%lx len 0x%x\n",
>> > +				   offset, offsetof(union ionic_dev_cmd_regs, data),
>> > +				   copy_sz);
>> And this one.
>> 
>> 
>> > +			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
>> > +			goto err_out;
>> > +		}
>[...]
>> > +	devlink_flash_update_status_notify(dl, "Activating", NULL, 2, 2);
>> > +
>> > +	netdev_info(netdev, "Firmware update completed\n");
>> And this one.
>> 
>> 
>> > +
>> > +err_out:
>> > +	if (err)
>> > +		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
>> > +	release_firmware(fw);
>> > +	devlink_flash_update_end_notify(dl);
>> > +	return err;
>> > +}
>> > 
>
>True, they aren't "needed" for operational purposes, but they are rather
>useful when inspecting a system after getting a report of bad behavior, and

I don't think it is nice to pollute dmesg with any arbitrary driver-specific
messages.


>since this should be seldom performed there should be no risk of filling the
>log.  As far as I can tell, the devlink messages are only seen at the time
>the flash is performed as output from the flash command, or from a devlink
>monitor if someone started it before the flash operation.  Is there any other
>place that can be inspected later that will indicate someone was fussing with
>the firmware?

Not really, no. But perhaps we can have a counter for that. Similar to
what Jakub suggested for reload.

