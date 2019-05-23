Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B192856E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387413AbfEWR5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:57:10 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37429 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387408AbfEWR5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:57:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id o7so7807096qtp.4
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0QsdWrFy6G1bR/zdjAQdIYm7tWeFBBrR9e0lWuR2F7s=;
        b=LXDkCSfloY2y74+WyGYkc7Z0Wg5NX/aPalNFzojttOPmvsdS/U2ycJ+gpEuliMoOJ2
         h2SqvZFA8kqzQGNVIj5KvQB527cqlgRGtlEjKm2nHnPjWJx7A+uolZ/IBiB/Kxqs2WDJ
         swNLEI+vxjUF8Qg/4Wtksy1HOjHRU0fHztTxF6cT7C0d3V16isJBBQnWi6v7Nmc2gXzm
         jeEtKivvpNVZCI4t3jg0WQR1NA6YyMRK65ZyjggA1Crzy5fbnvGM8hVQXoOktGo+tD9b
         2DzridHG4e5ZZf9pu1+Xu36jSI1WI9qfyXQazbSLy1O6/BQbKCUUB+Ze5QucHqC+AdLK
         M+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0QsdWrFy6G1bR/zdjAQdIYm7tWeFBBrR9e0lWuR2F7s=;
        b=ID0AK09nR0EDwtTOzrhpZ7/2zjh8jkQ2SIzm4fMeIoHkaim6hF6SXfJb5nZvDPEszg
         OZWLfzs5hh73R5loYNW75w7cnOlypJk7hqoK701kHDeuDU7V1r81VmRrLo5bXmV5WdNH
         3QjHvftijmkas+PmrSB7w5lnzqE4fu7FwAbhGhYFMA3rMzWjQXlMYo5qhSDc3nH78KS5
         05sHcigPWown6yBHL0sybpGSSC4CteCkhSCBCMV2whGbl+xFDPCWO+0HEZeBdO84E521
         V+Alf+QmkYZ9kxwT7iPjMTAwHINDePPs/f6WjnbX6QuzGSwj4JCpan048lMZXsD5DhPT
         0ZZw==
X-Gm-Message-State: APjAAAWVih73vYC+qv23CKPM86sCFg2uDHefiN+2g6oDpRgTv3kCBLEY
        SvGwAw/j3QlNnprQuPYFNdcaQQ==
X-Google-Smtp-Source: APXvYqxHZDrbclOjxO12O5EoMfzhsNtsOmEZC3aXLKWK8901PaSJgPL9p+Spgjy8gVzAOT5aCDol1g==
X-Received: by 2002:ac8:16b4:: with SMTP id r49mr74612853qtj.157.1558634229045;
        Thu, 23 May 2019 10:57:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j14sm860qtp.40.2019.05.23.10.57.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 10:57:08 -0700 (PDT)
Date:   Thu, 23 May 2019 10:57:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org
Subject: Re: [patch iproute2 3/3] devlink: implement flash status monitoring
Message-ID: <20190523105703.0f03acc3@cakuba.netronome.com>
In-Reply-To: <20190523094710.2410-3-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
        <20190523094710.2410-3-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 11:47:10 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Listen to status notifications coming from kernel during flashing and
> put them on stdout to inform user about the status.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

> +static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	struct cmd_dev_flash_status_ctx *ctx = data;
> +	struct dl_opts *opts = &ctx->dl->opts;
> +	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
> +	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
> +	const char *component = NULL;
> +	uint64_t done = 0, total = 0;
> +	const char *msg = NULL;
> +	const char *bus_name;
> +	const char *dev_name;
> +
> +	if (genl->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS &&
> +	    genl->cmd != DEVLINK_CMD_FLASH_UPDATE_END)
> +		return MNL_CB_STOP;
> +
> +	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
> +	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
> +		return MNL_CB_ERROR;
> +	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
> +	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
> +	if (strcmp(bus_name, opts->bus_name) ||
> +	    strcmp(dev_name, opts->dev_name))
> +		return MNL_CB_ERROR;
> +
> +	if (genl->cmd == DEVLINK_CMD_FLASH_UPDATE_END && ctx->not_first) {
> +		pr_out("\n");
> +		free(ctx->last_msg);
> +		free(ctx->last_component);
> +		ctx->received_end = 1;
> +		return MNL_CB_STOP;
> +	}

> +	pid = fork();
> +	if (pid == -1) {
> +		close(pipe_r);
> +		close(pipe_w);
> +		return -errno;
> +	} else if (!pid) {
> +		/* In child, just execute the flash and pass returned
> +		 * value through pipe once it is done.
> +		 */
> +		close(pipe_r);
> +		err = _mnlg_socket_send(dl->nlg, nlh);
> +		write(pipe_w, &err, sizeof(err));
> +		close(pipe_w);
> +		exit(0);
> +	}
> +	close(pipe_w);
> +
> +	do {
> +		err = cmd_dev_flash_fds_process(&ctx, nlg_ntf, pipe_r);
> +		if (err)
> +			goto out;
> +	} while (!ctx.flash_done || !ctx.received_end);

Won't this loop forever if driver never sends
DEVLINK_CMD_FLASH_UPDATE_END IOW doesn't implement status updates?
