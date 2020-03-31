Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5778F19A281
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 01:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbgCaXbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 19:31:13 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45486 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731259AbgCaXbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 19:31:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id c145so25119631qke.12
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 16:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1/vZ+j75h+hqrEeTFsh2AB5Ze9POSgnHZqJUEddBDlk=;
        b=mEA7Fnkm/q+J8My6tgimB2kiYjp/eH4SGz4x+R0o4yKDi+MaprhKfvFXrCKqyQkCBu
         LfAOVpgiJgowGbAsVJ4aXepyST7OtCPIp5reAs7Zo0OnDWdsyO5pRd60L35LFthTZyM+
         BLZCUFMEe1uBa5XEh6zUZy3DHhlXWt9x+28vvN3UVDkeLIh6uO8MStDfw5h3kOS7KA3v
         1RwwuORN1GhyZfslGZEcvJMmaFr940ecayVPDsAxEZR69+UkWR8aOzpw+0e8to+Gxa9S
         Yf4lVgt9BlbeEzY9LDu4XThOjkiuDq0l5zd4hUJiwU7ha4MKjF8TXrMONQ0fWcA4Wi60
         6mRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1/vZ+j75h+hqrEeTFsh2AB5Ze9POSgnHZqJUEddBDlk=;
        b=ODswH3OM0YFCifnWgGH8KtsZAIpwEoT/R/uw0ltZsV9eCoTPc80u7Bfw0UILPEVY/r
         TD7lgwUTChzjjvNkyycmX3Gm2TnJpzVNLD7dB9FPI+LDO6HJZdF2E+MvDNR5u4L1854f
         D1W2bYiMhbgNQyrSfnRfCHp1RvS5ywy6iGkylla4RJXFmG4ffOBN3gEtOWMPbKeu7/Zs
         0vsiTsYbVF6E6AvkRHF+YUZ22tL78YBeEXYrl9dSLCPbPQRFX/5Ovb8lcdCKsFsUhBNF
         6ubv742Qia2BzJ02aRYhiWAfGcCGQkLuCKKqKC008+6iHPGGr0guA3jmDhoHDXlQsvZg
         jDow==
X-Gm-Message-State: ANhLgQ1NYpBwTcY8Xorf0y9Nq2QnZwjolgQVAMQUnvpouSoTfkjTBLid
        ktB54z9tKnkEirfhEDO/Dgk=
X-Google-Smtp-Source: ADFU+vs63e1azyki1jQkM4gvG0V+qPyjDqXcBMe35X8E4WEgFrIEftb7J419p+WR41Kh17em4c7Nkw==
X-Received: by 2002:a37:9d4a:: with SMTP id g71mr6532823qke.54.1585697471579;
        Tue, 31 Mar 2020 16:31:11 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:8cf:804:d878:6008? ([2601:282:803:7700:8cf:804:d878:6008])
        by smtp.googlemail.com with ESMTPSA id n74sm281247qke.125.2020.03.31.16.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 16:31:11 -0700 (PDT)
Subject: Re: [patch iproute2/net-next v2] tc: show used HW stats types
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        kuba@kernel.org, idosch@mellanox.com, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        pablo@netfilter.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        paulb@mellanox.com, alexandre.belloni@bootlin.com,
        ozsh@mellanox.com, roid@mellanox.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com
References: <20200331085031.10454-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6e124844-4c3e-1097-f790-2949f053fdb5@gmail.com>
Date:   Tue, 31 Mar 2020 17:31:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331085031.10454-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 2:50 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> If kernel provides the attribute, show the used HW stats types.
> 
> Example:
> 
> $ tc filter add dev enp3s0np1 ingress proto ip handle 1 pref 1 flower dst_ip 192.168.1.1 action drop
> $ tc -s filter show dev enp3s0np1 ingress
> filter protocol ip pref 1 flower chain 0
> filter protocol ip pref 1 flower chain 0 handle 0x1
>   eth_type ipv4
>   dst_ip 192.168.1.1
>   in_hw in_hw_count 2
>         action order 1: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 1 installed 10 sec used 10 sec
>         Action statistics:
>         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>         used_hw_stats immediate     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> - fix output then hw_stats is not "any" - add \n
> ---
>  include/uapi/linux/pkt_cls.h |  1 +
>  tc/m_action.c                | 10 +++++++---
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 

applied to iproute2-next. Thanks


