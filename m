Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F483A5E18
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 10:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhFNIKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 04:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhFNIKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 04:10:41 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE2DC061574;
        Mon, 14 Jun 2021 01:08:38 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id i68so33967596qke.3;
        Mon, 14 Jun 2021 01:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Z9QCuBnaG3V0M5rfTL5FcVGUPaAvk8s7UrMizywBSc=;
        b=ClGamw/5HpYmv7E1SCdvUh0NthGaWpompaCbLLfoIfhcLKlDnAS/tJQnj5oj2hcXX7
         UOYP58ofwNo/ByqHuxs0zcnHKz6+5JTMTEUfpuWBGKHFMih0KYwUX0r7JaDUf55U44kE
         rcQwC1AyoyEW9PxVy18y5+DWnH5Bl0+ZaXphAbGI7hFRWa1PpGnxmGdgnBmV8NxUnWpC
         9U5Q35/Zc5FyAnVmsiebLZt9eWZOUtUvlCRg5i+a7cqPx0d5v0YymuhPW420fwjDmF8B
         9abGExwIQWpSfTig+3LunhBal+mOdAghSjPDSvW4TGthnn3V9MTLz7Qxaky97N44py+3
         GgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Z9QCuBnaG3V0M5rfTL5FcVGUPaAvk8s7UrMizywBSc=;
        b=XR5u53Rtqx7PHCsYi4LinOYjm1/MxxbJYUutOfPvDlu1dvyHWS1Qj9T+jrN+dXpz2s
         0quduNVtAbQQcmuMekuvL2EV4O8qyE4NPOwpZ43mB2upqYUDBNgjCAMn/QazkM+qtsSu
         C9VQS5QNAsQRkyDfRl6TSiGGp/jDqNKjhQA8x1zVCPGLMzaSOKCdMbtt2Ljt2xtnn0N9
         RSYte64vv98N3MK6ixjOpf0YGo2QXDqODPUpmfgAfYokUcRG/BKxemjzY3gspf6WaugO
         FfsjiYQBuivFUG/fihWOT+nViVsJpvn47+qjLgxO8KVOX1TqBxH2B+3JulpjzoAz34RV
         dTlA==
X-Gm-Message-State: AOAM530R7CLPysIQWDxDgwkZCEUGzi2zD24DaTrcf2lAXqk5ElSCoOPZ
        ZolR6jKngVdpXO9zdIlnbW3y6WpFbfXyuoh9jA==
X-Google-Smtp-Source: ABdhPJx5mwQn3GQlblVQmzlSty4I9Q29JE+MKg6WlAneyi2KORZr/2M0D20waUTodpFA2Sv8dVP5DRk0rjMzyv27Ssc=
X-Received: by 2002:a37:b404:: with SMTP id d4mr15218565qkf.465.1623658118088;
 Mon, 14 Jun 2021 01:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210609135537.1460244-4-joamaki@gmail.com>
 <20210609220713.GA14929@ranger.igk.intel.com>
In-Reply-To: <20210609220713.GA14929@ranger.igk.intel.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 14 Jun 2021 10:08:27 +0200
Message-ID: <CAHn8xcnMX03sX0n5VrTA2kJTSgcUj5s07mUHHc0wqB76QWpqeQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for XDP bonding
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        andrii@kernel.org, magnus.karlsson@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 12:19 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Jun 09, 2021 at 01:55:37PM +0000, Jussi Maki wrote:
> > Add a test suite to test XDP bonding implementation
> > over a pair of veth devices.
>
> Cc: Magnus
>
> Jussi,
> AF_XDP selftests have very similar functionality just like you are trying
> to introduce over here, e.g. we setup veth pair and generate traffic.
> After a quick look seems that we could have a generic layer that would
> be used by both AF_XDP and bonding selftests.
>
> WDYT?

Sounds like a good idea to me to have more shared code in the
selftests and I don't see a reason not to use the AF_XDP datapath in
the bonding selftests. I'll look into it this week and get back to
you.
