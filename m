Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2D458DA
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfFNJgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:36:52 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:38952 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfFNJgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:36:51 -0400
Received: by mail-lj1-f171.google.com with SMTP id v18so1699702ljh.6
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 02:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ru2KSQjfyG9288qsJetfF2O9SvqawPcSFTT52wjTjs=;
        b=rill1V7zPm3369J2G1xukVBwuLYUPZ0AfIiWAjtr+WDLla1spYhUr0tZSHabfruZhe
         nN9t+aljv9Gh6YrRFm+xItS1mTjHyqMU/U4SB+uUW1Sxu7RQulDmEzGgYtNz/WzQsscg
         wv74JBuhnRTWYoLpDitFQ9DbP3Mo/I4sGQ0cFte9kjYnQFpLw/T9YHPOB7kBZJOQPv9j
         wl2OyPiRKiNdXpl8i2LNhvbo00OB1l2FHUEuWr+FXzY2jFFRjja0lyFOE8JwncTa+QeS
         X3nRLQeikC74DtsQ5VOQY/VQhZNJ7k27T3SZg+GY7qZf3sYA1wwW96rVkyPhjlN/3M0h
         JV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ru2KSQjfyG9288qsJetfF2O9SvqawPcSFTT52wjTjs=;
        b=mqjzCfovTCsAzM0N6jvOHqunl37U2KnbOWKfKzYqsOLyCG3BUk8rqIXAbODKOcV+G5
         OaLxt3Xe6JsdJutWOVMeg6jJd01FiHAIdQZERZoAB7b37SGbMtSGvxC08liw8zCQboGK
         oNC8x7Lq9Bmg3ozYQRpZtBAFONkAGcT8TDAxHC9pBBv0SoJi2sp1/t0hpV4vw3+CNxVO
         j8mnRz4851mceb/ilddm2kDqWYu7SeRn2QjKGEuZCwmMdUS/4GrDtRidWphGDLjSA86p
         5XnsW/6wR0xIZCYIm6a9O5itDWpVFWBbn6Oof91ZxVKyLCNSI2XkiwcBtlRIK0/u1doG
         rrZA==
X-Gm-Message-State: APjAAAU1ojGbnIsTYpVMAK/t2sVuIvtv8kU46tSR6xoWE6PyvjzzYoRI
        +yyTmfz4U0HDYaWrZGVYViD+2w==
X-Google-Smtp-Source: APXvYqxFQgBNxUCEDpj1WI2mbKNdN61Z89wiiaBJfiGOme//0IPecMYP63mygyJVf8RKyZznoUIzsg==
X-Received: by 2002:a2e:959a:: with SMTP id w26mr3889076ljh.150.1560505009702;
        Fri, 14 Jun 2019 02:36:49 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.84.143])
        by smtp.gmail.com with ESMTPSA id g19sm541675lja.9.2019.06.14.02.36.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:36:49 -0700 (PDT)
Subject: Re: [net-next 12/12] i40e: mark expected switch fall-through
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
 <20190613185347.16361-13-jeffrey.t.kirsher@intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <32dbb5fa-7137-781c-c288-88055d0cb938@cogentembedded.com>
Date:   Fri, 14 Jun 2019 12:36:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613185347.16361-13-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.06.2019 21:53, Jeff Kirsher wrote:
> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> 
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> This patch fixes the following warning:
> 
> drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function ‘i40e_run_xdp_zc’:
> drivers/net/ethernet/intel/i40e/i40e_xsk.c:217:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     bpf_warn_invalid_xdp_action(act);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/intel/i40e/i40e_xsk.c:218:2: note: here
>    case XDP_ABORTED:
>    ^~~~
> 
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> This patch fixes the following warning:

    Gustavo repeats yourself. :-)

> Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
[...]

MBR, Sergei
