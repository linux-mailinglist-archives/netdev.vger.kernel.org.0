Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF992192E87
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgCYQn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:43:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39764 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbgCYQn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:43:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id f20so2728397qtq.6
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qji6itQwxRkmja6wPCvEJQPDtOccya6nrzgkTEzIwCQ=;
        b=lsQVWdRAKcZT9lmyfr3YJebo1SJUc1mpwLYc2JqsjpdlyPcVnIGxu4jKZYnUypF0GE
         F7BM6Mqek5hZa7bABHhEIldf73FwtQDxb8kfDEmLoAZt6KwEPbLuyDAftPhtn6HXEzP/
         lhJz8Jqzgs8eHr1sqVvstYGamjgWE+sCunCrRmgJvrOiS+liCF3z+2toZMhBuGfgLQx8
         Tk8Qd7kkMWQTo8LtNmeMzJxVXLmYcV4R/Vdw2o4oE4zC1ig39XzczrqkFv2WIjuMR5A0
         1IoMNVis0BSeOtufNFeQQtccpsXE4v9TuktV+pUafWFFijSQjgfrLqhVxsj7+2wvkJTw
         s8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qji6itQwxRkmja6wPCvEJQPDtOccya6nrzgkTEzIwCQ=;
        b=YmtetbQrnUjGYCPjYcKoMfeuiGkMnEEYmophjNfjZbNrlg0K78fVlb7hFjEEM2aTqV
         W2v7FyfR1wX4x0ATXPC1xYk2nrIUTRTVDZ7DWoW0qMYIUIndR1a/903BakPS1VNv3L+H
         lx0gwEgtJw1UE1yzt9yomg+RB9KWvKDud8WqR0HWN6FJiLpB/DGUOseBRi5UvTmT0cTn
         b9zZDjVRDS2VOXrStgjQpFdFgzaWf46q+lKMlQdl6g5PWmcgNLW3neirU4YVOHY9ziP4
         FT2nJzKDptU0lL8XD8Flg55Kab1t1bpsMgmW4EckochkGuR4W+OVMJu0JffifjQjt+zp
         PNAw==
X-Gm-Message-State: ANhLgQ1xsYBfL9I3o73ToK1FDZKAmpl0Kdl6GGKuaZEtbedIGA4cRGwG
        gfNr3OMKeEnG3BeuT+tYXyguEcJN
X-Google-Smtp-Source: ADFU+vsysfAsEOtfD3k13Y/JtSlMfhs47yWevrsRC7D02R7GPVmoWPuUSBuyjdDEUG0scpo2OinBJg==
X-Received: by 2002:ac8:4e24:: with SMTP id d4mr3869688qtw.307.1585154635480;
        Wed, 25 Mar 2020 09:43:55 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5593:7720:faa1:dac9? ([2601:282:803:7700:5593:7720:faa1:dac9])
        by smtp.googlemail.com with ESMTPSA id t53sm17681019qth.70.2020.03.25.09.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 09:43:54 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: m_action: rename hw stats type uAPI
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jiri@resnulli.us
References: <4e960372-2a5e-5a38-b2ae-843957f0cd67@gmail.com>
 <20200320202145.149844-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <26b5c7e8-b92d-d887-6f70-0b3938eb45d7@gmail.com>
Date:   Wed, 25 Mar 2020 10:43:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320202145.149844-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 2:21 PM, Jakub Kicinski wrote:
> Follow the kernel rename to shorten the identifiers.
> Rename hw_stats_type to hw_stats.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tc/m_action.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 

applied to iproute2-next. Thanks


