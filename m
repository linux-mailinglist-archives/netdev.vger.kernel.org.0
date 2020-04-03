Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F8119D62F
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 13:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390844AbgDCL5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 07:57:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39539 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390632AbgDCL5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 07:57:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id p10so8186259wrt.6
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 04:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m9uB8CXOauOvkixvQHaupaJsW5GE1b/+9MUTIoEBWtw=;
        b=mP38ZimsazJj47mkB31YHkndHlq8nfBVb0VJ4dOpLB1q02Anbk8BAxgjDFiejLpnHc
         rwrkB8j9Ri1rZpdgetcOhGIrErQrE8HS53Tc8hrHbMxCFkFdzjDNitVYbsfim78ihOaZ
         u4JXfGcv+zQ6ADmmgT6EM3TsniIsxAe8eIq3s6BHW36VkRoeZi/BnDeDpbJR0wA6T9nM
         wjHXfO42JkRWkcSVAoutvrdb0l7R6+wwlv9p8XJLiMrt6UfCYL6EgjNlnxtAOyKXoVcD
         yl6PhQA4ps0zd3OTsyunfNULVHwRJJeNSQH1Kp0DOLP5LLjllmUh4sxz6+8dau9mK36g
         FmiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m9uB8CXOauOvkixvQHaupaJsW5GE1b/+9MUTIoEBWtw=;
        b=rD8i90tC5HZ54R/pZO0/ckU2DfQ5gj1bnGhz0etYypT8SnwVy9wIKnOvxEqPjYbxXl
         vKJZmxruPduYxGs8czNm6fXo/tvT67DKC3KWVXStO5rx7UafqOUi4wvb8E9XpA64uRTt
         QNzrgtOZXxx7cSxg7Yh6uDIXpTimBb0b1XQP53/aF+s/ROy6bfln7lzvEhDvec2vPMT5
         sIE7QNyG0sCZIFM+qc/bY1KAUxEoxfa0n8mu3w+QMmT5nYr4yOEqFYqaJvLHe6lyLJT1
         53F/v8v6UGR77iZFa/JLssYOzS8Vwfo6QOYE0tSzdkMM4zQT5jxhUCH0WAqsYkBXnk2i
         LLEw==
X-Gm-Message-State: AGi0PuY5I/uYNcp72Rj1GaAHpT4xtUzdq+onmlJC8XSs+fXISH1IkqRp
        H1gsl0TPVYBkL9FawgCkzTexmQ==
X-Google-Smtp-Source: APiQypKPqO12YqzsS7Yog6MXPvcZfc7I526z0zAxC3kpVH3jFAjLrqtwuG8Dx+nbJb1IWqQgbkC7Aw==
X-Received: by 2002:adf:82a6:: with SMTP id 35mr8735769wrc.307.1585915070364;
        Fri, 03 Apr 2020 04:57:50 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.236.184])
        by smtp.gmail.com with ESMTPSA id h26sm10928350wmb.19.2020.04.03.04.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 04:57:49 -0700 (PDT)
Subject: Re: [PATCH v2] mptcp: add some missing pr_fmt defines
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <f66ab0b7dfcc895d901e6e85b30f2a21842d2b2c.1585904950.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <53e4271f-c881-c52d-c6e1-4930a4f6898a@tessares.net>
Date:   Fri, 3 Apr 2020 13:57:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f66ab0b7dfcc895d901e6e85b30f2a21842d2b2c.1585904950.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 03/04/2020 11:14, Geliang Tang wrote:
> Some of the mptcp logs didn't print out the format string:
> 
> [  185.651493] DSS
> [  185.651494] data_fin=0 dsn64=0 use_map=0 ack64=1 use_ack=1
> [  185.651494] data_ack=13792750332298763796
> [  185.651495] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 data_avail=0 skb=0000000063dc595d
> [  185.651495] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 status=0
> [  185.651495] MPTCP: msk ack_seq=9bbc894565aa2f9a subflow ack_seq=9bbc894565aa2f9a
> [  185.651496] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 data_avail=1 skb=0000000012e809e1
> 
> So this patch added these missing pr_fmt defines. Then we can get the same
> format string "MPTCP" in all mptcp logs like this:
> 
> [  142.795829] MPTCP: DSS
> [  142.795829] MPTCP: data_fin=0 dsn64=0 use_map=0 ack64=1 use_ack=1
> [  142.795829] MPTCP: data_ack=8089704603109242421
> [  142.795830] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 data_avail=0 skb=00000000d5f230df
> [  142.795830] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 status=0
> [  142.795831] MPTCP: msk ack_seq=66790290f1199d9b subflow ack_seq=66790290f1199d9b
> [  142.795831] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 data_avail=1 skb=00000000de5aca2e
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> 
> ---
> Changes in v2:
>   - add pr_fmt to C files, not headers.

Thank you for this v2 (sorry, it was in my spam folder).

I thought checkpatch.pl would have forced you to add a new blank line in 
net/mptcp/pm.c after the copyright comment and before the beginning of 
the code but it seems not. And there was no blank line before so I guess 
it's OK like that!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
