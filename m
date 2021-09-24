Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1174169CD
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 04:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243856AbhIXCG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 22:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243803AbhIXCG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 22:06:57 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C3EC061574;
        Thu, 23 Sep 2021 19:05:25 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so11194427ota.6;
        Thu, 23 Sep 2021 19:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=axmcHWINwhbQqCEqpjgusrdckROoPW/Dup1z+bcXAK4=;
        b=STxTG2T/Btd0AUZQsgGJGLl90actZCzfzSWJUSo6/KpF9GwPo7zs0KLdV/PlX5yCcA
         NK/KOHUN07TolUi43Ae6bx4EsKeOfiGor49jwrCShr1JE6hKbcnGJH1wQjQgCjUxHGdW
         8SmcFJ+aMMY8adnc5NWcLHyaeZJFlaxw9HpYh5pKlGkLqkq7X6cj2tf+TDLAcJBJ/k64
         oMjyfkA+78jBuMWL94tA4xCffuQbQwz36/g2fi6HMbmu6tBuCujJLvjDQ6HuNoit1ufi
         +SrLv8nu2RnDIL+/Ez9z113h43/yAgE9Mvr77wN+Tljez4wbXOjctu+X5ADv7hab1PmW
         og7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=axmcHWINwhbQqCEqpjgusrdckROoPW/Dup1z+bcXAK4=;
        b=eesdJOkkIGrNKCPI99n8Hx+esJ962EItkb8pkRCY2PKgHLdQ6i83CLB57vmLGmibK8
         zkAYxpb4HXI+QKemHhqsiwqhYo1AHYA9BmVJZ4RCXh8+8v+xpnuLkhxYKB9KDdkdetXg
         CfeAVFhL4vmG92+KuA0B3cZz3gYe6rm4mI42zk67T04DnOF7kKxAEQDg20CZSBS2DJVL
         eONZaUIlKPf9GtazY1qn0jVYzFdQ4WTY0Ln/EwUO6ekNXym79hB+cMZ+UWjmqGNfHQDH
         tIBvrPGbe5bJQ9n9mFNZyKumUsUHhLRTXeqdFShcHKRidDT3sCCliUeLYQAJ/czrtgld
         OKng==
X-Gm-Message-State: AOAM532mWgoPBS+rrYfRWyg864AvWom9JwnbIhWn0WvelIC/Rn03Aow2
        CTChq39WE0jSxE4krVkWwb0pcmqz7Pi04Q==
X-Google-Smtp-Source: ABdhPJz46xnTPNOVr8ZpBdtBjkO+1r919dkh/wxHjfJwibhtaHC4bQ3FtqUGeetS8XavWvxmIHxRSg==
X-Received: by 2002:a9d:5887:: with SMTP id x7mr1671653otg.331.1632449124814;
        Thu, 23 Sep 2021 19:05:24 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id a11sm1710075oiw.36.2021.09.23.19.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 19:05:24 -0700 (PDT)
Subject: Re: [PATCH v2 0/6] iproute2: Add basic AX.25, NETROM and ROSE
 support.
To:     Ralf Baechle <ralf@linux-mips.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org
References: <cover.1632059758.git.ralf@linux-mips.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f5cc6ffe-0351-7b4d-4ae8-fea6485490b1@gmail.com>
Date:   Thu, 23 Sep 2021 20:05:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cover.1632059758.git.ralf@linux-mips.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 7:55 AM, Ralf Baechle wrote:
> net-tools contain support for these three protocol but are deprecated and
> no longer installed by default by many distributions.  Iproute2 otoh has
> no support at all and will dump the addresses of these protocols which
> actually are pretty human readable as hex numbers:
> 
> # ip link show dev bpq0
> 3: bpq0: <UP,LOWER_UP> mtu 256 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/ax25 88:98:60:a0:92:40:02 brd a2:a6:a8:40:40:40:00
> # ip link show dev nr0
> 4: nr0: <NOARP,UP,LOWER_UP> mtu 236 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/netrom 88:98:60:a0:92:40:0a brd 00:00:00:00:00:00:00
> # ip link show dev rose0
> 8: rose0: <NOARP,UP,LOWER_UP> mtu 249 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/rose 65:09:33:30:00 brd 00:00:00:00:00
> 
> This series adds basic support for the three protocols to print addresses:
> 
> # ip link show dev bpq0
> 3: bpq0: <UP,LOWER_UP> mtu 256 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/ax25 DL0PI-1 brd QST-0
> # ip link show dev nr0
> 4: nr0: <NOARP,UP,LOWER_UP> mtu 236 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/netrom DL0PI-5 brd *
> # ip link show dev rose0

# lines get removed by git; $ is a better prompt for commands

> 8: rose0: <NOARP,UP,LOWER_UP> mtu 249 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/rose 6509333000 brd 0000000000
> 

applied to iproute2-next. Thanks,


