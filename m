Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE44DA1B92
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfH2Ngq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:36:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35696 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfH2Ngp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 09:36:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so3926985wmg.0
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 06:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zE0VmLeBzgPYmKuPhgJ9fctJWF45LQJx75UYMLKMg40=;
        b=LDhD1/JGvTucAvTQG4dSckFrsjbU95uXqflF0RIlZ9i4pAWZnJAwfigPkhQSAIT+FA
         B73Aa6/SZIe7LXKG+Crx9YFpwNSdXKBk2ajOxmVhRbH7uON2R3CT/oMnQmBKoNFVx1Sd
         vCX+OkLuUb7UDYZi1SLnTQn6Ecbs+knM8524db9/NLt1/OHfgp81QEf1/Wsg1+d7spqJ
         UZJJ9xSlMfbmabT15Na7ixOESMzllG03L/ucp2IVktC6DASEMzotvxULSlzP4F00BOYr
         5lhewHqDIHqBwbr+inNIDDcuKxJD8QeOE6HLwFTbCjrqhl1hzfK0QL5eOBs80wxg7h3z
         DimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zE0VmLeBzgPYmKuPhgJ9fctJWF45LQJx75UYMLKMg40=;
        b=PrO1/zQmqx0ZElhGN/IylIk2fLkUS0s+0HtDQAIXXcBPFJ8y8Fs7Ua/5TCOrHcXhiM
         gFN53D05tjcF59HCLjmjVmJRWzgPARyc6CAnEnnr9pJf8wWDBOlc6h0w8LLGyl75y+yQ
         93uCh9+0J7WHZtqroefqMKTzKO8qcJzZ3BURR1FfswZK3ZdeZTc2xLk3616TIBoaJ2hc
         fOAZOEXpDy87gjCfdK4OCR5Rb5Unkv+CG1y7bPOGL6YgBNy1k9Z6EC1xDMElSRhLDnkj
         tX3q/KGgGBv2T3x50RMYGHmlYE0tSBsNfTF4RaVZgeMQX6m5zx9Ch0VJDzqWVPqy9U29
         R6wQ==
X-Gm-Message-State: APjAAAXIkL7dkreaF1/GbVYVNYUmg6/HYa/cOUSyK5l5HJX/NmakXF0U
        22LauCdSwDJBNaHwXRYIw0iM3Q==
X-Google-Smtp-Source: APXvYqwypUOyTmNS5h+nHgiRnMgXMO0pA7nxRGN/4AT57HE9aMwLBYvn74vmzrW9/lmvE7zse0SGZQ==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr11321239wme.85.1567085803221;
        Thu, 29 Aug 2019 06:36:43 -0700 (PDT)
Received: from [10.16.0.69] (host.78.145.23.62.rev.coltfrance.com. [62.23.145.78])
        by smtp.gmail.com with ESMTPSA id b4sm4247974wma.5.2019.08.29.06.36.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 06:36:42 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
To:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net
Cc:     davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
References: <20190829051253.1927291-1-ast@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a5ef2f94-acca-eb66-b48c-899494a9f8d0@6wind.com>
Date:   Thu, 29 Aug 2019 15:36:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 29/08/2019 à 07:12, Alexei Starovoitov a écrit :
[snip]
> CAP_BPF and CAP_NET_ADMIN together allow the following:
> - Attach to cgroup-bpf hooks and query
> - skb, xdp, flow_dissector test_run command
> 
> CAP_NET_ADMIN allows:
> - Attach networking bpf programs to xdp, tc, lwt, flow dissector
I'm not sure to understand the difference between these last two points.
But, with the current kernel, CAP_NET_ADMIN is not enough to attach bpf prog
with tc and it's still not enough after your patch.
The following command is rejected:
$ tc filter add dev eth0 ingress matchall action bpf obj ./tc_test_kern.o sec test

Prog section 'test' rejected: Operation not permitted (1)!
 - Type:         4
 - Instructions: 22 (0 over limit)
 - License:      GPL

Verifier analysis:

Error fetching program/map!
bad action parsing
parse_action: bad value (5:bpf)!
Illegal "action"
$


Like Andy, I'm also wondering about the backward compatibility. With my current
docker, I'm able to play with tc bpf with CAP_SYS_ADMIN. But if I update my
kernel with your patches, CAP_SYS_ADMIN doesn't allow anymore that and CAP_BPF
is not implemented in my current docker, thus I cannot give the correct
capabilities. In other words, an old docker cannot run on a new kernel.

Regards,
Nicolas
