Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B684221A7D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGPDEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:04:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727034AbgGPDEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594868670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u3cJpUTzqg4XsvEigkP0qRKjmpXxEBPnj3YxAag4kA8=;
        b=IInjob76lLvJlsaEAu2G8J8eVYUFOZm8bDkmGOVPRURNoVoasGT0/4F5XYu6l/Igsxpngx
        4ZSF4kqiz0mXm8qfTgBDHN6Y6VnyX7ZrAEYJSSL9N+bCdWbCuKtNBRymmQYPOCZ1fRrla8
        ybA+pADt9GEKKUwpT+rv+JCCegF4JoU=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-uOrmqPp_NIqU0AUyoNyISQ-1; Wed, 15 Jul 2020 23:04:28 -0400
X-MC-Unique: uOrmqPp_NIqU0AUyoNyISQ-1
Received: by mail-ot1-f69.google.com with SMTP id 10so1992428otp.20
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 20:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u3cJpUTzqg4XsvEigkP0qRKjmpXxEBPnj3YxAag4kA8=;
        b=fRkbPLj6i68I7fpLiSAMLP0UxeHaZr2Ri8no0EUfDTpqeDnxOjtGl7SFdbwhNlix/m
         iJT16Jy8WLSn+nQnOvPMcfQYWxf9RsPj2fK6ES4/O9hXSWiJYdsHHd47bmBod39NAC2z
         6HPifnos1sGfkGVI3C8FHuefGPSGFvMrgrvX2QrVjHBv5LewVq7SIht8slMrqpafv191
         xQxnHHYjv/micoSB1R6uRg4ggbuWrrgfXw2sAvFRPrn5OWgKvhS9ld7QlHsvcNIbIth+
         8j9grZOTJLMvpRMMlWYITORrKkwd7p9vUd6LXC7fQSalK2lE4aJ5EIE957al7q1Auktq
         7Mdw==
X-Gm-Message-State: AOAM5333qzaButOVPXbw/rSP8hdYC5YTIhI9XSU1Yq+eAg6NXaDzfD97
        4oKjzqrSqKC13xsRYqa+vDkL6QjfvBjnvh2wrEJ9YLVqYPm+Is6gLZZCdhPzrmLzwDOT2A4LRtp
        DGefC9SJm3p3/fgly5XRCxoK7HzlVCnDo
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr2276114oih.92.1594868667432;
        Wed, 15 Jul 2020 20:04:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVFY9rpnyGirb4EfBOCbtJU0RrgfyKdCwmYw8wx20p10MV5trASOJ1b7kYhaS7omzicZKghG1A2DDyhyZ+u7M=
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr2276101oih.92.1594868667181;
 Wed, 15 Jul 2020 20:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz> <20200713154118.3a1edd66@hermes.lan>
 <20200714002609.GB1140268@lunn.ch>
In-Reply-To: <20200714002609.GB1140268@lunn.ch>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 15 Jul 2020 23:04:16 -0400
Message-ID: <CAKfmpSdD2bupC=N8LnK_Uq7wtv+Ms6=e1kk-veeD24EVkMH7wA@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 8:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Jarod
>
> Do you have this change scripted? Could you apply the script to v5.4
> and then cherry-pick the 8 bonding fixes that exist in v5.4.51. How
> many result in conflicts?
>
> Could you do the same with v4.19...v4.19.132, which has 20 fixes.
>
> This will give us an idea of the maintenance overhead such a change is
> going to cause, and how good git is at figuring out this sort of
> thing.

Okay, I have some fugly bash scripts that use sed to do the majority
of the work here, save some manual bits done to add duplicate
interfaces w/new names and some aliases, and everything is compiling
and functions in a basic smoke test here.

Summary on the 5.4 git cherry-pick conflict resolution after applying
changes: not that good. 7 of the 8 bonding fixes in the 5.4 stable
branch required fixing when straight cherry-picking. Dumping the
patches, running a sed script over them, and then git am'ing them
works pretty well though. I didn't try 4.19 (yet?), I assume it'll
just be more of the same.

-- 
Jarod Wilson
jarod@redhat.com

