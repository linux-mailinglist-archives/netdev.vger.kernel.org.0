Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87FB16371C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgBRXYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:24:19 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45766 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgBRXYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:24:19 -0500
Received: by mail-qk1-f194.google.com with SMTP id a2so21270783qko.12;
        Tue, 18 Feb 2020 15:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=04+RMjxV0LSG9mommATrJNcWRaF6OML8kDZixe0EFvo=;
        b=s3Des/NAGzhRLNt3aEE+Ak7ahHPjL7mgsduSsRQVUSlPXSq4/qyNPHUYi/ESbExi58
         XZKGDTaPU+nIBoCb+DbiYIVHl6BR27aAgSd3B7Um7pO6N8GwYADs8iKtVgMO2Cb7AoxB
         Jn4TebTQPzbaP0LwuTI0p4XqYtga6+PHHEFyfbdG5kE9FEC72MTwnvEEMre05Ea3UVm8
         9Wj0178i5gl38In7hqBrVy7Ar+FIUu+ijxqE8Qv2iDPxLt3bG4bH+xNBL/MsPiA33iLw
         jJnJrpXw7oVJfvzh5uW5ltzs+uZHKcbPk6za9bS4Dpq+rKpcuIK9L645+Zh3iBQZp7ys
         0uDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=04+RMjxV0LSG9mommATrJNcWRaF6OML8kDZixe0EFvo=;
        b=QV+jVbDnMBD6RCKhY6t5jk0o59ZlV5PHyMc8MQ6ceHIpOUSzkBaxdlCbQwcYDhdHtX
         ClZXTGkGNG3mgZeGGIqxAbJSKRWENMbQio37lVgEamO5GhvZ5U2M/0i0btQlvf20qNZx
         VvTYC2655NMStQzwRODZwsEQ19oJ+hifG9z10HDXXtdbsw+i8rngYa+os/Krz9KadUyc
         nEqoxkCf9UFGmhHeNYOcg+HV+njUCyRMtIwvapmUKWgQ2yIUmbVXJ5Kot27vsJqEG1nm
         9PpeOUIlcG5DSNit2dgJxcDCKCBRIJcueeKPmz19zQT0Yo7uN4uPFyc1Vi8A/hPDyXu4
         6/Og==
X-Gm-Message-State: APjAAAXkGvshrLLZuNs4pWm51zD/glNXRTxX2SO1Bsb6ANlyFiXvke7A
        WFddgauDg7UaF23gUV4AUZ8AgmJ8
X-Google-Smtp-Source: APXvYqxLFghvbyRGeHBc15A1CBuBf1g6mQkNO4XLY48JsQWOBu4qTVtHo7hKJy20Ytv3JjyqokWaQQ==
X-Received: by 2002:a05:620a:1326:: with SMTP id p6mr825419qkj.50.1582068256678;
        Tue, 18 Feb 2020 15:24:16 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:5af:31c:27bd:ccb5? ([2601:282:803:7700:5af:31c:27bd:ccb5])
        by smtp.googlemail.com with ESMTPSA id m27sm16197qta.21.2020.02.18.15.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 15:24:15 -0800 (PST)
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to mlx5
 driver
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, andrew@lunn.ch,
        brouer@redhat.com, dsahern@kernel.org, bpf@vger.kernel.org
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
 <20200218132921.46df7f8b@kicinski-fedora-PC1C0HJN> <87eeury1ph.fsf@toke.dk>
 <703ce998-e454-713c-fc7a-d5f1609146d8@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9018a2d-27d0-9ff8-82eb-83b37b40b12f@gmail.com>
Date:   Tue, 18 Feb 2020 16:24:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <703ce998-e454-713c-fc7a-d5f1609146d8@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 4:19 PM, Daniel Borkmann wrote:
> On 2/18/20 11:23 PM, Toke Høiland-Jørgensen wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>>> On Tue, 18 Feb 2020 01:14:29 +0100 Lorenzo Bianconi wrote:
>>>> Introduce "rx" prefix in the name scheme for xdp counters
>>>> on rx path.
>>>> Differentiate between XDP_TX and ndo_xdp_xmit counters
>>>>
>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>
>>> Sorry for coming in late.
>>>
>>> I thought the ability to attach a BPF program to a fexit of another BPF
>>> program will put an end to these unnecessary statistics. IOW I maintain
>>> my position that there should be no ethtool stats for XDP.
>>>
>>> As discussed before real life BPF progs will maintain their own stats
>>> at the granularity of their choosing, so we're just wasting datapath
>>> cycles.
> 
> +1

There is value in having something as essential as stats available
through standard APIs and tooling. mlx5, i40e, sfc, etc, etc already
provide stats via ethtool. This patch is making mvneta consistent with
existing stats from these other drivers.
