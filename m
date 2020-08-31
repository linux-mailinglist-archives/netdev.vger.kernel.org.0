Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D7D25825F
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgHaUUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgHaUUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:20:16 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8E6C061573;
        Mon, 31 Aug 2020 13:20:15 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id h10so7415344ioq.6;
        Mon, 31 Aug 2020 13:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1AcHyU9YuFtC3DFhxq+uyC++FLYMrBvu+K8DsXLlF50=;
        b=L57r1yIEAC4y68d5tuxwG6HxUO+Kvc7FTcQEevBspZ2lczXjuGs/WRqtev5l3AJHVR
         2CRHwIaFxCalysWU+C370cuuM5ZVE6cubV9hrFAPLBKcTUHtY4jHPLZrP032fsBw2uWj
         yL/5tJTSNkaGfeo+XZfYPVVHTXHDFJ8FFrjtbI54b5xr+5nY3G6VFVoHJZPS2prU7l77
         CbM3NtRUACveM8tojUsIe99Zm1Gy4MNGu/NNLWBDoZa1BzJ4DegR9wn2lTFELh1maQf2
         gLijELp7NdUxGXqz7p76Gb1py2GWHk4ingx9c800kqwY3NNjsNGypwVb7H1zS7gcf++x
         WAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1AcHyU9YuFtC3DFhxq+uyC++FLYMrBvu+K8DsXLlF50=;
        b=E6nPmXLMSPbfHHA1e9BDHjX8aOjfB25Sl6VC1wv4NffAfGcbjaZF2PfZ4er/tiaBI+
         4DADOkkWDsbC10RySw7+tgEetPdVpyLPK5CUAIAcn3i/flXzDwfhfTw0G4lxU8+PQA5U
         31N/yoJG1GvdMXFO5ZCv+fXjTAQCmkT3xQD3dvE2KRYFyNlou7+r/U8Buxvny331cehH
         PYAFUbAO3RPn/mwC/HzseSJwm6N7ZDB/4t+0F14rOpIQe+KveXhYs5Dbed+nlZ5tCGQ2
         mIrs12Ba7wtnZphWRvO9kRuoYmjGpVk2lghBc32kFSSQsAqfziG/6UDzK+UeuqGuEOre
         t7kg==
X-Gm-Message-State: AOAM530Mu8JyvLjeHtD7EOBMBs74pRx3hR3HjPXyJCgiGgluGjB/83fm
        qku/3YPp2T/IVnMYHbnFyWN3A+jf4EgVcA==
X-Google-Smtp-Source: ABdhPJyjbMnnlGAQs2AuOdQXhylMvRrPZUx2AOiJ+p0dHfbsAwg3Edkz5G+J554Kvwn1fjYNQ+jeUQ==
X-Received: by 2002:a5d:97cd:: with SMTP id k13mr2675127ios.164.1598905213803;
        Mon, 31 Aug 2020 13:20:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4c46:c3b0:e367:75b2])
        by smtp.googlemail.com with ESMTPSA id e28sm4390898ill.79.2020.08.31.13.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 13:20:13 -0700 (PDT)
Subject: Re: [PATCH v2] net: ipv4: remove unused arg exact_dif in
 compute_score
To:     Miaohe Lin <linmiaohe@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200831062634.8481-1-linmiaohe@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8028a4f8-72fc-2261-eb30-522e4b52282c@gmail.com>
Date:   Mon, 31 Aug 2020 14:20:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831062634.8481-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 12:26 AM, Miaohe Lin wrote:
> The arg exact_dif is not used anymore, remove it. inet_exact_dif_match()
> is no longer needed after the above is removed, so remove it too.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  include/net/tcp.h          | 10 ----------
>  net/ipv4/inet_hashtables.c |  6 ++----
>  2 files changed, 2 insertions(+), 14 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

