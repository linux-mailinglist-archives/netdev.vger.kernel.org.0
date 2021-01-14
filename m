Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D032F6A4E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbhANTAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbhANTAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:00:45 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84982C061757;
        Thu, 14 Jan 2021 11:00:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id g12so9749147ejf.8;
        Thu, 14 Jan 2021 11:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WxXi2MnOGxI5YShKcxudKHqn+/UocONefhZet/zCVLo=;
        b=UepYyIAWz7xy1nXKq5atNUa2Qm+TftsQELDvxiZ5ZKg3wkOF2UnwM3VUcE3iKk+sao
         qRlSSbXZDG6FdDcdxF0p+eeVKT2eO2Lqu9ornaQn/+dWSL6sYYsw9BybabV2MvFxuFVy
         EdDD22RnAuXX7fJzhLcJGpWMJnry4xLWFkjgmcLmLe0ztz0CBLqiyecsdixWS8t8Tlvj
         3X9tWg++SMQDewtRoPUSy/q0mWSAGjO/vFf/0IFrLfZgy8iFScN0WKyEzMbpkAVtOTIS
         t0k+ngWObDgEBwhHbUsySqzqeBOKLpJqPh/13FHPfK3ddlhIs+Y+LaNtTly9Jzfx3Hca
         TsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WxXi2MnOGxI5YShKcxudKHqn+/UocONefhZet/zCVLo=;
        b=BjVS2L92EhdNSv2PYWr3OukRKm4tWc22X9MoOpzsxumrswbYWe7/szNrhBi3kNqqVr
         yfo494k5CVsIhi4IiM2TYXan8jy5cK7AIac+rYnA96i6Ju1ejnL0OgoAXfnKwyuDIBrv
         o66cBJwXWmg1z91KeFLi9IdnEr2diWOCCv1p4FAHJ/DeLz3fdjpAnZHirrs+HtL7Ca40
         XRpIKxW7Kqgw9KV8VX3YdZOKFQJujGgvY+GPxC1LFGLzHK8Ql1mmY267+hOpAg8gYDeC
         4E70uhy/zHkSINx3gB2mEzydeklZYAAvK/DzJnIOJ+3955rkIhgdLBX5Av1p6zaacU3B
         +BIg==
X-Gm-Message-State: AOAM530S7Os6IwdKAGPL9D4N6r2XRtXNdS0AKtTzuqCUFq2J9DC8q87g
        /6dl+prTs7Hd3v84d9MQ1Ko=
X-Google-Smtp-Source: ABdhPJwdqEhWjoLT4FRVAHKXJUONfjo4T5q556X589F/6yrHtdr///kD7gdbJYS+TC7zRnmj28GM7Q==
X-Received: by 2002:a17:906:494c:: with SMTP id f12mr2937693ejt.56.1610650803972;
        Thu, 14 Jan 2021 11:00:03 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m22sm2290181edp.81.2021.01.14.11.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 11:00:03 -0800 (PST)
Date:   Thu, 14 Jan 2021 21:00:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20210114190002.eriqfc6yd6kg7w2v@skbuf>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com>
 <20210114015659.33shdlfthywqdla7@skbuf>
 <CAFSKS=NU4hrnXB5FcAFvnFnmAtK5HfYR8dAKyw3cd=5UKOBNfg@mail.gmail.com>
 <20210114183243.4kse75ksw3u7h4uz@skbuf>
 <CAFSKS=NrdVSDEh5DWN+JOcZ5fycM1y_N5b8cxzZwQxm-hJbVHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFSKS=NrdVSDEh5DWN+JOcZ5fycM1y_N5b8cxzZwQxm-hJbVHQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 12:47:46PM -0600, George McCollister wrote:
> On Thu, Jan 14, 2021 at 12:32 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > May boil down to preference too, but I don't believe "dev" is a happy
> > > > name to give to a driver private data structure.
> > >
> > > There are other drivers in the subsystem that do this. If there was a
> > > consistent pattern followed in the subsystem I would have followed it.
> > > Trust me I was a bit frustrated with home much time I spent going
> > > through multiple drivers trying to determine the best practices for
> > > organization, naming, etc.
> > > If it's a big let me know and I'll change it.
> >
> > Funny that you are complaining about consistency in other drivers,
> > because if I count correctly, out of a total of 22 occurrences of
> > struct xrs700x variables in yours, 13 are named priv and 9 are named
> > dev. So you are not even consistent with yourself. But it's not a major
> > issue either way.
> 
> Touché. This ended up happening because I followed the pattern used by
> different drivers in different places. Specifically ksz was using
> regmap to work on multiple buses but wasn't a very clean example for
> much else.
> I'll just change it to priv everywhere.

Don't worry, I know you copied from the micrel ksz driver, I made sure
to complain there as well:
https://lkml.org/lkml/2020/11/12/1344

It's a pretty bad driver to copy from, by the way.
