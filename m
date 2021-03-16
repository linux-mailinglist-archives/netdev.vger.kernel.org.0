Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5C633D56F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbhCPOFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbhCPOEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:04:35 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C2DC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:04:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ci14so72190260ejc.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ApeqBWmIq6a9WCbY4fxHgdzhgkG6jXiGhc0vygrIXuM=;
        b=gJIzNBlI6CEiFO6QdSM7OL5FobivMvPPIs2JFHqBH2NIetdIYa/aj26Ye2JSvy3iVZ
         BFCt3TfqIqpx9sfrakqkmw/GouFPVJhzLLRGoESXbgw0g0ZoPeR8vNXn/c6gP0yRgZA9
         y/8dyA15ybkLSQFoiGV4KVCQGjwzfS2L0b9uYH1i9ltlA0+pWjAsSKrTlsd8qi+9hGCK
         v7Tlbxq9UIoAtE8TE9PAfkwyySCKmGpqCz0ny5EcO6x5OYoj2MD7aB2SZJsm7QGwZZ70
         dqYl71GLvEQSyo3F0kP6ofM5X7io6mzcZIXam7qg5Kx7V5UpAGAFW9sfusuaC90Jgxt6
         8ADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ApeqBWmIq6a9WCbY4fxHgdzhgkG6jXiGhc0vygrIXuM=;
        b=OT18j2g1lQQ8sLaT0BRTUiQwKZlJs/gKZtrtQdynyqxjFMuiKNOvPIqESHJhrLMtMq
         iHRI6FeK5EpK9+I+TgoVfs9rXgamfmfb1QbkGd4ge/2mTVVoyVvclqC0D0MUaQrtp3PH
         sORk7S/k92xo8wEFWtrVSwMTjK0tl2vfMCyW9PqiNA6X3kazts7vdjmvEZWPOMGSsBfM
         vG5PbCSy1K1Je2n/su4ZXDek1zEhWfMfnHwgrxjvQxqjGM3K8+yiwNW4mfyiRLkVqRlo
         DzFakBgrGp2rFYI68I0+Y8P/xPKiiUOTGheWnMcqlZ7mwTqnayNHx5WqSRFjpQspKA4n
         si2g==
X-Gm-Message-State: AOAM531xAca9BC3/F77UzBzxvPl99/2sUgjuqAwbLfv7Ex17P0IQu9iA
        Lc1GF4zZ30MnLaDbIVfFY8c=
X-Google-Smtp-Source: ABdhPJzQAP6gdRi8HBEilH2n4ijdC4k3Uh83V/cRV6XbgsymxWIBqy3NPmgBXBvqE6ypHvei0CFwnw==
X-Received: by 2002:a17:906:5607:: with SMTP id f7mr29108462ejq.262.1615903472789;
        Tue, 16 Mar 2021 07:04:32 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id g11sm10628655edt.35.2021.03.16.07.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:04:32 -0700 (PDT)
Date:   Tue, 16 Mar 2021 16:04:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 11/12] Documentation: networking: switchdev:
 clarify device driver behavior
Message-ID: <20210316140431.d62yq63snjf7a3jq@skbuf>
References: <20210316112419.1304230-1-olteanv@gmail.com>
 <20210316112419.1304230-12-olteanv@gmail.com>
 <YFC6KV5OSVyCHmG2@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFC6KV5OSVyCHmG2@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:01:13PM +0200, Ido Schimmel wrote:
> On Tue, Mar 16, 2021 at 01:24:18PM +0200, Vladimir Oltean wrote:
> > +When the bridge has VLAN filtering enabled and a PVID is not configured on the
> > +ingress port, untagged 802.1p tagged packets must be dropped. When the bridge
> 
> I think you meant "untagged and 802.1p tagged packets" ?

You're right, I'm missing the "and".

> Looks good otherwise

Thanks. I wonder, should I resend the 12 patches, or can I fix up afterwards?
