Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412933F7C05
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbhHYSId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235251AbhHYSIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 14:08:32 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D57C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:07:46 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i21so332303ejd.2
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EcYKVqQSFav1GX+z3dOkJIc4nB4fMZOFfEayNc3CdZA=;
        b=MWBegt9r0CkqgxFcqDtewibUSNsZ1bQl+pb0B6BQvvhIgHW+/lZ7gHh802g+Ho3zjw
         gqQp4+Vh2WP08rW72lYsSWVa8dVfodLMVnFAbO0DgNrkuE/ROW2Buu5GzX8gX0VHY3gJ
         yJ0XuUt7P4yWx9MFK/pFwP4pYtBZFlCl+UKpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EcYKVqQSFav1GX+z3dOkJIc4nB4fMZOFfEayNc3CdZA=;
        b=FlV0umfcrnUEBm6eeIoGd/43ZiNxN6i7+tjp2z4hQ2MqrlpSUTUScOYD1E2pLmz9xq
         /c/FNhoRpIXWAyjkB7yTcBdhfAQIoaAFh0nhMmY58XxEaeUAtg3TSTNlYUEEYNtcPv/G
         Su/0zZUbgISzlmyl7kFut5MReQTHj8tu2c3CmNJuVt088K3CrgF4zArcvHC4K+/p8PVi
         vfSld3tO+TmkaNMYC+2+e7IA2YHxdppZdSqdADV3KnKvxwl5pFEDGf7zoMZva4//1/+b
         yhy5esgsdU2XCVN3M2MMc6o5pqEFIIXJMMrNeXpI9z3E28Hc5GxnHVARGy9ald2/qBKf
         UWUA==
X-Gm-Message-State: AOAM530GE+3Hfxhgbq/zIcQFaqXXA1jblEnncivcjjbiyuqeTYOQzfmu
        qopJO4Ngxh+ciIcRpo9RcYgLIA7oOozpFCWXFlTPGg==
X-Google-Smtp-Source: ABdhPJxNfrBB4SRP7AEr2PstKyZ1UcKE7jB+fsPlnc3d+DtyMYlgpBb8XNigBy9JNwuG2+WzeSMznGaq1/298lXOJ/g=
X-Received: by 2002:a17:907:2126:: with SMTP id qo6mr19587033ejb.476.1629914864682;
 Wed, 25 Aug 2021 11:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210702223155.1981510-1-jforbes@fedoraproject.org>
 <CGME20210709173244epcas1p3ea6488202595e182d45f59fcba695e0a@epcas1p3.samsung.com>
 <CAFxkdApGUeGdg4=rH=iC2SK58FO6yzbFiq3uSFMFTyZsDQ5j5w@mail.gmail.com>
 <8c55c7c9-a5ae-3b0e-8a0f-8954a8da7e7b@samsung.com> <94edb3c4-43a6-1031-8431-2befb0eca2bf@samsung.com>
 <87ilzyudk0.fsf@codeaurora.org>
In-Reply-To: <87ilzyudk0.fsf@codeaurora.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 25 Aug 2021 13:07:33 -0500
Message-ID: <CAFxkdArjsp4YxYWYZ_qW7UsNobzodKOaNJqKTHpPf5RmtT+Rww@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        ybaruch <yaara.baruch@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        yj99.shin@samsung.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 8:34 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Jaehoon Chung <jh80.chung@samsung.com> writes:
>
> > Hi
> >
> > On 8/9/21 8:09 AM, Jaehoon Chung wrote:
> >> Hi
> >>
> >> On 7/10/21 2:32 AM, Justin Forbes wrote:
> >>> On Fri, Jul 2, 2021 at 5:32 PM Justin M. Forbes
> >>> <jforbes@fedoraproject.org> wrote:
> >>>>
> >>>> The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
> >>>> This works fine with the existing driver once it knows to claim it.
> >>>> Simple patch to add the device.
> >>>>
> >>>> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> >
> > If this patch is merged, can this patch be also applied on stable tree?
>
> Luca, what should we do with this patch?
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


Is that to imply that there is an issue with the submission?  Happy to
fix any problems, but it would nice to get this in soon.  I know the
5.14 merge window was already opened when I sent it, but the 5.15 MR
is opening soon.  Hardware is definitely shipping and in users hands.

Justin
