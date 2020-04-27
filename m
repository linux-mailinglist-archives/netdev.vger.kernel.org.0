Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873EA1BA3AF
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgD0MiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbgD0MiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 08:38:05 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3450C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 05:38:05 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f82so16428291ilh.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 05:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6vDAyY3bEIHUgmyxFGMF9U8PhgtEj1qY1v2F1KEFpVE=;
        b=kGaqNGCTtZQVq5Nk0QePah76nlInrZXEfIzFzFmnESdfi6vcvMJshwIqwZ8P9tR2ti
         FGXtbG1cycFuofvaRJTEtN3KjQbZHA/2LT1HYTl9NPeS6JFA/T79kMg30OTjDvvIYrqm
         eFg5IGqbbc/3nS2FvO/8Lsu8XQdNH9wVlB0VUsYrNJb9AJaqT6eYXoyJW2lVbjstChyO
         ONfhkvjrD5gYNB6OToZXLcyzSagffaBtBBXMmCxvLsIFPIwsQQkVbndlTaQg2UzA7bEn
         1wktMdZak0BECrgfmjKYTFQzlzfOQZsEqYdNt6usL09RzqOnwmtMddQgLUkfNiOsW3Fm
         WTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6vDAyY3bEIHUgmyxFGMF9U8PhgtEj1qY1v2F1KEFpVE=;
        b=OvbS5TrqnEDexfNsvoKX0mOqPQ2Htf3C/csukp9OwqZKqVcPBnEtW4+yqGfiN4hyGc
         Eh9XYTY7VT4EajqC6uqavZITepuzbrz4vMqd4ePfJhHUy32YHTZfasfX4pAh623qUvas
         3D2V5dZDsNhqA5q5Yet9j8M3jiJ4nlAmCTkEL/QrSGk7aZ7dAtQa7Hu8NJuCiE57iQtl
         vJyj9q7hDI/xlYSyn+jshKjrXMe+HQZUOq0ucYUGK8cKAKriBt372oFFd/cjYfwJT+PS
         KTiJuMycBXcpf3f7POq+DVgfjPW0T0gLvtJfJEvQAh0Wb1G71FB/Lz+A0Ygjj0SAMS76
         6yPg==
X-Gm-Message-State: AGi0PuY9GdnOW5ydQmj9e7JvIm0AQbEmSrnaTd+4GGv2l8lemxUr9/61
        JgwiVW5B/6MjxgH5F0SpBow=
X-Google-Smtp-Source: APiQypJS//C3H5AimelflnvANxOYjnh3TPS/cynSHuEvxsTO5YAoQ12CpJTZy7OIcA5URgZelZn9yQ==
X-Received: by 2002:a92:dd09:: with SMTP id n9mr21469392ilm.132.1587991085202;
        Mon, 27 Apr 2020 05:38:05 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id t5sm4844147iom.3.2020.04.27.05.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 05:38:04 -0700 (PDT)
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan>
 <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200423082351.5cd10f4d@hermes.lan>
 <20200423110307.6e35fc7d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <70c448c7-cf2e-1f63-e4ea-03e73077c0d1@gmail.com>
Date:   Mon, 27 Apr 2020 06:38:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423110307.6e35fc7d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 12:03 PM, Jakub Kicinski wrote:
> On Thu, 23 Apr 2020 08:23:51 -0700 Stephen Hemminger wrote:
>>  3. If non json uses hex, then json should use hex
>>     json is type less so { "ver":2 } and { "ver":"0x2" } are the same
> 
> I may be missing something or misunderstanding you, but in my humble
> experience that's emphatically not true:
> 
> $ echo '{ "a" : 2 }' | python -c 'import sys, json; print(json.load(sys.stdin)["a"] + 1)'
> 3
> $ echo '{ "a" : "2" }' | python -c 'import sys, json; print(json.load(sys.stdin)["a"] + 1)'
> Traceback (most recent call last):
>   File "<string>", line 1, in <module>
> TypeError: can only concatenate str (not "int") to str
> 

I don't know which site is the definitive source for json, but several
do state json has several types - strings, number, true / false / null,
object, array.
