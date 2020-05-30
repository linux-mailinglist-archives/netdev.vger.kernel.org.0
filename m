Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6348F1E939E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgE3Uk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgE3Ukz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:40:55 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43820C03E969;
        Sat, 30 May 2020 13:40:55 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l26so7083834wme.3;
        Sat, 30 May 2020 13:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iIdsPZDerVaDWQokhH9B8e/vsx/XTfcKV8l7ICPHYbQ=;
        b=oLkpPY/W9+TeQjHlPe4CStiXz/vmj1x3NNPNGjXiJoz9xu4GN2Bp4+X5Zp+3kkl8fv
         9JWmE11XxKH2BkeHAe6nSVrNxFsaUkJrwUVBa1SRDkT5AihC0y0YgKfRc6juil/g/UY3
         h4Ytn6Nz3rRFqbZ3H4o6NlNGKhfbfE7Kbilau+MTxsOgCGsKSHJT/QmsHsejzhtICy2q
         SBOAP4aQ0nksspTUIvcjIp3qViNeFleiOiDRJdcRClNquRP+bm0Fk6PrvlTeSUqnUzWA
         KkidXYrtGk/48vZCwHRuDu2tB7fC5CrG1gjyX9ZmEIF+tCwYnhhbFCrO2b81z/LJCDh2
         RK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iIdsPZDerVaDWQokhH9B8e/vsx/XTfcKV8l7ICPHYbQ=;
        b=U+8TiM+bw59NWBgesd87hVLRfmSmsGpD/nV+YUMwkJ8IYCH1dDhIoIk2XQ88iXsmQN
         Qq6rLDqlI61QkZpLdCmVjA6zYXknGyPDt2b/I3fF468rKCOcnvEGbHsIYfXy9HmjPQZC
         9rNdvoOpvDDn70G+iINhwdt6KqspnVVcAo9Wr6MRWkKuKs/0up6PSiAd14Lz2ufD+Dol
         DMrrzSMQsbGO5jLjzAj8NA78RUNCleXFknJIaYTz/PZ9OjvtCmxdlVSKmKWanps0hhzr
         0hAYmEa/bj2jeoq2eixrKrjlOHc2flVTp4NoSKwoDZ2frY6irevGpOeOMrDppb/2Q5i3
         9m0A==
X-Gm-Message-State: AOAM533MP/ptlOU5QrsbYGT0regPsSU1ZDk3lG9nDxtlPyumQgY/CQmd
        lHtjePYVu6fvNtVoos2lcCZbrTxt
X-Google-Smtp-Source: ABdhPJyykGKPPKXRnQr86wSAtRbPuX1d4Up2JozWPcN7JWy9kR6jMpJQe7YLl9dx/T19RPlOedtMzg==
X-Received: by 2002:a05:600c:23ce:: with SMTP id p14mr14507648wmb.77.1590871253837;
        Sat, 30 May 2020 13:40:53 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c25sm4803920wmb.44.2020.05.30.13.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:40:52 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: broadcom: don't export RDB/legacy
 access methods
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>
References: <20200530203404.1665-1-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <63a97832-e8ec-e5fa-5f6d-7738dfafaaea@gmail.com>
Date:   Sat, 30 May 2020 13:40:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530203404.1665-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 1:34 PM, Michael Walle wrote:
> Don't export __bcm_phy_enable_rdb_access() and
> __bcm_phy_enable_legacy_access() functions. They aren't used outside this
> module and it was forgotten to provide a prototype for these functions.
> Just make them static for now.
> 
> Fixes: 11ecf8c55b91 ("net: phy: broadcom: add cable test support")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
