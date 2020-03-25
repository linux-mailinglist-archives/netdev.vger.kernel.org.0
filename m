Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F40F0192D95
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgCYP6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:58:06 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:39716 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbgCYP6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:58:05 -0400
Received: by mail-pg1-f173.google.com with SMTP id b22so1333509pgb.6
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=27MI+pxeAlEIMfPvPMDpujJi+ZohPaDk0S/nX9CW4io=;
        b=RzQrhhO2SxrollGwhERO7/Dd3pfuxr6CA8FFWFuBFYkeS/rtyMWlS9oJIuZsJCfpza
         z2NhH8BrC30c4WpUyZOduWbBTEZfqCrnJ6BZyFvLDHJ/fZJE4Iuj1kKcsJMYENL9RzDI
         ifObwgvU/Qs4gFDXSX1Xpd0gie+6VwquI0WBRRocjFSMk3xTLblrcxWLRPLsV2ALSmwq
         QeTSKWdK5oxULe/1HHPKNemKK/oaiGcvw3sTaYf7/Y/gwFmXjcMoL+K6Y8797glqIB95
         b7Sh7hki1QxuoxF117b8pg3BUNQfTe3z80hc68J2XJaQu46biHZmvSDPlPdq6qY9qzU8
         hn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=27MI+pxeAlEIMfPvPMDpujJi+ZohPaDk0S/nX9CW4io=;
        b=my/Y9BOmyLN8gKaNz/4sV/+h4IbibDuxRmacXHj+If/TqUUUd27AP/nuvsnU/jHFlL
         nCgEowJoo1ztcfCDkfrKZzRans7lbBfl3mbsAZloG24/XfoNfkdulL9beHLQ8rQ5QgSi
         5JUHoDiICYa8OTGSZ0W8Dd5dUkaG+YB0mAdS9zGvM9uKizr1SfnyVQYO3ZVs/j/E2Yx/
         1FWY9u2zvOFmaKvin/Dk+936+8gyIZcUlg1au0uIcF4SuRuEfoZI7C8tf1h1hRGQbEtr
         4/b6KiZL57CxwFJGDAW+t96/mrkwVZJzUOxfMAm3kvwSK5cZZlKsNnmzz1sm5o/ST8cE
         6UcA==
X-Gm-Message-State: ANhLgQ3R4iV9Kgtz31AsCW9R5bmBBMqIrrCzZQsNBH2/vFuMKaIw9RJf
        naCGGD+owWEyVIrqyCiacjHfaO6T
X-Google-Smtp-Source: ADFU+vvaFOyTc1FOq35h7H9yu/fKraP7m/jhQiGu0cVvN+ueishoT9tdJdnI0vgBpKZxsFxJefEL6Q==
X-Received: by 2002:a63:3d44:: with SMTP id k65mr3873766pga.349.1585151884420;
        Wed, 25 Mar 2020 08:58:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c62sm18602072pfc.136.2020.03.25.08.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:58:03 -0700 (PDT)
Subject: Re: Fw: [Bug 206943] New: Forcing IP fragmentation on TCP segments
 maliciously
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, fengxw18@mails.tsinghua.edu.cn
References: <20200325082638.60188be0@hermes.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b0505775-913f-79d2-fac8-d81184233a05@gmail.com>
Date:   Wed, 25 Mar 2020 08:58:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325082638.60188be0@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/20 8:26 AM, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Wed, 25 Mar 2020 08:37:58 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 206943] New: Forcing IP fragmentation on TCP segments maliciously
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206943
> 
>             Bug ID: 206943
>            Summary: Forcing IP fragmentation on TCP segments maliciously
>            Product: Networking
>            Version: 2.5
>     Kernel Version: version 3.9
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: fengxw18@mails.tsinghua.edu.cn
>         Regression: No
> 
> A forged ICMP "Fragmentation Needed" message embedded with an echo reply data
> can be used to defer the feedback of path MTU, thus tricking a Linux-based host
> (version 3.9 and higher) into fragmenting TCP segments, even if the host
> performs Path MTU discovery (PMTUD). Hence, an off-path attacker can poison the
> TCP data via IP fragmentation.


Usually, researchers finding stuff like that start a private communication
with involved parties.

Please send us the thesis or the details so that we can assess if the bug is critical
or not, considering the troubled time we live.

Thanks.

