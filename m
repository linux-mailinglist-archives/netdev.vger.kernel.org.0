Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D203A6686
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhFNM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:28:56 -0400
Received: from mail-qv1-f45.google.com ([209.85.219.45]:45653 "EHLO
        mail-qv1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbhFNM24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:28:56 -0400
Received: by mail-qv1-f45.google.com with SMTP id g12so20249398qvx.12;
        Mon, 14 Jun 2021 05:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+rUq2C8cXpVRpNGWqQmdgv7OPp4zEPLjXkkw2wZL/fE=;
        b=ETpvb8UgHDNdbT9QvIMYBTCKBUC5R76rginqC7eJWRAzbqz6ba7NWLeOyitRJF3N1A
         IL0DHV1mOK/+tcpNrQqLQv4mpYH6n7JuSlS12vAkqsVLA2FWjeOgs04kyUmOQJmk/x/K
         OQVUVQK9Wwt42hpp9G2ma+vwvrIm+nx0U2QRLtgGuxzoPrqXHMGhzxeXspe3yqEOIAM+
         Yrswou7aIT3JHT8hlNJ/XsIYqA5ATXVcr3KF6nKHdoJvmsTy+wUARFfL0zOtyoqNepYx
         JQ1Bhgb3odSb6d8GNbfauCmOcdXSFGyf3ckabaCHmKwb9Hxvi0l6nx0I44vrY9n8P3w1
         +f4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+rUq2C8cXpVRpNGWqQmdgv7OPp4zEPLjXkkw2wZL/fE=;
        b=ReVQ8S9Jw12V7HN0a8DVi/44prQq72/LZmrUbMfNoiHBqGkR837ALK8Hnbs/yV2b4+
         DysLqn6X6n2EaW4ShWH5f5/gYpggaiiJbux5/vxVfSkH5C/p0wEAby8Q8wlLH15k+n//
         YfnCYwyYHV18JPTkvgV1b3R2lq9SoSVjNMCICD+s7yIqCgOQA4eCEp/YG9fm77ZVnrUp
         i6neiVKTfcYWflRPiFprwm+Tvd4zpY2CG72ACMfg5WhNcz0wrOTHIoQaUn4I89RUNcdK
         AP0vtOr+INXeBMKgNK0eBz634fqR3/sCgRySWnDMOSvxlAgyTb/HYVGjvtXyv9xIrAyT
         Plnw==
X-Gm-Message-State: AOAM530gupbdQEEm0g5H3WUVI3GW6mKh6takFAJKfvsjA23QjoCRc7Vo
        lH+eqLX3Txeiyv6j3DjVDjfQ698XeAsknYaoHw==
X-Google-Smtp-Source: ABdhPJyImTY3nGnE8gqna+PiuY5Nx2VgJMrdyrg+BMD1VTHQebbCKn/FXm2SiHxbxshgyUuyEfK3IEl0AIs63c4j7d4=
X-Received: by 2002:a05:6214:2a46:: with SMTP id jf6mr6709403qvb.13.1623673553194;
 Mon, 14 Jun 2021 05:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <CAEf4Bzar4+HQ_0BBGt75_UPG-tVpjqz9YVdeBi2GVY1iam4Y2g@mail.gmail.com>
In-Reply-To: <CAEf4Bzar4+HQ_0BBGt75_UPG-tVpjqz9YVdeBi2GVY1iam4Y2g@mail.gmail.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 14 Jun 2021 14:25:42 +0200
Message-ID: <CAHn8xckZAwozmRVLDUuPv-gFCy9AaBC-3cKZ4iU4enfkN5my-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] XDP bonding support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 7:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jun 9, 2021 at 6:55 AM Jussi Maki <joamaki@gmail.com> wrote:
> >
> > This patchset introduces XDP support to the bonding driver.
> >
> > Patch 1 contains the implementation, including support for
> > the recently introduced EXCLUDE_INGRESS. Patch 2 contains a
> > performance fix to the roundrobin mode which switches rr_tx_counter
> > to be per-cpu. Patch 3 contains the test suite for the implementation
> > using a pair of veth devices.
> >
> > The vmtest.sh is modified to enable the bonding module and install
> > modules. The config change should probably be done in the libbpf
> > repository. Andrii: How would you like this done properly?
>
> I think vmtest.sh and CI setup doesn't support modules (not easily at
> least). Can we just compile that driver in? Then you can submit a PR
> against libbpf Github repo to adjust the config. We have also kernel
> CI repo where we'll need to make this change.

Unfortunately the mode and xmit_policy options of the bonding driver
are module params, so it'll need to be a module so the different modes
can be tested. I already modified vmtest.sh [1] to "make
module_install" into the rootfs and enable the bonding module via
scripts/config, but a cleaner approach would probably be to, as you
suggested, update latest.config in libbpf repo and probably get the
"modules_install" change into vmtest.sh separately (if you're happy
with this approach). What do you think?

[1] https://lore.kernel.org/netdev/20210609135537.1460244-1-joamaki@gmail.com/T/#maaf15ecd6b7c3af764558589118a3c6213e0af81
