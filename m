Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009655C106
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfGAQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:21:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:32778 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfGAQVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:21:18 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so30202048iop.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BvFmfxuF2tIHDGSIqt3Fo6EbJKEXQ251TGDX9ptSbJ8=;
        b=BdkYMUeB1OiaKsiX//R2vDFxrFqvfZWKEMjAY0LjDRQFLQmiAlYRbYDDhquISMo1El
         33BFcFNxlEcuvy6CRj4F2MureAijd6gzPBrHZvSlDw2g5gNOixF3sABmMa0eESCeGRRb
         BGRe18FEBEYsz16Q1SWw5zMS1tholivmy4joaLFXZDtaR87+YOnCSXtPjYQHC8XQvCq/
         /N4OFu/+TPal48oO3pXn2zYhIPc3l9kWS2zCUfPLB4dkxApF321GgeFupmwAxkBYRyKI
         VzwZFT7M6nhC0L4aj7LlwmPGC2bZODM8EFmfWq9lLvufF4DAqrjmdi1WNX6VppPYvI6l
         pwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BvFmfxuF2tIHDGSIqt3Fo6EbJKEXQ251TGDX9ptSbJ8=;
        b=mlGc5u/vMVMaRFNx1Byrmo2dfgqxvUnVY+UgHt1xFOu62Xte5CruMy2/K/t9BD/npI
         o/dwJdQ7NqMddABFOHlCZk1itrimgue0T/pO/LdXJGCGqrLZnPuhKwUJ9pQyO23fQvVW
         rLu2rNPe9Y4bjNIIHgXvInOXi5tRDoNJt5trU5f2AlG54QZCmdTEApk46WAgyOLA3POo
         s2XjgFM6XhHmof+/srAVDCLoDbYVPi1T6C8qpARd7dlrkGkD7BibBmYOx9AZCKW+fpBn
         HzfS7Voicqk04SVTmhXXFreXKcHaI6/dAO9ZbnQjzcJPr8e88eB+TKPXVwr5Moe30I4j
         2jwA==
X-Gm-Message-State: APjAAAXyHV41HtISXrOdo2n4xN3k0ShmGqy5Nz1+eaWd+n/xiEcQCIhA
        KxMlKEid+xragsREACTHhjQ=
X-Google-Smtp-Source: APXvYqyRUgCxiXOb7RJ103Dp7qIwTyfTBNWQ3dzCC50YWEmMBo70vvJsyOZ0HquHgDCLZcM81SKL6A==
X-Received: by 2002:a02:3f1d:: with SMTP id d29mr31154507jaa.116.1561998078056;
        Mon, 01 Jul 2019 09:21:18 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f191:fe61:9293:d1ca? ([2601:282:800:fd80:f191:fe61:9293:d1ca])
        by smtp.googlemail.com with ESMTPSA id y18sm12386574iob.64.2019.07.01.09.21.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 09:21:17 -0700 (PDT)
Subject: Re: [PATCH net] Documentation/networking: fix default_ttl typo in
 mpls-sysctl
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <20190701084528.25872-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b4655d5f-58cd-3019-e67d-9c0688f5a57b@gmail.com>
Date:   Mon, 1 Jul 2019 10:21:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190701084528.25872-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 2:45 AM, Hangbin Liu wrote:
> default_ttl should be integer instead of bool
> 
> Reported-by: Ying Xu <yinxu@redhat.com>
> Fixes: a59166e47086 ("mpls: allow TTL propagation from IP packets to be configured")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  Documentation/networking/mpls-sysctl.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: David Ahern <dsahern@gmail.com>

