Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B665C1EAEF7
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgFAS6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbgFAS6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:58:34 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96D5C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:58:33 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id q8so10106120qkm.12
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 11:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8KJGKjPb/AmB4hYPwn37cW/KwjpbmftPvZo5dO1LdiI=;
        b=WkUcrd+aaWzqoRxVM+l2d8rWqls+IWfHMc2TgHit2GwlVIiar6XjTBPGPTBnxFMTzy
         Y2bk2H8unog5I/S6urTvOD4QCZ44PmaQwtNdIqZWgH/pmUliugS9Ndl55JFVeQr48kOm
         Ew0CEYU2I0OYXS/NQmHqIDlXVRUR9VKYJoPNJv2iPsu9hWOvHE7KMosWM0sAuiEmrs3Q
         i0SJ+SCnDWBCpZqMZno8sfE+/L628KLgUUV6lflNXFmLmHgYARrypk/nVKMDDWWF7p99
         Da/trtefnlzUjdb9fKX4oCPfkq82YvIbSIE+OOF+rYd8jNNPyLA6G8JzUgbIE2mRH9GK
         fl+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8KJGKjPb/AmB4hYPwn37cW/KwjpbmftPvZo5dO1LdiI=;
        b=m2at5gzL69wzM+Z2j383qs+VKvpZgN+p/SuHMN2T5WxtReSiXVjAW6loG3u9Y6zmd5
         aR4CIuZGFbGjhFX0l5NuBmw8orYEm5MWxa9BGkEKfuzOk0lQi5ZcfKAVbjGGn81GMomX
         ar97ElGPK4pfnsexIuqVlDUYbQ6JxQO+9C158rxqeG8DganlY+cN8y19AhRWsc/gMCIU
         jcOH2rStOdYyCAyYRzRapzIIPF4P9caRRpd8643KLpmSrX8cJbR3qMf3sWUhlpyf7KNC
         24jJopyYdDW/3HxmWbIf3FFmg+eoTk059YB84tbDD2G9yR8pdJWh4ab4EhtBcbKAl+8B
         4eNA==
X-Gm-Message-State: AOAM532Ct0tlHdBFcMxQx2YIjSlSpspZvKgMDEho2D+s6RW8O/VWtmlo
        ii6N0QVnjDYH0VsbeVRUHlU=
X-Google-Smtp-Source: ABdhPJx66kggVUaUpHS9kdi5cYyA2/aqerg+cb2557xJVGoHEcvtRM3NIUZktybdbE0KWmNFRj31ZA==
X-Received: by 2002:a37:aa87:: with SMTP id t129mr21457304qke.197.1591037913075;
        Mon, 01 Jun 2020 11:58:33 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c9ef:b9c4:cdc1:2f07? ([2601:282:803:7700:c9ef:b9c4:cdc1:2f07])
        by smtp.googlemail.com with ESMTPSA id w94sm206525qte.19.2020.06.01.11.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 11:58:32 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/2] Implement filter terse dump mode
 support
From:   David Ahern <dsahern@gmail.com>
To:     Vlad Buslov <vladbu@mellanox.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, dcaratti@redhat.com
References: <20200514114026.27047-1-vladbu@mellanox.com>
 <20200514132306.29961-1-vladbu@mellanox.com>
 <acabad7b-2965-e7f6-b1d8-55f6b6f3f033@gmail.com>
Message-ID: <cc78ebd1-a37b-c557-8eab-cdcb2ca8dc88@gmail.com>
Date:   Mon, 1 Jun 2020 12:58:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <acabad7b-2965-e7f6-b1d8-55f6b6f3f033@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/20 12:01 PM, David Ahern wrote:
> On 5/14/20 7:23 AM, Vlad Buslov wrote:
>> Implement support for terse dump mode which provides only essential
>> classifier/action info (handle, stats, cookie, etc.). Use new
>> TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
>> kernel.
>>
> 
> FYI: I am waiting for the discussion on this feature to settle before
> applying.
> 

Where did the kernel side end up with this discussion?
