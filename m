Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3351524DFE0
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHUSoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgHUSoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:44:37 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22306C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:44:37 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id h16so2344601oti.7
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZxbQ/RHwQu3tXMp7Uucuo9eWuJD3XIKzCUlyFWeBRvo=;
        b=S7itXVrIuL/KnC0ZmkGXh00nkdgb4m4/YgonJ6vGkJJkHb6qF23CFb6Q5qC1WGaT7i
         dCEUwR83MNaIJSMDp1wVjhqrgGCGClQ8pkPmsIXwpgv/jwiOxXLagX7QjE8zUN6VeXY/
         QiIQQgx2/rTX4oGKo35xPIqD6aaqi7qT7f3lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZxbQ/RHwQu3tXMp7Uucuo9eWuJD3XIKzCUlyFWeBRvo=;
        b=VFXkzK0MPuLB7qFbQMB7mXURA1G4WxF0wWsLP+xmm1omOfOEM0D+gOtXDuwhJc4Hah
         D2Hdw+T+a3NBAP8Dg4K2jntT6oR1um+bpR5qfZniGF+SwYzT1dkpq4jFHZ1P+fIbwcMX
         dSg0UcIv2TiMg5C53veA/piW/9V/jNaMkYEIb5sGJ6JKbGU1eV/W3KC/IGd549737cxU
         yUjCtpdumLPvCWTn09uODq/YoWRwYp+lg5B+1uLBs7i8pHrEzrTa50G2LyTo3TQp3v43
         9+2ay9OtDBFCu8Cg53AsJlQirsI+C422Ik8C14O+qoo0C3m5AP2OwE/kE901xEOTiHRb
         o3xQ==
X-Gm-Message-State: AOAM533Dl6Yfdgqvuirvi8OTKvA9SfhlAK+7c+vK26H7cOHDbCCUjdF7
        dVdyl2ikOTkDsbJYVL+ZTUyuEYXjBnALLfWZVIQgNA==
X-Google-Smtp-Source: ABdhPJz3JSws4PXHNn8ViMIaDC0alze9NOOXok9ZOrVLrqvMjUaLHJNS2RDva9H8HzTAdkQLfKtA3caMWIbF7I9QbQc=
X-Received: by 2002:a9d:7656:: with SMTP id o22mr2726709otl.109.1598035475579;
 Fri, 21 Aug 2020 11:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+hceDweydEtSV8jXs15oqXMMNH+YZxzo+wZ3_MR9-Uqw4g@mail.gmail.com>
In-Reply-To: <CAH6h+hceDweydEtSV8jXs15oqXMMNH+YZxzo+wZ3_MR9-Uqw4g@mail.gmail.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Fri, 21 Aug 2020 11:43:59 -0700
Message-ID: <CAKOOJTzOxWa-g18dLL2ohEuVK6_iOzdGehsuJENao8w6X1XpFw@mail.gmail.com>
Subject: Re: bnxt_en 0000:01:09.1 s1p2: hwrm req_type 0xe0 seq id 0xcdf error 0x3
To:     Marc Smith <msmith626@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 9:28 AM Marc Smith <msmith626@gmail.com> wrote:

> [45186.100161] bnxt_en 0000:01:09.1 s1p2: hwrm req_type 0xe0 seq id
> 0xcdf error 0x3
> ...
>
> If I've used the decoder ring correctly, these appear to be the
> req_type and error values:
> req_type -> HWRM_TEMP_MONITOR_QUERY
> error -> HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED

You seem to be using it correctly, yes. ;)

> So I assume this is because VF's don't have access to the temperature
> sensors, either by design or something else is misconfigured. If this
> is expected for VF's, perhaps we could set those messages to silent if
> it's a VF PCI ID? Or handle this in bnxt_hwmon_open() if it's a VF PCI
> ID (eg, not do anything)?

I expect not exposing the temperature to VFs is by design. Thanks for
bringing this to attention, I'll look into it.

Regards,
Edwin Peer
