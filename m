Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0ED9259D5
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfEUVUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:20:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37447 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfEUVUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 17:20:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id n27so142184pgm.4
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 14:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zlUMYBozkrZIppLFnz+hr4tig7UewT+mUSWTAtyqCmQ=;
        b=PJXxgp9gJm7bS5BM2088kbFhfHcyZKuV4Fhy1Rjt+8tH1QGBO1XO820dmCl/VJJdDj
         1mQhzauTKzWv2XwTybPQQkKXGcDMzAQhXXVlqUIJnkfpvOOcjwn8Ys/S7sNTcIHc19bj
         zY3GQX7DbQBzFZpUpMSGbJTEkl8kTGCC5HLLvNcU5qXhzttO4JMXvdXN5vt7piefnguM
         5wK5K0yWT4zYoXEiHoPD/hPYW94wN/+SAO1JJdX1AgdNsVJ9MdIC7h/PluTYMIivHd6X
         XwW2hkd37+0w+/LX+W8jTHHJISTW1IbKEjhMXAhf+mDIi7O08b3p/spVJMs8XfjJdsv5
         ikxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlUMYBozkrZIppLFnz+hr4tig7UewT+mUSWTAtyqCmQ=;
        b=fwQA/WvPesQJ+ZaAL3eCAMD/1cSxDFtmp1tjauhbRqCKg5L6SHIZp9t0L5TXbqtFoI
         zrF1zY4KQZkWc9r1uXpwYBF8hKdCB753aium3/CRNNXxYyCZwiuWmkBQ9O+PNs4CK9+q
         9iYRAqIpvu6Bo/VxainagCZuckBpa+OjnilDgFUIeQE6zvpbDOHIX9SDq0a5JFf6UK7l
         6SU7bAXXTtQvRWNq7p4L1nuzcgLb/zcA7kRhWFACQEjVvljtsg1ZHmoE20SaMl7lnU/2
         jo1x47uJZsdflxrveYKEjVpUKhArOcgBstT5qQ8Ij/iz/xSyHwitNyk+FMZoMcctvGVU
         HjDA==
X-Gm-Message-State: APjAAAURb0vMGVzFA85bjyecc3kZgY50raCWdNcBexXInekHsX+IjmhG
        wUb22C6sSDHoiAEQfxKBxoU=
X-Google-Smtp-Source: APXvYqzTvrv1GaF1lgBtc7qCy6dlFq0GAL6aoX11186MNfoebm3q3NIm5O9B7iNy8QCt+zb9rQIQgQ==
X-Received: by 2002:aa7:8d89:: with SMTP id i9mr91031221pfr.77.1558473613961;
        Tue, 21 May 2019 14:20:13 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:49fd:f14f:d8fe:97a? ([2601:284:8200:5cfb:49fd:f14f:d8fe:97a])
        by smtp.googlemail.com with ESMTPSA id r29sm19464731pga.62.2019.05.21.14.20.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 14:20:12 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next] ip: add a new parameter -Numeric
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Phil Sutter <phil@nwl.cc>
References: <20190520075648.15882-1-liuhangbin@gmail.com>
 <4e2e8ba7-7c80-4d35-9255-c6dac47df4e7@gmail.com>
 <20190520100322.2276a76d@hermes.lan>
 <20190521121311.GW18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f9f733e-9977-1994-fe47-3a0fb4160ad4@gmail.com>
Date:   Tue, 21 May 2019 15:20:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190521121311.GW18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/19 6:13 AM, Hangbin Liu wrote:
> BTW, for some pre-defined names in iproute2, like rtnl_rtprot_tab,
> nl_proto_tab. Should we also print the number directly or just keep
> using the human readable names?
> 
> I would like to keep them as this is defined in iproute and we can control
> them. But this may make people feel confused with the -Numeric parameter.
> So what do you think?

To me numeric means no number to string conversions, and the protocol is
passed as a number.
