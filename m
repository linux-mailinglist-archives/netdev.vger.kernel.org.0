Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1585D1E3534
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 04:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgE0CJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 22:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgE0CJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 22:09:17 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BC8C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:09:16 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c185so8858716qke.7
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=++YgWJmE9usQTz9HhRezxGF1VBPAiquT6bkgDCcIGBI=;
        b=FL87orvk0g1Zib130oy5cdqwWlgUeGwECs1uUJjEl06PPweyEfaeEWU7982YIg9/WC
         tf4KCjB0F48yRP6A28IivPxe+zHej5iJx10Vt3bLQkf4hWGOSKr1GVxrbO+PBIDEx5nh
         5jrpYcB2c4rE1Qmjb8FBhqRT8TS40xYNzeMv7mRni24rRHNTATY3R1NBT1zxedj4ukA7
         IKCNAWggRPtJueOm2A4I+i7mQUzQuNCnk8F/ztkcXKBi4zhfpZV4E36FIPQ7WKQfFbnx
         4h6+OiF5do5M6SltwfaDqYct6QR0VGm0uy6/u50BwvI3/SwOc5xQPvODAPse6X4DsfuU
         +JgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=++YgWJmE9usQTz9HhRezxGF1VBPAiquT6bkgDCcIGBI=;
        b=rLvAQBSb8xGzusOvLOJxmnzfhBIDvu1ZpBAEk/rzobefvZDZFR8sYiDe5pyVpj5vx8
         Y7ciex6vQpzmkveeQ5QA9RAdqYynYg3wol/f5egJBIcG7Ftt/ApSZYEVNqBUp6AlpUfv
         j61dsR+grABjWf3huf+UcdHpPu3YEZnB88Ir0lyicD3/CwhLggInjX8fWfF2uDWscB9g
         StNK0gezDMXRy4090vqY2IUBsflEemAwArzH/gUjwsyMCD+3BPhuMpSvLpdFzdLvEidO
         p7+T9o/9QHUS2ffe5iOMcaRx2mqV5IoxN4Ni+OCskRc35q7TTghxg8Q6FJMyfSWZamJc
         TqGA==
X-Gm-Message-State: AOAM5336dIQ0LIBuav1WmSyI4dSky9pTze9mE7f2SzLWy+pIzt8FtuxZ
        mS4ilsNKEPHI4AoPX6DnOTizG/dZ
X-Google-Smtp-Source: ABdhPJxFg/pg6bgQzmsZwJe76FX73gcxX1l9mbFm8dgj21En4TmFQAVEZ1tEi06bnZ/Mhw1U8EuWZg==
X-Received: by 2002:a37:4351:: with SMTP id q78mr1698386qka.242.1590545355835;
        Tue, 26 May 2020 19:09:15 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id u205sm1251227qka.81.2020.05.26.19.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 19:09:15 -0700 (PDT)
Subject: Re: [iproute2-next] tipc: enable printing of broadcast rcv link stats
To:     Tuong Lien <tuong.t.lien@dektech.com.au>, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
References: <20200526094055.17526-1-tuong.t.lien@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9152136d-5ae4-f3e6-0929-0227d50fd3d9@gmail.com>
Date:   Tue, 26 May 2020 20:09:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526094055.17526-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 3:40 AM, Tuong Lien wrote:
> This commit allows printing the statistics of a broadcast-receiver link
> using the same tipc command, but with additional 'link' options:
> 
> $ tipc link stat show --help
> Usage: tipc link stat show [ link { LINK | SUBSTRING | all } ]
> 
> With:
> + 'LINK'      : print the stats of the specific link 'LINK';
> + 'SUBSTRING' : print the stats of all the links having the 'SUBSTRING'
>                 in name;
> + 'all'       : print all the links' stats incl. the broadcast-receiver
>                 ones;
> 
> Also, a link stats can be reset in the usual way by specifying the link
> name in command.
> 
> For example:
> 
> $ tipc l st sh l br
> Link <broadcast-link>
>   Window:50 packets
>   RX packets:0 fragments:0/0 bundles:0/0
>   TX packets:5011125 fragments:4968774/149643 bundles:38402/307061
>   RX naks:781484 defs:0 dups:0
>   TX naks:0 acks:0 retrans:330259
>   Congestion link:50657  Send queue max:0 avg:0
> 
> Link <broadcast-link:1001001>
>   Window:50 packets
>   RX packets:95146 fragments:95040/1980 bundles:1/2
>   TX packets:0 fragments:0/0 bundles:0/0
>   RX naks:380938 defs:83962 dups:403
>   TX naks:8362 acks:0 retrans:170662
>   Congestion link:0  Send queue max:0 avg:0
> 
> Link <broadcast-link:1001002>
>   Window:50 packets
>   RX packets:0 fragments:0/0 bundles:0/0
>   TX packets:0 fragments:0/0 bundles:0/0
>   RX naks:400546 defs:0 dups:0
>   TX naks:0 acks:0 retrans:159597
>   Congestion link:0  Send queue max:0 avg:0
> 
> $ tipc l st sh l 1001002
> Link <1001003:data0-1001002:data0>
>   ACTIVE  MTU:1500  Priority:10  Tolerance:1500 ms  Window:50 packets
>   RX packets:99546 fragments:0/0 bundles:33/877
>   TX packets:629 fragments:0/0 bundles:35/828
>   TX profile sample:8 packets average:390 octets
>   0-64:75% -256:0% -1024:0% -4096:25% -16384:0% -32768:0% -66000:0%
>   RX states:488714 probes:7397 naks:0 defs:4 dups:5
>   TX states:27734 probes:18016 naks:5 acks:2305 retrans:0
>   Congestion link:0  Send queue max:0 avg:0
> 
> Link <broadcast-link:1001002>
>   Window:50 packets
>   RX packets:0 fragments:0/0 bundles:0/0
>   TX packets:0 fragments:0/0 bundles:0/0
>   RX naks:400546 defs:0 dups:0
>   TX naks:0 acks:0 retrans:159597
>   Congestion link:0  Send queue max:0 avg:0
> 
> $ tipc l st re l broadcast-link:1001002
> 
> $ tipc l st sh l broadcast-link:1001002
> Link <broadcast-link:1001002>
>   Window:50 packets
>   RX packets:0 fragments:0/0 bundles:0/0
>   TX packets:0 fragments:0/0 bundles:0/0
>   RX naks:0 defs:0 dups:0
>   TX naks:0 acks:0 retrans:0
>   Congestion link:0  Send queue max:0 avg:0
> 
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
> ---
>  tipc/link.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 

Applied to iproute2-next. Thanks for the examples in the commit message.

