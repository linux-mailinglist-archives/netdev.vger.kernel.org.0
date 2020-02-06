Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEED1548CF
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 17:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgBFQH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 11:07:59 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:43837 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgBFQH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 11:07:59 -0500
Received: by mail-il1-f193.google.com with SMTP id o13so5518691ilg.10
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 08:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WDHsXJEwy7oyaYZ3m09oyN42xHkDQEnS203ZTyFyi3Q=;
        b=qYdoGOIeyTXA9rh+Vp5un1qR6DDEqK4rJg3ZN4LwPNVv2PnF1vvejYYI0h+050hM4Y
         aHjFX06LTIwFpLzqUNnHwn3Gw82AOzHw0UXIAQJKKydxuZ5VHXbKgEIUPXicgTBaUBjW
         Fh1C36LNtbR3esearwJAdzFh55LbWuhDwKWLBnB1aHSP/5Yy+wFJTtKjni0lqMpyjJpf
         KDZka/mZa4i91kJN/kdMWt+s7EEr/E/8OV/G65ZEkKIG1dIk/7Drrmfz3eTsJrJOKYKI
         7CpInUcOf5MS5AjTkBlvMWwEWtV8Vd3kjaFOY44mie5i5vYY6v2bn2ng5HGxDrighpGo
         CL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WDHsXJEwy7oyaYZ3m09oyN42xHkDQEnS203ZTyFyi3Q=;
        b=tu9AkuohOFDYAwa8ip6r38sqAev31jZ471m6Ho4U8vDFQHGdnI/D3vW9V7OBoG4Vnn
         LVdDFVYZOiH+ik4xEM+6iVGvvyGTRETRlA1WtzOJ4yPGKKoPAmRl1ONKGJ3LcDMccB42
         FMaKo4JAXHnYVmfmy9U9UQFk9mr16ji6Gcek0d9t94PwftBJsH8T7pWyJu3Zvwu5NUHs
         aklFvB9KO/g4hBgR7r7zOLfkI1S5qRhhG4lc+2Ugq7mBVd/7EUoA9oIQhMRRJ2RH9OO+
         ipF+a0Pb16gW4TMMXyN10GPI4ooA+lQQudDk665C1mndvwRgV9zh/l2/anOMhJsLKpQ0
         lN5Q==
X-Gm-Message-State: APjAAAWvshzz5vW1sICgmm+q/j3kXVPRnG+n7RJbAqpZVXrI/uWlGHyl
        9tm9smwYuHQ4VhHIprIQT1M=
X-Google-Smtp-Source: APXvYqwn09vOQIa1rDT0Yt8Y4YGjqwa2PaaC6Ab9JTlJBubwWlxqOYQ5MLpoDwz6gIJu6IxozG7HsA==
X-Received: by 2002:a92:5855:: with SMTP id m82mr4535975ilb.302.1581005277058;
        Thu, 06 Feb 2020 08:07:57 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:fd4a:2ca6:a073:b999? ([2601:282:803:7700:fd4a:2ca6:a073:b999])
        by smtp.googlemail.com with ESMTPSA id i11sm1005555ion.1.2020.02.06.08.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 08:07:56 -0800 (PST)
Subject: Re: [PATCH iproute2-next 1/7] iproute_lwtunnel: add options support
 for geneve metadata
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
 <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e62548a-6d2d-558e-aa8e-999648a89b7a@gmail.com>
Date:   Thu, 6 Feb 2020 09:07:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/20 10:39 PM, Xin Long wrote:
> This patch is to add LWTUNNEL_IP(6)_OPTS and LWTUNNEL_IP_OPTS_GENEVE's
> parse and print to implement geneve options support in iproute_lwtunnel.
> 
> Options are expressed as class:type:data and multiple options may be
> listed using a comma delimiter.
> 
> With this patch, users can add and dump geneve options like:
> 
>   # ip net d a; ip net d b; ip net a a; ip net a b
>   # ip -n a l a eth0 type veth peer name eth0 netns b
>   # ip -n a l s eth0 up; ip -n b link set eth0 up
>   # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
>   # ip -n b l a geneve1 type geneve id 1 remote 10.1.0.1 ttl 64
>   # ip -n b a a 1.1.1.1/24 dev geneve1; ip -n b l s geneve1 up
>   # ip -n b r a 2.1.1.0/24 dev geneve1
>   # ip -n a l a geneve1 type geneve external
>   # ip -n a a a 2.1.1.1/24 dev geneve1; ip -n a l s geneve1 up
>   # ip -n a r a 1.1.1.0/24 encap ip id 1 geneve_opts \
>     1:1:1212121234567890,1:1:1212121234567890,1:1:1212121234567890 \
>     dst 10.1.0.2 dev geneve1
>   # ip -n a r s; echo ''; ip net exec a ping 1.1.1.1 -c 1
> 

Thanks for the command list and example. It would be a lot easier to
read if commands were 1 per line and used the long form.

Same for patches 2 and 3

