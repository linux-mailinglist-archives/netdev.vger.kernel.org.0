Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A742749E211
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbiA0MJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiA0MJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:09:42 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5BCC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:09:42 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e6so2448302pfc.7
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kh6/IpxMasM5sK+RQE2LXlFptdFPJpwtkiMqWulNBFQ=;
        b=PDYQ7VBIsUEHkjHUAJqrMjKDLRoC7vBqGjcKExYM15lHUlOcYLXs/xnkl1uUkZ/Zt0
         rhIYdxwnCMzjZ+W9vWMSgu8j1Ena1nM2grlw7Cy18tTIXMM4it9NQeZG4x9ZZ+F8fccV
         ybplxMBeegnkYgL25kX0taRXI/+D7w9D/YQ7qfdLNr0IAP5nTeLdyYciV65MMSwoQcN/
         QBAhhox+bcMX1YVQTbJ6TuMPk4U+d+Mx4nnftpjWenSqQbF9haxgnnRKUc8sORTk3odU
         IBLAF7J7yjj/w/VS1I6G29MAb4GcqQb9u2LLdyv5FgIyUTUqZnTUC9kZMVQiDz63o41P
         L7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kh6/IpxMasM5sK+RQE2LXlFptdFPJpwtkiMqWulNBFQ=;
        b=kJjVmN7QVdR7RO2Zz3QTho+iMgVj/0xOIL4a5l8z9R3dnV0+yEIKcXS5tXhDu/baXi
         KePr8LlUI/QkyKHpbN1P3dVgDO9tYA2Ylqz1EYerbKzC0TeAhaLryfHBdETQnsG7Co3J
         f5OC7w4WV7nybQffIypmUbFzbIV0Ay2QKPEQGsZD8H6WvoQNz3FgzLe4RgDqcpFp5sE3
         cn8TUNO7G5REGXTuIvtEbS/DRox6R9FS57/WFaEY6Qol+bbqQXQuKHjyYMWJlRgr3o4t
         BHaOwUTz7737FLIJQs9AYteXQtf2mdrD8Tkw14GHRj4VDwEjU53JjPzz0evLcD/nGBS+
         JbMw==
X-Gm-Message-State: AOAM531BdgiajDyAPjPCzoj0339O+ENpa+7chkUeAdWw1otsdfv7T321
        hXyzjJ+QfC8GydFhe1+X5nKVCWmbWzO2Yb9q
X-Google-Smtp-Source: ABdhPJw+D1cWErTloJjERMPW5g9YXcbpDyrTtpYEu/FX1reLjzQOTkDYT6WxHRXV3XO2aEJu9r0K0A==
X-Received: by 2002:a63:50f:: with SMTP id 15mr2581866pgf.186.1643285382072;
        Thu, 27 Jan 2022 04:09:42 -0800 (PST)
Received: from Laptop-X1 ([103.152.34.77])
        by smtp.gmail.com with ESMTPSA id v20sm4080802pfu.155.2022.01.27.04.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 04:09:41 -0800 (PST)
Date:   Thu, 27 Jan 2022 20:09:36 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC net-next 3/5] bonding: add ip6_addr for bond_opt_value
Message-ID: <YfKLgL6qMDEQTS3Y@Laptop-X1>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
 <20220126073521.1313870-4-liuhangbin@gmail.com>
 <bc3403db-4380-9d84-b507-babdeb929664@nvidia.com>
 <YfJDm4f2xURqz5v8@Laptop-X1>
 <7501da6a-1956-6fcf-d55e-5a06a15eb0e3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7501da6a-1956-6fcf-d55e-5a06a15eb0e3@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 10:56:29AM +0200, Nikolay Aleksandrov wrote:
> You're right in that we shouldn't overload value. My point was that bond_opt_val is supposed to be generic,
> also it wouldn't work as expected for bond_opt_parse(). Perhaps a better solution would be to add a generic
> extra storage field and length and initialize them with a helper that copies the needed bytes there. As for

Not sure if I understand your suggestion correctly. Do you mean add a field
in bond_opt_value like:

#define	MAX_LEN	128

struct bond_opt_value {
        char *string;
        u64 value;
        u32 flags;
        char extra[MAX_LEN];
};

And init it before using?

or define a char *extra and alloc/init the memory when using it?

Thanks
Hangbin

> value in that case you can just set it to 0, since all of this would be used internally the options which
> support this new extra storage would expect it and should error out if it's missing (wrong/zero length).
> Maybe something like:
> static inline void __bond_opt_init(struct bond_opt_value *optval,
> -				   char *string, u64 value)
> +				   char *string, u64 value,
> +				   void *extra, size_t extra_len)
> 
> with sanity and length checks of course, and:
> +#define bond_opt_initextra(optval, extra, len) __bond_opt_init(optval, NULL, 0, extra, len)
> 
> It is similar to your solution, but it can be used by other options to store larger values and
> it uses the value field as indicator that string shouldn't be parsed.
> 
> There are other alternatives like using the bond_opt_val flags to denote what has been set instead
> of using the current struct field checks, but they would cause much more changes that seems
> unnecessary just for this case.
> 
> Cheers,
>  Nik
> 
> 
> 
> 
