Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8755D14910
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 13:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEFLic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 07:38:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34176 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEFLic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 07:38:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id m20so5252205wmg.1
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 04:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0dU4FW4KU3sCZta9Xy//Ckb/amueMM6AluqktiAD/y8=;
        b=vnOPEExCdj4K8JvKs92L/ltwPs8cyRe1W/cqzDmv2rBmXrMLyOCbjuwDUiozGneyx5
         JT8Xx4vXe5VY7yBC7IF2M7KnvRPqlBc7Q+GDLg38kpQoWTga/dXWIGuyyszhB8MOPUje
         i1b+VktG6ZMr5BguFiEd3NeOCMuieFIoKyVEE4Iw0ar+qryb9x5xSTLh+lQ1di/msTFg
         Cs7/j8m/EnaQ+I6YfS9cpweD8GVm+EMJ7673cWiWDk1FYM1FbSjExnVJBx2mWM63ARzI
         nVgtAPJ4VBYMpt7gIe9UlnRIwdPahPiqmIQVbzByssqitaFCzLFJEffPDhyL+y78e5fu
         Mh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0dU4FW4KU3sCZta9Xy//Ckb/amueMM6AluqktiAD/y8=;
        b=TOAynAcDDV4q9OPpcA0EnMjRTuOVjvp1Q+RJbDfk6RJQQKXQiBYnNU2hBvVNejWk/1
         a5NJglAbNiEYHQnXdhsbX2eJFGjuqAaqnPv1JnNS30z2Bczs3K+RmsaPPYe9USG5MIZi
         MldeHXNbuqAJngKEieVRtVtUFFSJvGpM9zmwfjPhjrnoUz6+xnSbStrcx44GreK3rxkY
         0GBW1wAh6MytmqH1216IBBI6wMBaS3BmNhpahoFnPPeUE9F0ndjXtdDiPIG8cJUTjgr0
         EwCfi3XuzEcKG4HpiZcHR5QmPkSk2Va70dg1RUMo4fIqPzHQmzCYeUztLSh0VH0LnlAj
         kieg==
X-Gm-Message-State: APjAAAU8KYT7uYMXgyFZEb6itQsB53zK1/+tVCsxS415QXOwHA8F09up
        G2b6k9Bw1cOnRPP7EV9yHkTYoQ==
X-Google-Smtp-Source: APXvYqzmUaW1X+CGU2R7PPXyJ5CJtA27bbVL6kEvujDdDcF99vP9BMrvPPeLeLhzMJWWPOvxEZvVmQ==
X-Received: by 2002:a1c:6502:: with SMTP id z2mr15626251wmb.119.1557142710733;
        Mon, 06 May 2019 04:38:30 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id r12sm5216221wrx.32.2019.05.06.04.38.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 04:38:30 -0700 (PDT)
Date:   Mon, 6 May 2019 13:38:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Message-ID: <20190506113829.GB2280@nanopsycho>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-10-saeedm@mellanox.com>
 <20190505154212.GC31501@nanopsycho.orion>
 <da1c4267-c258-525e-70a2-9ccd2629d5c4@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da1c4267-c258-525e-70a2-9ccd2629d5c4@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 06, 2019 at 12:45:44PM CEST, moshe@mellanox.com wrote:
>
>
>On 5/5/2019 6:42 PM, Jiri Pirko wrote:
>> Sun, May 05, 2019 at 02:33:23AM CEST, saeedm@mellanox.com wrote:
>>> From: Moshe Shemesh <moshe@mellanox.com>
>>>
>>> Create mlx5_devlink_health_reporter for FW reporter. The FW reporter
>>> implements devlink_health_reporter diagnose callback.
>>>
>>> The fw reporter diagnose command can be triggered any time by the user
>>> to check current fw status.
>>> In healthy status, it will return clear syndrome. Otherwise it will dump
>>> the health info buffer.
>>>
>>> Command example and output on healthy status:
>>> $ devlink health diagnose pci/0000:82:00.0 reporter fw
>>> Syndrome: 0
>>>
>>> Command example and output on non healthy status:
>>> $ devlink health diagnose pci/0000:82:00.0 reporter fw
>>> diagnose data:
>>> assert_var[0] 0xfc3fc043
>>> assert_var[1] 0x0001b41c
>>> assert_var[2] 0x00000000
>>> assert_var[3] 0x00000000
>>> assert_var[4] 0x00000000
>>> assert_exit_ptr 0x008033b4
>>> assert_callra 0x0080365c
>>> fw_ver 16.24.1000
>>> hw_id 0x0000020d
>>> irisc_index 0
>>> synd 0x8: unrecoverable hardware error
>>> ext_synd 0x003d
>>> raw fw_ver 0x101803e8
>>>
>>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>>> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>> 
>> 	
>> [...]	
>> 	
>> 	
>>> +static int
>>> +mlx5_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
>>> +			  struct devlink_fmsg *fmsg)
>>> +{
>>> +	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
>>> +	struct mlx5_core_health *health = &dev->priv.health;
>>> +	u8 synd;
>>> +	int err;
>>> +
>>> +	mutex_lock(&health->info_buf_lock);
>>> +	mlx5_get_health_info(dev, &synd);
>>> +
>>> +	if (!synd) {
>>> +		mutex_unlock(&health->info_buf_lock);
>>> +		return devlink_fmsg_u8_pair_put(fmsg, "Syndrome", synd);
>>> +	}
>>> +
>>> +	err = devlink_fmsg_string_pair_put(fmsg, "diagnose data",
>>> +					   health->info_buf);
>> 
>> No! This is wrong! You are sneaking in text blob. Please put the info in
>> structured form using proper fmsg helpers.
>> 
>This is the fw output format, it is already in use, I don't want to 
>change it, just have it here in the diagnose output too.

Already in use where? in dmesg? Sorry, but that is not an argument.
Please format the message properly.

