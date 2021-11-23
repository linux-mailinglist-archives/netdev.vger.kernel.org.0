Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACC345A27D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhKWM1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:27:55 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:34473 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhKWM1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:27:54 -0500
Received: by mail-wm1-f54.google.com with SMTP id ay10-20020a05600c1e0a00b0033aa12cdd33so1810181wmb.1
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 04:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+usE8lg1LzZIcyb1ClBMXKs71HHeANykQ45Nf2Xdw+s=;
        b=ZrLtTGNerqVtaybwdT5vDi8wWIY+8kMZiAC0jrso7NAm5x9mTjtuD9U+xymmsPq/E3
         Jn1+UNihCEShGVYbk2zO5pQe/lByVhoDfB1+FTHdDKh05uIjO/v8LNT0Ai2/HeRUGf58
         egy0TxcrsZkBiBrGS7TbMEAg53luN+4LbEIqOg/HAfQyoDoaOhw5wGd5eg4vPAteWgIO
         k95BR1LhXgrRDwm1/TcjwDhtzpMv4quc2zLp4ix6XW8Wo17jbw2ctAvP7i8FNGn3176Q
         sf71G+E3lfLQBpzlTidAiX7/Qi+HQM0F42AiQURZps4IjndPC96DOvvy7Qm4HfY7UsJi
         riTQ==
X-Gm-Message-State: AOAM532kQldzHsunTnCSRtQuSohx2zY2vA9y+XDuoaFeq1LOOQ93BOtq
        VZ9LZ2xJxBhRy6ag6nt8F/avsqr6twE=
X-Google-Smtp-Source: ABdhPJzuCTo1ltcUEaKa7CXC3o15ktGkZWoF6bAbY+nPh5FOojHfkKgtWo07S48Pwqi9WA/i9WX9Aw==
X-Received: by 2002:a05:600c:4f8f:: with SMTP id n15mr2591969wmq.70.1637670285767;
        Tue, 23 Nov 2021 04:24:45 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id f7sm1363899wmg.6.2021.11.23.04.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 04:24:45 -0800 (PST)
Message-ID: <bb548c53-6d5f-60af-3812-216be6728226@kernel.org>
Date:   Tue, 23 Nov 2021 13:24:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next v3] mctp: Add MCTP-over-serial transport binding
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
References: <20211123075046.3007559-1-jk@codeconstruct.com.au>
 <163766880822.32539.14789843706311733254.git-patchwork-notify@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <163766880822.32539.14789843706311733254.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23. 11. 21, 13:00, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:

I'd assumed a v4 is on its way...

-- 
js
suse labs
