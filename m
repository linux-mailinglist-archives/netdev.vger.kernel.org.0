Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604942962CD
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901879AbgJVQgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897274AbgJVQgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 12:36:44 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101FCC0613CF
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 09:36:44 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id l16so2289339ilj.9
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 09:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+lch+IZMfxV3l3RJZHJEowGmWSc4FEincm/6SxOPYKQ=;
        b=UnPigUn7I8I2pHxcyygPgbXBbVkqTbhqqy9L+bgfggs0G/DgBn9kZGBtoRIrdbBKpb
         lSUKTYm+WQM1NWvaXeaJF20E6u4RFsEM+tVlZBwNgSwVDlNS40hqgXXwPu92E8sK56h6
         bz++0QFzMroIeALDuDt+A+PqpUgYC5I+omcLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+lch+IZMfxV3l3RJZHJEowGmWSc4FEincm/6SxOPYKQ=;
        b=i2qMxVmRE+gcdfCd0X2bPCYXawg4w5tXTRDgYAi0y0tq+wANT/Vs08bXD6SxSyPk/J
         6WoSfryj9iURtl2IiCkSEdrJmmO6G/QBQZqeK8Z3tNslU576KTDGY6WRJDs1uAINC6A/
         dOtkrP22WlSgCwn1pLCwL93tYr21EcN+ZHY92HQxARjjGewoAFQIjQ52WRJ67ttboVcG
         fxYrTgL7xb/ZnwZl287RKT38e2IC5kSBQroIrryBKIC8mXxSW0x8b5JfyF3FRZolwzw7
         vdop9DP/orQ93aP1nr4loGZiPc0Eo0Mb3Na/XCC2lCTZFxWyeo0/PBb8WdOXOTOZmvaz
         PtBw==
X-Gm-Message-State: AOAM532QxTHo/ZKmCOC6Cl0UQN6+/Ugr8+N8tsE37KHXYoUxpizPlwHS
        swchwk3tnlvYGBHdqyWZR32Y1hBHmiUm9Xd6pW/rdw==
X-Google-Smtp-Source: ABdhPJw8exBc165wZjBOYF2Mq1SSOm9RufoUu4migxB1UkHORcrMp7OntunI5ATQr/R2FIQdbMLxOeKzZUu9cMeI+v4=
X-Received: by 2002:a92:d28e:: with SMTP id p14mr2661432ilp.132.1603384603410;
 Thu, 22 Oct 2020 09:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201022120826.GA28295@nautica>
In-Reply-To: <20201022120826.GA28295@nautica>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 22 Oct 2020 09:36:32 -0700
Message-ID: <CAADWXX89-No9XCE+ge+-Mv-DWPJk_y1E7YrDeng80jE=J3_gzQ@mail.gmail.com>
Subject: Re: [GIT PULL] 9p update for 5.10-rc1
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 5:08 AM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> another harmless cycle.

Quick note: your email got marked as spam for me.

It's probably just gmail doing another round of spam changes, but I do
note that while your smtp setup does spf, it doesn't do dkim. Which I
think makes gmail more suspicious about it than it would otherwise
likely be.

            Linus
