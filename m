Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04BD161BEC
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 20:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBQTxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 14:53:18 -0500
Received: from mail-qk1-f169.google.com ([209.85.222.169]:45209 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbgBQTxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 14:53:17 -0500
Received: by mail-qk1-f169.google.com with SMTP id a2so17272811qko.12
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 11:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hfR8fPBFkB6JxJHr6pGvxpf1n1vy36p7dADT1G/ViJ0=;
        b=gp76XIHRhxsRvvula19OYTI+pzXui+gdC2Y3LFcc83BnaVZ60a0OR906ebwhVxzPF0
         3mxLRFFSaWB5ACGsfv0uV/r6XKkGVt/i4IRiYGZbDSxvWSDafocYE7PD21xqcev/rogy
         ijE4VKltTeHtixYsYEINHFD0SP82Y1lxJQG5C7C3nMmAB/FBW2sJni+4MXOk9yKikL0X
         6dr7leUfJXrSRvbl6J8rHNQzu4rX6Sx5V6ax+Cq3Dd203bFumQR3FBNPziQ+V0MB/p9w
         0VeohYPcaVDOOdNmOtTs99+4z/NqVrTKlpV1oKz9U4cFmi2/qmQe3s//N0wKSnkEB2NX
         HQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hfR8fPBFkB6JxJHr6pGvxpf1n1vy36p7dADT1G/ViJ0=;
        b=OQxTGgIgfKfnzQ6fiRHfmCpYeBe9VexuWtrodJVnhzQ5H5hYUL8CfQBGIOKtJZXzSy
         I80Lcl43C7mkoTZdsToZkq/yUlwgZXwCYmcxwiIbW/aVcL6L5wcRRRzzoqO977T4YgFG
         /IlgowTROyqdKyqd7CsjYOGBid5LaLgE80b48+I/wAXNg4/Qreo7bxUCjMO5qO+6np0P
         EW+mi6k5lmdh3m5njp132g2yAsWap6xTLTokZrOuOzY0wpEfGwkH0E/eXOwko3xdjHtM
         jqVI6yQWRXc6kEr6Eml7huBMNUn/AsSs1jaO2UhdI4uTWf9cXe2EXoqpiivVajte22k6
         nbTg==
X-Gm-Message-State: APjAAAXZMue4mPjFGOUORWahmIvUBtLqKhZSAJOX+390qKybJHMgBG/l
        YvT05uwMXZy7wV/SYbwOzEc=
X-Google-Smtp-Source: APXvYqyEQ9YYQ32OgpEINw5LA7K9tIOxhPVex9g1KNXOfwQpryyXSqYoD3C4zaIJgISWoLsdusC18A==
X-Received: by 2002:a05:620a:47:: with SMTP id t7mr14738225qkt.432.1581969196316;
        Mon, 17 Feb 2020 11:53:16 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:65d1:a3b2:d15f:79af? ([2601:282:803:7700:65d1:a3b2:d15f:79af])
        by smtp.googlemail.com with ESMTPSA id x197sm757821qkb.28.2020.02.17.11.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 11:53:15 -0800 (PST)
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
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com>
 <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com>
Date:   Mon, 17 Feb 2020 12:53:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/20 11:38 PM, Xin Long wrote:
> On Sun, Feb 16, 2020 at 12:51 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 2/14/20 9:18 PM, Xin Long wrote:
>>> On Sat, Feb 15, 2020 at 8:21 AM Stephen Hemminger
>>> <stephen@networkplumber.org> wrote:
>>>>
>>>> On Sat, 15 Feb 2020 01:40:27 +0800
>>>> Xin Long <lucien.xin@gmail.com> wrote:
>>>>
>>>>> This's not gonna work. as the output will be:
>>>>> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
>>>>> instead of
>>>>> {"ver":2,"index":0,"dir":1,"hwid":2} (number)
>>>>
>>>> JSON is typeless. Lots of values are already printed in hex
>>> You may mean JSON data itself is typeless.
>>> But JSON objects are typed when parsing JSON data, which includes
>>> string, number, array, boolean. So it matters how to define the
>>> members' 'type' in JSON data.
>>>
>>> For example, in python's 'json' module:
>>>
>>> #!/usr/bin/python2
>>> import json
>>> json_data_1 = '{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}'
>>> json_data_2 = '{"ver":2,"index":0,"dir":1,"hwid":2}'
>>> parsed_json_1 = (json.loads(json_data_1))
>>> parsed_json_2 = (json.loads(json_data_2))
>>> print type(parsed_json_1["hwid"])
>>> print type(parsed_json_2["hwid"])
>>>
>>> The output is:
>>> <type 'unicode'>
>>> <type 'int'>
>>>
>>> Also, '{"result": true}' is different from '{"result": "true"}' when
>>> loading it in a 3rd-party lib.
>>>
>>> I think the JSON data coming from iproute2 is designed to be used by
>>> a 3rd-party lib to parse, not just to show to users. To keep these
>>> members' original type (numbers) is more appropriate, IMO.
>>>
>>
>> Stephen: why do you think all of the numbers should be in hex?
>>
>> It seems like consistency with existing output should matter more.
>> ip/link_gre.c for instance prints index as an int, version as an int,
>> direction as a string and only hwid in hex.
>>
>> Xin: any reason you did not follow the output of the existingg netdev
>> based solutions?
> Hi David,
> 
> Option is expressed as "version:index:dir:hwid", I made all fields
> in this string of hex, just like "class:type:data" in:
> 
> commit 0ed5269f9e41f495c8e9020c85f5e1644c1afc57
> Author: Simon Horman <simon.horman@netronome.com>
> Date:   Tue Jun 26 21:39:37 2018 -0700
> 
>     net/sched: add tunnel option support to act_tunnel_key
> 
> I'm not sure if it's good to mix multiple types in this string. wdyt?
> 
> but for the JSON data, of course, these are all numbers(not string).
> 

I don't understand why Stephen is pushing for hex; it does not make
sense for version, index or direction. I don't have a clear
understanding of hwid to know uint vs hex, so your current JSON prints
seem fine.

As for the stdout print and hex fields, staring at the tc and lwtunnel
code, it seems like those 2 have a lot of parallels in expressing
options for encoding vs lwtunnel and netdev based code. ie., I think
this latest set is correct.

Stephen?
