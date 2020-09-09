Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC672631AA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbgIIQXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731033AbgIIQXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:23:12 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73871C0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:23:12 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s65so1369446pgb.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=LC0V6SnudRoaLLf8lQnirMRHyMUKWlz7mIxhomF3dbM=;
        b=ux3eUnCb2hLl3aw6koiNY85vu7TDVYdVJH905Z3UW/pv8m6U8F7G2ixqtWgxujKvm1
         Mo4JQQ1q5rhTyN3vFdozbfHqhJvIZsjvpALyiHp6n3R5sHJSJcCmHcDBeRem4/zCa8AP
         1FyaOxkvfG9zNjAFV84+PXbLFhcSuEoLRu+XqpLmXkoyBwJeNji9ynFfvUJoo1YPvAB3
         XXbj0FLXDVtq72EoTxYIt/9DDjZbbZsuC0L0gTyQxRBcI7U7aJ9cC+NU1j+IEwFW5aL3
         r57u6TU9I5PCZJoNl31pLRuTymmFmKiYEEKZ7jzuu61HrtrNrN3R7z0Sdi/cuWbVxgR+
         P99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=LC0V6SnudRoaLLf8lQnirMRHyMUKWlz7mIxhomF3dbM=;
        b=d7G4Rh9caN3ZvoEYDYYaSgxgG9nFx7jrGAvL1wtqW6/hcgCSQEnvLY+jnhIB+CvhGQ
         CoEA2CsXlDY0j+baWaogbJ6XAvmd2Nm/VgL4psCXdz8L8ubyXQkUmzmAd/NMrisR7xYo
         bn02EJN8gZ2SWxdXM9YDhpwClyoOICK78v9fS/UPJijGsnwIaeSGMkW81Cw1Y3orsu9z
         EooOeQ7lMTCRmeSltKyWFWzJ/rjj/IxvHw1B2R5iMorPKbHaoWexze3ZZiEQtrW7pP08
         M+N+Afb2T1qFlv7JJcxtZ96/2rULrsJlTtQi64YjzDJQaLonx7oyD4l0THV0abxlKgrD
         XKZw==
X-Gm-Message-State: AOAM532vZ1iMTepnAVqBboQHd+ke3lHvSYG3DCJc1lTfqGoIosuO0VyI
        /KpbYCE7Bca6oOvVy/ZOk+9ubtfu8gQi4A==
X-Google-Smtp-Source: ABdhPJyrzrIYYNPH5ErEWD9wXWDmzpmOp17unOkypnveuqpT1FaAANfeFy7Gh52wAGZJ+sDRnI5R8w==
X-Received: by 2002:a63:7b16:: with SMTP id w22mr1138026pgc.17.1599668590529;
        Wed, 09 Sep 2020 09:23:10 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id b29sm2465478pgb.71.2020.09.09.09.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 09:23:10 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200908224812.63434-1-snelson@pensando.io>
 <20200908224812.63434-3-snelson@pensando.io>
 <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
Date:   Wed, 9 Sep 2020 09:23:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 4:54 PM, Jakub Kicinski wrote:
> On Tue,  8 Sep 2020 15:48:12 -0700 Shannon Nelson wrote:
>> +	dl = priv_to_devlink(ionic);
>> +	devlink_flash_update_status_notify(dl, label, NULL, 1, timeout);
>> +	start_time = jiffies;
>> +	end_time = start_time + (timeout * HZ);
>> +	do {
>> +		mutex_lock(&ionic->dev_cmd_lock);
>> +		ionic_dev_cmd_go(&ionic->idev, &cmd);
>> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
>> +		mutex_unlock(&ionic->dev_cmd_lock);
>> +
>> +		devlink_flash_update_status_notify(dl, label, NULL,
>> +						   (jiffies - start_time) / HZ,
>> +						   timeout);
> That's not what I meant. I think we can plumb proper timeout parameter
> through devlink all the way to user space.

Sure, but until that gets worked out, this should suffice.

>
>> +	} while (time_before(jiffies, end_time) && (err == -EAGAIN || err == -ETIMEDOUT));
>> +
>> +	if (err == -EAGAIN || err == -ETIMEDOUT) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Firmware wait timed out");
>> +		dev_err(ionic->dev, "DEV_CMD firmware wait %s timed out\n", label);
>> +	} else if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Firmware wait failed");
>> +	} else {
>> +		devlink_flash_update_status_notify(dl, label, NULL, timeout, timeout);
>> +	}
>
>> +		if (offset > next_interval) {
>> +			devlink_flash_update_status_notify(dl, "Downloading",
>> +							   NULL, offset, fw->size);
>> +			next_interval = offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
>> +		}
>> +	}
>> +	devlink_flash_update_status_notify(dl, "Downloading", NULL, 1, 1);
> This one wasn't updated.

Yep, missed it.  I'll follow up.

sln


