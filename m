Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873ED3AD68E
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 04:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbhFSCCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 22:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbhFSCCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 22:02:17 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADF5C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 19:00:05 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so9213667pjs.2
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 19:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RWv4Sw8eEamp7YQyGwlc2Qjh6QfIFDDiPhHqrbvK2w4=;
        b=A14QrJmG1rzRc3yJNxQbwB9qMIsnbrh9nKc/YGtcmScU6l/JxBOP4pDZ4QE3jrVeAx
         Mv6kvL1EhW2l0dVr9gVkAER14UYt4mDukAophRol9ddofe9HKjzb3BLz0m91NvghfZ9t
         YalRRwEfIAM+46CgJb+PyOOOQlJaDFaJL3Pr/cua4Tj98ZG87pYeYRIlCm1edjoucYxd
         eDCYgvv88VbZwkopVUuFG7eoZFX5/TQIpSpAvE2xJU8HCo6tWYMjSB/nZAbXiQdZBid9
         kObnnxPJ077GZzjRbYqHRqetDoAWh5EiZXsC9QV0hycaDj9wJcjITM+2u+xdtoTr+1oG
         nthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RWv4Sw8eEamp7YQyGwlc2Qjh6QfIFDDiPhHqrbvK2w4=;
        b=eIkRVNykRvWbyyAQoAp5osRX7JRZ7wEcheZcyciXkY9MTgR9HJ1N2SxFxKL5BzlJ9a
         xAD6NHpRk5dpNkAPeCoh+J71xMSrNHmvXA29yxGcGwZfrOMtu53NvCUJ29tcivPAU+p5
         gDIlHQtI9obRb2xi9tXsdlT7LqB+jBQuVp8ejqlGlkWPlYYiHFqGBLgMdD+RVU6mxed6
         dcYtFZbatYViByNBk0uyb2ya+7ATg35dAnOq3w/3/uHlKGcCzSxMT+Qor6Bv6C84enO9
         x9DP8hbjtX5khdjXer7LqyuybDYdtrK5DRS+5vlSyDUfVobd+hJkUFf/s0pdK92lSTvW
         6KlQ==
X-Gm-Message-State: AOAM532/yTOz68ZnPm5GEU+10XqPcNB79YMm+THNsVVfBetuaIYmudpv
        /57ViktnT0AAPjvvER9ZtVk=
X-Google-Smtp-Source: ABdhPJySh4/xt//OUVhBPbOA0HpsHq+ER7hL4sxpnIEYYUE35XodHA3bUpIWymSiK9EEW5ahVyHqwA==
X-Received: by 2002:a17:902:8f8f:b029:107:810b:9ee5 with SMTP id z15-20020a1709028f8fb0290107810b9ee5mr7487702plo.4.1624068005330;
        Fri, 18 Jun 2021 19:00:05 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id w7sm8741920pjy.11.2021.06.18.19.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 19:00:04 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: dsa: export the
 dsa_port_is_{user,cpu,dsa} helpers
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1411408e-c954-ca44-695f-e9e7a654778d@gmail.com>
Date:   Fri, 18 Jun 2021 19:00:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618183017.3340769-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2021 11:30 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The difference between dsa_is_user_port and dsa_port_is_user is that the
> former needs to look up the list of ports of the DSA switch tree in
> order to find the struct dsa_port, while the latter directly receives it
> as an argument.
> 
> dsa_is_user_port is already in widespread use and has its place, so
> there isn't any chance of converting all callers to a single form.
> But being able to do:
> 	dsa_port_is_user(dp)
> instead of
> 	dsa_is_user_port(dp->ds, dp->index)
> 
> is much more efficient too, especially when the "dp" comes from an
> iterator over the DSA switch tree - this reduces the complexity from
> quadratic to linear.
> 
> Move these helpers from dsa2.c to include/net/dsa.h so that others can
> use them too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
