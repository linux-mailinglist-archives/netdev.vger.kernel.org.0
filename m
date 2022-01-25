Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E235749B38A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350383AbiAYMOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444538AbiAYMKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:10:55 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7307C061753;
        Tue, 25 Jan 2022 04:09:02 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id e17so3295748ljk.5;
        Tue, 25 Jan 2022 04:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=jYOvh3TluQrcjkgjx/socsMLlC7b20Fo9pmrYGjtKZg=;
        b=e50pbGE8w0eIJVRReXoEZVlQD4WcZK070mmTC4q8/+TTueNm/GMXLNhx9y45Qn7pw4
         3QN+rL4MuXizPS4/DiGvDnLrR2hzhZGpfizBtgxZkXcAVdNaM6ggpYxgV6WcklQczb9x
         fb3nicof9MjMt/YxSlFv4dpx5t23LRTM504/diB50diJnpn0aNkW1pu3pO4zylBw6Aes
         OTJFU28m8O5V9ohzYoFxI4FZNIktw2CKVOkIqeDHvNmbcghbjhGyeGR9TIS/jMuFhlF5
         e2VyU+246N0qkNcHwErKtrUPGOfBbNCxUKcNmuQn+28pH4N5HGEwda9Yt+odv8k+s3jz
         Y4jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jYOvh3TluQrcjkgjx/socsMLlC7b20Fo9pmrYGjtKZg=;
        b=NvRuameHfATFJt4l0oi6w5sFket6Z6eqaEty37yMsaukAMHnHhOKGBYuWWfW7VOdH8
         hHRoPbDE4zfLKo8Fk/vFqafLctzoOzemxnyxiq+C1WS/JqzuDm1+kVU/ycwFQDwSVbbn
         FR7gW24IDPFQOub2iNz6fs6E2QUTEVlSaCwwucjjCl/65eOXBs3yHE7WnpZDjz2+Ka31
         cRxxy0fqPBuIAJ0ufzQpBXnQBcZGAmEKiNmk6bMWwv1pAQDUGFPDqZViyjgUcGO9Hb52
         uSN5Vxu5ZLk4SPTmKlsxs45rfSeQXGWWuLeKxvlAZf55u32aO2Q+XpTr6+YBLWNjYCNp
         3KCw==
X-Gm-Message-State: AOAM5325OSL3f7ut0B19G+V6LaLqgelP1lOg+s7JBheUZkGGfo7XRPtJ
        HXdqtSbYgNiDbH78TH5hiGE=
X-Google-Smtp-Source: ABdhPJwVub3zDKTOB+wjBLNORR7sCU9xt8UfpG/X3/KvRRBcVKHVtkjQDkJBg0tA78MsiLJC2g6uDA==
X-Received: by 2002:a2e:a5c9:: with SMTP id n9mr14649555ljp.220.1643112540915;
        Tue, 25 Jan 2022 04:09:00 -0800 (PST)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id y11sm1168942ljj.122.2022.01.25.04.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 04:09:00 -0800 (PST)
Message-ID: <455f4360-34fe-7fee-66d5-fd945fe1e086@gmail.com>
Date:   Tue, 25 Jan 2022 13:08:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 6/8] nvmem: transformations: ethernet address offset
 support
To:     Michael Walle <michael@walle.cc>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20211228142549.1275412-1-michael@walle.cc>
 <20211228142549.1275412-7-michael@walle.cc>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <20211228142549.1275412-7-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.12.2021 15:25, Michael Walle wrote:
> An nvmem cell might just contain a base MAC address. To generate a
> address of a specific interface, add a transformation to add an offset
> to this base address.
> 
> Add a generic implementation and the first user of it, namely the sl28
> vpd storage.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   drivers/nvmem/transformations.c | 45 +++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/nvmem/transformations.c b/drivers/nvmem/transformations.c
> index 61642a9feefb..15cd26da1f83 100644
> --- a/drivers/nvmem/transformations.c
> +++ b/drivers/nvmem/transformations.c
> @@ -12,7 +12,52 @@ struct nvmem_transformations {
>   	nvmem_cell_post_process_t pp;
>   };
>   
> +/**
> + * nvmem_transform_mac_address_offset() - Add an offset to a mac address cell
> + *
> + * A simple transformation which treats the index argument as an offset and add
> + * it to a mac address. This is useful, if the nvmem cell stores a base
> + * ethernet address.
> + *
> + * @index: nvmem cell index
> + * @data: nvmem data
> + * @bytes: length of the data
> + *
> + * Return: 0 or negative error code on failure.
> + */
> +static int nvmem_transform_mac_address_offset(int index, unsigned int offset,
> +					      void *data, size_t bytes)
> +{
> +	if (bytes != ETH_ALEN)
> +		return -EINVAL;
> +
> +	if (index < 0)
> +		return -EINVAL;
> +
> +	if (!is_valid_ether_addr(data))
> +		return -EINVAL;
> +
> +	eth_addr_add(data, index);
> +
> +	return 0;
> +}
> +
> +static int nvmem_kontron_sl28_vpd_pp(void *priv, const char *id, int index,
> +				     unsigned int offset, void *data,
> +				     size_t bytes)
> +{
> +	if (!id)
> +		return 0;
> +
> +	if (!strcmp(id, "mac-address"))
> +		return nvmem_transform_mac_address_offset(index, offset, data,
> +							  bytes);
> +
> +	return 0;
> +}
> +
>   static const struct nvmem_transformations nvmem_transformations[] = {
> +	{ .compatible = "kontron,sl28-vpd", .pp = nvmem_kontron_sl28_vpd_pp },
>   	{}
>   };

I think it's a rather bad solution that won't scale well at all.

You'll end up with a lot of NVMEM device specific strings and code in a
NVMEM core.

You'll have a lot of duplicated code (many device specific functions
calling e.g. nvmem_transform_mac_address_offset()).

I think it also ignores fact that one NVMEM device can be reused in
multiple platforms / device models using different (e.g. vendor / device
specific) cells.


What if we have:
1. Foo company using "kontron,sl28-vpd" with NVMEM cells:
    a. "mac-address"
    b. "mac-address-2"
    c. "mac-address-3"
2. Bar company using "kontron,sl28-vpd" with NVMEM cell:
    a. "mac-address"

In the first case you don't want any transformation.


If you consider using transformations for ASCII formats too then it
causes another conflict issue. Consider two devices:

1. Foo company device with BIN format of MAC
2. Bar company device with ASCII format of MAC

Both may use exactly the same binding:

partition@0 {
         compatible = "nvmem-cells";
         reg = <0x0 0x100000>;
         label = "bootloader";

         #address-cells = <1>;
         #size-cells = <1>;

         mac-address@100 {
                 reg = <0x100 0x6>;
         };
};

how are you going to handle them with proposed implementation? You can't
support both if you share "nvmem-cells" compatible string.


I think that what can solve those problems is assing "compatible" to
NVMEM cells.

Let me think about details of that possible solution.
