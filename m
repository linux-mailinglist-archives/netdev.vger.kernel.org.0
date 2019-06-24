Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C506C50BF3
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbfFXNZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:25:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36894 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfFXNZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:25:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so13388367wme.2
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 06:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qhMDYDjYRAwO0ka1qjQKivAhHcbXDGT/j+MNTC6poVw=;
        b=YlowwLODx7ZFt4VJWCZQZSJCZQ56pBoNr+/100lbHqwvnmgT+2W/xj8q+3HM0mGTb/
         4gY6rc9o8sBRJmc+1L+PFzU9Xz8dxBn8dbusR0SvTj7FcRJf9HwGR09rVRCOWQq3cfzf
         p2hdFscPio2jAJVyM4s9KGuwRHpjGL4DIjtX3ssKQkZDzz/aFqkom4jm0ZGhCPyefyzs
         QjObEJiWZVBafsa3zAFpcwyNM4nolM0UPto8/7Pnzfpv1yj9yON5606htXIkQDxnz2n1
         FS4s21S21t0Z22+MV772dbHf1dhZXGcVGxIsnPungzsqkVqzDZhY8RnOSHtldFydspmJ
         GnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qhMDYDjYRAwO0ka1qjQKivAhHcbXDGT/j+MNTC6poVw=;
        b=fyaOccc7nSTb9dlrrWRQiYa8LjYDJg+/ki456gpjYXJcOadBGlAfPlO8vXJcCS9WKP
         1MqYFpVCgDA+2t0f4RGYkS9DF0F/XIt6vel6ctH1scHern5Xi0l1KlyaypDD00YLfFES
         88W5Ujv/fT85OIz18N4JnCkvGYJQ1QS/55M67gzpu0Keub1QKqqixTA2Zz5pphvHR0Ha
         7uE/Mr2Okbq14hCJ53NCSUjEeEaSWTivCyjpnJvYoMSxIxopuN+oqmO3pzsQ2gTDvx+5
         A0NO0YZCnUQJ9EvotggCjf6CxsYLkspwAkygdcK+Yc7s05U56R9tUCVJBzLtX5ivYIrq
         4WSw==
X-Gm-Message-State: APjAAAUEfjwEhr0LPDj9Oi61bkrVXSEzVbS/ANdZLLih8bYmsR2vdi6E
        zMC6cS2Aoi7hE8WTLJJSaQ3JE+6M9aw=
X-Google-Smtp-Source: APXvYqwcUra2ij9ZRQ7+AQF/9qtFNAdWpROdrelVpuwSCUuFKCQaMR16X65GmyelmhmL4KcTPXfjqg==
X-Received: by 2002:a1c:2907:: with SMTP id p7mr15849941wmp.100.1561382740205;
        Mon, 24 Jun 2019 06:25:40 -0700 (PDT)
Received: from [10.8.2.125] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id u6sm12974247wml.9.2019.06.24.06.25.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:25:39 -0700 (PDT)
Subject: Re: [PATCH rdma-next v1 08/12] IB/mlx5: Introduce
 MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-9-leon@kernel.org> <20190624115059.GA5479@mellanox.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <baae74b9-94ff-9f5a-0992-c1eec5049306@dev.mellanox.co.il>
Date:   Mon, 24 Jun 2019 16:25:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624115059.GA5479@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2019 2:51 PM, Jason Gunthorpe wrote:
> On Tue, Jun 18, 2019 at 08:15:36PM +0300, Leon Romanovsky wrote:
>> From: Yishai Hadas <yishaih@mellanox.com>
>>
>> Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD and its initial
>> implementation.
>>
>> This object is from type class FD and will be used to read DEVX
>> async events.
>>
>> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>   drivers/infiniband/hw/mlx5/devx.c         | 112 ++++++++++++++++++++--
>>   include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  10 ++
>>   include/uapi/rdma/mlx5_user_ioctl_verbs.h |   4 +
>>   3 files changed, 116 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
>> index 80b42d069328..1815ce0f8daf 100644
>> +++ b/drivers/infiniband/hw/mlx5/devx.c
>> @@ -33,6 +33,24 @@ struct devx_async_data {
>>   	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
>>   };
>>   
>> +struct devx_async_event_queue {
> 
> It seems to be a mistake to try and re-use the async_event_queue for
> both cmd and event, as they use it very differently and don't even
> store the same things in the event_list. I think it is bettter to just
> inline this into devx_async_event_file (and inline the old struct in
> the cmd file
> 

How about having another struct with all the event's queue fields 
together ? this has the benefit of having all those related fields in 
one place and leave the cmd as is.

Alternatively,
We can inline the event stuff under devx_async_event_file and leave the 
cmd for now under a struct as it's not directly related to this series.

What do you think ?


>> +	spinlock_t		lock;
>> +	wait_queue_head_t	poll_wait;
>> +	struct list_head	event_list;
>> +	atomic_t		bytes_in_use;
>> +	u8			is_destroyed:1;
>> +	u32			flags;
>> +};
> 
> All the flags testing is ugly, why not just add another bitfield?

The flags are coming from user space and have their different name 
space, I prefer to not mix with kernel ones. (i.e. is_destroyed).
Makes sense ?

> 
>> +
>> +struct devx_async_event_file {
>> +	struct ib_uobject		uobj;
>> +	struct list_head subscribed_events_list; /* Head of events that are
>> +						  * subscribed to this FD
>> +						  */
>> +	struct devx_async_event_queue	ev_queue;
>> +	struct mlx5_ib_dev *dev;
>> +};
>> +
> 
> Crazy indenting
> 
OK, will handle.

>> diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
>> index a8f34c237458..57beea4589e4 100644
>> +++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
>> @@ -63,5 +63,9 @@ enum mlx5_ib_uapi_dm_type {
>>   	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM,
>>   };
>>   
>> +enum mlx5_ib_uapi_devx_create_event_channel_flags {
>> +	MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA = 1
>> << 0,
> 
> Maybe this name is too long

Quite long but follows the name scheme having the UAPI prefix.
Any shorter suggestion ?

