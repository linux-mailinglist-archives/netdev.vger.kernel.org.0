Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2205A5F065E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 10:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiI3IZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 04:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiI3IZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 04:25:11 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CB911F12E
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 01:25:05 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dv25so7485448ejb.12
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 01:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=r2bKUsIZ4GrOXKpkzuoeGpQTTdhXOqkqlzFKr5ay91g=;
        b=cHVqERCy2Tp3NTjdJCtr993xTHNz++rf2nwASo6FJsRrI7dJqI/mx5gyZLTi6T5nVR
         ujCtlxUO2vqrqWbt+90FlSkzvVuWS6FR9wudEADuBAM48NPbS3x/BV0W8LCaCI3Rco+l
         TESRzmKpKMkChOY4QJkWoJiXgv3es6yZMUn5k1iEYCRahjCXNCf7RCcjb91GPeFLRNII
         jqNDNviE/UI8Sn70Xcj/euFX8FopeDYxHOHuBXUpWZOSde1xdPUrq0BsH0SVhZSMLeUL
         KEK3hreyuCQvEzfHhKo6rYrqOiFW5TwaYAqlGrQCStNpS5fc9hOEl1Sh5+gDi8BTaOZv
         QYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=r2bKUsIZ4GrOXKpkzuoeGpQTTdhXOqkqlzFKr5ay91g=;
        b=u4IRwoUz5US+/4nKyeUOGKBNhu4sz0ohUD6LGf53uuTD5whtgPYBfBJgc4FgfPilyb
         PoU7Y9YYUyopS8AfVaPNj3T26plprfmlNSYF2vUesFWzkIqo7iLLP9GqW3N8oyPue+tl
         lCreDOeEnC2uTTt7jel69n+G9eojPfs0g58CPV60AEA+S42PqRnENgkw4ongbkV9i5xz
         mX4LF5kmAMs8PtUqWInIEyLvuAu/3k1FXOhHld/CEsZ9GMIZZnbcz+1JHt4a0qaeo5V/
         hS3DK7F1KiSh2GPvNpa6BPnOPnIpzO8NktYdo6sxbnFbvACQBe7kZ5GpTZkJV6kPK4td
         3MGw==
X-Gm-Message-State: ACrzQf3dhBMX4HZUBDJkuw6sexWYK/LCmkYVIxEl5aCUtzoIQgBSzLt/
        M3+ssxp3OhinWGYOhRJHIOe+Qg==
X-Google-Smtp-Source: AMsMyM5Di4H55h+Zi/UpTbRR3jZXK4qZs/eAJOoYTg8JhBvD8K+Jh7dMR8leRA+XVkYFYHG17d9jQQ==
X-Received: by 2002:a17:907:9715:b0:787:751a:90a4 with SMTP id jg21-20020a170907971500b00787751a90a4mr5656176ejc.279.1664526303708;
        Fri, 30 Sep 2022 01:25:03 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y15-20020aa7c24f000000b00457b5ba968csm1278233edo.27.2022.09.30.01.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 01:25:02 -0700 (PDT)
Date:   Fri, 30 Sep 2022 10:25:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <Yzan3ZgAw3ImHfeK@nanopsycho>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch>
 <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch>
 <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzWxV/eqD2UF8GHt@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 29, 2022 at 04:53:11PM CEST, andrew@lunn.ch wrote:
>On Thu, Sep 29, 2022 at 07:12:09AM -0700, Jakub Kicinski wrote:
>> On Thu, 29 Sep 2022 14:28:13 +0200 Andrew Lunn wrote:
>> > If we want to make the PHY a component of an existing devlink for a
>> > MAC, we somehow have to find that devlink instance. A PHY is probably
>> > a property of a port, so we can call netdev_to_devlink_port(), which
>> > gives us a way into devlink.
>> > 
>> > However, the majority of MAC drivers don't have a devlink
>> > instance. What do we do then? Have phylib create the devlink instance
>> > for the MAC driver? That seems very wrong.
>> > 
>> > Which is why i was thinking the PHY should have its own devlink
>> > instance.
>> 
>> Tricky stuff, how would you expose the topology of the system to 
>> the user? My initial direction would also be component. Although 
>> it may be weird if MAC has a way to flash "all" components in one go,
>> and that did not flash the PHY :S
>
>~/linux/drivers/net$ grep -r PHYLIB | wc
>    114     394    4791
>
>~/linux/drivers/net$ grep -r NET_DEVLINK | wc
>     20      60     945
>
>And, of those 20 using DEVLINK, only 4 appear to use PHYLIB.
>
>> Either way I don't think we can avoid MACs having a devlink instance
>> because there needs to be some form of topology formed.
>
>In the past, we have tried to make PHYLIB features just work, without
>MAC changes. It does not scale otherwise. Cable testing just works if
>the PHY supports it, without the MAC driver being changed. PHY stats
>work without MAC changes. PHY based PTP works without MAC changes, SFP
>module EEPROM dumping works without MAC changes. Why should PHY
>firmware upgrade need MAC changes? The MAC does not even care. All it
>should see is that the link is down while the upgrade happens.
>
>Maybe devlink is the wrong interface, if it is going to force us to
>make MAC changes for most devices to actual make use of this PHY
>feature.

Yeah, I tend to agree here. I believe that phylib should probably find a
separate way to to the flash.

But perhaps it could be a non-user-facing flash. I mean, what if phylib
has internal routine to:
1) do query phy fw version
2) load a fw bin related for this phy (easy phy driver may provide the
				       path/name of the file)
3) flash if there is a newer version available

I'm not saying this is complete solution, but it could be first step and
perhaps sufficient. For example, this pattern works for ordinary mlxsw
user who just updates the kernel/linux-firmware parkages - the driver
does flashing implicitly during init when never version is found.


