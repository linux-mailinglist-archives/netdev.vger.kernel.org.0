Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C4C3B20E5
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFWTVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWTVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:21:20 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C36C061574;
        Wed, 23 Jun 2021 12:19:02 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id k9so1284547uaq.6;
        Wed, 23 Jun 2021 12:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v9LoyiV46pvdi80Pbx9CDtSP3RNB7KyV4DwXyuMZdGc=;
        b=W3xk4sx35Lp/TDb6nZ99vzFv+COWGqNBIR2hpi8AVUZYCHyMciIn+bsVL58MGBFHgR
         K8fdNathOjm8s9pJMzy5GAYVPmm/cN6z2sCnCexWUcTG6PR43x2ZSA5ymd6Gi7dx2GXs
         yVDGYnFEY3R3di65ZbNsLJ6SYSqljZEH3GzVTWox2K5rIS8vwAX4SUik/CDJiYHkGnoL
         Pj7Rbn9nx9zybEAny2aeYtVaGrJN99jbru3CR9yqG6l9XdzCn28V9UB1nuDgYc8TVZiS
         MI7uHNVr4g2Ulbc/gkJIskNLecm/wFiqGmO0QtIPxWB7bbgqpjgD7+8A0xGROp031yFI
         NitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v9LoyiV46pvdi80Pbx9CDtSP3RNB7KyV4DwXyuMZdGc=;
        b=AgrTrMcTEYMWw9JemRwSOFiLM4kDJat8bD0cMvOfACOYu/kalm6hIGnsIao3ZCuf52
         jmihlQGxEml5cQxmyIdlfMKdtqFTb4MwTLgbjYJZRSqRdXSDtT8IlbgA+X9nHYbvaIIT
         QvZIkqzhIDYMSHytsLqZC5RoBsJAWio4k9WK7M7de0kK+obJM3xx6kVdhKm46KwvWsbO
         uT2wIQwNjMDQxLpoMsVbhkFn/X0oLLLNgMsX7qHLSIFArJX0osz83+yJkmQnEM8uExIf
         pirj3ov0VdG+DiU9zAq7/cc6hxneh9dkS9TKlDwGyGvb3smPxgpFbr3ODmI97zsbuGjj
         l6VQ==
X-Gm-Message-State: AOAM533ay0itJeBR1DiJHfUrsflGoVAOj+ZoSFFLCbEZFcUk7qzT3CdX
        Vj2uWb/oHYtuvMWzkWyvGD4PmHzT7E8BTgXum+Q=
X-Google-Smtp-Source: ABdhPJwxgoNgzKlegGJk3WiBlO4Ca8BbbgQAPN2l4R6CrRNKQ7GWCDxOCeLMOwKnNkhk5JjF05jxykEuv+4/GFVsyEQ=
X-Received: by 2002:a9f:31b1:: with SMTP id v46mr2106369uad.22.1624475940993;
 Wed, 23 Jun 2021 12:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <1619348088-6887-1-git-send-email-jrdr.linux@gmail.com> <20210615133503.DA3B9C43149@smtp.codeaurora.org>
In-Reply-To: <20210615133503.DA3B9C43149@smtp.codeaurora.org>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Thu, 24 Jun 2021 00:48:48 +0530
Message-ID: <CAFqt6zY-eXTALDeLknCMpvCi1BCsN9QSrdqUnn-XrokHoTdbaw@mail.gmail.com>
Subject: Re: [PATCH v2] ipw2x00: Minor documentation update
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     stas.yakovlev@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 7:05 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> > Kernel test robot throws below warning ->
> >
> > drivers/net/wireless/intel/ipw2x00/ipw2100.c:5359: warning: This comment
> > starts with '/**', but isn't a kernel-doc comment. Refer
> > Documentation/doc-guide/kernel-doc.rst
> >
> > Minor update in documentation.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Acked-by: Randy Dunlap <rdunlap@infradead.org>
>
> Fails to apply, please rebase.

Sure.
>
> Recorded preimage for 'drivers/net/wireless/intel/ipw2x00/ipw2100.c'
> error: Failed to merge in the changes.
> hint: Use 'git am --show-current-patch' to see the failed patch
> Applying: ipw2x00: Minor documentation update
> Using index info to reconstruct a base tree...
> M       drivers/net/wireless/intel/ipw2x00/ipw2100.c
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/intel/ipw2x00/ipw2100.c
> CONFLICT (content): Merge conflict in drivers/net/wireless/intel/ipw2x00/ipw2100.c
> Patch failed at 0001 ipw2x00: Minor documentation update
>
> Patch set to Changes Requested.
>
> --
> https://patchwork.kernel.org/project/linux-wireless/patch/1619348088-6887-1-git-send-email-jrdr.linux@gmail.com/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
