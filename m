Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8415340EF7
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 21:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhCRUSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 16:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhCRUSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 16:18:17 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCA0C06174A;
        Thu, 18 Mar 2021 13:18:16 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id q13so6569384lfu.8;
        Thu, 18 Mar 2021 13:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ltuUYSrQ22360MaVIawtGhACBKIcjgougcQE1G7wGAA=;
        b=F4QeAGKDIThJPMctZAII2rO4TuJboOCM5+gHx2h5ZZLGvWTR2m3cYkw8GiPFbzWorw
         eBEiACVn/CHdg8KNrzyrZhXRj1Xs4NCtig1WDImwfG8U4kEfw0GqoPAKX/DH0aEmsgWn
         d2z/ItdvH/Kjjtv11TQX6JTa5sTbrwxh3yxG5/15WlyliExP2QXfOojF86epOAke1SMo
         pWWJ95BHSEgUA2SJ1cCzXbAOJvvfLXBUSZOJ8X0O80CAF/LKsJQ+Lb/ixxQbPh0ur7gz
         uY+MoEdGdu6Q/VI7ng+b0iHuugzUjIMsytAFVTyRryluWvYeow4XIQk16IGZ2GIqo9bY
         COpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ltuUYSrQ22360MaVIawtGhACBKIcjgougcQE1G7wGAA=;
        b=Hk1UauNiQMriLnT4YEX6vThlKWBBInuOiVX6MqKXi93n0dhyrQW4UgeWrd707SfpiJ
         BB8xEsbgAwqPfLv6CrZxSrttiSobxZzltELTYE45fPLH3cUiChgHOJGBHIhgIqOpHk1V
         ef2Igqhhiz5wAWhIW4BVlb6Bvyd9H7D6aZB+UHaZpKgLj37FaIbUeRwLnZ1vCiVTHGxk
         VbJ7EpdEAELHK+e9XaFm9BrELD2mC0zK2paeasK5gdZIjsycq0KaVrJdA4lQnS1v2Ypp
         F1KZUg9rMI1SrCt7xNxh3MB+DCP0SfwI3nkPjCx2xRqzKbw1hfHJveKfgBlNBQVTJIEt
         zr9A==
X-Gm-Message-State: AOAM533j8wW4k932oAkLWpo6owJc7nuVF/P94wsmW6uQ2fUe3kd69AA4
        Di0e16E5T/VrkpgjSH/6E3q1R/FHzvqbTA==
X-Google-Smtp-Source: ABdhPJzYIMdkZTpuvxt9Flxzr5EurI1lzhhqeqrHUG6u0VPIbHFRPye5xR0H0zY6gseiO120h+WN3Q==
X-Received: by 2002:a19:ec13:: with SMTP id b19mr6528756lfa.238.1616098694652;
        Thu, 18 Mar 2021 13:18:14 -0700 (PDT)
Received: from [192.168.1.101] ([178.176.79.185])
        by smtp.gmail.com with ESMTPSA id q3sm353393lfr.33.2021.03.18.13.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 13:18:14 -0700 (PDT)
Subject: Re: [PATCH V3 1/5] dt-bindings: net: renesas,etheravb: Add additional
 clocks
To:     Adam Ford <aford173@gmail.com>, netdev@vger.kernel.org
Cc:     aford@beaconembedded.com,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210224115146.9131-1-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <d2618a49-5314-af7a-0367-2519de78f957@gmail.com>
Date:   Thu, 18 Mar 2021 23:18:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210224115146.9131-1-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On 2/24/21 2:51 PM, Adam Ford wrote:

> The AVB driver assumes there is an external crystal, but it could
> be clocked by other means.  In order to enable a programmable
> clock, it needs to be added to the clocks list and enabled in the
> driver.  Since there currently only one clock, there is no
> clock-names list either.
> 
> Update bindings to add the additional optional clock, and explicitly
> name both of them.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

PS: Sorry for the dalay reviewing...

MBR, Sergei
