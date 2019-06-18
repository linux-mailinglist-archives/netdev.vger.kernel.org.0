Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155EA4A54A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfFRP0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:26:48 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:47089 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfFRP0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:26:48 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so30644178iol.13
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o8i76n9aHq38Hesq8UK/ZA1ak6WuqcRjfXVYIm67I0M=;
        b=KCLB/ptIyP++CpV9/qOq+GpgEoKlAbL7npLp4UdKkdbc0JwH0eQ0X+W8AeweYJU2eL
         9RkHOZRzyoxb2VUPGYlPz7UsJCc0h97C9YwsRwLQPZgDF9JrTD1UR2Oc7lm9RHrpyDun
         ScjlN2h8U8frSxLuE7LTrNlq6SJxpvGgn+m+JjeDxSlEV5BHk5II7gaHU73BcJ/9TY55
         ySMTIU6BYVi9bshBrptNGOkfZyhKJ8ZVGunUki5BhYo4z7BWnoAWDrIAVE0pVthRNMfE
         BV6nv5ClHw6gEotgID/IlRwpZ4nq4J16dP6DIoBw5GyvKn0GmY8MNDcmt/Kn1n18oQz3
         8+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o8i76n9aHq38Hesq8UK/ZA1ak6WuqcRjfXVYIm67I0M=;
        b=e5iBD4nwE94T8ACpKMguXsmEKbS4N6AjWbCCRoH4SuCwU9RTatcZjpcQX5PbV8/uFk
         F0TWzqKi6RLDZovyZTSjDi3BQDtsvT55S5jaW3S7Rql5AXlCMMX/R860dCnvUZkou5RV
         /DTuqiX9DPkDtjITGv2xu1/t+YoTgjTuO9WMvWfXDM1/ZcaDzP293Q8vcVVkTi1ZPy6x
         8Q3PUwKlsnGsRuveffDg/6UDFZxNdVJ2AHdshQA60JQbLIjZHdihCcVyUe4puWT3yKkS
         S5KD75B+mg0R4/aRRyH6LsI37wPYhxc9IlR3MxJmh9/kqBh1xkTywHvQpXg9a3ZDaTKt
         LAWg==
X-Gm-Message-State: APjAAAVJuSOIcSnUsRsy1VQylwbURf37YW8r618MrwKuPP8bLD7XkTvH
        w7RmQrORzkvsJ7rpWvj01DI=
X-Google-Smtp-Source: APXvYqwDTkC5CK18gh5Hfs9M13srbLOIuzdLQB3bkgcy2qAtanHTsxLfnCrITJLVeRRSXGAuIM+65Q==
X-Received: by 2002:a6b:6107:: with SMTP id v7mr21823123iob.154.1560871607648;
        Tue, 18 Jun 2019 08:26:47 -0700 (PDT)
Received: from [172.16.99.114] (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id x22sm12643361ioh.87.2019.06.18.08.26.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:26:46 -0700 (PDT)
Subject: Re: [PATCH net-next v2 03/16] ipv6: Extend notifier info for
 multipath routes
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190618151258.23023-1-idosch@idosch.org>
 <20190618151258.23023-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0db23bfd-5c59-657a-8599-22c3f94875a5@gmail.com>
Date:   Tue, 18 Jun 2019 09:26:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190618151258.23023-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 9:12 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Extend the IPv6 FIB notifier info with number of sibling routes being
> notified.
> 
> This will later allow listeners to process one notification for a
> multipath routes instead of N, where N is the number of nexthops.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/ip6_fib.h |  7 +++++++
>  net/ipv6/ip6_fib.c    | 17 +++++++++++++++++
>  2 files changed, 24 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


