Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928B742FF44
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 01:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhJOX6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 19:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhJOX6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 19:58:35 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCB7C061570;
        Fri, 15 Oct 2021 16:56:28 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id q129so15402971oib.0;
        Fri, 15 Oct 2021 16:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7cuQKyRo8VwWnrKSZqEjby++qEMEDn98shw21ePswis=;
        b=DTAlrs5lawIcHNKMkDsVFpsUnbe/RApPndHoGvA4uMu8Bd0+h05InLaOreTm9qoPp8
         Gsz7n5r4009xFEnw7Nc8j5c3ulsd89xTQLObrxQ6bSo23FYp/Ewq8HN4z7qC/LlSowk0
         OgAIo0hu/haakwrin2XoDtzZOAUFbTg9FFiLcijalh/vWzsBBz2n6kEdFrtc6aXY2cOX
         s+LVFKLNdQKPXGvz2rkXMFaauPManGtK0ggHLbt48etYsRcG0ZK1Ew7yRp9NsLxPVIvL
         L2JQ2GwvS9a5yr1c8G7lAlfgowpqsyyIm/gxAkpIjLvijzR8NRMZOW+JN5IC2MUxsgJS
         Oxzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7cuQKyRo8VwWnrKSZqEjby++qEMEDn98shw21ePswis=;
        b=i3DOIJnOLz+Ko1IfLJj0kHJKvQKJTZNh0XmAhY0nkDuOQmV/iMrYbyB4z2Y0mic+60
         +t5rMvA5oRq7xb8CuALXRpFcaakp8U6odfT+x+KxMzaMh+Cy2UpHyhrrQwdwfLKsf8IY
         zqZ0O77kJoxKvVRGC81U1GRTJ3aIdD8j01QqUyW+LjvrWYeTpx7O1XeZZTKyg1loZE84
         wMXFokpez7H5WQkehMEQPuxNuxEAr3bF4nNYUNdUDkC4dC65nOVPjtXjwUjln7gES2cp
         OC6gOdDAALI6gXxEps5+CjOom3ZHwwUy/9WUlSDyFd5ntraKMR9byvOCKVKypP81YHT/
         JCvQ==
X-Gm-Message-State: AOAM530BME3B6eZxpOU1qBqgo+zIW8lJid62b1izABSNl7Ia1TUMNanY
        VBzU3rPe9Ua2Vxruij66AEFPhYU7XsBbkA==
X-Google-Smtp-Source: ABdhPJzP8XCGDMiZ2DvlGAjvtaHS7914IxZVLdV88hxxy+wmUMHk+1O6jCOUKtQ4hROfPYB1cgeHSg==
X-Received: by 2002:aca:3bd7:: with SMTP id i206mr10557473oia.166.1634342187455;
        Fri, 15 Oct 2021 16:56:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id w2sm1278923ooa.26.2021.10.15.16.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 16:56:26 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 2/3] rdma: Add stat "mode" support
To:     Mark Zhang <markzhang@nvidia.com>, jgg@nvidia.com,
        dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        aharonl@nvidia.com, netao@nvidia.com, leonro@nvidia.com
References: <20211014075358.239708-1-markzhang@nvidia.com>
 <20211014075358.239708-3-markzhang@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a01a1b0e-90a4-c14f-fa5f-35a698d5b730@gmail.com>
Date:   Fri, 15 Oct 2021 17:56:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211014075358.239708-3-markzhang@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 1:53 AM, Mark Zhang wrote:
> +static int do_stat_mode_parse_cb(const struct nlmsghdr *nlh, void *data,
> +				 bool supported)
> +{
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
> +	struct nlattr *nla_entry;
> +	const char *dev, *name;
> +	struct rd *rd = data;
> +	int enabled, err = 0;
> +	bool isfirst = true;
> +	uint32_t port;
> +
> +	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
> +	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] ||
> +	    !tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS])
> +		return MNL_CB_ERROR;
> +
> +	dev = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
> +	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +
> +	mnl_attr_for_each_nested(nla_entry,
> +				 tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
> +		struct nlattr *cnt[RDMA_NLDEV_ATTR_MAX] = {};
> +
> +		err  = mnl_attr_parse_nested(nla_entry, rd_attr_cb, cnt);
> +		if ((err != MNL_CB_OK) ||
> +		    (!cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]))
> +			return -EINVAL;
> +
> +		if (!cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> +			continue;
> +
> +		enabled = mnl_attr_get_u8(cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC]);
> +		name = mnl_attr_get_str(cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
> +		if (supported || enabled) {
> +			if (isfirst) {
> +				open_json_object(NULL);

I don't see the close_json_object(). Did you verify json output is proper?


> +				print_color_string(PRINT_ANY, COLOR_NONE,
> +						   "ifname", "link %s/", dev);
> +				print_color_uint(PRINT_ANY, COLOR_NONE, "port",
> +						 "%u ", port);
> +				if (supported)
> +					open_json_array(PRINT_ANY,
> +						"supported optional-counters");
> +				else
> +					open_json_array(PRINT_ANY,
> +							"optional-counters");
> +				print_color_string(PRINT_FP, COLOR_NONE, NULL,
> +						   " ", NULL);
> +				isfirst = false;
> +			} else {
> +				print_color_string(PRINT_FP, COLOR_NONE, NULL,
> +						   ",", NULL);
> +			}
> +			if (rd->pretty_output && !rd->json_output)
> +				newline_indent(rd);
> +
> +			print_color_string(PRINT_ANY, COLOR_NONE, NULL, "%s",
> +					   name);
> +		}
> +	}
> +
> +	if (!isfirst) {
> +		close_json_array(PRINT_JSON, NULL);
> +		newline(rd);
> +	}
> +
> +	return 0;
> +}
> +


