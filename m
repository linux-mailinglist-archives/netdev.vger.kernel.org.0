Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7672EC0BF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbhAFQBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbhAFQBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:01:14 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EA0C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 08:00:33 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id iq13so1755534pjb.3
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 08:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JYnxTycwM/Yf0+6nVe6cbw4DIEENIcTjMUniGjv8TDE=;
        b=hnkK4LRJ1sQhVVtmxBrF9GeM14LlimrIt5FXPckcNiuY5B4T5vuDy67KD3Csbvena8
         bjSFp0c5I6TT9lQAo3LHYK0tOUIXIQ7kJvgE70bC7OjYT0aaxfEbDBr1NhJ/g4OEH1NT
         RDpq3/RacpfZZIIeAJImAV55nYCzxVIdwnEVCTgdYagkkQ99EtNdEcvJ7zNMOr2amSMv
         iJJxsQzr0bmEpmvD+n/f4YCiupsg+tzhy1ygFlzpRSQMP0/T2Suh+9f3Vodxh6O0FxhT
         0Adz4ZnhdcCHSuZUDsuyExPD6iHCTzOYPDHtrrxSI+jvZ6io+eBsmxGJ85Dt7QQifozG
         zbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JYnxTycwM/Yf0+6nVe6cbw4DIEENIcTjMUniGjv8TDE=;
        b=VbzgO1MsFkZhjeOQEv7amNhwsx1yCJkwVTAmCCSZO7PM5L9dEMPoWBjfU8SItHVtN0
         TnJ+xKieOg1efkQtzUomMmB667tAfW9AKJ6Dmi6pqdG+X3+G5GuhnUB0qjO0bS1iyLQB
         UPMRfIOy9WCfpbuNo5NZcGTUbIMESkCJeq1629lWKkJ6qOzNITAKQE9lcMxmoyTcxi6M
         Bo4Clo5U1kjWECynR/uPXBLPiE3E57Lyik4NkAj8gvSKHZcRNmb31FrKtOEuVgHGcAsh
         ZSyRRBoy6iswthI9K5/CMf+qwYUsnQzxjKP7npPEw9mn237tvTK9yjcX65arrsK3bu7v
         WOrg==
X-Gm-Message-State: AOAM531CBjqxTKZ6+O52ige2GNo0ndXeCK762OH1w1AF1dlYPq8fIX6w
        yLAiu96WJ8PIauseP4XrBs3q/eyQvPOiGQ==
X-Google-Smtp-Source: ABdhPJzrGP3mnl5xiiF/vDbY95Cv5MqTBLnmYLDafIWjqaebYTHVj0tHEvrTFSJIRH87c2mCQQ3jug==
X-Received: by 2002:a17:90a:348f:: with SMTP id p15mr4918032pjb.125.1609948833326;
        Wed, 06 Jan 2021 08:00:33 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z28sm3119675pfr.140.2021.01.06.08.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:00:33 -0800 (PST)
Date:   Wed, 6 Jan 2021 08:00:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Petr Machata <me@pmachata.org>
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
Message-ID: <20210106080020.44ffd4d9@hermes.local>
In-Reply-To: <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
        <875z4cwus8.fsf@nvidia.com>
        <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 10:42:35 +0200
Roi Dayan <roid@nvidia.com> wrote:

> > 
> > I think that just adding an unnecessary -lm is more of a tidiness issue
> > than anything else. One way to avoid it is to split the -lm deps out
> > from util.c / json_print.c to like util_math.c / json_print_math.c. That
> > way they will be in an .o of their own, and won't be linked in unless
> > the binary in question needs the code. Then the binaries that do call it
> > can keep on linking in -lm like they did so far.
> > 
> > Thoughts?
> >   

Adding -lm to just some tools is not really required.
The linker will ignore the shared library if not used.
