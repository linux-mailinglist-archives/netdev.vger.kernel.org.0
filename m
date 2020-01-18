Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047921419EA
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 22:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgARVtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 16:49:13 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36541 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgARVtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 16:49:12 -0500
Received: by mail-qk1-f194.google.com with SMTP id a203so26461815qkc.3
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 13:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p2kPBvUCLyyMbNmigVa80sF/0tPf9kJCYsNheORe8W8=;
        b=CqDNZ9dYcSWqmGG+r4d0A6bxCo86uqtkwQ8Xbh+xPKrFPdI4s4293tVpZi3AWhgS40
         KVGy1d9KK1AJx6klBinc5JcDCdlM0EevvWe6/W4EVIgqWltCxlfP5IODBzMjs+f5t0dF
         sMAyhJ9xrhwzmKhCtxtRqeG9ZzLvccbmgUeNIsLuXIjSXAU4memtSP48k8EkNZq85Atf
         LrF4WUS1p2wnC8a+xWbrKLO5nUD4OctGiJ9Wn9NUuYto4WOucvMO4FEhGmwUntSXZMGP
         4Vi6wFdLXcZzjk8OAacCHBINjNGeFX0CDyebWhZXxtSmhW8Q/G6Jdgbv1WN9kZsEkK6R
         2oUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p2kPBvUCLyyMbNmigVa80sF/0tPf9kJCYsNheORe8W8=;
        b=MTzzZvIx1JGlczVwnQLqu6MPeEXy1oA7MMTyIxKBNfLGSqpNoPBUCf0Lajd4eKzFmP
         WfHJYYjiRvLSsbGbUuvtXDORbUakJrpXseDO0cZFXueAgdxSrRPuADK2yeBAOenzZIgX
         bQh7XWZezNxY1wZZxaOR8kyF+EJQrhvtnEvEwyukU1bElvxmdWB8i96JgSZfv4bGpiLI
         CBC7ZbSz6o1TJZQOFTjRwgWuedPFK7BLm+blpUhOK9tUlLp1yhdeIfG2Xvx7nC54LkFP
         pIe57kmywyr76bx8XPWmbU48v2+0D7uV2MS1dgGTObMsDU1vugHjwpRrNQfON/uI3ua9
         qWMg==
X-Gm-Message-State: APjAAAW15vNt9MJ1UEaUu98eRauDci5xZLxgmypVIf8mEJ01FaJEF9a0
        drEapsAg28w08NdzYqnvxUg=
X-Google-Smtp-Source: APXvYqyPbampR2+5hFhtthEOVeqtBy+Fs96c5nYo6i17n4W8mm7C+/iJWglQUki0Rsef0vdyG5OtQw==
X-Received: by 2002:a05:620a:136e:: with SMTP id d14mr36823556qkl.263.1579384151702;
        Sat, 18 Jan 2020 13:49:11 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:61e3:b62a:f6cf:af56? ([2601:282:803:7700:61e3:b62a:f6cf:af56])
        by smtp.googlemail.com with ESMTPSA id w1sm15438724qtk.31.2020.01.18.13.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:49:10 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip route: Print "rt_offload" and "rt_trap"
 indication
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200116184348.1984324-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08ac439a-6530-7feb-5eb8-ba60bfa92cda@gmail.com>
Date:   Sat, 18 Jan 2020 14:49:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200116184348.1984324-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 11:43 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> The kernel now signals the offload state of a route using the
> 'RTM_F_OFFLOAD' and 'RTM_F_TRAP' flags. Print these to help users
> understand the offload state of each route. The "rt_" prefix is used in
> order to distinguish it from the offload state of nexthops.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  ip/iproute.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

applied to iproute2-next. Thanks

