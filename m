Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E47A1AFEA2
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDSW1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgDSW1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 18:27:19 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48882C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:27:19 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c16so7045618qtv.1
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8WDj4r4lW92u+BbLZkB2kUa1UnOds/fvPqfz/8pmvwg=;
        b=V4OppS8vsmsyAfQrLTJ1XNb2f7Eiu4HwUKWwORRtHnPaXLMbZRCOS+lFYUsHnmJDX3
         tSjjp/Te/NuTKVeRr7VUN0BYYe02Y0ACzRa1GXxMo25oFxq37brx+vz74LKc1sqOQNwD
         kxkPw/t0lYr8xQ1mEfyv5nNwu/4SVo+nPMuPhL0nuSNgwSsTwDAUACSGKKpOoS3PlMXV
         v1rI5daLbHH3bqyH25K0+1iYacZD6JlQW3fIrH/YVg9R1jKyutYGzy5gJUw4BJ1hm77P
         /wMNX2TX0jve9FfXE2bybv3jiebR+b//0qYLokFrrxxINnIBKmm9WwmaFt0m8ZKlVm7S
         Q3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8WDj4r4lW92u+BbLZkB2kUa1UnOds/fvPqfz/8pmvwg=;
        b=KPyEieceIySgn6X8fff6dMUC+O4i1T1fF0vCFmVGyVqLUDNnghj8KQ5wyBxlbKgOfz
         j9Ss8mYt9gG6vhIlgnqEQM5WwV4U6xUqAZyRbmLbjWps8K0veWpYlBzIaf8NHRM6gvh5
         Q3lRl4UcFrnGWL/IRKLLbQHs9IeBvZ4AFSzRcEvZo9JMThkfGvOpKy+pua0BR4SEvh72
         Gd386SoMq0KafKdl1cYXYjoU3yKfUGC+/lMYshpyPXUml3VCJS0vO7NeKnTQ115eojeV
         XatJu46AOfPHuh0Q93iN3TXZePclJUHbxjfGkMw88b1j3iIE+NyWJeuBu0jzcd/fcvb5
         bEqw==
X-Gm-Message-State: AGi0PuYbLKOALdzoi+PdyMzUanottlrXbeNYQfIQLCeqpSO/dPIV+ppt
        zEeJjTIT0HT3xZmVSy9zZbc=
X-Google-Smtp-Source: APiQypIePEsQ29f9duJBwbVkAqiCfXn2SO820h1TTxAWs7JLuvJL7JVRaJTYIpISuGRLgtrTBdALTQ==
X-Received: by 2002:ac8:71c1:: with SMTP id i1mr13306159qtp.280.1587335237780;
        Sun, 19 Apr 2020 15:27:17 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id d23sm18219941qkj.26.2020.04.19.15.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 15:27:17 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] devlink: Add devlink health auto_dump
 command support
To:     Eran Ben Elisha <eranbe@mellanox.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Aya Levin <ayal@mellanox.com>
References: <1586847472-32490-1-git-send-email-eranbe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <934bc85f-1dda-0216-ae23-402d67c57cd1@gmail.com>
Date:   Sun, 19 Apr 2020 16:27:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1586847472-32490-1-git-send-email-eranbe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 12:57 AM, Eran Ben Elisha wrote:
> Add support for configuring auto_dump attribute per reporter.
> With this attribute, one can indicate whether the devlink kernel core
> should execute automatic dump on error.
> 
> The change will be reflected in show, set and man commands.
> 
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Reviewed-by: Aya Levin <ayal@mellanox.com>
> ---
>  devlink/devlink.c         | 19 ++++++++++++++++++-
>  man/man8/devlink-health.8 | 11 +++++++++--
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 

applied to iproute2-next. Thanks


