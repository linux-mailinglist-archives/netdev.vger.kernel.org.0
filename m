Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA562FAD9D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbhARW6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbhARW6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:58:39 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A0C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:57:59 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id q205so19250672oig.13
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4LF+c0jvmjlvUgkmXnR4einSnUUo/BYucbUefBpSR/w=;
        b=cm1XamvYlpEoQ6jd1YI4N6CJv0xAsSL9Ms47WLeSrpQRXDhOm5t0vpgLWSzr8lnexi
         TihA09GfhkH5vpRomlNls7dv+y4/BQzj7s56TpN6YmN4WtiBrLLN3+JLFltvzqUOlIrH
         +ja11HoBkSQVJimVazel6YE7nPgNx65plXcSgvWzG6NlgXkpYSORJOl+rkmMT7zzaHaE
         nlJ6Pce9OBkcW0Zs5C230IZ3QSqb/Qs65tTJs2dGn0F/74xBwkd4f4smpJ8WP0sR3ycQ
         YgN3xVTXKknvGhiJY0r2XPyiYm2/awKCInubyN+8xnSUHFCwgxgkivmsVvnS3KKSSD2W
         efow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4LF+c0jvmjlvUgkmXnR4einSnUUo/BYucbUefBpSR/w=;
        b=HAXbqpo9jF1CSBuNy3TT5AztzPQgH4AIl9nA/c/vNcvBVkNqFGVMSEYmL9W2QfakXz
         k6m35ZIGowhbgLbdxgq9bvJAUTN63Gt+D74wuAFtvH4i+e/by7BUbIxu9sOa+Kb9na9X
         VZ7FSVXa5DNgFEs6jUBiA78yDwygPzZEQsxvOvK2WnZ+ahnUTU5JayyawGhMfDH24C0F
         aGRVtK+gHga5lfaO2dfJUV5SKGQ5cfVFrWgUop6lAVmCDgdXx7ayUtZxn5zcppl0kDCX
         UwtBzBg4/CMnEGs/ImXDZaSOYtmon6npeTA0sETqtSg2rbJcAUNuGVZ+K71GLJPN+tUc
         KPQw==
X-Gm-Message-State: AOAM531capnWtcb5SOKM3Lw2lQtEz6voBPEEMro6rSgihcSuRtWcCO82
        M3PSeQmiylCfm/0Bh2YmtAA=
X-Google-Smtp-Source: ABdhPJzXOp1867yNpLNxfCeJ7QSTCe2K9G1HSlgYm/JQ8fe9R2aOXMPnzOItfXMONG2YLpOr1Bu4aw==
X-Received: by 2002:aca:d612:: with SMTP id n18mr893924oig.62.1611010678644;
        Mon, 18 Jan 2021 14:57:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.44])
        by smtp.googlemail.com with ESMTPSA id x20sm3847058oov.33.2021.01.18.14.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 14:57:58 -0800 (PST)
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Edwin Peer <edwin.peer@broadcom.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>, roopa@nvidia.com,
        mlxsw <mlxsw@nvidia.com>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <CAKOOJTyWWsK0YgN+FVF8QgHaTbZrjpEYkG6Cfs4UVsB9Y8Mj9Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9b940a66-8c91-34c1-e64e-42b92bf403a8@gmail.com>
Date:   Mon, 18 Jan 2021 15:57:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKOOJTyWWsK0YgN+FVF8QgHaTbZrjpEYkG6Cfs4UVsB9Y8Mj9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 11:01 AM, Edwin Peer wrote:
> I'm facing a similar issue with NIC firmware that isn't yet ready by
> device open time, but have been resisting the urge to lie to the stack

why not have the ndo_open return -EBUSY or -EAGAIN to tell S/W to try
again 'later'?

> about the state of the device and use link state as the next gate.
> Sure, most things will just work most of the time, but the problems
> with this approach are manifold. Firstly, at least in the NIC case,
> the user may confuse this state for some kind of cable issue and go
> looking in the wrong place for a solution. But, there are also several
> ways the initialization can fail after this point and now the device
> is administratively UP, but can never be UP, with no sanctioned way to
> communicate the failure. Aren't the issues here similar?

