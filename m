Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC924E07E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgHUTNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgHUTNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:13:22 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D139C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 12:13:21 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id k4so2440812oik.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 12:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uLq6h7zLQ4fyQdUIuiQgHNEtwi6kRgNEUIRE4gZlMOY=;
        b=aOdD2kLAKcRUXzxJDbv8QrZxKwmlvAa0ZdNMVUcZI3ps4QbebM5IZ69HVmcjPp3xZ6
         IpOl76ZSfVY7kW2b9Xop/8r8pw0Y0v3PNegocyGvLGVxI/EvNMEL4TxXzpLPDgznZAzJ
         BiMk8HiBDDxJkUwr90+yNjygZeciZygfWvWkQipPWS3FRLODt5oxoLnmihQRAMy5CUbk
         rpseZPEn8Bh85yUfxDZ+n4G/L3extScXZ+tu/au23+9Fnw/7fuYEj99NnjKjUJC4Yin6
         EwFSDieB7zyBY1gKbCgp3+TJPBPLVu7nlzmE3+rWAccA8GGtYnK60A7OaYNXVcqX8dJk
         C+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uLq6h7zLQ4fyQdUIuiQgHNEtwi6kRgNEUIRE4gZlMOY=;
        b=Y3XweGCJhhHYxDmVinhDMpukRKG8dKmeNlhGB6G9nmD5jr/HJZyi5WfjNkjGAAw5ZK
         w7Btk8x6qScSgUXy0kwtig/ZjmAispW8P8K8Nt7cHnZo2dBZj0qu4DXiwOMyuuhVHBds
         Q5airvDECQ4qIMKCTDRnNA7PMOMQmQ4rx2p3jznb8CIlYi/pgMMr5nA9AOImzvLRfTxF
         O27FdUcs2aNNu9YlEo89SiX4k5bQH4xfoPXshkXEwgsEmNaeeaT6bpMewG+Hm+erEtKk
         Fo2JsVSRXw/gVo8CpAZZj9kVy24sF5IIW6TAUFKktdJ2SdP6nsyF4R3ZQN9uTMzhD3fz
         Km+g==
X-Gm-Message-State: AOAM533cat16RRgfJeb7rQI8k9kl5dImC4SmTTMwh0D5PVtFBRb4V5vO
        HZr/mK0SzsuQfidvZoUOLLc=
X-Google-Smtp-Source: ABdhPJxbJmB0sOI2dXwuNKrZdYoqqbIldoqiN4bF5zpBBZJNQissFxDLej9Bax8ToLrUqBwFKxDzpA==
X-Received: by 2002:aca:d4d5:: with SMTP id l204mr2772513oig.70.1598037200992;
        Fri, 21 Aug 2020 12:13:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:a888:bc35:d7d6:9aca])
        by smtp.googlemail.com with ESMTPSA id k34sm524171otk.46.2020.08.21.12.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 12:13:20 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com, roopa@nvidia.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, tariqt@nvidia.com,
        ayal@nvidia.com, mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
 <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
 <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
 <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
 <20200821103021.GA331448@shredder>
 <20200821095303.75e6327b@kicinski-fedora-PC1C0HJN>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6030824c-02f9-8103-dae4-d336624fe425@gmail.com>
Date:   Fri, 21 Aug 2020 13:12:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821095303.75e6327b@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 10:53 AM, Jakub Kicinski wrote:
> How many times do I have to say that I'm not arguing against the value
> of the data? 
> 
> If you open up this interface either someone will police it, or it will
> become a dumpster.

I am not following what you are proposing as a solution. You do not like
Ido's idea of stats going through devlink, but you are not being clear
on what you think is a better way.

You say vxlan stats belong in the vxlan driver, but the stats do not
have to be reported on particular netdevs. How then do h/w stats get
exposed via vxlan code?
