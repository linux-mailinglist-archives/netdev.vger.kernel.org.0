Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D57A471838
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 05:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhLLEXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 23:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhLLEXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 23:23:20 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB74C061714;
        Sat, 11 Dec 2021 20:23:20 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id m15so11485357pgu.11;
        Sat, 11 Dec 2021 20:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G0UiJRDCKMkzWw1cDf+yPZPj+/s1Rr6x9jJ5A0IDbqM=;
        b=NhNXnrmaRdtFVpy/qbFrm0vtgKaNaOQOdF+k+Wk750HHOIZu3nN1eGMDv4SFCvgCsn
         BzULkcZzPtu+IRFRdU7pMmF4mXjLypk0ca8eXy573Dwi/AA2/93x2JzwUJEOh97uHX94
         cR2uC3FBnTOwWOHGn1OmwDTMyuiAB5INNjuGhzV63os9Xn+t4DxdO+558UUL3C5dbMjy
         302cMG+MaQ340oLUa2KZNP8hn0ZVBEUPUL3iRe7IFO3Ub8SpzRgmuuO5URs4YYK7z2N9
         YGXugiCB2iwgi2QI6wlBR+B8DyTNNL5UDcN2qHAtsBeTvi2VQi0S6Uwt6bDV1y/rQ2By
         X7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G0UiJRDCKMkzWw1cDf+yPZPj+/s1Rr6x9jJ5A0IDbqM=;
        b=naUDFsgzf+Tm3cEjsuva6SWbEIU0iHvkPfX28qaTljp7U1L0KWuCnxU2K/TnbZxyhN
         qKCYL3b6K6fzuK3Eiav+BPMu0LI4fa4lhFP9d/QnVlUvgYR7I+7AWldfJIU722PydPrH
         9JaGmg54EGSnZOXZXI4kJugCj+k6EqwHsHPpvI7E9EtEk/PsITqpKehsz+IkRbcc9Et+
         Nc8ofcADjN7F+3qxwjxKfjXR8n8goSUwal+LSzPbyhQ2OyzeO7A5NkOtwyvNdu0Ltfor
         +ABfVBHNvoLMvgunMUHERFic0+cxST3siLAx9hXsW9Vmcyp09vF0VSrbzU4ZWKkyGCqP
         fUXw==
X-Gm-Message-State: AOAM531AoXprlCzB7Mf0ekIuBhXldDgO+QeNhCvxMdSfW9ULYFDWxkPJ
        qb/6sFUmfm/kvrlq/C/ckdA=
X-Google-Smtp-Source: ABdhPJwPfgh7ZR+yYBwELT4LdffMTq8n+4YLFL1lGGz5K///hkVP1fapkaMyeOMilQLlH8/qm4GZqQ==
X-Received: by 2002:a05:6a00:b49:b0:49f:c8e0:51ff with SMTP id p9-20020a056a000b4900b0049fc8e051ffmr25968790pfo.36.1639282999789;
        Sat, 11 Dec 2021 20:23:19 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:4964:df1f:902d:8530? ([2600:8802:b00:4a48:4964:df1f:902d:8530])
        by smtp.gmail.com with ESMTPSA id mi14sm3296109pjb.6.2021.12.11.20.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 20:23:18 -0800 (PST)
Message-ID: <768d3503-a575-3e5b-8a44-8dd0293ca444@gmail.com>
Date:   Sat, 11 Dec 2021 20:23:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [net-next RFC PATCH v4 02/15] net: dsa: stop updating master MTU
 from master.c
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211211195758.28962-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2021 11:57 AM, Ansuel Smith wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The dev_set_mtu() call from dsa_master_setup() has been effectively
> superseded by the dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN) that is
> done from dsa_slave_create() for each user port. This function also
> updates the master MTU according to the largest user port MTU from the
> tree. Therefore, updating the master MTU through a separate code path
> isn't needed.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
