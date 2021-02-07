Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4340C312361
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 11:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhBGKIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 05:08:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhBGKHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 05:07:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612692386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nI3CuNAhEGALCXdE3wTR7z3x3Df42xi1niQl1wqF/K4=;
        b=S7NBU2q7XEr7FVJZ77xTUKaReUstbYfm0iww8Ejy9z33oVpp2g28QF0UVvB4LaDSnEwgdp
        7P3O5FqMIO7uQJ8VltBvn841l/TWcdluQ0NEbaqifTpkV0WMcdLJF62/6/flEfWynbrRJ4
        XLx54xz7YZnxqZOYp/cirIAluiwU5GQ=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-ZZA0eGWoNV-OxgtK832SCw-1; Sun, 07 Feb 2021 05:06:24 -0500
X-MC-Unique: ZZA0eGWoNV-OxgtK832SCw-1
Received: by mail-yb1-f200.google.com with SMTP id f127so13162184ybf.12
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 02:06:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nI3CuNAhEGALCXdE3wTR7z3x3Df42xi1niQl1wqF/K4=;
        b=WvSKflo+3WYXfbQcf+L1zwdUpdjEU63c3+WMM+EJIHhn+BCqPeSbmkkmjHkjK6rk7r
         7q2qne8msdHr92Jd37kRCh7IP5sDTLnNSQX5GmrbyDiHXOpoHZLotQswTMpuseRx1ums
         AMmJmm4fT3s81hp+Nma4QMLbRDdlKELK/VDPBLHuypSOMfng1vimMOblbAzJI27Sh881
         IH0y1knE5ed0eoFzRgbKBb1pkii3SLK70tEo0D1cTVF6YORxy4Ukz+je1KxCXkl+JZdI
         RvjpmUkPgLtI2VFCVR5jzN0/R2ObC3YZJr3vKB6HBxRwPlVMXXRhY6OJA9Gsb9gBGgV2
         hv9A==
X-Gm-Message-State: AOAM531MI/WEKWKlc43R6Z0VAAyoMSemC/TFjt0ZQ2NjbDClPdYcS4G6
        kcJTvMyZ3GxlbHz0jhiHuszqAV632dgYDE3uboUPeilbo49rs08w3VkBbcvi3Zv5s9QcDWkdG6o
        hemyCTxdI4Q9vt8f2rYj1pNY7bvFJ/LH8
X-Received: by 2002:a25:aad0:: with SMTP id t74mr5995790ybi.107.1612692383796;
        Sun, 07 Feb 2021 02:06:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBmqAhUy2O7xzTlMawk7rbbfe1u4MPWcHYEWQ2AVn3si3UQwS1OeW/o+Mt/cDXjNh8hxtpeXH4wMzSjonA+Cc=
X-Received: by 2002:a25:aad0:: with SMTP id t74mr5995694ybi.107.1612692383612;
 Sun, 07 Feb 2021 02:06:23 -0800 (PST)
MIME-Version: 1.0
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
 <20210206093537.0bfaf0db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210206194325.GA134674@lore-desk> <87r1ls5svl.fsf@codeaurora.org>
In-Reply-To: <87r1ls5svl.fsf@codeaurora.org>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 7 Feb 2021 11:06:12 +0100
Message-ID: <CAJ0CqmUkyKN_1MxSKejp90ONBtCTrsF1HUGRdh9+xNkdEjcwPg@mail.gmail.com>
Subject: Re: pull-request: wireless-drivers-2021-02-05
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>

[...]

>
> So what's the plan? Is there going to be a followup patch? And should
> that also go to v5.11 or can it wait v5.12?
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>

Hi Kalle,

I will post two followup patches later today. I think the issues are
not harmful but it will be easier to post them to wireless-drivers
tree, agree?

Regards,
Lorenzo

