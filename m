Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64F81C18C6
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgEAOvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbgEAOvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:51:31 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AAAC061A0C;
        Fri,  1 May 2020 07:51:31 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q7so9450583qkf.3;
        Fri, 01 May 2020 07:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iSF8qkyzOWCTJWVtIv/KwIUFYxZnWd76ArT3iSBhPAs=;
        b=aBwfdaI5kzqFOE6foEl5YSlIVohmWNm0VSsIsIyw4DoiMSb3trTNF6MW5I/8i38nBr
         7o+sjRUrSMrqPTvIszk/NBk8VotsDFZEVWbCiifR1tjPOyo/m2+yvRcU5Op9+yISUm4O
         1CLZuOpLy5YmuwieyEqX6DA9nnC5t4Cu4G+NtqYdW+k+m9tyPhkabzK2Lic6avfSwS/+
         LMQBUFFVgOGppTRBj5i4IBwBh3Bdz8WycXWW26g5Zi8n1M9vK05NzB1f/Jd4QqUF8qLu
         rz8HnO5ev46glsYThvSyfInERjfIS4ANRphIDFSyerbzu1KHQvTORObBZOa97jgf1TKD
         7fdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iSF8qkyzOWCTJWVtIv/KwIUFYxZnWd76ArT3iSBhPAs=;
        b=jtiN3ntbh1vqUGkrSkktC3jeRD3Sn0Ds5PPq5cRTygL74nWUdg1PrGAnF63Dl0mjcg
         K9h+6yTAqkfKFNAr2Z6kAzPNLLxOtiIp0IAE6PV57j1j8lfFmilEtN9roBm7gI292H6Q
         n2AAddEmzn9xvRnkkFZIt87pF7Ebs8lWGSj3D7UQ+JXje+0dqUAE5Ia7EufmBle8k160
         MCELoKilg9jckB1AZeiWjhbl4tkGTTS1dbxCbIIFnTTh4fMPkzUm6uCSD++x80io6424
         5IB/vAutjHAzQkatFcz4EL/4BibrpvPC1o6ZtXt+hCBeW6w3sE/X2Tgb25Yub8pNcRTf
         TrrQ==
X-Gm-Message-State: AGi0PuYAB5h9QeXz3Ue3qmxREPboQNoOPpm/J0qHdNxTGS3UNza8m8+N
        pKoMaLuO16SCBUWUpG+YBVTJkWiy
X-Google-Smtp-Source: APiQypJIa6cdu+IKsx/LXE513SnU1kaYCk/ynYtFDjRz9LKo3QE4dI5s32VnrTFjrTGNvTQVBn7okw==
X-Received: by 2002:a37:b185:: with SMTP id a127mr3829339qkf.87.1588344690768;
        Fri, 01 May 2020 07:51:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b01c:ec8e:d8ff:35b1? ([2601:282:803:7700:b01c:ec8e:d8ff:35b1])
        by smtp.googlemail.com with ESMTPSA id i2sm2791303qki.54.2020.05.01.07.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 07:51:30 -0700 (PDT)
Subject: Re: [PATCH 03/37] docs: networking: convert vrf.txt to ReST
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>, netdev@vger.kernel.org
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
 <af2ba2c29e8dfa9fb66dda16311a28a9f7c8cf43.1588344146.git.mchehab+huawei@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e6de21b-c26d-8d76-901d-f588575c3b0d@gmail.com>
Date:   Fri, 1 May 2020 08:51:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <af2ba2c29e8dfa9fb66dda16311a28a9f7c8cf43.1588344146.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/20 8:44 AM, Mauro Carvalho Chehab wrote:
> - add SPDX header;
> - adjust title markup;
> - Add a subtitle for the first section;
> - mark code blocks and literals as such;
> - adjust identation, whitespaces and blank lines;
> - add to networking/index.rst.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/networking/index.rst |   1 +
>  Documentation/networking/vrf.rst   | 451 +++++++++++++++++++++++++++++
>  Documentation/networking/vrf.txt   | 418 --------------------------
>  MAINTAINERS                        |   2 +-
>  4 files changed, 453 insertions(+), 419 deletions(-)
>  create mode 100644 Documentation/networking/vrf.rst
>  delete mode 100644 Documentation/networking/vrf.txt
> 

Acked-by: David Ahern <dsahern@gmail.com>


