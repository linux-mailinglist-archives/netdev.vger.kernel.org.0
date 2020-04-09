Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09CB1A3624
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 16:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgDIOnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 10:43:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34756 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgDIOnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 10:43:45 -0400
Received: by mail-qk1-f193.google.com with SMTP id i186so4184535qke.1
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 07:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QvayCW27oh01f91WesyEICdhphF/ReoLLXfa/JIiimc=;
        b=rJY1LtgJ4WZMFQojNw1bGC8eYIZTlAGU+DPz6tWZG/ha4z4Td2BjIjuHrxQWLBoanW
         WfvpqCZmpD3BGDmg5wKZbLQrtvHZInoS7EA+1RVWudNXxvHMM6AR2HvNPu1CQYwGx26E
         TALed/TD8N3BQApjaRZ115YUy1SPZxutQ2lnZoTjBSXGK+3fG5HQr6B0l5vMdC2U6Kha
         j/htpnBD+gDTIRa//GCIsxQ8kngzvIsHshmvWQjM3Ips5wnsFCbLFoCTjOYwqBVt3fkL
         ZZeVYysh0IlDfNXKLkAuh7W4z6LP4kbMeLGRdVxL+S7VLOmXzTNKyDYYDjJzDnDIUvyO
         G7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QvayCW27oh01f91WesyEICdhphF/ReoLLXfa/JIiimc=;
        b=bPAE0q+bs5RjcyPiS88wvZXkNNLt1I9avkgiYBff3l1WzWfGqq1xqWSZDQNEn8qQqg
         N/1/AvUusYcifLyH19Mz5OwTdiq9jM9iSRt7/70W+O1cBqCbX0Pm0oGaGgHbNg0Irh0t
         lqaKwcSspl4tqc3f8/QvQ9UWTKAT5btjrATBm2uPxPbdOMHmwQ+Z2Csfsl57U5w0wmN8
         fKnvU4dBiAvhJuThlWY8PkzNj9flTsN+RKhZRBX5LU7QrSKNIW+I7CRfngrPiM1E/1z6
         tjeXokeguDPHhye4gsg7XCW+3MezcJmkS95yoirR16EkCuirPvWEZ5dhcNh84fqJxD/z
         VS1w==
X-Gm-Message-State: AGi0Pua/gHy4mIUSK1UT4V4weQn/XXjXv2ytHlICTAnXlBafM3XKp/uD
        xfeWeu7S5YnnT5CR3MQgY/ScrO5L
X-Google-Smtp-Source: APiQypJFw5czOzGICHXw3dqVutgobR30OCfAqJEJcZ6Lngb9aFrkgXvUtXkIzVI5LOIWzW97sahP+A==
X-Received: by 2002:a37:af86:: with SMTP id y128mr92503qke.429.1586443423790;
        Thu, 09 Apr 2020 07:43:43 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c4f9:1259:efe:b674? ([2601:282:803:7700:c4f9:1259:efe:b674])
        by smtp.googlemail.com with ESMTPSA id e7sm3905672qkf.57.2020.04.09.07.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 07:43:43 -0700 (PDT)
Subject: Re: [patch iproute2/net-next] devlink: fix JSON output of mon command
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@mellanox.com
References: <20200402095608.18704-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <11d5b161-80ae-e006-9ce1-e9d04a99a021@gmail.com>
Date:   Thu, 9 Apr 2020 08:43:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200402095608.18704-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/2/20 3:56 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> The current JSON output of mon command is broken. Fix it and make sure
> that the output is a valid JSON. Also, handle SIGINT gracefully to allow
> to end the JSON properly.
> 
...
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c | 54 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 2 deletions(-)
> 

does not apply cleanly to -next

