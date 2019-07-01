Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694BE5BDEA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfGAORI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:17:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37834 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfGAORI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 10:17:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id v14so14070600wrr.4
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 07:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R/v4XqdJc3LmNjTI+rjkorVUyU/MR0aH5YskfX0Lx5A=;
        b=hSIHVIfCwFMB5UqRSJVHXKBSdO5UeUJtXh//DRljlIDq0kl9+/hNVp18vhP1KhFQKb
         0ukEwJiqnlPm0XnlAeYAzVAodE1CGs4GX9LtZW/lMh7lknaABr/56Mv0EXjdJDRqa3/g
         VMgTNTZw5+VMlzyil9qqJFO0tiXxFBLKonvsHOkFXtSQi57Ew1MGSfDM4X74vgvx3JnD
         jEKc+enPg/4xe4C8vVZJH51DwBK6MTsZXot4c7wVd1MRyLC3F3t0bnK/RWzv6zqExTNv
         ml7WDDLSsNnKO3MByr8opbuhum7Kkg/s2FlWAB43H9wpFqlJiYCElIzOioX28KniGhvS
         Kazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=R/v4XqdJc3LmNjTI+rjkorVUyU/MR0aH5YskfX0Lx5A=;
        b=OXug/VoE+4e1AskSwYT8nnWkqppiAP/dxC3mi9n/Fz8DwX/8Ut0anBKH4GID8pnf7p
         zEUOMpqHEGJsdUs37kqEY2oBaqyEV5f1aG01FOojl4hsMEdh/45SRlYvxqK8lbjDTLZs
         fhGqlpZPl8np0ERlYqZu5wmuGacC0yTTJrB8k/b6wvDkxivOiMWqipGoj5bsm9iMSYc6
         38kPYtBr2WR+Uhq+MrHrsCJiPCtfPa1Qk5gUxNfsoNmjD49ltMcWgKGqoUu4XI+1KKj9
         ZoNkGaCMEoFPWb3hiDW2tNPz58nPvhgMGunXHRkMVja/IJtWxxXxKRdiZp7W7CMOKFRl
         Ko5w==
X-Gm-Message-State: APjAAAUWL41/ni4yGAweWNUEIhqzs/v24kg3IDlxAZEETNQQoRNrpisu
        r4JUvntK+JXXvYntyFrxhZ9PCvtp/Vo=
X-Google-Smtp-Source: APXvYqxanm3MIxXsm5vXeUyvriDmRAcHFu5+97J0WS2utUO9Mfv5w9ueEthS5KTGVrPMB+kJ/T17+A==
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr20397515wrt.295.1561990625995;
        Mon, 01 Jul 2019 07:17:05 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:78cb:f345:e2db:cb5a? ([2a01:e35:8b63:dc30:78cb:f345:e2db:cb5a])
        by smtp.gmail.com with ESMTPSA id p11sm9501034wrm.53.2019.07.01.07.17.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 07:17:05 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC iproute2] netns: add mounting state file for each netns
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Aring <aring@mojatatu.com>
References: <20190630192933.30743-1-mcroce@redhat.com>
 <e2173091-1c7a-fd74-95ea-41eedbab92d3@6wind.com>
 <CAGnkfhz92SA7_kbARMzTqj3sTE3pgE=FEOXzFQxX6m=cemJUkg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b3374a06-fa75-b1af-baa5-14b5dfba2b19@6wind.com>
Date:   Mon, 1 Jul 2019 16:17:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAGnkfhz92SA7_kbARMzTqj3sTE3pgE=FEOXzFQxX6m=cemJUkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 01/07/2019 à 15:50, Matteo Croce a écrit :
> On Mon, Jul 1, 2019 at 2:38 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 30/06/2019 à 21:29, Matteo Croce a écrit :
>>> When ip creates a netns, there is a small time interval between the
>>> placeholder file creation in NETNS_RUN_DIR and the bind mount from /proc.
>>>
>>> Add a temporary file named .mounting-$netns which gets deleted after the
>>> bind mount, so watching for delete event matching the .mounting-* name
>>> will notify watchers only after the bind mount has been done.
>> Probably a naive question, but why creating those '.mounting-$netns' files in
>> the directory where netns are stored? Why not another directory, something like
>> /var/run/netns-monitor/?
>>
>>
>> Regards,
>> Nicolas
> 
> Yes, would work too. But ideally I'd wait for the mount inotify notifications.
> 
Yes, I agree.
