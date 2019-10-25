Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4E4E4FA4
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440517AbfJYOz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:55:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33650 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440053AbfJYOz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:55:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id u23so1721427pgo.0
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 07:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uz4/0VPc/LVukLtMH9NhgPAHFSuVAg4MXjZpYQG2Cug=;
        b=kzXXFivdIXnezZh2d4gyu7vzJF5cXjKUlAIPh8UbB5DtUdP69of+z0nRjLSmJULktc
         Oaxg9pRiWydy9+E/vr4+X2rmXid7SzM7P7y9oK0N5KlaFC0EUFOQElk1kpaW/sx2Hnuh
         9gC4gZp8TIlfJjLu2w7MmmH+nikH3jfkv9dZap01epOJgjkhRtUMWT1LMnrNpu4mNzB+
         8lIU1DooMXK0d57lbWsewqS0yVXX48h0jg+JBSQsTNkn2gVO1usBvvJrajUbQsGoEDEB
         T7WJmskUIV04qbejZb5PnOG07PeoBXx6ujjnDitLSeAAuorIN/aa0OjqGAiCLC8Ka0lI
         TY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uz4/0VPc/LVukLtMH9NhgPAHFSuVAg4MXjZpYQG2Cug=;
        b=o5xQ+CJUKWpcmWqmNXYZMsWsNT5Fc11EH1t6r4pnj9EuGCgOZIgAWby6yWh8HjB+Bn
         ddIbR8M5QsfHi4T568fcsfzyBeXeFe8Uy+0fjPfVdELD3/hw4Q91+lM28W2MHoHnZPjD
         o1LD8jXxiHeIheK04TYhwGsACHYEL4UsLhXsS41ona5subDG4+G3vhjLCi9RWHW9Yg7p
         IejZ/hn1fGwfJJ/Vl17MXrV70iU6Vxh9kKMwTyyBR/srlzrc7VofdFk3OQcrDuKbvWwZ
         OR4KBJ8cY23alRcI9kuYqfY29WaHeMFvke/TxGCELomhSbD25NrnZ9z2AG84DDI9Apvw
         jO0w==
X-Gm-Message-State: APjAAAXqBIGq1KHA+JLfl3q7RK2pvp+4CUDlGSKUb9tWHxpWFqRRe92j
        FIxHpxZkqdvve9yeJcoJJFxq9Af54McS+uXZW1GXrg==
X-Google-Smtp-Source: APXvYqzXpb3waTwiwI+DaMsBjdc/rLbQDrJ0oa43fOWX+CbQABahbkpC0tOVTlDgChdL0k3xaam+TWttL48GzdAM1VM=
X-Received: by 2002:a17:90a:6509:: with SMTP id i9mr4657102pjj.47.1572015356966;
 Fri, 25 Oct 2019 07:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571844200.git.andreyknvl@google.com> <20191023150413.8aa05549bd840deccfed5539@linux-foundation.org>
 <CAAeHK+xLS8TVioJeqYrf9Kso9TsiWiH0O-k+RrRBCKPPS9_Hrg@mail.gmail.com> <20191024165907.d56f8050b5097639263c0a41@linux-foundation.org>
In-Reply-To: <20191024165907.d56f8050b5097639263c0a41@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Fri, 25 Oct 2019 16:55:45 +0200
Message-ID: <CAAeHK+yBL1montfzqeFXxK9-kGsuHLzD0VWccPiKahF0Wt8i0Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] kcov: collect coverage from usb and vhost
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:59 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 24 Oct 2019 14:47:31 +0200 Andrey Konovalov <andreyknvl@google.com> wrote:
>
> > > is it expected that the new kcov feature will be used elsewhere in the
> > > kernel?
> > >
> > > If the latter, which are the expected subsystems?
> >
> > Currently we encountered two cases where this is useful: USB and vhost
> > workers. Most probably there are more subsystems that will benefit
> > from this kcov extension to get better fuzzing coverage. I don't have
> > a list of them, but the provided interface should be easy to use when
> > more of such cases are encountered.
>
> It would be helpful to add such a list to the changelog.  Best-effort
> and approximate is OK - just to help people understand the eventual
> usefulness of the proposal.

OK, I'll add it to the cover letter in v3, thanks!
