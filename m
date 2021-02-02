Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550FE30C407
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbhBBPi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbhBBPgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:36:40 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79992C06178A;
        Tue,  2 Feb 2021 07:35:58 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 63so20224205oty.0;
        Tue, 02 Feb 2021 07:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tdFhB73A7dTTwfblIiXQMJ3iM2WbUmdSjuebDAtwxg8=;
        b=ULkz5rx865PO4hyqXiU0CvoD8nLy3Fmoa2CW0hS/qL+mhsAtbm87nKMtLQ8go3FOzR
         1jase5lCYJL6I5AUhMiboSh26Wr+FrLhEIZ+UkP4+OzTuny6xy1N66GLnfGO9vQpf9Q/
         O/8pEw2fi9OizE2Fn6lexn64BMRAE4bkCK9Txsog6+OdF22jhN2AX0w4ZxXff8+HoQst
         5Q3yXzFwoINH4yswVtulRTP8Tprg/Tatvk74UfRdUQ36zIeviPVOR9X//QRi+VoeI4T3
         zrYpmflVhNjWaY8WLlYZYmmznQYXSYxLy0O/c6BJHmXQ0iYIWzy5hbPSID/UGMmAJtUq
         ntxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tdFhB73A7dTTwfblIiXQMJ3iM2WbUmdSjuebDAtwxg8=;
        b=PoV4lqmweflc5d0CGB6wRyJJG+l8muna6tQb1n3QIkR2Ej41aPEMw9Vz8p9wX5MlTZ
         WJCxA41DDRkhY3AryoBdMs5X7EugRNccK64XkdgfojzXYJ+OfJ8jEO6BJeyhmEMGAsOc
         jz4hsjc3dVbxlignSCm5EbPEUdIxqpNwVFzaLPKq+yXn93uy68LIotEZ5Kjzf3RFz4t1
         ZFyF+gwJR3g5yGEe+h7ze7K89Xydrw+00P7YF/csQenGay3Bb2c7E+DXa294/y8Yf32/
         qbAFVxUIhVW+Uxs7qk5+phrt5Z6Bp1rmgRPCjHrMQXWPQOR/w8bl4ewqNpza+a1t2B7X
         SSGQ==
X-Gm-Message-State: AOAM532tX6HkVE1B2xjDKahiHJekIT6uSvUliucyQKDl7RVuV4jkj5yM
        wyM/m0SDuXnc0OKR+EwR5Gr3BPfyfEg=
X-Google-Smtp-Source: ABdhPJxl2ocQ9oxqTL9Ow+Bspd3uWxH3q5cJyCKAq3Fu3HpSxWpYV1R0dVCrJIHTNRAi0igD0tuZYQ==
X-Received: by 2002:a05:6830:543:: with SMTP id l3mr16140902otb.241.1612280157872;
        Tue, 02 Feb 2021 07:35:57 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id v207sm5341685oif.0.2021.02.02.07.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 07:35:57 -0800 (PST)
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20210125104055.79882-1-socketcan@hartkopp.net>
 <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
 <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <586c2310-17ee-328e-189c-f03aae1735e9@gmail.com>
Date:   Tue, 2 Feb 2021 08:35:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 3:48 AM, Oliver Hartkopp wrote:
> 
> Are you sure this patch is correctly assigned to iproute2-next?
> 
> IMO it has to be applied to iproute2 as the functionality is already in
> v5.11 which is in rc6 right now.
> 

new features land in iproute2-next just as they do for the kernel with
net-next.

Patches adding support for kernel features should be sent in the same
development window if you want the iproute2 support to match kernel version.
