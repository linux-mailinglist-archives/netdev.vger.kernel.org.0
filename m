Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA7428035D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbgJAP6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732119AbgJAP6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:58:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA90EC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 08:58:44 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so6428740wrm.2
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 08:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6cYK+RtjQ+W5rEmU2HGzzVDLSsh+K9fVGR7NF7mO73Q=;
        b=TnN7pmaI3FPSKr7fVQPgjjyoyqWMcvheFVsn8W1VAUO7e4qnPTUt5X1c0vIsFFfiks
         Y4MlGteo1B6w98aNh59IZo4EAaVNu1PhWQ1wrf/se6gak4Rux3UaMQQmWBhk6rGrszf7
         f01hRWaZ0gP0tWbMCBhaaQgRQ+blwktd/UqxQbVwEZL/E/eNm5krSiVVHmNceHr15Dye
         ZCnGiGouEVNq3B0BLfLETf0UivQ9SosluxLVvLE2X8J5pfEch43p03NzOHZralwY3wci
         KE7aMwD8Xe6EScL4yl7dfBmxNXX3G7GB2PcLkDP9nGnlIrJCjU5tI2rNlsgSRSTryLJX
         JE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6cYK+RtjQ+W5rEmU2HGzzVDLSsh+K9fVGR7NF7mO73Q=;
        b=SC5F2+HyMDBBtwwE9PCTPzi7UA3T/SvOoIZk8M3MwraXINAFKdBbnFEajDBP1SF2eX
         5zufHF6sgbZNrjrvtl7TU4kRAovp4kBhdb6Cb6FnmUFgIxCID4uCntPD3jOhRGMy05/J
         oYaPEahwfHuLO703TneQ+B2skKQEvbCyJnHlUiUDG+WWgueeUGDiGdMNmSQvWm4BbdvI
         EXLtcYpRe60NTc3dROGF5Pu4fqNgndUW9sCvzq9USnZVg6noNAxZcSDDeezIkbFvoOnQ
         zdyGoTiYInGYshlBVF0WqVNBwX/XoikePsd0T0ue935HOFI1c8W5yplNnxieTMrWcyFL
         XcYw==
X-Gm-Message-State: AOAM533/1Pg7X9LEMeTgEjwHMUkZVxvyT702xo8gah9Y+A6SQKiiPfh7
        iB+vUvZanJ5f4BBtsOohTddTy10L/KhPag==
X-Google-Smtp-Source: ABdhPJzSiGcDDQ5ZPZ+w+jT/GH/FtzQx+Ef6BQyEqiwgy/lbaxnfTPxVgMx4vmFZ118zXjZ50spqOQ==
X-Received: by 2002:a5d:4cc1:: with SMTP id c1mr9857037wrt.122.1601567921954;
        Thu, 01 Oct 2020 08:58:41 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:65ff:4b3c:809e:8987? ([2a01:e0a:410:bb00:65ff:4b3c:809e:8987])
        by smtp.gmail.com with ESMTPSA id e18sm10860609wra.36.2020.10.01.08.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 08:58:41 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 08/12] ipv6: advertise IFLA_LINK_NETNSID when dumping
 ipv6 addresses
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
References: <cover.1600770261.git.sd@queasysnail.net>
 <00ecfc1804b58d8dbb23b8a6e7e5c0646f0100e1.1600770261.git.sd@queasysnail.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <40925424-06ff-c0c5-0456-c7a9d58dff91@6wind.com>
Date:   Thu, 1 Oct 2020 17:58:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00ecfc1804b58d8dbb23b8a6e7e5c0646f0100e1.1600770261.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 01/10/2020 à 09:59, Sabrina Dubroca a écrit :
> Currently, we're not advertising link-netnsid when dumping IPv6
> addresses, so the "ip -6 addr" command will not correctly interpret
> the value of the IFLA_LINK attribute.
> 
> For example, we'll get:
>     9: macvlan0@macvlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
>         <snip>
> 
> Instead of:
>     9: macvlan0@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000 link-netns main
>         <snip>
> 
> ndisc_ifinfo_sysctl_change calls inet6_fill_ifinfo without rcu or
> rtnl, so I'm adding rcu_read_lock around rtnl_fill_link_netnsid.
I don't think this is needed.
ndisc_ifinfo_sysctl_change() takes a reference on the idev (with in6_dev_get(dev)).
