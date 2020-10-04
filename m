Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE44282BCA
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgJDQR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 12:17:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59ABC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 09:17:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so4028317pjd.3
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 09:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1R8CfHN597AHGftGxjc9pIo4g5jqwhdv//9a2vnOg98=;
        b=PaeYQNUhkg48m3VS7VEw+8HxOn8ztO6AH1Vj+LXckiiPlcR+hkN2LsBPV0zL1NztC8
         EBtnDj+4ZoBxL+my6GS2prnamP504aU9LQWLbbyhLc+L9PFtL+/CUBNPfdJlJeTHPpUA
         Am/nM65srs47rKicYZmbldnFT0rbaby6VuRI5YFT2MNeFlEdytFLkHhJEXBP1jNIn/Wv
         nUIM5UQZUiDkqFK3/+/CVezoOMH/SiX5yUQuCpwxgI8dnzVu3RkwFdOUFgJ6GNRHHeFC
         JK4eD8kkSzP19064RmJK5Y7grX5lgEB+okeiBD7xxM1x5QF3+1qbBkgtxgn0u5r+ZoDL
         Ofeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1R8CfHN597AHGftGxjc9pIo4g5jqwhdv//9a2vnOg98=;
        b=h3T/NekDq6SGXuAZihrcgTdLU4xzZcZ/hXRF/ydutk0rht871j/hZmbvbpF4r6ZO4j
         /xwRbuVPg30mnHogQ3OSskcTHNdnCEqlN1pqDOKwzUVudf77piuVmecP3jdNomvfxSwC
         raletFV4rimQL/q14jvWbGQ6jvFLSHs7zQVsb4K1x6QCDNt7tvBtQqtjSiu6C/Hn9P8h
         /tH7qxp1x0DhtFRXWYupRdEbRDlKc3cbNo7ksSSZ76QB5jb3NwUcuKjHD3nMfppWYCRb
         B95XgcJY15Zr55+LpRd7LSpcuf7wQ2rOlXi+xJVTYSiLO7ngBtrDFRTMzjQnN09YOpbA
         7ctQ==
X-Gm-Message-State: AOAM533VjjUsk9KAlUGZs/iBL2Q/+ZkUpMp1WY5uXegtKMue8nlbWyXj
        MTkfc38CAtm5NkCNuHlR8oc=
X-Google-Smtp-Source: ABdhPJwz2jSq+R39817qmWUFFkSeb8HvLMvUAYisiKaO6NhsZIh50rkyzOnzj3nli9nFCZQEK9rjVA==
X-Received: by 2002:a17:90b:1b52:: with SMTP id nv18mr12920905pjb.149.1601828277185;
        Sun, 04 Oct 2020 09:17:57 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k28sm9295854pfh.196.2020.10.04.09.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 09:17:56 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/7] net: devlink: Add unused port flavour
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cb6ab3a1-914f-545c-fc32-ae63602413f8@gmail.com>
Date:   Sun, 4 Oct 2020 09:17:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004161257.13945-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2020 9:12 AM, Andrew Lunn wrote:
> Not all ports of a switch need to be used, particularly in embedded
> systems. Add a port flavour for ports which physically exist in the
> switch, but are not connected to the front panel etc, and so are
> unused. By having unused ports present in devlink, it gives a more
> accurate representation of the hardware. It also allows regions to be
> associated to such ports, so allowing, for example, to determine
> unused ports are correctly powered off, or to compare probable reset
> defaults of unused ports to used ports experiences issues.
> 
> Actually registering unused ports and setting the flavour to unused is
> optional. The DSA core will register all such switch ports, but such
> ports are expected to be limited in number. Bigger ASICs may decide
> not to list unused ports.
> 
> v2:
> Expand the description about why it is useful
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Tested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
