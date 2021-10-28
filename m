Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7166243E496
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhJ1PK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhJ1PK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:10:29 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED18C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 08:08:02 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id t17-20020a056830083100b00553ced10177so8812358ots.1
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 08:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=U+t3+9k4Tr+OnUorhncyexgm5Qf98x7OjtnyDMtUrX4=;
        b=fLxM5P3irbMHFJC4CrHqrj5e2BPsXVIH4VbgnjAcmIkYLsC/Fa4r8wUdhbIz40dZkR
         RCv9DqFWVkD+UfDhzax+fzAAx3XFid6RHmwRGl3g9FLT35aMPhloB/TH62yXevFj43pD
         FuABcY8utDSOs33f0/RatgFVcLT0BSdGGRIq3PSeJ53dd3DsIDRuAVS1gT2SRCA5HpXh
         s7/ELgH6m+la1APqfTXS9L1nTAyXrPgSJwwvx6Qx2ME60MqPt7joaomSlN+x8HRzkYlh
         WBY2PPj3LS3rW9qfCD+uJoZ/lB6zoiIWUoL6rTyZgeMCPR73h5uZUJhMKxwQ5w/90siv
         lO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U+t3+9k4Tr+OnUorhncyexgm5Qf98x7OjtnyDMtUrX4=;
        b=RgzjdfLSpd8gIie5MEMc5lq384RX8SVzObVBGIU441Fydp5hCL1t0N4x8UOfXGEQFC
         7l2opr7vyrxSotxLowHkREyfX3thg4URFMVwcHzG/WQMRn9jDf/Hmc/1CQ7gLQzjF03W
         12LIsnmfZu3Ta+47d+3V8aCQMLbhnJZdXV4+Ht/Viw97yT7Gs80x2ZA1USqC+/mcrYkC
         54RustYqyzGpzq3Bwff8Ph508tUj/QCwvU+dB4A4bGPiDN4T4OrUo0K2kkArhOd8DUJS
         gGXLlMOoLvsZKwGCWeEoZpjda6BQmB+ChIOPQL2R04Fs8D9+iS3pdpAYk4lRoyx2xLhJ
         wvUA==
X-Gm-Message-State: AOAM532S7vyqM+1KrvUGPXPOrWQUssHXu/PAUM3sOLjfb6jBwmJKfNwx
        +SQ2GJRDNBS+9OXgSQzMd8g/nDljn28=
X-Google-Smtp-Source: ABdhPJwy6sQvS32nbviJEZ8rNqvM3OdLWVyDu4Fpq6Yc3f2/iXCDPv21OJlX1aAbRMkcadDB2jgL2A==
X-Received: by 2002:a9d:7403:: with SMTP id n3mr3930506otk.9.1635433681504;
        Thu, 28 Oct 2021 08:08:01 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s23sm1137425oie.20.2021.10.28.08.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 08:08:00 -0700 (PDT)
Message-ID: <d9e2e1a1-bd99-b318-560f-17abf23f8dcd@gmail.com>
Date:   Thu, 28 Oct 2021 09:08:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH iproute2 -next v2 0/3] ip, neigh: Add managed neighbor
 support
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
References: <20211025154728.2161-1-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211025154728.2161-1-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 9:47 AM, Daniel Borkmann wrote:
> iproute2 patches to add support for managed neighbor entries as per recent
> net-next commits:
> 
>   2ed08b5ead3c ("Merge branch 'Managed-Neighbor-Entries'")
>   c47fedba94bc ("Merge branch 'minor-managed-neighbor-follow-ups'")
> 
> Thanks!
> 
> v1 -> v2:
>   - Rebase and dropped UAPI header update patch as not needed
>     anymore, rest as is.
> 
> Daniel Borkmann (3):
>   ip, neigh: Fix up spacing in netlink dump
>   ip, neigh: Add missing NTF_USE support
>   ip, neigh: Add NTF_EXT_MANAGED support
> 
>  ip/ipneigh.c            | 38 +++++++++++++++++++++++++-------------
>  man/man8/ip-neighbour.8 | 17 +++++++++++++++++
>  2 files changed, 42 insertions(+), 13 deletions(-)
> 

applied to iproute2-next.
