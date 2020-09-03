Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A67B25C5F8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgICP6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgICP6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 11:58:45 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61747C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 08:58:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ls14so1676996pjb.3
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 08:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=58d/pu/jyUTz6K2ZEKjbUgOZoXwR4t6Pq1EPE5UMLSg=;
        b=fIxNsrbMQgatoo9TTrFHgYcR/u19wQK0KbpOW4P82XECMkzRI3IppSjQLHuBe7O4xI
         oX66Du2tmqjhuWABNO9cjhAaKHpVIbM/NPkW+UEXh+CUwaRaC5bPK2K3tV7Xb2DgfKSt
         kQUO4ddft05mMssJDuFOk545rqA8+BC6fGLrn+mRo9xz42fVcpcaMHa8NRQpV8WN48aA
         Ta90k53lTJUkxS2gj39C1T0b/IT2Lho3pXKi1L2H6FUXyjKBjumeDpvX/BpH45uExuB2
         VUBRvjtI8QKXNebdbHc1jslnnGVSjJ/uzgqvB383iC32jGpttgwsfK6PPXqvVqJyYTB9
         IEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=58d/pu/jyUTz6K2ZEKjbUgOZoXwR4t6Pq1EPE5UMLSg=;
        b=fIRNl7wEzpOuJ2Ks5qwdaXsUHptYXzJoZD/+dD+VfCKHW9OkTBVYUCWyrUIEC0b5GJ
         EZ7mmOFoFZoJziGIvxb1GaLb3jxhGmeuFhAd3aIP3lelIrC67TYpyO8UcFkJpgMp+kWo
         txdJQR9pLhg0FkkLrhiKoOPyHFdZuGLAWGUMFdb9pi/87SN01vgoeYsZtr6eOaua16Qq
         U+jddvM/bccz6vIa36HJhI5/RSzAD6WqMSw2q6AzVVH0ERnXjBRcB5U98mkYB2vi9upP
         Xv44RdaKuSsyBiPNgbMexNeM5amXtx5JrKsU7p94B3W+gxvZZJIK9q0VRwPrWB+vA/Aw
         ipsQ==
X-Gm-Message-State: AOAM533VgSgBAlRi65jsrljWYV3QmWlrgT6YK9BXvR3A7FiFpJYMXW+B
        ArOGnlRNa6R8mjrhGSV60gz3ZaH86aCY4g==
X-Google-Smtp-Source: ABdhPJypbVSpnh4EhgxejkU1CmtfYOdJrkgpPiWV+4GRM7jcFHXn3UgKM2wvPAExA79EEJO2sD+ijw==
X-Received: by 2002:a17:90a:3486:: with SMTP id p6mr3784523pjb.44.1599148724894;
        Thu, 03 Sep 2020 08:58:44 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id u8sm3577902pfm.133.2020.09.03.08.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 08:58:44 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] ionic: add devlink firmware update
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200902195717.56830-1-snelson@pensando.io>
 <20200902195717.56830-3-snelson@pensando.io>
 <20200903060128.GC2997@nanopsycho.orion>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9937d5f2-21a1-53cc-e7fb-075b3014a344@pensando.io>
Date:   Thu, 3 Sep 2020 08:58:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903060128.GC2997@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 11:01 PM, Jiri Pirko wrote:
> Wed, Sep 02, 2020 at 09:57:17PM CEST, snelson@pensando.io wrote:
>> Add support for firmware update through the devlink interface.
>> This update copies the firmware object into the device, asks
>> the current firmware to install it, then asks the firmware to
>> set the device to use the new firmware on the next boot-up.
>>
>> The install and activate steps are launched as asynchronous
>> requests, which are then followed up with status requests
>> commands.  These status request commands will be answered with
>> an EAGAIN return value and will try again until the request
>> has completed or reached the timeout specified.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
[...]
>> +
>> +	netdev_info(netdev, "Installing firmware %s\n", fw_name);
> You don't need this dmesg messagel.
>
>
>> +
>> +	dl = priv_to_devlink(ionic);
>> +	devlink_flash_update_begin_notify(dl);
>> +	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
>> +
[...]
>> +		if (err) {
>> +			netdev_err(netdev,
>> +				   "download failed offset 0x%x addr 0x%lx len 0x%x\n",
>> +				   offset, offsetof(union ionic_dev_cmd_regs, data),
>> +				   copy_sz);
> And this one.
>
>
>> +			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
>> +			goto err_out;
>> +		}
[...]
>> +	devlink_flash_update_status_notify(dl, "Activating", NULL, 2, 2);
>> +
>> +	netdev_info(netdev, "Firmware update completed\n");
> And this one.
>
>
>> +
>> +err_out:
>> +	if (err)
>> +		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
>> +	release_firmware(fw);
>> +	devlink_flash_update_end_notify(dl);
>> +	return err;
>> +}
>>

True, they aren't "needed" for operational purposes, but they are rather 
useful when inspecting a system after getting a report of bad behavior, 
and since this should be seldom performed there should be no risk of 
filling the log.  As far as I can tell, the devlink messages are only 
seen at the time the flash is performed as output from the flash 
command, or from a devlink monitor if someone started it before the 
flash operation.  Is there any other place that can be inspected later 
that will indicate someone was fussing with the firmware?

sln


