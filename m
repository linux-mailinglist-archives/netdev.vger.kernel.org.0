Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1D33A13A7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbhFIMDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:03:03 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:40940 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbhFIMDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:03:02 -0400
Received: by mail-lf1-f49.google.com with SMTP id w33so37639323lfu.7;
        Wed, 09 Jun 2021 05:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XU4nuwXA9XapQtWzgw9qoH4a27DL9lWpG4Je6ZYcMRs=;
        b=AXDNZVTT4Go+M2IvGYKwAojDrYlAighaolpI4KG1uDGX/8k8mHjDmIT7PTo7h0Qvm5
         hZr5+0B0BQCIKeEKD4LNt+oyKLmSTqaTiE7ldtFOIo7bX1Szd+idx0BhBNLqxzdbQ9vv
         H90PkkFtkM69YL5sT0Q88rXGn/2swCbntcCOvyZj/14WDe/EX+GM7Q75Shnt5ISyIzn1
         xzV7LT804hTNm9+dBWC7ItyPvfkFNQl8TzHl/b+rRwZ16+UuiHOQURa8XzgceK6Zy1ZI
         K+VW/Jw9daaA1eVEfEp8KG/2YZda83lpvY1jHI9oVpYLjofSBp2QiX0TO21itY9I2o+w
         6/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XU4nuwXA9XapQtWzgw9qoH4a27DL9lWpG4Je6ZYcMRs=;
        b=W/ipMLstV8ERM33lIp9s5zlzPa460PuL7eqEUF+lvOAu+kZPtFUAPRx5L0zDekNu/y
         KEq3Rl+ukpklX1OWD5apFz0F94VWX0+bxL6rYXLTPVaYIXt6Fh3s246zLAKZn0Nz9Rdw
         X5LFJdIjmu5AOV9fHuE8YCZdXwGdHgOBwO8jqccAEeV6WIVlhhVVMHTS5gcxMbkdIjVH
         snt71ib6mi10N1PjX6J1gtI2WmDmsUOuO4PEqS1WupqxRmvyOsxiYNMo1FbHEjH/y37J
         ToE68h4Y7CATNF6FxBNoSMQig05xS94lczltDZfakuS3e1flPbSwQyywIwkmjnEG9uO9
         opsg==
X-Gm-Message-State: AOAM532umedy4u2LLUrRFDbiWzWeR0rzPXKhrYspRYiaXknwZhJC8hU1
        hE4hulnaGUbANKhocx+e8JVg0or2Hvc=
X-Google-Smtp-Source: ABdhPJyC211kk1VJbJeaXu9dPrd9jO0PM0t3qbZQ4SQeLLyH+KJe/bCmOVOriESnlcoEg/cp2y7cdg==
X-Received: by 2002:a19:740e:: with SMTP id v14mr19468765lfe.614.1623239994312;
        Wed, 09 Jun 2021 04:59:54 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.77.194])
        by smtp.gmail.com with ESMTPSA id t201sm338909lff.39.2021.06.09.04.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 04:59:54 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ethernet: ravb: Use
 devm_platform_get_and_ioremap_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
References: <20210609012444.3301411-1-yangyingliang@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <13d7446f-13c9-bf0c-7181-adea1cb031bc@gmail.com>
Date:   Wed, 9 Jun 2021 14:59:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609012444.3301411-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/21 4:24 AM, Yang Yingliang wrote:

> Use devm_platform_get_and_ioremap_resource() to simplify
> code.

   Not as hard as it seemed at the 1st glance. :-)

> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
