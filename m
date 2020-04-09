Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAB51A361D
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 16:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgDIOlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 10:41:53 -0400
Received: from mail-qv1-f51.google.com ([209.85.219.51]:35926 "EHLO
        mail-qv1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgDIOlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 10:41:53 -0400
Received: by mail-qv1-f51.google.com with SMTP id o15so3044588qvl.3
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 07:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AGt51fCUmTCQ39mrPGg/jjVN/bvOOZC3RoFBrA0cylY=;
        b=c3mxhpwjWgaD5mvExDuW8pCsIbfB9AcDs0zT8Zyxk080AgqeT19YCQWorkVeJHQAC9
         R7A+rUWhv48JMPcZp74wQ3kJiAAC5RBWdFbcqJR+ADbibdySJK98bj0fqvaoIyV41I6h
         sFOddYxGGGItVvEny6XOvv14hrW2pm3vEh/Ga1EPZXq8ds3tV/a8Ae+VN6iDGCXnBGps
         OhuP1HcfMwIiAGVWD+5iPrcZSy8MYk1rYRfsqQpyt00UHtrAvmJk+CuoY5rxPHsPCDB6
         NRAMmaWVvyxTxMYsQKY5X+vrH8Z8qpVyRLHsii89S4iTLuE30gOXBjORebmXWX4YlhoH
         X4LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AGt51fCUmTCQ39mrPGg/jjVN/bvOOZC3RoFBrA0cylY=;
        b=I2tR3QGI8Gz3zsAJcWMIHhIelS+AgPl7xjprA4+oziyfrezFO76DK0yyx/ZZFgRya1
         B3CL7MdZGHlJJZjkIzz01yCE4aLwa7swypVZ19A35z7YV1EXwzKV/DrKKGpA0sKu/XJ8
         rimG3NLrobw0g5YCrM+ewU111zMUGg/EVsBkoXXq2TUqFPKmDBRNRvF7ggq15hsFxF98
         CiGOMOapBuOesNFYkLmu0PiFaE05YKFbLXhG6iiWhfrKVO6q6RpIEoXtMmklD7u47ySN
         7DKmJQ8XQgkbCqrrRZOu7BfIJt0Xn536jFhWMRqFGz+464Uw54aOmfAqrzadc/7N31PT
         rVeQ==
X-Gm-Message-State: AGi0PuYltru96PkcCerbXqjd/L75f4LpmW6dHLhoaQDttqKHvRa1t5jn
        bFBPiK5vSQz9oJ/0xMT5+JGkih8j
X-Google-Smtp-Source: APiQypIKo+Hlwsl7YEx7x3TMchA3sZ8Ab4qlMZaJIJ/wnP/zKMt/LP4hsgs5LifMs+7xa1WgGoaqvQ==
X-Received: by 2002:ad4:4993:: with SMTP id t19mr309029qvx.197.1586443310859;
        Thu, 09 Apr 2020 07:41:50 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:440d:6925:c240:4cc1? ([2601:282:803:7700:440d:6925:c240:4cc1])
        by smtp.googlemail.com with ESMTPSA id o33sm4903363qtj.62.2020.04.09.07.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 07:41:50 -0700 (PDT)
Subject: Re: [patch iproute2/net-next] devlink: remove unused "jw" field
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@mellanox.com
References: <20200402095539.18643-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43c9b4dc-5c4b-afca-5f4b-389c465a9e5f@gmail.com>
Date:   Thu, 9 Apr 2020 08:41:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200402095539.18643-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/2/20 3:55 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> This field is not used. Remove it.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c | 1 -
>  1 file changed, 1 deletion(-)
> 

applied to iproute2-next. Thanks


