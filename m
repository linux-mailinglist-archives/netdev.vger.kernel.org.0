Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269E32BC8D0
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 20:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgKVTr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 14:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgKVTr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 14:47:28 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BBFC0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 11:47:26 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id r17so1969014ilo.11
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 11:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=20H7uO+uyiXmT5yjZaPBrlVPSQMOtGYJYvchr7l1seg=;
        b=E59FyahI0/fNJUxgyYJudNbW7H1rJyuZMtFPiVSaJijbbyVzOJ+uxP0jIVhY89z9L2
         ZMS1a5X9O2VXZWdpPoqfN75cQ1fWag7q+Sd+YwNARRWQkG9A9E+tL/AE13aC5f412+BJ
         4/rXJUzMDhbvD1+qspND2dPfPWBqZGfS6JrQeb6lLYLXfBkkXbzBrhpFiQMK5T4E63Ve
         6WBOWk+hUE9JYWBcaVxtDQSbfAhYLpoNkW/DOvOUiE0CiZXNjNZb+woZCwBEmRaSAWyo
         PgHyEoJijP+WBgd9wBV7CWDf/dElsKjheCutXjPjBSyhORK6zK8NtI8QhKPERKI4G7GE
         eTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=20H7uO+uyiXmT5yjZaPBrlVPSQMOtGYJYvchr7l1seg=;
        b=te0qa/IfnzPzQM4vKOj431srpDCvQVHlVpxWJB0pn0DQ4wccT+vxC24q4kLk76Vxbb
         u57w94YD5xNufXn8Mmt6GfaFj1TDXpPFVRG6iJwW/XD1VD0Pym5e8uwVDj/9Icar6okZ
         6XyLYQuv+V6pdHpNRrNe+dfk7y7mgFLYjgaJgQh/P/nQ+sS0939JHOowE5zb1H0DGf3t
         DJerG1jXteBQceS38NSfKfzKeyLNC+5l+6/3PcJYMpbJpvLTNFh2GyNCX9cfxCEGNuSV
         H0ulK4H1ECw3MzZpcmt6IRrLNjwA7oqSfrKuyHg4yVPMPe1YO6EkBGoMv/C7rq2a8WsX
         H/qw==
X-Gm-Message-State: AOAM531aVVTUyJCCfiBFawt0G6TN67+5bsomlQbJqz4Hcp7mIEa70ur/
        OhK65yQwpm7mzZrWl94n9uA=
X-Google-Smtp-Source: ABdhPJxhdshxSzu6voH43vbt3PRzhKVB496uNn1wfEhcJh4VTZSt0P0e4iRS0GsKvkCh0g+TtrQJmw==
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr3826850ilt.42.1606074445666;
        Sun, 22 Nov 2020 11:47:25 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:4c6e:ca88:2712:88ad])
        by smtp.googlemail.com with ESMTPSA id t12sm5156893ios.12.2020.11.22.11.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2020 11:47:24 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/2] ip: Nexthop flags extensions
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20201119135731.410986-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <335227b5-56e6-3312-d090-84d2fabff32b@gmail.com>
Date:   Sun, 22 Nov 2020 12:47:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201119135731.410986-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/20 6:57 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 prints the recently added 'RTNH_F_TRAP' flag.
> 
> Patch #2 makes sure that nexthop flags are always printed for nexthop
> objects. Even when the nexthop does not have a device, such as a
> blackhole nexthop or a group.
> 
> Example output with netdevsim:
> 
> # ip nexthop
> id 1 via 192.0.2.2 dev eth0 scope link trap
> id 2 blackhole trap
> id 3 group 2 trap
> 
> Example output with mlxsw:
> 
> # ip nexthop
> id 1 via 192.0.2.2 dev swp3 scope link offload
> id 2 blackhole offload
> id 3 group 2 offload
> 
> Tested with fib_nexthops.sh that uses "ip nexthop" output:
> 
> Tests passed: 164
> Tests failed:   0
> 
> Ido Schimmel (2):
>   ip route: Print "trap" nexthop indication
>   nexthop: Always print nexthop flags
> 
>  ip/ipnexthop.c | 3 +--
>  ip/iproute.c   | 2 ++
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 

applied to iproute2-next, without preferential treatment.
