Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3715FF49
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOQvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:51:16 -0500
Received: from mail-il1-f173.google.com ([209.85.166.173]:45566 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOQvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 11:51:15 -0500
Received: by mail-il1-f173.google.com with SMTP id p8so10724174iln.12
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 08:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tYfUsgnJE2GZkgkwa/DP7oaGmzP/v9/9W3SnVf2BF6k=;
        b=byVmrcxcMgzIE0DTxm+DSL/cuJwH48b+5CKVSWPzXsjS70lauXJfPHMnj8eEnZC2q7
         QWJorTZOyl1hTUjl4XSCvgQsXzaOaIWOKajsv6cPkuZqf6unoSsoOuGXcOurJZC0BMOo
         fFxQm6a5Lv1JDgnKOIwLaEw3LYU0aVfxEV7AfVRaBlb62+S1ZARvIMT1D9gENFT6N0tF
         noURM0hCeSRhLwUOhYhWTne9ow/WdJsrgkgUxRAH0Kug8+w76+J6PqUgDgNMsVXiYpZ7
         yFbqcKmrix2UneOEM5oZJXFy2xMlCtXxSYdjNaKzmC/z3G8ZOqgy2umek7rZXaUSfmZI
         Qnaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tYfUsgnJE2GZkgkwa/DP7oaGmzP/v9/9W3SnVf2BF6k=;
        b=HmKS6Ogmetohv4Xajd7yO0UzYakBN0MIz/HBVD0JKLBfGnqIoQpi7myr6otKDKFfJX
         6wuE36bkSTsfOVSPtBG3O80dIpbb7rOBIprFY6NR4sClK+N9y/CECVmVIxTLSA15a8jC
         N9iiU2yLlBQylI1dxGOOiaLYxK+YfSpzWZk4E7EUJJi2Su7iGJ4Jq7vZUJp8tCDjnyY9
         CbiZI5sONmwuwb08g34im3XuuJHhork4MTzgIC3ddbHL40BX4OPdC/bPpnnACjk+VwG5
         LujFZw0Df0rWudzJDvta744CCZOjSJfr4BTz6my/OoIfGVjhuS+V/b6zc5LhGJJnypAp
         S+SA==
X-Gm-Message-State: APjAAAU3rnayX7WlNLoRPuQqU7YalZnMTn5cw9ZBIvAPENCXucbqrn21
        CZepnzrXlXUA/ai3DtfdXzE=
X-Google-Smtp-Source: APXvYqxuX7Gy4zC/9U8WubYkXKLDhU8Gvn5PtAZbgAsX5vXmkSfkLvgfkgLNa/2Qo6TvWRSokyITOQ==
X-Received: by 2002:a92:afc5:: with SMTP id v66mr7442554ill.123.1581785473768;
        Sat, 15 Feb 2020 08:51:13 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:65d1:a3b2:d15f:79af? ([2601:282:803:7700:65d1:a3b2:d15f:79af])
        by smtp.googlemail.com with ESMTPSA id h23sm3308304ilf.57.2020.02.15.08.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 08:51:12 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Xin Long <lucien.xin@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan>
 <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan>
 <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com>
Date:   Sat, 15 Feb 2020 09:51:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/20 9:18 PM, Xin Long wrote:
> On Sat, Feb 15, 2020 at 8:21 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
>>
>> On Sat, 15 Feb 2020 01:40:27 +0800
>> Xin Long <lucien.xin@gmail.com> wrote:
>>
>>> This's not gonna work. as the output will be:
>>> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
>>> instead of
>>> {"ver":2,"index":0,"dir":1,"hwid":2} (number)
>>
>> JSON is typeless. Lots of values are already printed in hex
> You may mean JSON data itself is typeless.
> But JSON objects are typed when parsing JSON data, which includes
> string, number, array, boolean. So it matters how to define the
> members' 'type' in JSON data.
> 
> For example, in python's 'json' module:
> 
> #!/usr/bin/python2
> import json
> json_data_1 = '{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}'
> json_data_2 = '{"ver":2,"index":0,"dir":1,"hwid":2}'
> parsed_json_1 = (json.loads(json_data_1))
> parsed_json_2 = (json.loads(json_data_2))
> print type(parsed_json_1["hwid"])
> print type(parsed_json_2["hwid"])
> 
> The output is:
> <type 'unicode'>
> <type 'int'>
> 
> Also, '{"result": true}' is different from '{"result": "true"}' when
> loading it in a 3rd-party lib.
> 
> I think the JSON data coming from iproute2 is designed to be used by
> a 3rd-party lib to parse, not just to show to users. To keep these
> members' original type (numbers) is more appropriate, IMO.
> 

Stephen: why do you think all of the numbers should be in hex?

It seems like consistency with existing output should matter more.
ip/link_gre.c for instance prints index as an int, version as an int,
direction as a string and only hwid in hex.

Xin: any reason you did not follow the output of the existing netdev
based solutions?
