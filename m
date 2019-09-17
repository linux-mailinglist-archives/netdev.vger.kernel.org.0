Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4132DB58BD
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 01:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfIQXqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 19:46:17 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:44898 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfIQXqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 19:46:17 -0400
Received: by mail-pl1-f181.google.com with SMTP id k24so1384959pll.11
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 16:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yghpdtVNxa+bjt+D03KJvZeH2tG/CagNHCWfxTbiNJ0=;
        b=Y7WdcIuzXlTabL/6c2ehO5HeYOBMPz0/Plzi3k9bDvFKoHn8cHu8OBZzpAaWFNtqxZ
         UQLRCmonG2lLv1ZMG6HhVKG2pj+G1myk0PHgWEqBqOHkKUbMRD5gIsY9NtKeRedQQ/6b
         SoSYwTGOTLVQ+A/gD7Rpnzg1I7hD4EO13bTZrnKPzYojkIpSkLRDQb0AuHciQdPGvMPi
         IZnZZTF78PTmKphGbhtHZsfRDS1jso5/uCmSAvjVDWal+FNWlj1XWAp3w0tGedc5XyS8
         qkaWsNbjaqo8xguda+DZT5HRxuZ4anKo8a6WqBekI06EPmz04zlGl+HjBO8xamFHr6jm
         I+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yghpdtVNxa+bjt+D03KJvZeH2tG/CagNHCWfxTbiNJ0=;
        b=EOJVE4SSpJAO+WzNyBVz4JuvRARZHiWIwA4nrgEfsSMpcqXZ0kPRvcgeE+GGs8xrub
         7OKQtmLzf/jcfvSBlcMKT5ou86rw2CRq9rD86KgEeD7t8bxEuPjFYOSSVBgNGTVuo095
         yahQ6s5NsWEAV9C+gmEuebU+14s06WDwEkRddAc2oj5UzFDzrXU+41nuVel7rbIH9vsP
         UN0liD6hEKPGO/n0Zs6yZ17HHAiyTLB5IYajgh3a6sd91mPUGMIZB20oOm3suhkz4dJ0
         GHPMB9qEbK1rS1FPT1f9+fcGtXBhRreC0YUb6jnsnBDee/eVqg0zGXW3Pbq4HH/9n6VN
         I++Q==
X-Gm-Message-State: APjAAAVaybUIwNHw/QcDSmQcBBF5MJALrohvHfHyOy9/4Hb18VjJfJFE
        L6k2fehDznhlwGzsLXfffIw=
X-Google-Smtp-Source: APXvYqwZP16QPZRp74GhveZ2sqv5S6XKGXXEgjl9CsxUtYcKhRWoGqBEepoSqLrJtuVft5YOF8NcpA==
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr1292205pls.184.1568763976726;
        Tue, 17 Sep 2019 16:46:16 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:891:77d6:e233:a77c])
        by smtp.googlemail.com with ESMTPSA id ep10sm11429596pjb.2.2019.09.17.16.46.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 16:46:15 -0700 (PDT)
Subject: Re: [patch iproute2-next v2] devlink: add reload failed indication
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, mlxsw@mellanox.com
References: <20190916094448.26072-1-jiri@resnulli.us>
 <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
 <20190917183629.GP2286@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <12070e36-64e3-9a92-7dd5-0cbce87522db@gmail.com>
Date:   Tue, 17 Sep 2019 17:46:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190917183629.GP2286@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/19 12:36 PM, Jiri Pirko wrote:
> Tue, Sep 17, 2019 at 06:46:31PM CEST, dsahern@gmail.com wrote:
>> On 9/16/19 3:44 AM, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@mellanox.com>
>>>
>>> Add indication about previous failed devlink reload.
>>>
>>> Example outputs:
>>>
>>> $ devlink dev
>>> netdevsim/netdevsim10: reload_failed true
>>
>> odd output to user. Why not just "reload failed"?
> 
> Well it is common to have "name value". The extra space would seem
> confusing for the reader..
> Also it is common to have "_" instead of space for the output in cases
> like this.
> 

I am not understanding your point.

"reload failed" is still a name/value pair. It is short and to the point
as to what it indicates. There is no need for the name in the uapi (ie.,
the name of the netlink attribute) to be dumped here.
