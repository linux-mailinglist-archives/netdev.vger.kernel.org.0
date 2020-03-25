Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEEE1930EC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgCYTOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:14:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50178 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCYTOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:14:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id d198so3830056wmd.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lxetV3nR7qzICt1aUvnii58mpNJY0JDqIVUAfry96FM=;
        b=TIpmTdutdDwRVr8bNuUWE9bBgHs706aVQkJJYN2VwxchpfNio/Xeh9AJTJfZVT/RCz
         dCTLtnHgHH3EAXLspjiUGs0gLioDqZ4493Nzj0U27UUZogen3awhlaDBPoZ05ac5Ny/V
         v63DeI1izDbtPEQYnxkp/m3vcM4NpmAfKGXZ8e+qYuU/bhReFs1sN4PpxaPhqhSWtWHl
         UbjUkCPWVaAuhxSYInbDyRozEcPsU0hSTw8EfKZj11/RgHdPU0sRLxQvALIXCfY3ppRX
         U8esNGDFOThpyESnfuo83pMPs34G5t0gRALgD3oMYchXA9mEzD6e6/dsGMxSMFk2kL3L
         iM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lxetV3nR7qzICt1aUvnii58mpNJY0JDqIVUAfry96FM=;
        b=GSYv98BzIrw3ivv8u2zx8DTUC4t1xogOfzX1AttFJsaNV6qZUnOXU/9LR9fptMkt8k
         wmjyqDOUtqcSwPCnmiDswcmSvahxcml9MgP7bT4jE146QNnH16wr0YWT1W0YLBlq/w/i
         BBr7o4EFOf7hR64eBrfREPAIBz0GXtdDCU3jsaMG5DnVVu6of+2YGmoBgfGbYIP3spyK
         n+8HiONxOPKRvKmosuVfklvwYlyizm8elCOcnC28u50/2DfumaYZBdMOZyxipDDnE57G
         bqQvdWt3Idl6MXGU6OkuGFaB+M2e8LjM9l8uXqlJBoVaE6DIJzxLMaGOYgkoFmiCL5OP
         /hoA==
X-Gm-Message-State: ANhLgQ0ZU72Sq+gpTmUm1pem0EBmKXnS04g/KDMC3xvLBoLFqvWIZj37
        kedhH+W0UlCA13L/3F2sTCcCQw==
X-Google-Smtp-Source: ADFU+vv6dbEgu7q3Zufhakc2s5jtU4B96q6HX6mbf986625vhKU5cwMSGETH6sSbWOOUhKnwvVTx5Q==
X-Received: by 2002:a1c:3105:: with SMTP id x5mr5077091wmx.51.1585163638021;
        Wed, 25 Mar 2020 12:13:58 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l83sm10250121wmf.43.2020.03.25.12.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 12:13:57 -0700 (PDT)
Date:   Wed, 25 Mar 2020 20:13:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH 06/10] devlink: convert snapshot id getter to return an
 error
Message-ID: <20200325191356.GF11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-7-jacob.e.keller@intel.com>
 <20200325110425.6fdf6cb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325110425.6fdf6cb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 25, 2020 at 07:04:25PM CET, kuba@kernel.org wrote:
>On Tue, 24 Mar 2020 15:34:41 -0700 Jacob Keller wrote:
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index f7621ccb7b88..f9420b77e5fd 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -45,8 +45,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>>  {
>>  	struct nsim_dev *nsim_dev = file->private_data;
>>  	void *dummy_data;
>> -	int err;
>> -	u32 id;
>> +	int err, id;
>>  
>>  	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>>  	if (!dummy_data)
>> @@ -55,6 +54,10 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>>  	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>>  
>>  	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
>> +	if (id < 0) {
>> +		pr_err("Failed to get snapshot id\n");
>> +		return id;
>> +	}
>>  	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
>>  					     dummy_data, id);
>>  	if (err) {
>
>Hmm... next patch introduces some ref counting on the ID AFAICT,
>should there be some form of snapshot_id_put(), once the driver is 
>done creating the regions it wants?
>
>First what if driver wants to create two snapshots with the same ID but

>user space manages to delete the first one before second one is created.
>
>Second what if create fails, won't the snapshot ID just stay in XA with
>count of 0 forever?

Yeah, that seems like a race condition this is introducing.

