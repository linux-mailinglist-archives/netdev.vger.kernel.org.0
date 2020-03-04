Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2632E17996D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgCDUAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:00:39 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39285 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbgCDUAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:00:39 -0500
Received: by mail-qk1-f196.google.com with SMTP id e16so2929905qkl.6
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 12:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NOYamIvIzIc0+GlJ3XusH/Od9U+7ljpDA7fKeuHk2D0=;
        b=teJLug3D9nD6Bqc3W0/q+IBNLRKlY5H6Jz4hNUQoynoNRekJ5Ct+vRJsOBT00EuRf2
         u/0DGqw25obHQI2G1iyRf/Sa/9/KTi/XouxudEHpnoQbtbTGXn0G+ykupcdwQ2E5VPNc
         heCTnScuwj6eBcIcf02J0mUtezOZYOaoRJfWmppp7WYGVLeghQLwrGVfhZTyq1HppqeW
         HXps4znfkDG9PDigDg+4Xlj6c/aejNOn3b6B/q9G/RO7lgvmk4aFD5Y35iqq+fZr5+rW
         fpkIWZu7ZvDhz+HzQ77O977lp/JEtnYtSGEvMb3UmFyU4tbz5GFy3jFVOoLNLRdY/R1B
         tySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NOYamIvIzIc0+GlJ3XusH/Od9U+7ljpDA7fKeuHk2D0=;
        b=SDyFVZchc4v5PSsYyK/dbMayhoA2IQsbtoT0rTiNwW2VQkVGoNPhYKBnpSixvE3KQJ
         NIkNsPR4kd3IrhniHUolr5+0/5QadEDcTXF3R8hVoViel68+vJw0tkn1xedkTeWub62B
         foymt4y2evIlqKv4HgaQ1TU2D3c1I6cdUmoKVvxdu2SaYz5aGMvo+46hCVxiKSNJe9TO
         aruqckrHMp8nNtipk3J9Y9USO1Xrx/T6/mARCuljK5XhTRwprPgdQ/9pNHHb7xMJGRV3
         tqnL19uozJTJlSRFsARfmJqArhzTupAgYPKOAuR+cVwiUgXhiyFVMR9S6Y1FbBzdeHw2
         CFpA==
X-Gm-Message-State: ANhLgQ1Xgv2UmaVE8NkZSrFHBszGG+Crgwfyn/JAjmtw7uJUiVVQTuX/
        xRSFlqkdjQRgu5pjY2bp72DgSmTE
X-Google-Smtp-Source: ADFU+vsEKkJ4lx+5JnyzeTYMD4VjPNdyIgkCzoZ3ifyWgFY/Nv0VT04J6X3QskKn8E6YHaV+O7/4nQ==
X-Received: by 2002:a37:e86:: with SMTP id 128mr4505925qko.403.1583352038211;
        Wed, 04 Mar 2020 12:00:38 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:95f4:82ed:fbec:d0a2? ([2601:282:803:7700:95f4:82ed:fbec:d0a2])
        by smtp.googlemail.com with ESMTPSA id 65sm14457658qtc.4.2020.03.04.12.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 12:00:37 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 0/4] macsec: add offloading support
To:     Antoine Tenart <antoine.tenart@bootlin.com>, sd@queasysnail.net
Cc:     netdev@vger.kernel.org
References: <20200303103619.818985-1-antoine.tenart@bootlin.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <74e7f534-9ada-f553-53d4-420a37a9e227@gmail.com>
Date:   Wed, 4 Mar 2020 13:00:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303103619.818985-1-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 3:36 AM, Antoine Tenart wrote:
> Hello,
> 
> This series adds support for selecting and reporting the offloading mode
> of a MACsec interface. Available modes are for now 'off' and 'phy',
> 'off' being the default when an interface is created. Modes are not only
> 'off' and 'on' as the MACsec operations can be offloaded to multiple
> kinds of specialized hardware devices, at least to PHYs and Ethernet
> MACs. The later isn't currently supported in the kernel though.
> 
> The first patch adds support for reporting the offloading mode currently
> selected for a given MACsec interface through the `ip macsec show`
> command:
> 
>    # ip macsec show
>    18: macsec0: protect on validate strict sc off sa off encrypt on send_sci on end_station off scb off replay off
>        cipher suite: GCM-AES-128, using ICV length 16
>        TXSC: 3e5035b67c860001 on SA 0
>            0: PN 1, state on, key 00000000000000000000000000000000
>        RXSC: b4969112700f0001, state on
>            0: PN 1, state on, key 01000000000000000000000000000000
> ->     offload: phy
>    19: macsec1: protect on validate strict sc off sa off encrypt on send_sci on end_station off scb off replay off
>        cipher suite: GCM-AES-128, using ICV length 16
>        TXSC: 3e5035b67c880001 on SA 0
>            1: PN 1, state on, key 00000000000000000000000000000000
>        RXSC: b4969112700f0001, state on
>            1: PN 1, state on, key 01000000000000000000000000000000
> ->     offload: off
> 
> The second patch allows an user to change the offloading mode at runtime
> through a new subcommand, `ip macsec offload`:
> 
>   # ip macsec offload macsec0 phy
>   # ip macsec offload macsec0 off
> 
> If a mode isn't supported, `ip macsec offload` will report an issue
> (-EOPNOTSUPP).
> 
> Giving the offloading mode when a macsec interface is created was
> discussed; it is not implemented in this series. It could come later
> on, when needed, as we'll still want to support updating the offloading
> mode at runtime (what's implemented in this series).
> 

applied to iproute2-next. Thanks

