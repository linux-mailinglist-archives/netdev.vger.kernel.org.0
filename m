Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3F36E040
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 22:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbhD1Uam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 16:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhD1Ual (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 16:30:41 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BAFC06138A;
        Wed, 28 Apr 2021 13:29:54 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id r3so10917737oic.1;
        Wed, 28 Apr 2021 13:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tGQaGaHwtMEsGBsvTpG/LEWMQ/8sDbHoSj+JOzCRLas=;
        b=FySiKbeLJyA4fvNRGfHBfMQpZxib7gTtzEGpQNDB3bz7T1I8fuGkkaDnuPFdKI5+ny
         K4Ptr64TZojEEJvwbW1WQ9L4dUBwGtzk4ZwXfFcHqyEfdnNmT9WYMPZq4HXC7eJnzYqp
         2Kvn2CRjNrPAuTpmazT8cCCNfNpaXSncbBZCZj6950x06c4Oa0IZfIHmNkyPVQlS1Hvg
         TDtyP4fa5r8PhrpQdLqrHFx8vB2fGgfLr7GTthw7qWPcrTbYsqAmimNOFqBg4uJt27Ht
         1/nulyyULfBu8oQh/b0I7o/lNXh1b5iJCd0vMtpgW10jyQgBf5s2ijF/joyfHQQj9up9
         gG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tGQaGaHwtMEsGBsvTpG/LEWMQ/8sDbHoSj+JOzCRLas=;
        b=fw9V3lgB8YF6n6sS+jlKGCubPPjyylWXYFTCjpUHF5ZHwIAoAFyGW2YLYZoWPRWQZ2
         GuX5WVWJ/jofdiQKDgSRV7KpA1QWDHjPn0mzt93PFihFK7QihJXi6bs7Kj78i6qlVhpT
         I7A/Zu9hXwk3KOdSpN7Ag5uziuHb9ji1BOMmtCRNktQbJf0xPjPItgm8lok9UEGJHkM7
         PjZPopRUOfSwKvvJRBMc3xw9iP4Ky1MDLaLw6HM9vitBcT7U5Id/IuuRHYPMB1fRNoy1
         UL8G4ueQv47ILzBtDh4h+8b9guwGrERDLJSc23fEoo0VvTf9C5iTl4Evt3IeYJb1elU6
         S94A==
X-Gm-Message-State: AOAM5333Qpq3adC5bFtTU+/VB9mu+mvqZg7jcJuauZWZxxAsVm893Owp
        45IwYgrfCO6RwUsBaksYJoI=
X-Google-Smtp-Source: ABdhPJxLbFzmwTwVKe1AFcOhbz/anbtcjO6QbYay1vp2NvlS8lsgoXE3mgjCCHRnlSK9OICdeWZ3LA==
X-Received: by 2002:a05:6808:b3b:: with SMTP id t27mr4321817oij.50.1619641792296;
        Wed, 28 Apr 2021 13:29:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id j5sm226021oor.28.2021.04.28.13.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 13:29:51 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 3/3] selftests/net/forwarding: configurable
 seed tests
To:     Ido Schimmel <idosch@idosch.org>,
        Pavel Balaev <balaevpa@infotecs.ru>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
References: <YIlWbxO+AFZAFww7@rnd> <YImPN7C/5BXRv6uC@shredder.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <67788a64-1df7-ee3f-0bd3-cd05d411940c@gmail.com>
Date:   Wed, 28 Apr 2021 14:29:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YImPN7C/5BXRv6uC@shredder.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/21 10:37 AM, Ido Schimmel wrote:
> On Wed, Apr 28, 2021 at 03:34:55PM +0300, Pavel Balaev wrote:
>> Test equal and different seed values for IPv4/IPv6
>> multipath routing.
> 
> The test does not follow the usual convention of forwarding tests that
> are expected to be run with both veth pairs and loop backed physical
> devices. See: tools/testing/selftests/net/forwarding/README (and
> existing tests for reference)
> 
> This approach allows us to test both the software and hardware data paths.
> 
> You can construct a test where you have multiple VRFs instead of
> multiple namespaces. These VRFs emulate your hosts and routers. Send
> multiple flows from one host and check the distribution across the
> multiple paths connecting your two routers. Change the seed, expect a
> different distribution. Go back to original seed and expect the original
> distribution.
> 

Pavel: I think net-next is closing soon, so this will need to wait until
next cycle (2 weeks from now).

I'll take a look at the patch set in the next few days. You can send
follow up sets as RFCs while net-next is closed, so this will be ready
once it opens.
