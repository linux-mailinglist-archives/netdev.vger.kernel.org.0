Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0CB427E13
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 01:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhJIXrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 19:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhJIXrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 19:47:20 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B84C061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 16:45:22 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id w11so10811117ilv.6
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 16:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Airj0p7l6oidEFAuIVq5OGBN1M9Rv3bU0/TVNDt3Fkg=;
        b=G9azjgI7asFyiED1g8v2YasB51a1VsC3Lp/QsMpqE87UIJzR5yKbK41F0OY6Vhw5x9
         5BrkLhkQz4+g7d3zmuiAXCj96c9FT7GsUoXO3kIq5twNCkJqdxjQchfdl1iTsO/xFf1i
         85/d0+v07NHpb2GJe9r93d9AVVV7r4XsElAKHPexmZF2wvra/6BBK1PD7F21AQ0cuEOL
         NZGE9GQGo72TuALcdgNj0fhoEnWpI1yz3yHwxymUkFEMmXY3mRYmOgl/i94e7XeUEqf6
         4L14ksgVBE50dldooM0RsoDM4W9seoOMT8wy98AHNvX/rCoaEja6EZlkPhMPl46+N+qa
         YomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Airj0p7l6oidEFAuIVq5OGBN1M9Rv3bU0/TVNDt3Fkg=;
        b=1SIfBkYi6mtVap4gdebvDOh5DtzI/NK/rnK+WzevEm/RXA514kioYykhipuzhhfs7z
         P3mwRjZ80Tf8wEC/brynaYqKKSXIw4qN8qS6hhAdc64btAt3i9lgsfTV1sIguIPFR8jZ
         PZxIoCz0J5fkBKdsBuwKXruMkGadowkvFJoU9txGYqOlboO2pCzXs5YZiCxw69Uwio5j
         ZvN6CCxcpNN6OebyAo5wBVmLNjcyB1zhB/tpfQmlVANVF8+Uwo2Gjg+t28Z5QmuRuelj
         sn9Flf/DEHH3sr58n9Briwv9rhwuPqdnKCEIzG1nmJ+pX3oABEy2EZNPQTrS/gNkXJhc
         qtrA==
X-Gm-Message-State: AOAM533bR3IkMG7l6Iwn7S+gN3v3RjQNVDcZs0DFD0Eu/37G0Z/BrGwX
        OlQCAHbOZgHMMkXBU8iWUs2E1mTsM6YhkA==
X-Google-Smtp-Source: ABdhPJxUg75Y/JMaL6ctr/QMFCSKH1V8AGA6jw2Em7mhwfkMOy2ufSDg+rtEeOTZHjsDOZQBqDVuSg==
X-Received: by 2002:a05:6e02:16c5:: with SMTP id 5mr13394366ilx.143.1633823122172;
        Sat, 09 Oct 2021 16:45:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o3sm1795241iou.11.2021.10.09.16.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 16:45:21 -0700 (PDT)
Subject: Re: [PATCH iproute2 v4 0/5] configure: add support for libdir and
 prefix option
To:     Andrea Claudi <aclaudi@redhat.com>, Phil Sutter <phil@nwl.cc>,
        netdev@vger.kernel.org, stephen@networkplumber.org,
        bluca@debian.org, haliu@redhat.com
References: <cover.1633612111.git.aclaudi@redhat.com>
 <20211007160202.GG32194@orbyte.nwl.cc> <YWBCx6yvm7gDZNId@renaissance-vector>
 <20211008135025.GM32194@orbyte.nwl.cc> <YWBvoFW1RDQDYAGx@renaissance-vector>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5256e688-70cb-d7a0-714f-2445b912dc8c@gmail.com>
Date:   Sat, 9 Oct 2021 17:45:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWBvoFW1RDQDYAGx@renaissance-vector>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/21 10:19 AM, Andrea Claudi wrote:
> 
>>
>> Which sounds like you'll start accepting things like
>>
>> | ./configure --include_dir foo bar
>>
> 
> We already accept things like this in the current configure, and I would
> try to not modify current behaviour as much as possible.

that is definitely not intended and I don't see a reason to allow it.
