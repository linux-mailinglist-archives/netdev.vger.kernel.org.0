Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B9950CE00
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 01:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiDWXDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 19:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiDWXDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 19:03:16 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647CE53738
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 16:00:17 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id m20so2142540ejj.10
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 16:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3QBd2G2aZjvPIlQVfUzMKqliUmMW6oCJslRCFwoaxhI=;
        b=Eqm+jTY3bs4ULYM0nOB03k10+Svn4xVtLKpFDd5SWUqcchNFjgq7KsG7lWlFnNqIQD
         j9XggUsvD9cQtLuC+DnTYWVASpPtq+y9R+7ssAQkN4k0AGSZyqpDXL9VnvDjq+RNL4r9
         lLEZv8DC4yXRKazGRD7QiSKVNxWAKRa8PO6kO0oaGLtayij+rCnJT5wqgn27JD2wTIk0
         6WY0Vgai3P8bk3dluV1y5vh0+uIyoLD3OX7svnNb9xJYBzmx6VUhUCH2ly520IzTPqUW
         +j1C2JTPH0GcPnG6B4KyBG8osRH5FJN2A3zb3mQV0v3BKlbzfBDArWWCbp76KJ1jSQCI
         JPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3QBd2G2aZjvPIlQVfUzMKqliUmMW6oCJslRCFwoaxhI=;
        b=PI6SL3zL0T7p4t/n5mYaysSjKHLTWpqiu+Bg65I5yaXJQD1m40BM3h17+mj63K1fxJ
         Ux17wGIek02BSjP3Y30TQhqIY91PqXBo5IqaPk0f8diAPvG0jSHF0UGgJRFdbyuogA9s
         Uk7xI+ILMtcoEsNyU6/AHYhonvbqSTiiw0n0X9i2/6mV45DiyVpqB0olkFWjGZylnVe1
         PRotgKouTH9uIk0sZIv9mrMiowD0WyQICKwJ4+Y4mSFXZexJ6OtZi3XpItHa459B5T8S
         JjBUXkxe48VQGsjDR13IY87SF59rGn5TaDqPbWeP+xSrXPMTUCIuE77M4eZ8V6I8vCo4
         QnjA==
X-Gm-Message-State: AOAM531Kct0lM5Wl6QFYYcRapNP0RUkkSQFzXKD7YDynIRw196n+slId
        +X1OAnvdOV/C96Mp2C6ZPxXN7w==
X-Google-Smtp-Source: ABdhPJzpB3Vf2L4wPFGrVsJfpBQ2OLcpKxuPQCSeeVgK1GHdiRzef5uzC4teMJQgd6OJS3bM0GfNKg==
X-Received: by 2002:a17:907:c29:b0:6f3:8d26:c330 with SMTP id ga41-20020a1709070c2900b006f38d26c330mr27075ejc.215.1650754815797;
        Sat, 23 Apr 2022 16:00:15 -0700 (PDT)
Received: from [192.168.0.117] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id fy29-20020a1709069f1d00b006e8d248fc2csm2047005ejc.108.2022.04.23.16.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 16:00:15 -0700 (PDT)
Message-ID: <0d3b9da5-3f26-a1a1-1bde-9b6332e6e8f2@blackwall.org>
Date:   Sun, 24 Apr 2022 02:00:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v2 1/2] rtnetlink: add extack support in fdb del
 handlers
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com,
        roopa.prabhu@gmail.com, jdenham@redhat.com, sbrivio@redhat.com
References: <cover.1650754228.git.eng.alaamohamedsoliman.am@gmail.com>
 <6a77eca533b7048b85bf0ffe0c3904d36045c320.1650754231.git.eng.alaamohamedsoliman.am@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <6a77eca533b7048b85bf0ffe0c3904d36045c320.1650754231.git.eng.alaamohamedsoliman.am@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/22 01:54, Alaa Mohamed wrote:
> Add extack support to .ndo_fdb_del in netdevice.h and
> all related methods.
> 
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---

Please CC all patch-related maintainers next time. One comment below.

>   drivers/net/ethernet/intel/ice/ice_main.c        | 3 +--
>   drivers/net/ethernet/mscc/ocelot_net.c           | 4 ++--
>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
>   drivers/net/macvlan.c                            | 2 +-
>   drivers/net/vxlan/vxlan_core.c                   | 2 +-
>   include/linux/netdevice.h                        | 2 +-
>   net/bridge/br_fdb.c                              | 2 +-
>   net/bridge/br_private.h                          | 2 +-
>   net/core/rtnetlink.c                             | 4 ++--
>   9 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index d768925785ca..5f9cb4830956 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -5678,10 +5678,9 @@ ice_fdb_add(struct ndmsg *ndm, struct nlattr __always_unused *tb[],
>   static int
>   ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
>   	    struct net_device *dev, const unsigned char *addr,
> -	    __always_unused u16 vid)
> +	    __always_unused u16 vid, struct netlink_ext_ack *extack)
>   {
>   	int err;
> -

I don't think you should remove this new line.

>   	if (ndm->ndm_state & NUD_PERMANENT) {
>   		netdev_err(dev, "FDB only supports static addresses\n");
>   		return -EINVAL;
