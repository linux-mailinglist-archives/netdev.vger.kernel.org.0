Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C411214D49
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgGEPGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgGEPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:06:51 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C72C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:06:51 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 145so30225653qke.9
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/3ZIsOkBoFzeiw/Uo2ycNSshDo8koYm0Fo85arTHw/M=;
        b=O7tvU8qG9Mi1SV4SnqNcoX+dGm2CMIBob7oRIoX4iwWkQtgI/FqU5rI5vu8ZvpRcMI
         gPtoNd1HnHFW26Y71RAtVlES8+tqnzRQLEdOoYlMdxSTjK8k65rTl9MIx3kqpaeLZwsW
         Sx8XP+Sh6B2uWQjyrsFAjm+sziVI/Ld6NX3BHPu/UkFU/UShak5MHj9l/m/yboRTRVuj
         c2H1u+wF+KTryoVvMM6bS1w/DewsTXvK9CpflzVfbp7Mx+c8ipN1axvXsI7C9MWRlMlo
         nGuXmtkYEjiuLg/gXBTHNBjCZkveN2bdKjDezsZUeFSJ8kZejQi1AD16A64H/cns5DUv
         Ys0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/3ZIsOkBoFzeiw/Uo2ycNSshDo8koYm0Fo85arTHw/M=;
        b=cuL2c2PFK3l2D35qFSI9UwzMcqeEgL7swyXQFLBPj0bR2UFNuO7Yw9bDY3DEJfbtaj
         s7ecKXaQeStVtLsF38jXm/w4GQHdC84F2tDcOHrqvenLekp4VzoeD5/sJiVin9o5Ax1L
         qqj8CYjhLNZg0nQIgJEWDA2xuawxM9VVeOuZX5M0L0Y14lm7ca4E6eUD8q9tTiOHMVnB
         lTXQXWGMImy9KQBrslJEHDtuVoxosOgr9xu8AaG7pHgd8yylVPdu3BfbI+nt3RxclKoQ
         ar1m33GuDSsSRjGIRj/NYYfuTvaHX1Ug6sxzJTqIGiShp9PuyeoakbTsqhhvMmLfYOm5
         48qA==
X-Gm-Message-State: AOAM532MTeSdAangWgAKuUgIswST0hoVNpraIa267S4n2vO/ZB4TdUT+
        lWqSnDfqItaS9LBLX6JiWbs=
X-Google-Smtp-Source: ABdhPJyalqnOnCP/0odkwHjnimN3akqW1q8OSai0mEcVlEmj1EIejB9FT7PuB/Hhw8oCJTQsMiD2sw==
X-Received: by 2002:a37:a80b:: with SMTP id r11mr43652098qke.474.1593961610927;
        Sun, 05 Jul 2020 08:06:50 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id l1sm18106717qtk.18.2020.07.05.08.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 08:06:50 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] add support to keepalived rtm_protocol
To:     Alexandre Cassen <acassen@gmail.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, quentin@armitage.org.uk
References: <20200624162125.1017-1-acassen@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <13433295-b8d4-80fb-223f-d1367c8a9bc2@gmail.com>
Date:   Sun, 5 Jul 2020 09:06:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200624162125.1017-1-acassen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/20 10:21 AM, Alexandre Cassen wrote:
> Following inclusion in net-next, extend rtnl_rtprot_tab and rt_protos
> to support Keepalived.
> 
> Signed-off-by: Alexandre Cassen <acassen@gmail.com>
> ---
>  etc/iproute2/rt_protos |  3 ++-
>  lib/rt_names.c         | 43 +++++++++++++++++++++---------------------
>  2 files changed, 24 insertions(+), 22 deletions(-)
> 

applied to iproute2-next. Thanks


