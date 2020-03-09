Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DB917D835
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 03:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgCICtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 22:49:06 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:38379 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgCICtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 22:49:06 -0400
Received: by mail-qv1-f65.google.com with SMTP id p60so1714274qva.5
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 19:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aumzn3JCsVacS0kLF1lF7fhe5Q2GmsWbctVm5BMWdcI=;
        b=Tjsq41XlR5M0VDyKxIvh6farkcRbiXA+lhyOiW94qFhwNrrvZ32k+2WAz9Y3xBitvg
         fQWE+aEtE6eXuMQvXtxtrRGOHsoHxPfTqgC7c524OCOBighJwEtAnI2QCcls3BxRNlLw
         cO4hlpI4MJh5jcU036m8zKLm9DBqkO1Hhy+ZevadI7vAC8kQwvV4R08BGUvh334NdEvB
         7wpgnOEXv72KJnlioDj2zpVRMlKSBTqEnXrnIpQfRTV8EiFFQcu5gmwMoc9CcvrealeY
         N04kCj6l1lIJEy9+N2Zdn+enhr5c85AK3f7pRMKNlQOwfgusgm77Lzlpt1EJAbKrh8aw
         w1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aumzn3JCsVacS0kLF1lF7fhe5Q2GmsWbctVm5BMWdcI=;
        b=Mz+klLcHJBZM6LH/2iXAB2AU565gMKQpH4N+KFpnmrTeyQy5JnOAvpoImS208Za/oj
         zil1SiXHFjl7iCYZXzU2o7PgYNhis1pjL0lB8nBEq8WPShjzvkCxWHZhB8BBkhIo4qQu
         U6knIcMJl19c/mCUR41yOFTJibWtu/RaSP5aUancaYW62xbMCfRAFd25ghPil4xgckoa
         RwWHJuVijJcwBS16t87uRL3eVPh6MyAAiXc4tMwANbcDh+kGoT82l7kaSqPWN4XwHgpu
         teHff+SUESe95QTsBYvWX5hnmq5YzfUXI5Yw4wmh7jpxZFH9x3akOb23l+QftWQX7ijY
         PRaA==
X-Gm-Message-State: ANhLgQ3vZn/ZooglaDwq8QSWcPvBhxBifDZFK5QdI2kCKNCw8qCJbruC
        3AqSztJByBnUEB+abE3Ao0A=
X-Google-Smtp-Source: ADFU+vtht6UINHvM6WHHeVfuD+gq4gH3Z8OgwnLo3cqAuLWT0RfLr0Lfmbq9hupFCC2L8VGzoPSP0w==
X-Received: by 2002:a05:6214:6f0:: with SMTP id bk16mr12942810qvb.23.1583722145257;
        Sun, 08 Mar 2020 19:49:05 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:54d7:a956:162c:3e8? ([2601:282:803:7700:54d7:a956:162c:3e8])
        by smtp.googlemail.com with ESMTPSA id c191sm6850915qkg.49.2020.03.08.19.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 19:49:04 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: pie: change maximum integer value of
 tc_pie_xstats->prob
To:     Leslie Monis <lesliemonis@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
References: <20200305162540.4363-1-lesliemonis@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <37e346e2-beb6-5fcd-6b24-9cb1f001f273@gmail.com>
Date:   Sun, 8 Mar 2020 20:49:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305162540.4363-1-lesliemonis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 9:25 AM, Leslie Monis wrote:
> Kernel commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows"),
> changes the maximum value of tc_pie_xstats->prob from (2^64 - 1) to
> (2^56 - 1).
> 
> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> ---
>  tc/q_pie.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks


