Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B3948361
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfFQNCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:02:01 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40516 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfFQNCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:02:00 -0400
Received: by mail-io1-f66.google.com with SMTP id n5so20870853ioc.7
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d/Wnz//4u+E7H5TwVipn8EO3vMmnBwpzx+NDTeof1vc=;
        b=X2T3up67tQKZU6BIACc2rYH2hC9eFS9S7FtYM1lLE9TNdbbCaRkjnGFAAkEd2x5dYL
         FxjBCggyTgKHaS8jMq6Dar8ISYHPkS6bFmEQf8xBzYnBJprokdh2DvA7CNw/mbUgYMV5
         EEZZ9WTECFByJVAA7sC5oNqMEtXG6dMqcWmhsgjzeUZcdXLQLovlxZDQyGI0z4dC4wgj
         sBX2ZjCWfNkbGnamz8M35fgD2qt6EDinBqKSoeuWlvIcr2M4lpIJ1VaCa7mbONwvZEGZ
         IasQhEnZlSw1prVMJuGCNM37BhbLp0UA4mjOLJ2vpnZx3xJPKqSzuW9qKD0IBGF4J9ag
         PXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d/Wnz//4u+E7H5TwVipn8EO3vMmnBwpzx+NDTeof1vc=;
        b=Nr5nn69YplEwPBPm1jj+oPfOOH5HbsOhIdzN9EUzER44G2OQxnd+cbWX1fjmUGVxCL
         YHYbHTm5jn4p2RprdiIevVg6IPzPZyHBpTCT3hOQyTpIcmieYixrekZqAHMFKC8xNNNl
         BcJcEUTHp6+FTREsmJGG8RT8dHDjPc6lk6di5ud3ERPbDPPIllU+slZ460XS867W49ab
         TPl0j0N0Yf9e8KMDQb5f3g6Ij4JhQlU3Mgwaaq9inAcsvoQJ6ildy1PoL3MCY/ZKXq+Z
         AhmYUrJHA394py7OteM7JgxhGE/T3KAlRyC5GIo4PFXxdqU9iddJEMCGWfEJf5RQRApd
         gFrg==
X-Gm-Message-State: APjAAAXn41LeZjW7jJ49BES5IXzwpVUzqRYU9VJez5+zFeAUmAKHbrP7
        boaJhXHvX9u/Al9WIOSQGFE=
X-Google-Smtp-Source: APXvYqwoDXnlNyhe1EJXjFxeLqMU8fow1DGboQzRe5iAA10Ofk8kHJK8zI44vHFxapbI/cZGFehI/w==
X-Received: by 2002:a5d:884d:: with SMTP id t13mr1945876ios.233.1560776520161;
        Mon, 17 Jun 2019 06:02:00 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id k5sm12153357ioj.47.2019.06.17.06.01.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:01:59 -0700 (PDT)
Subject: Re: [PATCH net-next 06/17] ipv6: Add IPv6 multipath notifications for
 add / replace
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3c187b2e-e727-ab7f-4862-12b71eae4825@gmail.com>
Date:   Mon, 17 Jun 2019 07:01:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615140751.17661-7-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/19 8:07 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Emit a notification when a multipath routes is added or replace.
> 
> Note that unlike the replace notifications sent from fib6_add_rt2node(),
> it is possible we are sending a 'FIB_EVENT_ENTRY_REPLACE' when a route
> was merely added and not replaced.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv6/route.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


