Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9E0220136
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 01:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgGNX7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 19:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgGNX7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 19:59:10 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EE1C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:59:10 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id o38so338951qtf.6
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ufvwRr8zCpTFSXLUcCvne9Su/XeYx5A9944BrvE1OdY=;
        b=BRw3IJpgZB1W3lxpho4Eokmbpnj7gg/peiErp1Xd4KirbSikbkmCr78oWQzUBH6JvQ
         ObmJbSWwmjxr9KI4Pz/FGk60rJFd8uE8KacVspVfxM1BNd1O8w69lzrva387Fl+0F1rb
         y0S2Hfb3yELRag2xP7jkLsmwpsMHorg5uatrZrPbHxWHwtv4nCLzSuvo6eTKTmdd0YZO
         i17/t6ilckQUYd9WbsjDZOvm6F2K2oVDyUmtV2apv+PW0lUIfW+19cH+JO5ODolHweSx
         11hmAI6NYSwqSh1FrNzWFNFbdRjqozCzv3AXAOv9ob5UbITZNnfVZ4/YjhKyEC+GGEyM
         AvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ufvwRr8zCpTFSXLUcCvne9Su/XeYx5A9944BrvE1OdY=;
        b=ph+OsVlMMtMPWgvcFiC0aZ9x6uIKn0syXZdu3GzS76ONpbHlwVzo8gnhLdjk5rPn6g
         SVadA24zE0GERDu1y2rUgxZgXbcdAXd0ioOGgW2PqQ6rnwj04VxliFR64BDI11byuD6I
         RS0tCUEivyLHmr/YGxiJ4zQHOIAmOyvIOOFPpMoRaFsJB0orQFRtmydcRCggbGcmyn+G
         jiIeWVhH9EzCo5EP3GFGkDkNTsvh29M3D3rHxpplCc0FlJMoadCOM1YQtU6dcZxjKUPB
         Zb+M4FzakiMCMavS9hXBnV07H6zCcQhzNbbk0xc4j3u6SaJMuMMaptE7ZsWy5ymeq1K/
         Osjw==
X-Gm-Message-State: AOAM532uxnnVBOEsZmDiXoTyY/ajAoNPZYUDHvyO5E/DceMlAJKzkHvi
        llOxRMGNPZuCpoAJa+s1pPE=
X-Google-Smtp-Source: ABdhPJz7iM2zgDyRCKeikq7VhbA2oeCHJXG61TQfrvJmKITcvtnhSvuppDjMZgZoleGv3uMR4iv5Qw==
X-Received: by 2002:ac8:d86:: with SMTP id s6mr7516233qti.343.1594771150063;
        Tue, 14 Jul 2020 16:59:10 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5535:8779:7beb:b05e? ([2601:282:803:7700:5535:8779:7beb:b05e])
        by smtp.googlemail.com with ESMTPSA id o18sm338408qkk.91.2020.07.14.16.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 16:59:09 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 2/2] ss: mptcp: add msk diag interface
 support
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, David Ahern <dsahern@kernel.org>
References: <cover.1594388640.git.pabeni@redhat.com>
 <f99042572923cd0d569f3fa89393ca9b384ad1bf.1594388640.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b3b053a5-186e-a272-0576-65d0950295d4@gmail.com>
Date:   Tue, 14 Jul 2020 17:59:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f99042572923cd0d569f3fa89393ca9b384ad1bf.1594388640.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 7:52 AM, Paolo Abeni wrote:
> This implement support for MPTCP sockets type, comprising
> extended socket info. Note that we need to add an extended
> attribute carrying the actual protocol number to the diag
> request.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  misc/ss.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 105 insertions(+), 10 deletions(-)
> 

applied to iproute2-next. Thanks


