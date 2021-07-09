Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657BE3C258F
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhGIOKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGIOKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:10:19 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2195EC0613DD;
        Fri,  9 Jul 2021 07:07:35 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l7so11392144wrv.7;
        Fri, 09 Jul 2021 07:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ma+hKPNbdiSLb5Fn2aElz4EmDXq6ZJG5Z0MvOylplGU=;
        b=ZawjCCLSIQdbJ43VlHbzZG19bHsCqC0nn1EUJP+3n2vuEkFPCrhRPgkjWBdU6TmqLz
         oXpay6xuM02dsr5yz0rM0yyVmcvRobOf2yenM0S0YXfjDFdjXRpJGyyOg8NVUM6pqKCQ
         XUEeFPR2IF4bSDmb6AvE/ljNjCVpPJRkDeJtXNIJag0beGE1nmEIjEY52w7AMLWJpUDB
         KgDqnIQWvkU9pvFwTbzB21o2ZXuShbQzl4VIqBVq7AERhHZ67Zam5LetTOM7hspTXk4X
         bFGka89eD1cptjz8l/FxunNVRi4l0nrr6YQi/t/mB1iK41N7BYD7gBOw1DX/HX5zHJ/n
         zmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ma+hKPNbdiSLb5Fn2aElz4EmDXq6ZJG5Z0MvOylplGU=;
        b=XfZwFhxxMuDYSzlI4PxsEb7BcNnQEV08yKrO5RNTF5nzDhfUN9Zygb295wlIymMAb6
         RTY5JZwRA7JtDe2zaWIwq3Xq89/7DUdW6z035bVfMgE1PqXAffqK0rzY1rZkTZzQVcqL
         /K7G9s16EF6rMdUP2TZ5YJvCjZ/gQC4Qo5q/QEnFOXoFBGIhhYMJcht/EgC29GbbUg2Q
         xGOAL2V1ZMElMjqN/25C430mnPQ4hH2SB5r8fa9xfD3I7iJ7O01oHfO3IwoW6SGMOmYt
         79eQPduz6rX/MqtDLEhNgpQcI34C0WQCCDggQx4OpEU16DYR1iSjZJfy4cPxAyfmRtk3
         vK9A==
X-Gm-Message-State: AOAM531dWS7InlI4KWHye+ZTjAJl+QTXO+7jjnY9ueS8SZFDPNASiZ/A
        u51YxcibFdQDvuDZdYzFxbljqBPLCDRxkQ==
X-Google-Smtp-Source: ABdhPJz55a8D//r46cwmkz0jyB1Cpk0tq3qg2yn6tzx6JPRLH8WEyjti3Weeq2CDzMtHfz5gTmkLWQ==
X-Received: by 2002:a5d:414b:: with SMTP id c11mr2082293wrq.162.1625839653797;
        Fri, 09 Jul 2021 07:07:33 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id f14sm12038373wmq.10.2021.07.09.07.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 07:07:33 -0700 (PDT)
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev
 queues"
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
 <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
 <20210707130140.rgbbhvboozzvfoe3@gmail.com>
 <CACT4oud6R3tPFpGuiyNM9kjV5kXqzRcg8J_exv-2MaHWLPm-sA@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <b11886d2-d2de-35be-fab3-d1c65252a9a8@gmail.com>
Date:   Fri, 9 Jul 2021 15:07:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CACT4oud6R3tPFpGuiyNM9kjV5kXqzRcg8J_exv-2MaHWLPm-sA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07/2021 13:14, Íñigo Huguet wrote:
> In my opinion, there is no reason to make that distinction between
> normal traffic and XDP traffic.
> [...]
> If the user wants to prevent XDP from mixing with normal traffic, just
> not attaching an XDP program to the interface, or not using
> XDP_TX/REDIRECT in it would be enough. Probably I don't understand
> what you want to say here.

I think it's less about that and more about avoiding lock contention.
If two sources (XDP and the regular stack) are both trying to use a TXQ,
 and contending for a lock, it's possible that the resulting total
 throughput could be far less than either source alone would get if it
 had exclusive use of a queue.
There don't really seem to be any good answers to this; any CPU in the
 system can initiate an XDP_REDIRECT at any time and if they can't each
 get a queue to themselves then I don't see how the arbitration can be
 performant.  (There is the middle-ground possibility of TXQs shared by
 multiple XDP CPUs but not shared with the regular stack, in which case
 if only a subset of CPUs are actually handling RX on the device(s) with
 an XDP_REDIRECTing program it may be possible to avoid contention if
 the core-to-XDP-TXQ mapping can be carefully configured.)

-ed
