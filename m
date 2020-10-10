Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346D6289FFD
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 12:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgJJKTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 06:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgJJKQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 06:16:07 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973E7C0613E5;
        Sat, 10 Oct 2020 03:03:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b193so8506010pga.6;
        Sat, 10 Oct 2020 03:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pEEKeQr4AxJsyV0EJXbsIp9rmMhN3mdQEUHeeZ1DQX0=;
        b=SYKluLk1xiuVXtuBY+vLYX+G1VKNe1UNjHn5wSMbGmDYq7apD5kYy7QBH4bTHDiSHz
         yFxE/ALQLOFWpvLu1BFpbxH8+5tGXR6QwKiKkgSmZrJGi9YQ/GIGNBi+9hHnElRJ096+
         /KY6pTs/ZJVNOqyQdz10Xdk61RgqAWHV5qXUFZtbWfhqwTKGMkX5ahJV5BLwQcwi+3jG
         iZ0R1P7WRt7OSfhLoLkxQdvI2f7x125oJBaqiOPUxGpWItEV4QqJ4WrKcwpNyKP9tChu
         tMUlardM+xNSHmauqTZeYmzZkl9iqCBlRYBbOajLmo9tlefjaN1Wo5NidFEN/kAG7NGG
         z1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pEEKeQr4AxJsyV0EJXbsIp9rmMhN3mdQEUHeeZ1DQX0=;
        b=M59hqZtU2HNAxM+FEXocx7vPWajGXVZBXQ4pM3i9FYeuI52NcUs9kjLuGdDOaviOgM
         sMddWmvZq7iS4yVI12TgPNk/ZbGpUSiJ310H7lZeqJtbxk49d+XVz21Bo+39IonPoRAq
         0EF5JgTvA9SD16hCAsip8G8fx0tvsX2HuFZYL62isXKv6kF8t6FGMS9/ONyct7hRRpsL
         9sQjvkolgUWX0fEpVB2AAi0JZXiyRwxbT2EasW/CZJQyneh88bwmxGDZK9m7MW8VZn4i
         6kU/NIsI6F+3tVL0rW5UGv7yU7AQGmkLSycAqUW85vaJ1feHuc+viSPg02nSgWyzz3ct
         Ud8Q==
X-Gm-Message-State: AOAM530inV+tCs4B7HNvWDqcKJqyL7s/yeJGwNdPZ3msmX3nKtW1xfT/
        nRqDye9nyXzwJGle73LVQQ8=
X-Google-Smtp-Source: ABdhPJw2MPqnrARRlqblzpmpUAYvMLuvf+p9y3d+T4o6tNKqjhiWtMY8ouXNCeLTWZwEJAqZch7IxA==
X-Received: by 2002:a17:90a:c501:: with SMTP id k1mr9817868pjt.170.1602324189048;
        Sat, 10 Oct 2020 03:03:09 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id t13sm13862681pfc.1.2020.10.10.03.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 03:03:08 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 10 Oct 2020 18:02:58 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/6] staging: qlge: coredump via devlink health
 reporter
Message-ID: <20201010100258.px2go6nugsfbwoq7@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-3-coiby.xu@gmail.com>
 <20201010074809.GB14495@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201010074809.GB14495@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 04:48:09PM +0900, Benjamin Poirier wrote:
>On 2020-10-08 19:58 +0800, Coiby Xu wrote:
>>     $ devlink health dump show DEVICE reporter coredump -p -j
>>     {
>>         "Core Registers": {
>>             "segment": 1,
>>             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
>> ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>>         },
>>         "Test Logic Regs": {
>>             "segment": 2,
>>             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>>         },
>>         "RMII Registers": {
>>             "segment": 3,
>>             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>>         },
>>         ...
>>         "Sem Registers": {
>>             "segment": 50,
>>             "values": [ 0,0,0,0 ]
>>         }
>>     }
>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/qlge_devlink.c | 131 ++++++++++++++++++++++++++--
>>  1 file changed, 125 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
>> index aa45e7e368c0..91b6600b94a9 100644
>> --- a/drivers/staging/qlge/qlge_devlink.c
>> +++ b/drivers/staging/qlge/qlge_devlink.c
>> @@ -1,16 +1,135 @@
>>  #include "qlge.h"
>>  #include "qlge_devlink.h"
>>
>> -static int
>> -qlge_reporter_coredump(struct devlink_health_reporter *reporter,
>> -			struct devlink_fmsg *fmsg, void *priv_ctx,
>> -			struct netlink_ext_ack *extack)
>> +static int fill_seg_(struct devlink_fmsg *fmsg,
>
>Please include the "qlge_" prefix.
>
>> +		    struct mpi_coredump_segment_header *seg_header,
>> +		    u32 *reg_data)
>>  {
>> -	return 0;
>> +	int i;
>> +	int header_size = sizeof(struct mpi_coredump_segment_header);
>> +	int regs_num = (seg_header->seg_size - header_size) / sizeof(u32);
>> +	int err;
>> +
>> +	err = devlink_fmsg_pair_nest_start(fmsg, seg_header->description);
>> +	if (err)
>> +		return err;
>> +	err = devlink_fmsg_obj_nest_start(fmsg);
>> +	if (err)
>> +		return err;
>> +	err = devlink_fmsg_u32_pair_put(fmsg, "segment", seg_header->seg_num);
>> +	if (err)
>> +		return err;
>> +	err = devlink_fmsg_arr_pair_nest_start(fmsg, "values");
>> +	if (err)
>> +		return err;
>> +	for (i = 0; i < regs_num; i++) {
>> +		err = devlink_fmsg_u32_put(fmsg, *reg_data);
>> +		if (err)
>> +			return err;
>> +		reg_data++;
>> +	}
>> +	err = devlink_fmsg_obj_nest_end(fmsg);
>> +	if (err)
>> +		return err;
>> +	err = devlink_fmsg_arr_pair_nest_end(fmsg);
>> +	if (err)
>> +		return err;
>> +	err = devlink_fmsg_pair_nest_end(fmsg);
>> +	return err;
>> +}
>> +
>> +#define fill_seg(seg_hdr, seg_regs)			               \
>
>considering that this macro accesses local variables, it is not really
>"function-like". I think an all-caps name would be better to tip-off the
>reader.
>
Thank you for this suggestion!

>> +	do {                                                           \
>> +		err = fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
>> +		if (err) {					       \
>> +			kvfree(dump);                                  \
>> +			return err;				       \
>> +		}                                                      \
>> +	} while (0)
>> +
>> +static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
>> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
>> +				  struct netlink_ext_ack *extack)
>> +{
>> +	int err = 0;
>> +
>> +	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);
>
>Please name this variable ql_devlink, like in qlge_probe().

I happened to find the following text in drivers/staging/qlge/TODO
> * in terms of namespace, the driver uses either qlge_, ql_ (used by
>  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
>  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
>  prefix.

So I will adopt qlge_ instead. Besides I prefer qlge_dl to ql_devlink.

--
Best regards,
Coiby
