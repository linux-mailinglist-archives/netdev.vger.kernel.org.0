Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBE3177B6F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgCCQCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:02:00 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46942 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgCCQCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:02:00 -0500
Received: by mail-qt1-f195.google.com with SMTP id i14so3130516qtv.13
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 08:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zAOqfToqDKWy6aShMRT38IAQO8JodPjxo8ZTApO4Ajw=;
        b=Mx2xjJcWXiTcR4AvfOnW0L52HKyZjeU+HnLgk8DXimaovGGR9nCjl+1+2qQQ5IXleN
         2o/ftyY3wUMLCnY8zFH+bGB9K9wX8fpO+1tdI5JuD7QXXCtC9BVXuUIeK2gEuuUrPFro
         ABQqEeZxBNmfKh1kMLoI6ChTZW7O6qnJ9xxGHU7TcXW9735rHPd/BA/HnRuwYYTJ7AbS
         TA9ApgPvyL0CNMXt0Tpc5mMqLwOMadjH7KtgcxHyVbYLvGDhv/P3PXdaKr8JxbiuD6Cq
         +swPA5LskIUDyNf0uT/LNzxkYnuygh55ODWWu8zvVg0kIDxfEuV4Tdgk3d+LcTJqvcnq
         vNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zAOqfToqDKWy6aShMRT38IAQO8JodPjxo8ZTApO4Ajw=;
        b=oB+1n4ncBe9E38dRxRbfpHj4VU3g5XfgFYi6lzXNYRSKK0KpUsc655ir0HeoVCVlXC
         vpa1R36bndRIXMrSdUy8Blj+Z1VtQ0d/XpLIlWQtyPy2VngA2eNi6dbWR6ajKCV+z6N5
         mFK+MQgqZ9NmpIg98+Gy420upaTOJzgRMSkRiXi0JcU9UXMx7D+OTBwhyvAhEkKw+E5h
         a/O4hBPmbSzmGYyHU/oprMtSDqBhCPOmzL8XazCYdn070TMZT/GAYqjqgBDgLBTyNP+M
         9kuYQtqEBO04CymkSubnThEEZ63wq/ffVQ+E95lImSL6L0lW5P76yINE7r45v/Phm5Hx
         bSuQ==
X-Gm-Message-State: ANhLgQ2BZhvwkHkzw4Hdi5AekKFButgf42PSo/6j7OQI662YUcw0i/A2
        IpnTUouYtDDy7VXZEkOdjQU=
X-Google-Smtp-Source: ADFU+vuE/51vx66uEsEi4XHfS0PBQf1OzQjUZjOD6P5SXEI1XtxrnyhePp+NNiBzVqaQgme+gFwv5A==
X-Received: by 2002:ac8:7381:: with SMTP id t1mr4640056qtp.142.1583251319445;
        Tue, 03 Mar 2020 08:01:59 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29f0:2f5d:cfa7:1ce8? ([2601:282:803:7700:29f0:2f5d:cfa7:1ce8])
        by smtp.googlemail.com with ESMTPSA id q1sm7575468qkm.11.2020.03.03.08.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 08:01:57 -0800 (PST)
Subject: Re: [PATCH net 03/16] fib: add missing attribute validation for
 tun_id
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        Thomas Graf <tgraf@suug.ch>
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-4-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <464d9f7f-303f-da00-b309-5f9aa4794a41@gmail.com>
Date:   Tue, 3 Mar 2020 09:01:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303050526.4088735-4-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 10:05 PM, Jakub Kicinski wrote:
> Add missing netlink policy entry for FRA_TUN_ID.
> 
> Fixes: e7030878fc84 ("fib: Add fib rule match on tunnel id")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: dsahern@kernel.org
> CC: Thomas Graf <tgraf@suug.ch>
> ---
>  include/net/fib_rules.h | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


