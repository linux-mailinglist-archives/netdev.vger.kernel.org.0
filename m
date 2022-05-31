Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4965389D7
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 04:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbiEaCLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 22:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiEaCLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 22:11:20 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFDC87A3E
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 19:11:20 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-f2cd424b9cso16507279fac.7
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 19:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Jb1gRyg2fSm+hzMK9OEVu7nzK2DB+ZXXpFJAvzboyx4=;
        b=je8oY2ZPgLVBHGvPMQtJ65LFLKrsZPL9ut3q7F4FWHK9kDzVeX5hep/UovM7AjdgIh
         +or+2r0vhCFsqcA0ERtJtnhSJbuZzofbuunnXfgZJx1/T0TdUw4tEUrdTM6pYJyS22md
         O8SZl8tX+B3KqjIdF0gH/Tv5SsZ32eTel/dvo+2vXsP+GHnqKxg9NukANCA5CNTvxN8V
         Cnb1IcijEWfb+jDTpi9oGSZl5B8PQQLgJzyKeTemPL8tYP9kXVit9uTFIhOxd42t9wz3
         U/dHL0Z96w9JoplMkMqnU7kjlDCjukkz5/ieo1bmz0ZW+1eeOxbHJ65Ksw2ps2ha1DzG
         0+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jb1gRyg2fSm+hzMK9OEVu7nzK2DB+ZXXpFJAvzboyx4=;
        b=Ix3C9F09WNdrm1qZOA3aAicmljgreWTUarTpmlJD8OyVMJlPdDkCCzAQIdEvxFNu9z
         YuEkmilFYQRfyJga3F03Z8lWTqNGXVRbhe1tHzqoyRmwqgJ33CPuQLL6XYLLN7uyuvXa
         SCtZ8QThVZWr189pus6Mh+2UCUCg2NZyxHCwB/BmtNAZhQMuNj4v6g4P46jqaw1ToTSh
         DEIAa6pmLzDuLBD/Aozp9TvF2pazyLlGEaIMOEmR35iss3wJI5imyA45R+8TJ5V25z/E
         g2yHvh/YbH9kVv6xTYnAandi0czMt+Sz108wljEgsPqYDW/X5VYxt7w4qQ0iPUsDr+4Z
         s1Tw==
X-Gm-Message-State: AOAM532xqafyhcQPAbLVKa6MZTpAnmasgtnRduCzPsWsi3K8mT65vQmn
        5NORTN0O5foA3YFtHdrWQVI=
X-Google-Smtp-Source: ABdhPJy2BZHu/vLIOkYQ0inNLrGVavI7BcprUr0snzksZA7ytW9pstlReJsX13ips22IrTO+zBjAVg==
X-Received: by 2002:a05:6870:41ca:b0:e9:c84:987a with SMTP id z10-20020a05687041ca00b000e90c84987amr11408927oac.149.1653963079573;
        Mon, 30 May 2022 19:11:19 -0700 (PDT)
Received: from [172.16.0.2] ([104.28.192.252])
        by smtp.googlemail.com with ESMTPSA id pk10-20020a0568704c0a00b000e686d1387asm4558269oab.20.2022.05.30.19.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 19:11:18 -0700 (PDT)
Message-ID: <5c740b60-78eb-d0df-369c-d8411e24a054@gmail.com>
Date:   Mon, 30 May 2022 20:11:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, andrew@lunn.ch, mlxsw@nvidia.com
References: <20220429114535.64794e94@kernel.org> <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org> <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org> <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org> <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <2d7c3432-591f-54e7-d62c-abc93663b149@gmail.com>
 <YpM75y3rf4nUhYsy@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YpM75y3rf4nUhYsy@nanopsycho>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/22 3:24 AM, Jiri Pirko wrote:
> Sat, May 28, 2022 at 05:58:56PM CEST, dsahern@gmail.com wrote:
>> On 5/24/22 8:31 AM, Jiri Pirko wrote:
>>>
>>> $ devlink lc info pci/0000:01:00.0 lc 8
>>> pci/0000:01:00.0:
>>
>> ...
>>
>>>
>>> $ devlink lc flash pci/0000:01:00.0 lc 8 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>>
>>
>> A lot of your proposed syntax for devlink commands has 'lc' twice. If
>> 'lc' is the subcommand, then you are managing a linecard making 'lc'
>> before the '8' redundant. How about 'slot 8' or something along those lines?
> 
> Well, there is 1:1 match between cmd line options and output, as always.
> 
> Object name is one thing, the option name is different. It is quite
> common to name them both the same. I'm not sure I understand why it
> would be an issue.
> 

example? To me it says something is off in your model when you want to
use the same keyword twice in a command line.
