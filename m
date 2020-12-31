Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFE52E8137
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 17:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgLaQTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 11:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLaQTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 11:19:35 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3E8C061573;
        Thu, 31 Dec 2020 08:18:54 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id q25so18317232otn.10;
        Thu, 31 Dec 2020 08:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KJaEUkkAN82+qp8E3MGa7L6IXpBsU6/JywsUxir+y0g=;
        b=R47AD1qukruthdXPdekyQCq5vZSwTbFQieQiipzBCrSSjC61ua7t2pInAJo8ijcdWz
         4ylriCQPFCWp4PUzOwYBMexsGxttKrN88TD8LvQc5RdQlhy/WHZwc4Cb76zMQYQjkQHp
         tuc3RVnhPy+i/l0Sx46aBp8Wd0GLnTYDdDXen5nLwqcrsOMIreAHiok8DKNlEQPsiGIS
         A8rY1HmidsmxxZ/cpw2lfXSqIo9TB5cr/kIuydLY0tTx/dk5m5I9ybkLDvfeUGybN0iC
         cc1bjcE9eynYqnQnWQZhh+G7oAnfWoAwRt0EobHe1N5WBh3Nsg/XObdHHvAn6Cu9/vdp
         X6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KJaEUkkAN82+qp8E3MGa7L6IXpBsU6/JywsUxir+y0g=;
        b=NbzSgXPdjTyQe7zdutB6qsuZF3IC45MwQxaZ12fat595xWjBXsSuW0tcEK+503SW7X
         F8aw9ZnA5Dnq5dF1fDQR6KVBRP5aXfDlsOYYfKWu38nJe53KVr/uSSnsg0b81ArW152y
         Q5d+mH/lUw+Ns/DtOZaEK+sGDg9C1p3k91bsK6d5sw7soLYQ6YbcAsSrdeyWpOtcPTfI
         iO/z7CmIPsTDrtGW8YGGz4Kt/sfPrfzyNfBEEkx/OsQRPqxhq61tvhD0k6AYfgy5AdDO
         8fyQwtPMwxMhjsXS3Pijt/v9bdyA17oxaT+HGjQ+EIKi/Pc0nzUBPf9ZR3CM5qE9vXsV
         k1xA==
X-Gm-Message-State: AOAM533MoRLMivcFkxEviRDOgYK+IZk6YUp5raKa2m/nMcrnO/jgAPki
        9JTWK0nG4S9776GqxB2zA1o5tDrGTKU=
X-Google-Smtp-Source: ABdhPJzuBm3GVpHoqAChnXq4M1lVKgjAgjx61YYN6tgeYQgciK/6m1oHsL/qJcpOWjWMVaNAXPF5BQ==
X-Received: by 2002:a05:6830:1aec:: with SMTP id c12mr41328504otd.342.1609431534224;
        Thu, 31 Dec 2020 08:18:54 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:98e1:c150:579a:a69c])
        by smtp.googlemail.com with ESMTPSA id f25sm11094369oou.39.2020.12.31.08.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Dec 2020 08:18:53 -0800 (PST)
Subject: Re: [PATCH iproute2-next] rdma: Add support for the netlink extack
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20201231054217.372274-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8d59994a-0c08-8c62-d23d-da3f74f57af5@gmail.com>
Date:   Thu, 31 Dec 2020 09:18:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201231054217.372274-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/20 10:42 PM, Leon Romanovsky wrote:
> diff --git a/rdma/utils.c b/rdma/utils.c
> index 2a201aa4..927e2107 100644
> --- a/rdma/utils.c
> +++ b/rdma/utils.c
> @@ -664,7 +664,7 @@ void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags)
> 
>  int rd_send_msg(struct rd *rd)
>  {
> -	int ret;
> +	int ret, one;
> 
>  	rd->nl = mnl_socket_open(NETLINK_RDMA);
>  	if (!rd->nl) {
> @@ -672,6 +672,12 @@ int rd_send_msg(struct rd *rd)
>  		return -ENODEV;
>  	}
> 
> +	ret = mnl_socket_setsockopt(rd->nl, NETLINK_EXT_ACK, &one, sizeof(one));
> +	if (ret < 0) {
> +		pr_err("Failed to set socket option with err %d\n", ret);
> +		goto err;
> +	}
> +
>  	ret = mnl_socket_bind(rd->nl, 0, MNL_SOCKET_AUTOPID);
>  	if (ret < 0) {
>  		pr_err("Failed to bind socket with err %d\n", ret);

you should be able to use mnlu_socket_open in ./lib/mnl_utils.c

