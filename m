Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDB929A90
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389079AbfEXPEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:04:36 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:34182 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388995AbfEXPEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:04:36 -0400
Received: by mail-pg1-f171.google.com with SMTP id h2so2161245pgg.1
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 08:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x6TbkfGprqxa7HuNnv82cBoTrvTLC5T+c/QpQH0AiBY=;
        b=tAJvIezHP3QD5af/3tWgL9/THO8EWwSZuzxgWET934fLiQtv5t0+BdJHLgtxH7nOOB
         eA/xVIDJiAv5bIQoLlWjYznSmQDZcXrXcEEw++GHweDSPJUESUANy1pYmhWOt+Ab7/kU
         qJLuRiN/Tn3C82Xyo+5miIcKAVmoUsf252xzvDhi96tkIbzzRLwL2mqBVszLVk9t+ppf
         M/92pXMbL7rN21NiljmIQWflSTbRHPY2/GlBZvrTNN5yKnAYrov/sy5D4bvqFWZCieic
         cs4EFfXbZvugyqNUscyID5HQFVFFXadlZ2HiffpxYj3Zxc5NYE4IUwV58QfpLxgTwOEC
         Ofqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x6TbkfGprqxa7HuNnv82cBoTrvTLC5T+c/QpQH0AiBY=;
        b=BXyvP3uO+scsjBX5VHnTdnJpFHTrRrZyJjXeeKz55oMs/ULOx4e7Z9W3r2rivoF2ls
         n4P6KKaqunmmscOPzHgwIy6NblpP9eEUYPfHP7XMvPns/dIpePnAjymIlIffvPr7TcVI
         JdK0Jejru8YhcaJB6R36l2nLGBmYTLyuql7utcHiCX20Pve5DHMGAvj3hyp9PGe38OW/
         l+jpSJqhHjOcPzZzpgh/sL+SvCdML8wYYfA34jSLPQ6sb7vdXq94OxM9Dwi0UjA7eG7G
         bxslQ5qe/IEbI7sfSFrzJMR8LQhxoepJgeCWH/XA+fGjtmsS//rRW5SMvgkDw5Lqw1Qk
         G7Pg==
X-Gm-Message-State: APjAAAU64gc3NFmREO2zPLnNZ7QQEDc4pfo8LJD9op9zAEB0D9tzlVZz
        VhWCpAaDwNS+4kGxY1QRwjY=
X-Google-Smtp-Source: APXvYqw2YJ3VLRuleOmy2FZKo/sDQc7QtVZvRPn9irjxPqvxwtH9tfgL6T3kezZLlxntHuqxglYhTg==
X-Received: by 2002:a65:5202:: with SMTP id o2mr2984676pgp.199.1558710275891;
        Fri, 24 May 2019 08:04:35 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:59ee:6a57:8906:e2a1? ([2601:282:800:fd80:59ee:6a57:8906:e2a1])
        by smtp.googlemail.com with ESMTPSA id f10sm2378917pgo.14.2019.05.24.08.04.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 08:04:34 -0700 (PDT)
Subject: Re: [patch net-next 0/7] expose flash update status to user
To:     Jiri Pirko <jiri@resnulli.us>, Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        mlxsw <mlxsw@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <c4bd07725a1e5a4d09066eb73094623d8b37082b.camel@mellanox.com>
 <20190524081510.GD2904@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3c0703b1-21d6-edc5-1fd8-517c1bf9cc17@gmail.com>
Date:   Fri, 24 May 2019 09:04:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190524081510.GD2904@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/19 2:15 AM, Jiri Pirko wrote:
>> Very cool stuff, \let's update devlink docs with the new potential
>> output of the fw flash commands, and show us some output example here
>> or on one of the commit messages, it would really help getting an idea
>> of what this cool patchset provides. 
> You mean in man? I can put some example there.
> 
> 

and commit log messages.
