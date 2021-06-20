Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075B53AE10B
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 00:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFTXBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 19:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhFTXBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 19:01:02 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06F1C061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 15:58:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id my49so25428246ejc.7
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 15:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJBOiArEiJxpe4IgehQUCa3fhEo/xjSXPUDM1UGtCiE=;
        b=taEhq0lScfJYAGiNL0+6yaJORtZUqs/+JlWBZRT1EdGP1J/XPNhLtjfqcui7OuYfwf
         LlXE8d9jhWTEO2njb7Aaj1xsG8Z4/7CHWt5s9MHWpnpuDDI4dutacHaKI8jpsFCsfNux
         68bPDkhWJOl2i/qmCFSC44wKTAaMJhhogJlosMo5Sr5TLYvRKF/WXMKjbLSXtmBAgdH5
         rB5dJIwKMDCDRl74OfR3E0eeD4OBGSJzlIC1pPYnwi5iNq+J2oCpXGTOcs73gEDXzJ9A
         v1MGrx2hB+8Y1zqdpmpvpo/CagAw+bdBZepykO8ZRNgoW7Xfh16+0caQNNWW5u7NVnGV
         2wiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJBOiArEiJxpe4IgehQUCa3fhEo/xjSXPUDM1UGtCiE=;
        b=MB/9upTLBh98fp/cIVz06slJognxiunymiJ5XHGRL4/P7xSkIIbe3JhwU/vAtz556t
         UQ+wfLG88H7Q16a2nBPdjBEvy5YaeTYudKaE2D0ZxlrRFjyIAC06B+qedkwjmtWaQVwX
         n8RV3WUMORej3Z9gtavVbccrn11BMGlOV2zP3TC+kTsEXWpTTtMZeWUZrvtnW9UHk4lJ
         4SbTDQ7PkK21xmL9TSlgGFwA+M88OQA33YqqtwOgyRlMmW7eh3ouvXR/cl8KmHRsBjt8
         fVwkgvutQuBYeQ34V1uKpE/E4A4svV1QrBE5wN1cML+WS1Lcy6ufVCn/Fm8b/y1lUBjd
         h7Ng==
X-Gm-Message-State: AOAM533s8dNtcSG6mlfnmjQXjDb6fUPtdViEkXk9fAHySkLFxoC8LKTI
        15qvH6pJuPp1B8A9OB+95CmKxIYZpIwgIiTRkBc=
X-Google-Smtp-Source: ABdhPJzCiVMSVfr2lKSSUcR6K8o3RJSR+e8V5wfRJD7j7piIQP2HDH9Kua9S0rfvk5T3wngYl3wU2eT+HODuHXltEQo=
X-Received: by 2002:a17:906:474e:: with SMTP id j14mr7608227ejs.9.1624229927169;
 Sun, 20 Jun 2021 15:58:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAGvuCg_iLtzHr_rF0291oKAtYFCespoJ=dszFWjDftZd8EN6JA@mail.gmail.com>
In-Reply-To: <CAGvuCg_iLtzHr_rF0291oKAtYFCespoJ=dszFWjDftZd8EN6JA@mail.gmail.com>
From:   Juan Manuel Santos <godlike64@gmail.com>
Date:   Sun, 20 Jun 2021 19:58:36 -0300
Message-ID: <CAGvuCg-FJM7LLcb5i6gfZLRWJBUyDrGyCyZ4xPVqek58-kAVbQ@mail.gmail.com>
Subject: Fwd: WebRTC protocols broken when forwarding after a change to ip_dst_mtu_maybe_forward()
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Apologies if somebody receives this email twice. My first email was
filtered by the mailing list because gmail defaults to HTML. me--

I am writing to this mailing list because I believe based on the
maintainer list[1] that this is the correct place to report issues
like these, especially when unsure. I am a Gentoo user and I already
reported this downstream[2] but in my troubleshooting I was able to
confirm that linux-stable is affected, and possibly others.

The issue happens whenever a kernel version with a certain patch is
used in a gateway device doing IP forwarding for a LAN, such as a
Linux box running iptables / firewalld+iptables / firewalld+nftables.
It does not seem to matter which of the three methods is used, all are
affected. Applications inside the LAN using WebRTC (such as Google
Meet, Discord, etc) are affected. In the case of Meet, no video of any
participant can be seen, although audio works. In the case of Discord,
neither audio nor video works. It does not matter whether the
conference is started or joined from a device within the LAN, it won't
work properly.

I was able to git-bisect this using linux-stable and found the
offending upstream commit[3]. In linux-stable this was backported
right after 5.4.72 so >=5.4.73 are affected, up to 5.4.126. I can
confirm that reverting the commit (even if it is just commenting those
4 lines that the commit adds) fixes the issue at least on 5.4.109. No
other protocol/connection type seems to be affected, and this only
seems to affect webrtc in the context of forwarding (i.e. when
started/joined from a device in the LAN, not the gateway itself).

I am unsure how to proceed, whether this requires an upstream bugzilla
to be opened (which I can gladly do) or not. I searched the archives
first but I could find no mention relating webrtc and the change to
this function (I only found the relationship when git-bisecting).

Thanks in advance.

Regards,



[1] https://www.kernel.org/doc/html/latest/process/maintainers.html#maintainers
[2] https://bugs.gentoo.org/797211
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=02a1b175b0e92d9e0fa5df3957ade8d733ceb6a0
