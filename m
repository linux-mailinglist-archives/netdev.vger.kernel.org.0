Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D56699461
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388816AbfHVM7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:59:05 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41777 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388104AbfHVM7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:59:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id g17so4972361qkk.8;
        Thu, 22 Aug 2019 05:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hgTctn29ieSv42p2+UtUFKnO4/1RmHVD+YhjeOyxIkc=;
        b=EWkmECElqhtsrNcDzn/8gJrVEyuTH1LM8EeTirRu6j4hw16YSC/ShSf13iIJwM+lEg
         HI/Xaa/mIQzx03+OV+jZ+yMvTsNOBugf9QgcSOvSVz0seHqgETn9XdwOCDzSDrLZ6QRM
         P4YoY925I+dUFpyyC06GaMWTWaqIAub97oqThKyygb1GxhcVgqELF+vBZcHIQbWBfBZn
         7KPN/hjwmh7dvVkRTJsYeOtmNp2q0y5HRas9Tjld0rTRzzM1zaNuLa8Pgm0gXCqfs5RM
         YE7ec9stdw3EuNcSvywrt8gxcIFeMlsuGAdWqfuiVhM1rfgY3GUxWel4kC/OcqdVUGT7
         PJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hgTctn29ieSv42p2+UtUFKnO4/1RmHVD+YhjeOyxIkc=;
        b=YEY1u3DhsUoLyJKFSdjL+HQJONJ+No93TCku+54V5ltA7k0p2UG1prmB142fn4OMTP
         LqeUB/9srZh1oPXDWurSJ7NiWg0jL3tfHADZ5c9SUy6Wo7c0Plh470p7EAIxikAwOaqA
         u/49ZaFoy//Pt8EczmMUZScP5U3vaeJUS+a6WjepL5KB1FkUAw/HWma6Uq9IIH6WoH6Q
         e2+BUnZ7vXpuH7/yu1VyRmvHWNaRb7j1tTdVhuFiv4KX7Eaixn6p3ECbaGa2gnMYn045
         +Ahmkgc1q9zuUFUzgBFPRQsRPR3BGRqd5CYKSlY599+ISNn6J+rJaLJ2ha7rplR/CNGi
         6xcA==
X-Gm-Message-State: APjAAAW7L5p2lDwdKJvfimLxCHOeIdoJGWUkgmuFoppZmXuVOIqUb7OW
        wGa+W9YPSLBOQak3UTnQoDMplboa
X-Google-Smtp-Source: APXvYqxBzrFOaOTMQLkBXGPUP5i5IIF1I2NgcDOCjyFnzR2FN1V85TTPRbD+YqOZ9Zssy9F1QgDVjw==
X-Received: by 2002:a37:4dc5:: with SMTP id a188mr35732368qkb.206.1566478743913;
        Thu, 22 Aug 2019 05:59:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2604:2000:e8c5:d400:18a2:a8d5:6394:8e1f])
        by smtp.googlemail.com with ESMTPSA id n66sm11210601qkf.89.2019.08.22.05.59.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 05:59:03 -0700 (PDT)
Subject: Re: [PATCH] nexthops: remove redundant assignment to variable err
To:     Colin King <colin.king@canonical.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190822125340.30783-1-colin.king@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ad6d4f72-c299-5704-31ee-a300c9c67396@gmail.com>
Date:   Thu, 22 Aug 2019 08:59:02 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190822125340.30783-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 8:53 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable err is initialized to a value that is never read and it is
> re-assigned later. The initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused Value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
