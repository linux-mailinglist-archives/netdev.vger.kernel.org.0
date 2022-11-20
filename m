Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3BA631266
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 04:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiKTDRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 22:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKTDRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 22:17:24 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E729B3BF
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 19:17:22 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 62so8274571pgb.13
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 19:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/S8gXMx/tTJzNY1ZVanonDgP/wmJO65aIObncb0L+E=;
        b=D+AfZtpEezfMDDqOHRMA/Me5CT2M9VnGhSDLxpvwMHKBdp9titQrvW285ygwlrhqb7
         FH+aKqmZWUQ+rx5Wb9Uzw2G4qLJdI6ExikAWgj2o1u7yVsEyCVtpSWK5YeDApZQmhKM3
         aiZ6KIHWem9xLPc+sonM+yke36AF6GluFoBsLqDYJVFnNKB/kg2bmjnn+yIQgWHtXoIF
         JntGNeffkcPumzHgZ/FYSCDDMjcI3BGlJV2wP98l13jX4qDxCxU8V4zwp6vJ9NzCnfxg
         K+yKjRlk5zhKYK9LG6/EGrzvOL1b3wWthzJjLDdyUyZMlzPhDdmGumgMt4YJEjxn2kIc
         qDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/S8gXMx/tTJzNY1ZVanonDgP/wmJO65aIObncb0L+E=;
        b=efT7rLCAK2tzhAJhLTCyCDmw8JWDSQ+a3r3rr8xvkbxoQeb8Pq3g4MgueBtnqN5DZ4
         mEjeOSxYL8kaTm4JqSWP3dSdHaHj1V90DZNTXmAqcQBCztaKLfleGZpQSUB585y+Wcq4
         UGrtzR5v4oU7jt26FB/kdUSWYAbGC9WziTyXS6XsyIinxVBAUbh74tMZHona0XmMZxRX
         TM0+e3VAkOMbi3jUw9IRs7eEe5PiaKbbb7sD/G6jnVM7Mhil5qYdVmnnQIEN3KNYX9VM
         uW4QKrZ4iS1jpvQWdKbuKXs/M5P5Rdsr2S9PRJy4OGbfdsUTHvJR2AkPd71fDOPlTKSv
         r/lg==
X-Gm-Message-State: ANoB5pmBfbTpfXb682H0REXZrr8uMYvbB9HzEmA/wdavBErmW9xWQICD
        HpNM0ahQL2SpuDc/J+vM7jw=
X-Google-Smtp-Source: AA0mqf4Bftn56S+MJxWZbHnKwT615Z8WNLND4ELLziLSzQc3iDA8liLyT0uC99+pn+21e7ALbXCHCg==
X-Received: by 2002:a65:5b47:0:b0:477:4eb4:4b6a with SMTP id y7-20020a655b47000000b004774eb44b6amr3884423pgr.531.1668914242223;
        Sat, 19 Nov 2022 19:17:22 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y9-20020a170902b48900b00186f81bb3f0sm6498285plr.122.2022.11.19.19.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 19:17:20 -0800 (PST)
Date:   Sun, 20 Nov 2022 11:17:17 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [Need Help] tls selftest failed
Message-ID: <Y3mcParyv6lpQbnk@Laptop-X1>
References: <Y3c9zMbKsR+tcLHk@Laptop-X1>
 <20221118081309.75cd2ae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118081309.75cd2ae0@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 08:13:09AM -0800, Jakub Kicinski wrote:
> On Fri, 18 Nov 2022 16:09:48 +0800 Hangbin Liu wrote:
> > Hi Jakub,
> > 
> > The RedHat CKI got failures when run the net/tls selftest on net-next 6.1.0-rc4
> > and mainline 6.1.0-rc5 kernel. Here is an example failure[1] with mainline
> > 6.1.0-rc5 kernel[2]. The config link is here[3]. Would you please help
> > check if there is issue with the test? Please tell me if you can't
> > access the URLs, then I will attach the config file.
> 
> Hm, looks like a config problem. CRYPTO_SM4 is not enabled in the
> config, even tho it's listed in tools/testing/selftests/net/config. 
> Maybe it's not the right symbol to list in the test, or there is
> a dependency we missed?

From the build log[1], the CKI will read selftests/net/config and reset
CONFIGs if it is not defined or need redefined. e.g.

```
Value of CONFIG_MPLS_IPTUNNEL is redefined by fragment
./tools/testing/selftests/net/config:
Previous value: CONFIG_MPLS_IPTUNNEL=y
New value: CONFIG_MPLS_IPTUNNEL=m

Value of CONFIG_NET_SCH_INGRESS is redefined by fragment
./tools/testing/selftests/net/config:
Previous value: CONFIG_NET_SCH_INGRESS=y
New value: CONFIG_NET_SCH_INGRESS=m

Value of CONFIG_NET_CLS_FLOWER is redefined by fragment
./tools/testing/selftests/net/config:
Previous value: CONFIG_NET_CLS_FLOWER=y
New value: CONFIG_NET_CLS_FLOWER=m
```

And in the config file[2], all the CONFIGs in selftests/net/config are
set correctly except CONFIG_CRYPTO_SM4. I saw in the config file it shows

# CONFIG_CRYPTO_SM4_GENERIC is not set

Is there any dependence for CONFIG_CRYPTO_SM4?

[1] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/698017956/build%20x86_64%20debug/3340789060/artifacts/build.log
[2]
https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/698017956/build%20x86_64%20debug/3340789060/artifacts/kernel-mainline.kernel.org-redhat_698017956_x86_64_debug.config

Thanks
Hangbin
