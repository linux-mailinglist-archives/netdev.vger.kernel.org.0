Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE9B19B734
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 22:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbgDAUmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 16:42:00 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:33790 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732411AbgDAUl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 16:41:59 -0400
Received: by mail-qt1-f180.google.com with SMTP id c14so1439155qtp.0
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 13:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iIRRf+GraRLCCujNnXL/qmnDvhHgz0hmnC4Ih+y5WZ0=;
        b=kFNblNNwpvxW0mooxqUXbeMXbOcb8pp3C+0MGGCHtNw8WBsZUMCCCCtucsCw8we03Y
         ddss+Pfc8BOjtea/y35MTDocA63OrrYWuOq/UxLv3uIQI0WXam2Butbsr8G3RBFnJ/KI
         P4H1P3puM1s3riLSRpevCvlUiqcdRuOMzCox5JcHNnbCJn7AkE/Mah8LV27FYRInjE0M
         nUuhLuiNEYHtGC8rAZpfARBF76vpdXc+3xScHJ7pHuQKWQ+Y+f9LbtjeBLfJSAZx6Ume
         h7lcmusPlT0jjrhVZD0tmn6LxOs3vrElptLg3AcKprTR9I9tZDfQKlt4FlZ6A9Z1ALzO
         wEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iIRRf+GraRLCCujNnXL/qmnDvhHgz0hmnC4Ih+y5WZ0=;
        b=poDwlQDP49pXZJQrz8Y+/OuRuOgh7m5tSlQ0RxmFUKPgxrTEc3pyI0pZCv3D/F84Qr
         dkm1dNySgrSgnnUp1wFFcshbf+eF48hsl+4sgEc6tof6VcBeH6B63BsaZ5bhEHJN7cF+
         bym9zMnbIaoBvt1r0Eo2a3hHESFgEmq2A0I9es5LSzodLtHA9hO5PeKQ801E76bp3Yhz
         2qiGs0hlo7kF+wwt4j/wPumX8S4gxMgxYriCLOGxpM17utq+7H0jlzUkfg4drlXozURm
         pp8ZG3Wq9WgM2vpH0kc0bQP/dxB1xbXdPsiXVJT6QAhdzFvc1BQ3Lr2n77c6oX8skR2Z
         Fzzg==
X-Gm-Message-State: ANhLgQ3pi57oqnNxh7b2Q6EvT5xk9gGX9qZM9IKC+w7VteXQTZoMskiI
        EiZwIEKYaY/8HBfSH2NHVbEfwydX
X-Google-Smtp-Source: ADFU+vsbA2dt1cKiSviu4tPquvx1jHMd3Cij/C1gJAfWidFM6dy03RuRleuwd1Og3kkhUD/ZvJg8cA==
X-Received: by 2002:ac8:7684:: with SMTP id g4mr12455961qtr.339.1585773718246;
        Wed, 01 Apr 2020 13:41:58 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f8fc:a46d:375f:4fa2? ([2601:282:803:7700:f8fc:a46d:375f:4fa2])
        by smtp.googlemail.com with ESMTPSA id u51sm2287399qth.46.2020.04.01.13.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 13:41:57 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Maximilian Bosch <maximilian@mbosch.me>, netdev@vger.kernel.org
References: <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
 <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
 <20200401203523.vafhsqb3uxfvvvxq@topsnens>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <00917d3a-17f8-b772-5b93-3abdf1540b94@gmail.com>
Date:   Wed, 1 Apr 2020 14:41:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401203523.vafhsqb3uxfvvvxq@topsnens>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/20 2:35 PM, Maximilian Bosch wrote:
> Hi!
> 
>> This should work:
>>     make -C tools/testing/selftests/net nettest
>>     PATH=$PWD/tools/testing/selftests/net:$PATH
>>     tools/testing/selftests/net/fcnal-test.sh
> 
> Thanks, will try this out later.
> 
>> If you want that ssh connection to work over a VRF you either need to
>> set the shell context:
>>     ip vrf exec <NAME> su - $USER
>>
> 
> Yes, using `ip vrf exec` is basically my current workaround.

that's not a workaround, it's a requirement. With VRF configured all
addresses are relative to the L3 domain. When trying to connect to a
remote host, the VRF needs to be given.

> 
>> or add 'ip vrf exec' before the ssh. If it is an incoming connection to
>> a server the ssh server either needs to be bound to the VRF or you need
>> 'net.ipv4.tcp_l3mdev_accept = 1'
> 
> Does this mean that the `*l3mdev_accept`-parameters only "fix" this
> issue if the VRF is on the server I connect to?

server side setting only.

> 
> In my case the VRF is on my local machine and I try to connect through
> the VRF to the server.
> 
>> The tcp reset suggests you are doing an outbound connection but the
>> lookup for what must be the SYN-ACK is not finding the local socket -
>> and that is because of the missing 'ip vrf exec' above.
> 
> I only experience this behavior on a 5.x kernel, not on e.g. 4.19
> though. I may be wrong, but isn't this a breaking change for userspace
> applications in the end?

I do not see how this worked on 4.19. My comment above is a fundamental
property of VRF and has been needed since day 1. That's why 'ip vrf
exec' exists.
