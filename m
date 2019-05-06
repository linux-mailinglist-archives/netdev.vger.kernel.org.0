Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD4914918
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 13:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfEFLmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 07:42:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34827 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfEFLmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 07:42:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id w12so3358317wrp.2
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 04:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TExVoQ8ewmtHuXXxWRGPiX4K2KqF2t3ZQWNBr0NW1Mg=;
        b=IiFzTBp6gS3lppAXQ8TogBMN6wjguRLYHlCZHvbxbA13GfF60B6hmqZR431e7AGN6s
         B18mmusuibB6xRKoCaV/lGhSFurOioBsuB+6MuMIfUj1SxpGmbwBmUv189t0mFqVG6bz
         bWipL6BRbLMXBERMwdwT5L0zLVum0FwHAKmRamvxNVwZzdZKc4cbGvjYnfWExKpPZkwb
         UQlBiiZsT07QTGmX/yI3KpyW8sOnLZP59FYUycU+c0mCflw7zHqsMJgksANrrAJJeDzv
         wWbRenEDIxmfvG+ARxT+/jCbNBkEg9Xv98fw8Rvc5BD7o8o1WmOwys2sh81lqmhMQpwy
         XxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TExVoQ8ewmtHuXXxWRGPiX4K2KqF2t3ZQWNBr0NW1Mg=;
        b=HzUkCZLAtMjazP6TZcAf4QezokuTiLoWDZSAn+dqma4WtdY32hi3qRty1Q+SKAbsOa
         P7P2ytGkq5afO7/7RqH5NWT1m1C0ITfKIqknwC6TbHw0lxO4aFGlPGo/HOF8k6AbZSL7
         Rm0lh9Q3qR9nUUFFMKE1pRUEYgk68JZxLud+bEddViC5sdHAxSIXryzNR79UPd1jhP1h
         aePnmDQvxRyGHqO3zGNQ4674ES75LRHXOiDOKCzceHcrKUcXRerA6VbDnzyZUFzMqUi7
         WeZjvqwajsHxs0nRHXFviRlgs6VewFNB97H1mSWQPj2Tv3+aRXzlqHAMJQWJOMbJjHyO
         N/HA==
X-Gm-Message-State: APjAAAXnH3EkGyLL7/QiW7NsoXt5P2JObjRMnBMgzpBmYNkHmrS1E1+N
        GWOx0pfh4hwk5h+qEnI1FlMUXw==
X-Google-Smtp-Source: APXvYqzU010XmZ22RELbMTAZJUJJiqWcrquUphVuTcyKeM4XgEFGAyVOO6x/PXfXeFqYCpV4KrWHSw==
X-Received: by 2002:adf:ee42:: with SMTP id w2mr17306674wro.161.1557142929048;
        Mon, 06 May 2019 04:42:09 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id n15sm1360845wrp.58.2019.05.06.04.42.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 04:42:08 -0700 (PDT)
Date:   Mon, 6 May 2019 13:42:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 14/15] net/mlx5: Add support for FW fatal reporter dump
Message-ID: <20190506114207.GC2280@nanopsycho>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-15-saeedm@mellanox.com>
 <20190505155243.GG31501@nanopsycho.orion>
 <4d297327-ec38-c0c9-cb9c-df09443f433d@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d297327-ec38-c0c9-cb9c-df09443f433d@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 06, 2019 at 12:54:00PM CEST, moshe@mellanox.com wrote:
>
>
>On 5/5/2019 6:52 PM, Jiri Pirko wrote:
>> Sun, May 05, 2019 at 02:33:33AM CEST, saeedm@mellanox.com wrote:
>>> From: Moshe Shemesh <moshe@mellanox.com>
>>>
>>> Add support of dump callback for mlx5 FW fatal reporter.
>>> The FW fatal dump use cr-dump functionality to gather cr-space data for
>>> debug. The cr-dump uses vsc interface which is valid even if the FW
>>> command interface is not functional, which is the case in most FW fatal
>>> errors.
>>> The cr-dump is stored as a memory region snapshot to ease read by
>>> address.
>>>
>>> Command example and output:
>>> $ devlink health dump show pci/0000:82:00.0 reporter fw_fatal
>>> devlink_region_name: cr-space snapshot_id: 1
>>>
>>> $ devlink region read pci/0000:82:00.0/cr-space snapshot 1 address 983064 length 8
>>> 00000000000f0018 e1 03 00 00 fb ae a9 3f
>>>
>>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>>> ---
>>> .../net/ethernet/mellanox/mlx5/core/health.c  | 39 +++++++++++++++++++
>>> 1 file changed, 39 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>>> index e64f0e32cd67..5271c88ef64c 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>>> @@ -547,9 +547,48 @@ mlx5_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
>>> 	return mlx5_health_care(dev);
>>> }
>>>
>>> +static int
>>> +mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
>>> +			    struct devlink_fmsg *fmsg, void *priv_ctx)
>>> +{
>>> +	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
>>> +	char crdump_region[20];
>>> +	u32 snapshot_id;
>>> +	int err;
>>> +
>>> +	if (!mlx5_core_is_pf(dev)) {
>>> +		mlx5_core_err(dev, "Only PF is permitted run FW fatal dump\n");
>>> +		return -EPERM;
>>> +	}
>>> +
>>> +	err = mlx5_crdump_collect(dev, crdump_region, &snapshot_id);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	if (priv_ctx) {
>>> +		struct mlx5_fw_reporter_ctx *fw_reporter_ctx = priv_ctx;
>>> +
>>> +		err = mlx5_fw_reporter_ctx_pairs_put(fmsg, fw_reporter_ctx);
>>> +		if (err)
>>> +			return err;
>>> +	}
>>> +
>>> +	err = devlink_fmsg_string_pair_put(fmsg, "devlink_region_name",
>>> +					   crdump_region);
>> 
>> Oh come on. You cannot be serious :/ Please do proper linkage to region
>> and snapshot in devlink core.
>> 
>
>Not sure I understand what you mean, as I wrote in the commit message, 
>the region snapshot added value here, is that user can read data by offset.

If there is a region/snapshot affiliated with a reporter, it should be
linked together in devlink core. Not in the driver by exposing
arbitrary strings...


>
>> 
>> 
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	err = devlink_fmsg_u32_pair_put(fmsg, "snapshot_id", snapshot_id);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> static const struct devlink_health_reporter_ops mlx5_fw_fatal_reporter_ops = {
>>> 		.name = "fw_fatal",
>>> 		.recover = mlx5_fw_fatal_reporter_recover,
>>> +		.dump = mlx5_fw_fatal_reporter_dump,
>>> };
>>>
>>> #define MLX5_REPORTER_FW_GRACEFUL_PERIOD 1200000
>>> -- 
>>> 2.20.1
>>>
