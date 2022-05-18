Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1194652C5C8
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiERVzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiERVyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:54:41 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8940415EA5C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 14:43:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i27so6289140ejd.9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 14:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+0u6Co0fQyRE3E7Gd5FQVT98igTbdpT+/KuuR/oOF0o=;
        b=Lq8UN195SQC5IPnKOEO6l2YcI/XCWCeTBJOiTVUrQdQOxiP1flbaAf6YI7ybUg0SOA
         dwWdS7QqjCMOmLJLxYO9qocWPkMdotKnjr6RgpNBqCZCnXClXC3jLNldc/IQA+E+3MUV
         2Jp3+81U9+l4tJimSqzZviLR8KKZnBDgM0376nX7/uC7oEaGV/Hn04khLJNVivyigVpH
         iW8ubOhHKXxNL4H3rajYGJWeI0v97YfuINgV/bZ/7KBkZJWx53bJnbt6x94JjnHR90I5
         oB7xrGGWksa6RaAYGX1M3n17tWudAnT3kuqPqhxmx67tDvpt5R4MbvUlR8yqnaQMyFrP
         uPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+0u6Co0fQyRE3E7Gd5FQVT98igTbdpT+/KuuR/oOF0o=;
        b=4NeUwyD6g71S7lmQzKI0P/sdz9OJCksvbR3bHv+E/rQWtyhB4VGu/M1F6z6QhUfn+P
         J2AVsvu1fgDiQuN6pIQpNdeMYv6Inr831TDJfA2xW/FUqEri7aVlyiutWoH3zS1zw3Xm
         EnH19JYw3QFxyJkl4DHf134zFtAfpESsS2DDMoGpORO7UDWG3oxTyCvwafJ8o5l6g+ab
         upTmqVqEZwc8rt8ygtkTxAkZ9HAl50eCevMPLFjBxccUn8CEytkR+sX/qX4K63Q1VfVs
         iVbg2txFWY1y9Ja3YNDgTV4ycdyB8D2AokgnQ3iqN4YvPHBgsRrA7FIiQcMLPCvHyYHJ
         iy9g==
X-Gm-Message-State: AOAM530rb8YChNkOopBVAFEZykNo0lz5funuvtMfOJNqigrByW+iv2DU
        7TJSLjy3BCkpdzyo8IT0UqDDYw==
X-Google-Smtp-Source: ABdhPJyMMU+X1/waHm0V+jOhDoSXQpwPFG3UJgrD7Y4DiyR5Ls6dWqS1Vt9ubSBbzCWbycRPlmU2HA==
X-Received: by 2002:a17:906:7309:b0:6f5:ea1:afa with SMTP id di9-20020a170906730900b006f50ea10afamr1466099ejc.170.1652910193932;
        Wed, 18 May 2022 14:43:13 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id hg23-20020a1709072cd700b006f3ef214decsm1377344ejc.82.2022.05.18.14.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 14:43:13 -0700 (PDT)
Message-ID: <b3a94a42-1333-1393-1946-e6412d6830d5@blackwall.org>
Date:   Thu, 19 May 2022 00:43:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 net] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org
References: <20220518005840.771575-1-andrew@lunn.ch>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220518005840.771575-1-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2022 03:58, Andrew Lunn wrote:
> It is possible to stack bridges on top of each other. Consider the
> following which makes use of an Ethernet switch:
> 
>        br1
>      /    \
>     /      \
>    /        \
>  br0.11    wlan0
>    |
>    br0
>  /  |  \
> p1  p2  p3
> 
> br0 is offloaded to the switch. Above br0 is a vlan interface, for
> vlan 11. This vlan interface is then a slave of br1. br1 also has a
> wireless interface as a slave. This setup trunks wireless lan traffic
> over the copper network inside a VLAN.
> 
> A frame received on p1 which is passed up to the bridge has the
> skb->offload_fwd_mark flag set to true, indicating that the switch has
> dealt with forwarding the frame out ports p2 and p3 as needed. This
> flag instructs the software bridge it does not need to pass the frame
> back down again. However, the flag is not getting reset when the frame
> is passed upwards. As a result br1 sees the flag, wrongly interprets
> it, and fails to forward the frame to wlan0.
> 
> When passing a frame upwards, clear the flag. This is the Rx
> equivalent of br_switchdev_frame_unmark() in br_dev_xmit().
> 
> Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> 
> v2:
> Extended the commit message with Ido obsersation of the equivelance of
> br_dev_xmit().
> 
> Fixed up the comment.
> 
> This code has passed Ido test setup.
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

