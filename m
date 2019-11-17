Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863A3FFAC9
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfKQQol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:44:41 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36878 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfKQQol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:44:41 -0500
Received: by mail-il1-f193.google.com with SMTP id s5so13744249iln.4;
        Sun, 17 Nov 2019 08:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=36Tcd3xvowpaFHHOukEJNvL3vFXR/sOP5nOa5scXrnE=;
        b=tSH1TGFcQ0ItQXfer5WLy/aRI//T79BHWXHbPKv25v/4rsKAk0U1tRBGQwu9n/Z2Zt
         AN4XZiH05yjwl395s+vmky4dclcliC6XSOYiCUVJmHVHUftzrrnh3oN5qUK8YQPYnNP0
         M6gX+GvMLkhJWEtAVnzP0PdHHyzYVIw7uJ2H8CAQSiwP6YWRExzjI6yVrFMwQqymw8hb
         kf5TVPcQkZPiF4Yz2Dp+G6BhPNRRuP2g5jSpya2q8XBydaNNXStNCIz81PimF1kOqTuA
         rHDZtHcRt9IJQ2k7wJiFD/cUItTkKiZoBLUhd0B8H+B7kF4wABhAhjK2tUhdX1R+svT8
         T5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=36Tcd3xvowpaFHHOukEJNvL3vFXR/sOP5nOa5scXrnE=;
        b=bUbduAygozOOmUHjaEPOlvv405N7TWK7azSuwIm7UvgIUplvAb6ts0XHIVNYskVzWt
         RYYOOLKHwJkkGD71IromqyE0IFP6rhthIF2jLQNwBpS3XhabEoWWx6FiDKex/KFkU5eA
         6TRS6luxfXZr1m5AocznR3Rk05/IXNocxmZTyfj8Q0YI9GAb/08y2KDRSnPk3RrSeptZ
         fLnVfeY4yUi78LrffiO0uDV56fqZkAXV1XbzVU2lzpfj9PKth1Rv7CEIpfS/D0ovb9/y
         dnoJ6o8q1ecyUAzIGbGAJhjwM0OFD6V9ugXbJ7gvR16NviMZjk1iZe7vFgcVwR9hzeN3
         t+vw==
X-Gm-Message-State: APjAAAXjzoDuHhN3fPuBKfVDFnVQmR8TNsA6K1mnSByleFfBr16HkR2J
        +Lcm4v/PiFdOg1jQMLi8cPATtifV
X-Google-Smtp-Source: APXvYqxcM+fLeUZlpp/Zq9SJUIFyOcFUl7TSat14OvsDmsnA/Lz37Wi6VHL6nH6fjyPaWf7CRxIxCQ==
X-Received: by 2002:a92:8498:: with SMTP id y24mr10984537ilk.89.1574009080179;
        Sun, 17 Nov 2019 08:44:40 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bd88:fb6d:6b19:f7d1])
        by smtp.googlemail.com with ESMTPSA id p8sm3103393ilp.24.2019.11.17.08.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Nov 2019 08:44:39 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 4.9 89/99] vrf: mark skb for multicast or
 link-local as enslaved to VRF
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Mike Manning <mmanning@vyatta.att-mail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20191116155103.10971-1-sashal@kernel.org>
 <20191116155103.10971-89-sashal@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a6c038cb-4b95-beb0-abf3-8938825d379e@gmail.com>
Date:   Sun, 17 Nov 2019 09:44:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191116155103.10971-89-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/19 8:50 AM, Sasha Levin wrote:
> From: Mike Manning <mmanning@vyatta.att-mail.com>
> 
> [ Upstream commit 6f12fa775530195a501fb090d092c637f32d0cc5 ]
> 
> The skb for packets that are multicast or to a link-local address are
> not marked as being enslaved to a VRF, if they are received on a socket
> bound to the VRF. This is needed for ND and it is preferable for the
> kernel not to have to deal with the additional use-cases if ll or mcast
> packets are handled as enslaved. However, this does not allow service
> instances listening on unbound and bound to VRF sockets to distinguish
> the VRF used, if packets are sent as multicast or to a link-local
> address. The fix is for the VRF driver to also mark these skb as being
> enslaved to the VRF.
> 
> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Tested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/vrf.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 

backporting this patch and it's bug fix, "ipv6: Fix handling of LLA with
VRF and sockets bound to VRF" to 4.14 is a bit questionable. They
definitely do not need to come back to 4.9.
