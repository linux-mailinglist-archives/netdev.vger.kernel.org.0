Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B44293F1D
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394424AbgJTO7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394402AbgJTO7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 10:59:48 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EE5C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 07:59:48 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j13so2642847ilc.4
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 07:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x7wrM83RnVwEWh0daruuolCl+gsnZqMN5/U7W8AKifc=;
        b=Vd7P/8jfds57kAvQD9uX7pmI7hzNgPGdFD5cm2l3i9hpIIf4yPIQRdnk/wBSNi1w5m
         Te9F4O1RD1YoMmDLn3KdzK2/zmu+wJWruFgtZLj/M4cTd1+zHbXoUNVlBvQ02z1knDBO
         bVpQ+FzfrXWEEwC6PFicn6AJoavJElHyCjHsQaf4yiTB3XUWGdm3HsG8hgAFMbb6WqI7
         gcTniPM847ARZ1ZPt0C1AWdh8gvVq5Y5q7T3G9LwFBBFTY6xNSoTxvQOagioSZLnWp68
         +5MA81lijR8MfpwHs/LqslfGPB6GLW6neiy2MCJmKQelWRL+vgW0IZSOJBeglxW6pUc+
         TEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x7wrM83RnVwEWh0daruuolCl+gsnZqMN5/U7W8AKifc=;
        b=OsArRSDJXzRqSfEvXZZU/psaW5yM8Ds2feCsPinorOWdg1FYg/Iw84XuznoIpzzKot
         T5gxZlTc+fx6+z/lL6md8wnOp6seU3Yx9qqBGRxkGRTZXH+hRe6afHG/xO3YqjxYPimx
         t29b/TV+stF8KpH39shz7ox/FFmD+8MVZ4hAoSvJdTCWs1mE027twbt5qtbe3gE4+xR/
         a2SfNrokzeFS1+nCBEZTFg2yuHPrUEOIK+SbmxREoqWrSFKuxmJQg3XiLFuztJ+7RzRQ
         TyYwF91qEx9ZsVrdO94JtBcouWgpBObj5Kz7y5kYBsI3KAME1/JwZIe6Gy4KqJOvC4L0
         T1Gg==
X-Gm-Message-State: AOAM532igrukyV+0kSymQgyZQDy0tdplAidTgnAcJZJSxPR2w5+M1EWD
        EA4f1IovJ2+YFwTtaubnK8Mj1uIlmHU=
X-Google-Smtp-Source: ABdhPJz1jDlLLmRHFW0lxRJbJLlxSceuf9QGcT9gz3lLeGDnqQQY8lSZtLhqPxQb83U3kE0Rxfh4qw==
X-Received: by 2002:a92:d80c:: with SMTP id y12mr2361260ilm.107.1603205987642;
        Tue, 20 Oct 2020 07:59:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2cd9:64d4:cacf:1e54])
        by smtp.googlemail.com with ESMTPSA id c18sm1651703iod.28.2020.10.20.07.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:59:47 -0700 (PDT)
Subject: Re: [PATCH v2 iproute2-next 0/2] tc: support for new MPLS L2 VPN
 actions
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
References: <cover.1603120726.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <eb1da9df-a488-5920-adcc-36f342c454ce@gmail.com>
Date:   Tue, 20 Oct 2020 08:59:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <cover.1603120726.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 9:22 AM, Guillaume Nault wrote:
> This patch series adds the possibility for TC to tunnel Ethernet frames
> over MPLS.
> 
> Patch 1 allows adding or removing the Ethernet header.
> Patch 2 allows pushing an MPLS LSE before the MAC header.
> 
> By combining these actions, it becomes possible to encapsulate an
> entire Ethernet frame into MPLS, then add an outer Ethernet header
> and send the resulting frame to the next hop.
> 
> v2: trivial coding style fix (line wrap).
> 
> Guillaume Nault (2):
>   m_vlan: add pop_eth and push_eth actions
>   m_mpls: add mac_push action

applied to iproute2-next. Thanks, Guillaume.

