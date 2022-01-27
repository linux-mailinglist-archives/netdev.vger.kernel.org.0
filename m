Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3718449DB21
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbiA0HC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiA0HC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:02:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2D0C061714
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:02:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so920582pjq.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mtyc21uEydxdbnZSH3l/1jGZ2eHsrD6jKs13sK11Qnc=;
        b=Ii9XoRHj5dXSedsF0hUukZEVGwCoFKkSGBQ3t5xglIRtMuacTUB2QF/rz2d3o5D1w8
         blun+WHHZSgasnXKZxRD7y0Ko3LyEG+CSP7vM3rVutpn++DVV+0vExSDc6Wy7cOY0MEk
         UsaM3atODS/p7mupizoYjV9sctcjG0oROzXhi7Ts5JhhTIWrZvrCg8VReakzT5cbgByv
         RZ15KTdYPUiXltlIVAkQM3SUsGKEVe25WuZXlqDj38B340KE43KjVjqSm6I+fFFwo5Nh
         oVhbkfGllW1sASzL2nd4pzAassLkvjaSjT4WPp1MUdu2t/cji5yclyh1rHnFK+kjpc9+
         sVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mtyc21uEydxdbnZSH3l/1jGZ2eHsrD6jKs13sK11Qnc=;
        b=EqxSfDric7no5t54ThO7zHbqMCjXrJ/F0am2Olnv7ig2bcrGYMPFmCakDwcikImNd9
         iaVud4JC9ARQr56W1ItfxQXzOfRQmEk+A7T+BX4axTVuZ/BzWq4ViL3YtIhOliN9Ron8
         kxbUwgJe/9gsj56AoDb/yzEHhR1TxiAvvvBuoMijZySyB6USsK4r1Gwl2tRB3om/E1H0
         eWPe8DFbdrAirfWb/OBErcS6WU8zozHWLe+2xkaqd64plvf6WJcEqe+hIXKHdmTZpXwc
         see88sdxCaYbJ11pRy59V+54i0y8vB0iEm0VpLqWTem0QpkOiMj2UKYZi293kIiXOz1U
         RqFQ==
X-Gm-Message-State: AOAM533cQMAiY+kBQUz22jTWv2dm7vtubE/Aa9nJl6QkDJCR3l9zWh6y
        +CWySAXE1wvQhO8raGsTCA0=
X-Google-Smtp-Source: ABdhPJzooqCYphdTi1AHm9rU2QYNeGjMRFcnzu4g/X0coV5eaKqUmHRo8/K2RLXZqSKXluqGIZOYkA==
X-Received: by 2002:a17:90a:8b06:: with SMTP id y6mr2853325pjn.214.1643266977846;
        Wed, 26 Jan 2022 23:02:57 -0800 (PST)
Received: from Laptop-X1 ([8.218.112.33])
        by smtp.gmail.com with ESMTPSA id f2sm4242614pfj.6.2022.01.26.23.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:02:56 -0800 (PST)
Date:   Thu, 27 Jan 2022 15:02:51 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC net-next 3/5] bonding: add ip6_addr for bond_opt_value
Message-ID: <YfJDm4f2xURqz5v8@Laptop-X1>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
 <20220126073521.1313870-4-liuhangbin@gmail.com>
 <bc3403db-4380-9d84-b507-babdeb929664@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc3403db-4380-9d84-b507-babdeb929664@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 01:35:46PM +0200, Nikolay Aleksandrov wrote:
> > diff --git a/include/net/bond_options.h b/include/net/bond_options.h
> > index dd75c071f67e..a9e68e88ff73 100644
> > --- a/include/net/bond_options.h
> > +++ b/include/net/bond_options.h
> > @@ -79,6 +79,7 @@ struct bond_opt_value {
> >  	char *string;
> >  	u64 value;
> >  	u32 flags;
> > +	struct in6_addr ip6_addr;
> >  };
> >  
> >  struct bonding;
> > @@ -118,17 +119,20 @@ const struct bond_opt_value *bond_opt_get_val(unsigned int option, u64 val);
> >   * When value is ULLONG_MAX then string will be used.
> >   */
> >  static inline void __bond_opt_init(struct bond_opt_value *optval,
> > -				   char *string, u64 value)
> > +				   char *string, u64 value, struct in6_addr *addr)
> >  {
> >  	memset(optval, 0, sizeof(*optval));
> >  	optval->value = ULLONG_MAX;
> > -	if (value == ULLONG_MAX)
> > +	if (string)
> >  		optval->string = string;
> > +	else if (addr)
> > +		optval->ip6_addr = *addr;
> >  	else
> >  		optval->value = value;
> >  }
> > -#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value)
> > -#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX)
> > +#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL)
> > +#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL)
> > +#define bond_opt_initaddr(optval, addr) __bond_opt_init(optval, NULL, ULLONG_MAX, addr)
> >  
> >  void bond_option_arp_ip_targets_clear(struct bonding *bond);
> >  
> 
> Please don't add arbitrary fields to struct bond_opt_value. As the comment above it states:
> /* This structure is used for storing option values and for passing option
>  * values when changing an option. The logic when used as an arg is as follows:
>  * - if string != NULL -> parse it, if the opt is RAW type then return it, else
>  *   return the parse result
>  * - if string == NULL -> parse value
>  */
> 
> You can use an anonymous union to extend value's size and use the extra room for storage
> only, that should keep most of the current logic intact.

Hi Nikolay,

The current checking for string is (value == ULLONG_MAX). If we use
a union for IPv6 address and value, what about the address like

ffff:ffff:ffff:ffff::/64?

Thanks
Hangbin
