Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7DC19ECC1
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgDEQwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 12:52:33 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:40303 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgDEQwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 12:52:33 -0400
Received: by mail-il1-f196.google.com with SMTP id j9so12407778ilr.7
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 09:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MV98g94yDnvUF9S16GRoqgbM3rwRJYDoquWLLjgP7Ec=;
        b=M1IOov8b8fR/krRT/L3PClneR7Tem/90sB8mtH+i5iaIBas0heEhosx2dEsinGy7ka
         7Y7gbx1n5qrimIY93SfSp3s27whVcyoL/vXpI49PFdMxxd9VLjuP4krptzQMiR4DLItC
         jsqU6ZGkibD51VnL2erV24NczqkKjKg3rRVr5YLtP2sUD3gGE6CPnnE417KOSOGPgwLa
         lb75QkM72xDiI79Ni37C8+uQrP+qMGRjWNJSMoNiXBfG8FRDEMzjd4nuXlRRadfOHDWM
         0lFSdslK88ofhUJ2ssq3HHszFPzQY3x02K/vApOMEIciPD3lAYwSuTJepXac2pu4//cx
         XF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MV98g94yDnvUF9S16GRoqgbM3rwRJYDoquWLLjgP7Ec=;
        b=sOCwpNUxoeDqlSCAxljiVU5clkl6FPfRXN7Hjxsv+2acyM39X+Jn4jdxLB9RBqKvhH
         wBviyZM0ZytFs+t4Pds/Jns0UTndpiW3e8loYD8d+GCNVlunOajyKvmJZDrqUirOitKr
         QbuNgoZhoxb53n1MPOdiD8/L2qYRxBanOir6hbuYGfAZ92/HG7IJrxoWKAuEAhnVUS8B
         cxBcEWSIhLxf92zU8h+D9puc1fYGKxPamAdb3SDc19ZValsTIBwDXLpYMzWlSLLQ51GI
         1LTk26WJa8brpy3EgthcDPfQ6BUtt/P+tnesp6PTIgX3Zy+WPdAiB7zMMYwuzk5uUPsU
         bF5Q==
X-Gm-Message-State: AGi0PuYgoRS7qC6hf9vtcTuy6kzbFfMB+H35Htzy4rgxsQuwCAOGk8OX
        On1SfH6qF4M2kDsqavJR/MQTI6rN
X-Google-Smtp-Source: APiQypJO3KZnU7c8cy3D93j2V8IIe20hcAw4d1C1nolzEpy7QHt6MyGf1exncn/SznCnfkUF+9xaTA==
X-Received: by 2002:a92:8659:: with SMTP id g86mr18377287ild.267.1586105552021;
        Sun, 05 Apr 2020 09:52:32 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:60e1:98ca:913:d555? ([2601:282:803:7700:60e1:98ca:913:d555])
        by smtp.googlemail.com with ESMTPSA id p69sm5089534ill.46.2020.04.05.09.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 09:52:31 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Maximilian Bosch <maximilian@mbosch.me>, netdev@vger.kernel.org
References: <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
 <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
 <20200401203523.vafhsqb3uxfvvvxq@topsnens>
 <00917d3a-17f8-b772-5b93-3abdf1540b94@gmail.com>
 <20200402230233.mumqo22khf7q7o7c@topsnens>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e64064d-eb03-53d3-f80a-7646e71405d8@gmail.com>
Date:   Sun, 5 Apr 2020 10:52:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200402230233.mumqo22khf7q7o7c@topsnens>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/2/20 5:02 PM, Maximilian Bosch wrote:
> Hi!
> 
>> I do not see how this worked on 4.19. My comment above is a fundamental
>> property of VRF and has been needed since day 1. That's why 'ip vrf
>> exec' exists.
> 
> I'm afraid I have to disagree here: first of all, I created a
> regression-test in NixOS for this purpose a while ago[1]. The third test-case
> (lines 197-208) does basically what I demonstrated in my previous emails
> (opening SSH connetions through a local VRF). This worked fine until we
> bumped our default kernel to 5.4.x which is the reason why this testcase
> is temporarily commented out.

I do not have access to a NixOS install, nor the time to create one.
Please provide a set of ip commands to re-create the test that work with
Ubuntu, debian or fedora.


> After skimming through the VRF-related changes in 4.20 and 5.0 (which
> might've had some relevant changes as you suggested previously), I
> rebuilt the kernels 5.4.29 and 5.5.13 with
> 3c82a21f4320c8d54cf6456b27c8d49e5ffb722e[2] reverted on top and the
> commented-out testcase works fine again. In other words, my usecase
> seems to have worked before and the mentioned commit appears to cause
> the "regression".

The vyatta folks who made the changes will take a look.
