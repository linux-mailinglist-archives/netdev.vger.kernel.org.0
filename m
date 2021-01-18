Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64692F9895
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 05:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732203AbhAREOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 23:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732097AbhAREN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 23:13:58 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA174C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 20:13:43 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id x13so15036422oto.8
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 20:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ibO8Ce9w26pmHWjzZ4ajoLCei6fHAofUkO2pUfy8sak=;
        b=ibZXD7hfzlqKjZz5NulatipmaGmsrpPZRAAducxNtY9J0JU57nYlN9WCIOH1t9DVFo
         IBcl/w25tpfG5vYaYDxNesmMowtDI2jEdltaSQQv+zcwJahJLLw0IqsNgfT1dwfQCLkE
         KORJ+Ia4c5sqySIEHK0/C3MnfPGqINgySOn/Ty825wokUmt1Y0C9YmP+oiXtra1ZplhM
         mQbIJv/3zkgbRHM0YWy8LPqBdkdacWJv1FrS7RP/92z7djjcubUL0WjS+0CCEdiVZxyM
         uX5h+ujYzhOZA9AxzV26GR+JANqZiSYb+w8ldUVVZTKRuZnFkbA0liGjlFbBN4x3F/L6
         5wJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ibO8Ce9w26pmHWjzZ4ajoLCei6fHAofUkO2pUfy8sak=;
        b=RpGU7+xcRI2eMsl3DYq5ySGUg5zHUm77S2d6h6gYWGw4yWY6RcPHfGxyyqFd7lftGR
         zx9r/1WVcNAhaMBf3pu1p9VVdH3vzbiNV47Jml6EuCVG2jTwZBDO9W6iWf3NsYrlRwFt
         SWlFkO/HJPsB4JK8C6oU6Maa34j641GEN5J10anfG4KT6aeCi4gMNgeVDK3ZOiIXJ1O9
         FvjdmAFK3RTR+Fz4v+P/CpShIq48UvE2tJlPgJSJpxi0mEUdvit58mrsL4cESe7yvmIw
         KzAyI6HLODC2ylE9wYmMnXGXsnIVJZuOX5tyXSOxDf6tcElThoOMuLQ1xV0t0Oeln7x4
         zgCQ==
X-Gm-Message-State: AOAM531ptp/NhmgmyxLFIrOD+SyfuJmKtpoFZWDQ5ukQ+Qjp0Q1clP5C
        8fv2M8NaJ2fiu8J0Zv6pxP8=
X-Google-Smtp-Source: ABdhPJxWAL2PkicatEzpW2lSZ9BINfwUjytc0q4US1djMrKNhACNsbV0t2b095eB66HJZ/5wvu56NQ==
X-Received: by 2002:a9d:5d1a:: with SMTP id b26mr16648730oti.112.1610943223190;
        Sun, 17 Jan 2021 20:13:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.148])
        by smtp.googlemail.com with ESMTPSA id a22sm3559852otr.75.2021.01.17.20.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 20:13:41 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 0/7] dcb: Support APP, DCBX objects
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
References: <cover.1609544200.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f8cd18dc-b399-9a40-dada-bc6ed5ae0e8a@gmail.com>
Date:   Sun, 17 Jan 2021 21:13:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <cover.1609544200.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/1/21 5:03 PM, Petr Machata wrote:
> Add support to the dcb tool for the following two DCB objects:
> 
> - APP, which allows configuration of traffic prioritization rules based on
>   several possible packet headers.
> 
> - DCBX, which is a 1-byte bitfield of flags that configure whether the DCBX
>   protocol is implemented in the device or in the host, and which version
>   of the protocol should be used.
> 
> Patch #1 adds a new helper for finding a name of a given dsfield value.
> This is useful for APP DSCP-to-priority rules, which can use human-readable
> DSCP names.
> 
> Patches #2, #3 and #4 extend existing interfaces for, respectively, parsing
> of the X:Y mappings, for setting a DCB object, and for getting a DCB
> object.
> 
> In patch #5, support for the command line argument -N / --Numeric is
> added. The APP tool later uses it to decide whether to format DSCP values
> as human-readable strings or as plain numbers.
> 
> Patches #6 and #7 add the subtools themselves and their man pages.
> 

applied to iproute2-next.

