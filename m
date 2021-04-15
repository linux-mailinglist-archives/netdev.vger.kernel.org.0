Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483D7360FCE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhDOQFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbhDOQFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:05:21 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B5DC061574;
        Thu, 15 Apr 2021 09:04:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m18so10119729plc.13;
        Thu, 15 Apr 2021 09:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kLD6StwdW4u/OcdFNxOlIIvKlMXP69prYCwtXPa51Vk=;
        b=au/Cnl8VHA/HbnCjOFOxEwp/yHO8mSPXx2ftwpa1fTvtPyzl+DL7DyOWIm3ZtTffI+
         lXl25q1zwGehMCzkeDtJi6QaI/Rq7rruico03faKPUfMVZ/Fqjp92nGjCvIEx6TClV4X
         khrY4FhVZgYCyBb1OFOZr8TpeUwTPe3jLHoSn2YuasW/IYNuUUUYqjgEMr0isQHNqQ1Q
         Ofi0ShQb3rYSEFsYwOBSL/ycECeOp8mlukY1N1PTKNQbEXuuCN5mwN3F6WUCkZK1LFUk
         LvaKoiDtBla6mtD8CNyqx8edn26pUnl2coVjlU45xVge0E/g50w4ZZBIiC7esWf/XA09
         mOGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kLD6StwdW4u/OcdFNxOlIIvKlMXP69prYCwtXPa51Vk=;
        b=c538p64+3SmZctcc2Nt39KWWhK7g63d39/fPng0vyL4mE79IbanbfavegAAZZQBcge
         oXiad75SZm1NgKZgBlPtJZeow4Cx5ABHH6IxwK5q2JsQLE1tuya5PVRIo1IXTLm3ZBS9
         V5izElAOw8WFJzbp7fvdkWcdD/vdqXofBrXPs4OWEZn4tiyMiVv/YqlpMnnIHdFMUrfW
         /FVRWC+FLT2IJ8vrxaIFgKbbbYMt9q9LyAMcgfJnDpoQ84BeDj9Po0sShGdKc/NDopI6
         4QpD4A5H/UOSU3UVctH9HmypgqHfXN1rz9lXg7UnGhyNmEdziFFyvpmnlLZrOAp2Vsdn
         jJBg==
X-Gm-Message-State: AOAM5312E67X+dedFyat0O+PsLNvoYSVqGdCdh9xbldFOxHCaZtZNwXV
        oXCMbKwhmz4OLBD48inOOS4=
X-Google-Smtp-Source: ABdhPJynejMbEEL1eiJn6Npe7GSVkWdabcnFrcJZH82mbHV1oXCbkJ+3huzzgy+0O7TCkXL+Q/Bm0Q==
X-Received: by 2002:a17:90b:388a:: with SMTP id mu10mr4522139pjb.203.1618502696514;
        Thu, 15 Apr 2021 09:04:56 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id h19sm2730461pgm.40.2021.04.15.09.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 09:04:56 -0700 (PDT)
Date:   Thu, 15 Apr 2021 19:04:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: mv88e6xxx: Mark chips with
 undocumented EDSA tag support
Message-ID: <20210415160446.sqhwechnvknkfom6@skbuf>
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415092610.953134-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:26:06AM +0200, Tobias Waldekranz wrote:
> All devices are capable of using regular DSA tags. Support for
> Ethertyped DSA tags sort into three categories:
> 
> 1. No support. Older chips fall into this category.
> 
> 2. Full support. Datasheet explicitly supports configuring the CPU
>    port to receive FORWARDs with a DSA tag.
> 
> 3. Undocumented support. Datasheet lists the configuration from
>    category 2 as "reserved for future use", but does empirically
>    behave like a category 2 device.
> 
> So, instead of listing the one true protocol that should be used by a
> particular chip, specify the level of support for EDSA (support for
> regular DSA is implicit on all chips). As before, we use EDSA for all
> chips that fully supports it.
> 
> In upcoming changes, we will use this information to support
> dynamically changing the tag protocol.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
