Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F13A2245A4
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGQVNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQVNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:13:46 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE34C0619D2;
        Fri, 17 Jul 2020 14:13:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q7so14233401ljm.1;
        Fri, 17 Jul 2020 14:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=1d3lxx3KtSFah+0xpHy/GLRMEx2gCAuDBaifp0MIvAY=;
        b=b8qnYAZWPECX1sBySPzW41/Z88W3Z2cxq2cUrdUtQAl3DVVBuEz5eN1UYlosLWCHpl
         cRPruwsnOvPEvhVYpFqaKSQE0OqsOdlnC77BRQ/qc4ggysT4OWLbEwOMXH52yxotyyO3
         XNHkCC/VPzP1/3PM3xy9LsavwlxKfjDj4w/Ya3Ku/69PnUZTJNbDu6Tk1Odnw5vWpRqd
         TOR0QJ76VwSPvQhPsYcPmiL/3n0mFnLS7ZpHLp/dNBo09YlLajphVcAqcfKtcmvLHMsT
         boLHme7ygbJuaCZjsEhemWQJL/3IUYtzTVbAN30cHIDrzU49UVSxNWtL3c18praKWCOm
         HBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=1d3lxx3KtSFah+0xpHy/GLRMEx2gCAuDBaifp0MIvAY=;
        b=DIF2emtJEnh3Tp1M9CX/PirM2VBkwFXZqikymYAoU+7nRqERusaZI0ahdPACMZYVNm
         B3WW/MGQKhhJQhkbKn1FOER18e90/SKcmZPBOUYF6fXzRxR2AAqeWq3VddZM8lIpgfjs
         xoUH/XcWEltKNHRDHQj3hdcxMa0QKRDLvtQF+d6+JLKFEs2HDs9HR1qXrEnF7tXWYfpG
         fvVwPF9TC+TY6v3+nmyBqgwxZrMxQELBYIMPrwxc2mQ0CLsGlhk+TKVVD4h+LYWV9Mp/
         4XvQ9qdVMSbHiYvQS8K1Jp0CkIwV/kNjHbHJq84G8ywPfAYETE22Mo9TpWlW0oSp1SQt
         UK4Q==
X-Gm-Message-State: AOAM532fGpLZWGscepFJ1nSeTOcd7QYDbZ5QA/K0HRvjFNsL6iXJ4xoe
        aew6CcxIRvBXGOaKZvi4+Rnkv46/
X-Google-Smtp-Source: ABdhPJz/U2IbiS4qPHdn0La8QfmEM3TBOYev8V9bhpoSncA+pu/MKhhFybtTNm8ZoGoc6yK0h+ZPDw==
X-Received: by 2002:a2e:9207:: with SMTP id k7mr5167811ljg.120.1595020424389;
        Fri, 17 Jul 2020 14:13:44 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id v5sm1834099lji.75.2020.07.17.14.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 14:13:43 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Document more PTP timestamping known quirks
References: <20200717161027.1408240-1-olteanv@gmail.com>
Date:   Sat, 18 Jul 2020 00:13:42 +0300
In-Reply-To: <20200717161027.1408240-1-olteanv@gmail.com> (Vladimir Oltean's
        message of "Fri, 17 Jul 2020 19:10:24 +0300")
Message-ID: <87imelj14p.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> I've tried to collect and summarize the conclusions of these discussions:
> https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
> https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
> which were a bit surprising to me. Make sure they are present in the
> documentation.

As one of participants of these discussions, I'm afraid I incline to
alternative approach to solving the issues current design has than the one
you advocate in these patch series.

I believe its upper-level that should enforce common policies like
handling hw time stamping at outermost capable device, not random MAC
driver out there.

I'd argue that it's then upper-level that should check PHY features, and
then do not bother MAC with ioctl() requests that MAC should not handle
in given configuration. This way, the checks for phy_has_hwtstamp()
won't be spread over multiple MAC drivers and will happily sit in the
upper-level ioctl() handler.

In other words, I mean that it's approach taken in ethtool that I tend
to consider being the right one.

Thanks,
-- Sergey
