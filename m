Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EA421C676
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgGKVhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 17:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgGKVhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:37:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E01FC08C5DD;
        Sat, 11 Jul 2020 14:37:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u185so4174651pfu.1;
        Sat, 11 Jul 2020 14:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qm2wNoh2ZwDRe8Xutxhio/yXQ/HlmLrg9sgqZkA5oDA=;
        b=mY+O8/QFYXG7FzWPSyOC4kzFsY14IRyJCRs+z2UXtt6tA+UCtkFYZcYLodWyBbxPMM
         iYcBW35KDo6mGRy1VmWZnHMGiNxfmySwYXK+if1wTpDctesex4vj+NxfHctvcsM27FNp
         Ln4MBkK1SdCRSWct5Kly1TM8TqAvcmsI33RhD4iYT084/uFoP8yaPrLD5tUhK8p6H6XL
         2v4TFIku6GWXSbieMWTC2t3PHaVxTBzapnczs+wj/QIyyX6DrLg6bEm65xwLf73XOdAp
         mMU/KZ5rI40PmZGQJDUtC6yVJd9Y4NQQjfdAFUqKhn4l0aIJ9FUxxDJd3TQ3nU5VBxl8
         vzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qm2wNoh2ZwDRe8Xutxhio/yXQ/HlmLrg9sgqZkA5oDA=;
        b=HxzOhK5CFUt4iqGNZGH+9gJlH8IuHPxf3VhIiK9sRaIDPWD8VdKKkrCqwgJBh399jJ
         q+J9VCS0UlpuDoUqknItIF9edCWOpMGHMjc1SY82XW6BcunoSH9zkpSFUasm+1cHgfiC
         yuYNmwfbnAbhM/EBqbdMHpttk4iTcmp9iBy7zPcRxdFrXixb78Xvm1JrjRnkzBfFvwx8
         cQW50icmNRU/4uXXiYHuM0+yX2e2LY4zLKjHo6oOg8Hjs9SMBjlEuw+zkSQQ16WlCAZz
         l1ei7vQblNyEcAEGiR80RG0D8aS3zUQjBQchYK3oSWnlOLnHi1xeTD0vVbtveifK1zRU
         fx/A==
X-Gm-Message-State: AOAM531/nf7LK2pU+aTkADScXMc0/F81qZ9LdtGIDfmbpvAVAIAv8IeG
        /U0BOpsFUIOpoDNyVpBScGo0dhaJ
X-Google-Smtp-Source: ABdhPJycGrtXMBAQGklx+bHeRdnvXCozCUrkiyCPKx99pieTuSaY7m7IiXSTyd+rKRE/bFiXlYFNrQ==
X-Received: by 2002:a63:4b4e:: with SMTP id k14mr61841937pgl.75.1594503472393;
        Sat, 11 Jul 2020 14:37:52 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:108c:a2dd:75d1:a903? ([2001:470:67:5b9:108c:a2dd:75d1:a903])
        by smtp.gmail.com with ESMTPSA id b24sm9460197pgn.8.2020.07.11.14.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 14:37:51 -0700 (PDT)
Subject: Re: [net-next PATCH v6 5/6] phylink: introduce
 phylink_fwnode_phy_connect()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
 <20200711065600.9448-6-calvin.johnson@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <998d1566-ede8-88f4-6c80-cda0c10ca7bf@gmail.com>
Date:   Sat, 11 Jul 2020 14:37:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711065600.9448-6-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 11:55 PM, Calvin Johnson wrote:
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> ---

[snip]

> +int phylink_fwnode_phy_connect(struct phylink *pl,
> +			       struct fwnode_handle *fwnode,
> +			       u32 flags)
> +{
> +	struct phy_device *phy_dev;
> +
> +	if (is_of_node(fwnode))
> +		return phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
> +	if (is_acpi_device_node(fwnode)) {
> +		phy_dev = phy_find_by_mdio_handle(fwnode);
> +		if (!phy_dev)
> +			return -ENODEV;

Please also assign dev_flags to the phy_dev for symmetry with the
phylink_of_phy_connect() function:

		phy_dev->dev_flags |= flags;

With that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
