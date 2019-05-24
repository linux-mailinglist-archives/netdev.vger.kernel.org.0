Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C14292BB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbfEXIO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:14:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52234 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389160AbfEXIO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:14:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id y3so8381710wmm.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 01:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1HsD7mMC2/+jXIC1KTrUHZf1j8ALiE7MIw1gmjGl40A=;
        b=DllpAZO6SADoULQqTKnYKK1NM7cUcMH7zmDnrezPI0/XJRfWExv3fg4R4R/vG6Ak9k
         7jtOBNyvMY0cFHpoMF5PYr0FT2rUdTw2KufQlYg/3HUm1tP3KOCET8F4aqu/HBVq5KHj
         dx1H7SSFU5TId9c114JTZgnGQ1yoXTyyMK2KloPRDv8DWfBZNPVeiTflsF5P2ZPSwS6C
         QYZLmoi5MiDQRFSP4oaIZ7ESNI5iulb2lzvD5gAHFcwmN6xoy8Nq9Crq8JeRZ1YsXUx4
         AR0Tscz/3yMoTc5gPQlj0VOz6Rf0YKn4DZED7GnwOQTbM+S7Ax0Tvmh4azfNppVPxyRF
         anzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1HsD7mMC2/+jXIC1KTrUHZf1j8ALiE7MIw1gmjGl40A=;
        b=gfYd1sbx7s1Sf5lR/+Agz3weOv9IVvTwjUNHtnqt4Gw2R7wqDCbxOZFn1qnDkjmmyD
         WXfLl5w5E5N4BRc6+9D7NpPYg1eK/2aKZf469/vvSv0x0ou/NC91wA6AtCvRACK162iX
         /zRIyZOVQl4SrXDx4759cKF/v2MhjZJKRTOMteSAh1/wpgdp+hX7wSruuY1T4vDSrMQ6
         WTuoZ5zjLjhAPUD9BA2WEWIJwZjh6ImD9ru8k3l397ICfsRROpGKbgycNE3lrIuZMp7D
         snW63tSBWtBuqBO6TjU2O4UJeZDy6HjyElr+vkTZHE9TcLqTGtud5J/7RmETOXuPSaAq
         6bjw==
X-Gm-Message-State: APjAAAXvwr+AalV+U2SIxO7fk3b21V9LZqSBS7RG7jWIGGcBs0YqMV+c
        CzrbThvukB2uwharXlzPZU6mWg==
X-Google-Smtp-Source: APXvYqwsW4GWGMVH90QBUhpTcFaRZONIzcCLyNvATxpVfZQ7Z5OhiR8ubyp+dN/GEckmgWIL3JrSLQ==
X-Received: by 2002:a05:600c:21d2:: with SMTP id x18mr5186138wmj.112.1558685667530;
        Fri, 24 May 2019 01:14:27 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id q68sm2075477wme.11.2019.05.24.01.14.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 01:14:27 -0700 (PDT)
Date:   Fri, 24 May 2019 10:14:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org
Subject: Re: [patch iproute2 3/3] devlink: implement flash status monitoring
Message-ID: <20190524081426.GC2904@nanopsycho>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <20190523094710.2410-3-jiri@resnulli.us>
 <20190523105703.0f03acc3@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523105703.0f03acc3@cakuba.netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 23, 2019 at 07:57:03PM CEST, jakub.kicinski@netronome.com wrote:
>On Thu, 23 May 2019 11:47:10 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Listen to status notifications coming from kernel during flashing and
>> put them on stdout to inform user about the status.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>> +static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>> +{
>> +	struct cmd_dev_flash_status_ctx *ctx = data;
>> +	struct dl_opts *opts = &ctx->dl->opts;
>> +	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
>> +	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
>> +	const char *component = NULL;
>> +	uint64_t done = 0, total = 0;
>> +	const char *msg = NULL;
>> +	const char *bus_name;
>> +	const char *dev_name;
>> +
>> +	if (genl->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS &&
>> +	    genl->cmd != DEVLINK_CMD_FLASH_UPDATE_END)
>> +		return MNL_CB_STOP;
>> +
>> +	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
>> +	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
>> +		return MNL_CB_ERROR;
>> +	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
>> +	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
>> +	if (strcmp(bus_name, opts->bus_name) ||
>> +	    strcmp(dev_name, opts->dev_name))
>> +		return MNL_CB_ERROR;
>> +
>> +	if (genl->cmd == DEVLINK_CMD_FLASH_UPDATE_END && ctx->not_first) {
>> +		pr_out("\n");
>> +		free(ctx->last_msg);
>> +		free(ctx->last_component);
>> +		ctx->received_end = 1;
>> +		return MNL_CB_STOP;
>> +	}
>
>> +	pid = fork();
>> +	if (pid == -1) {
>> +		close(pipe_r);
>> +		close(pipe_w);
>> +		return -errno;
>> +	} else if (!pid) {
>> +		/* In child, just execute the flash and pass returned
>> +		 * value through pipe once it is done.
>> +		 */
>> +		close(pipe_r);
>> +		err = _mnlg_socket_send(dl->nlg, nlh);
>> +		write(pipe_w, &err, sizeof(err));
>> +		close(pipe_w);
>> +		exit(0);
>> +	}
>> +	close(pipe_w);
>> +
>> +	do {
>> +		err = cmd_dev_flash_fds_process(&ctx, nlg_ntf, pipe_r);
>> +		if (err)
>> +			goto out;
>> +	} while (!ctx.flash_done || !ctx.received_end);
>
>Won't this loop forever if driver never sends
>DEVLINK_CMD_FLASH_UPDATE_END IOW doesn't implement status updates?

Hmm, right. Will look into this and fix.

