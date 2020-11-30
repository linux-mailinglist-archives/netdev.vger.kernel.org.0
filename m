Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDA62C8B56
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgK3RiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbgK3RiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:38:11 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA25C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:37:31 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id t15so3992836ual.6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DY7aJ2EnDe2+cRSn46RZNOO3lrlnC/7FrfDSMKNi77Q=;
        b=r3xnYS9dE0kiFFsUpJxEU8COFH1QnVXjFuHTzIs9ukPFjhik6fh00irsrh5A6l1/YC
         Cy6CgLDDudFB0fbXeG2cUdyu9g5xB9Uj8+m3/j4CaGVIgJ7OM/RvQA0P6trW1jJ9JNNp
         bNSk3AWNXUtfI5EEKsA+3F/SIKAF6WoqEXoB69jQIFmDOkBNML/Bwir78UTVzX8M4bbs
         w492Rz4mkBkAOkOu/br9lbiivjkqrS3u+xx6bParvnMtIoKW3E0RNPi0sSELV+ZBPewX
         3Vcc582XWsrgHsLBIjmofd0tIHosk5LkMhyeDjkNDYvqhr85Yodv7sV62Bv/0iZDtczA
         eTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DY7aJ2EnDe2+cRSn46RZNOO3lrlnC/7FrfDSMKNi77Q=;
        b=HTNoI3XBgTAur7cpvNFN6mVRatxzRWYj5UWehsmeGVDB8hd8yggeRigudJy04tuN+t
         VQHysergYihNkXZE0eZrinUxOFvhv/FixuUElZAwlBglBGHqW7U9ka0G+uO9C+YgvfQO
         HY0F0qdCfAqS5CUPuYoO+Nl9RN4mDky/XVXnOdgFGAm1AP9P1zS1XPka6nWq0LWUoP3Z
         FXypGqiiO6el0oqpJz3/DdIoD8JdReRXFYLP6VPr8EO82LqaC0617RCYODhVts3wKoKm
         SnCssskYZeDXr8NTjo4JtkOa2DdRJd3EOIGDIRPp2VfcOZgVI4OMMsF6ErWvWDiwvnbj
         Vzow==
X-Gm-Message-State: AOAM5336wpY14JqWHUexQi2j3eZq4VH3blScBNDxkq/6G6AJ1w+0fBa6
        84L3lDuJTsz+dpYwAsQ1DeBzNVCMuz+30puqNL+o4y4VMiVUKA==
X-Google-Smtp-Source: ABdhPJyT6mdzkfpkiLhLyIPQYOWPaccbCUnqKfJW3oJtk3KRM41wxF7q2U5PjNjmnfWyZxRbY9kUYsK2/bqMexPIzGQ=
X-Received: by 2002:ab0:321:: with SMTP id 30mr15183793uat.125.1606757850259;
 Mon, 30 Nov 2020 09:37:30 -0800 (PST)
MIME-Version: 1.0
References: <CAH6h+heNaKFT-xYdbOfYUa0Vp=Ybohb6A0TQ=N1EJDvFE6wbpw@mail.gmail.com>
 <CACKFLikcVv0VrC1CX+BWKGM9n6J+nOSkJcB97m3RpxqO0svJCA@mail.gmail.com>
In-Reply-To: <CACKFLikcVv0VrC1CX+BWKGM9n6J+nOSkJcB97m3RpxqO0svJCA@mail.gmail.com>
From:   Marc Smith <msmith626@gmail.com>
Date:   Mon, 30 Nov 2020 12:37:19 -0500
Message-ID: <CAH6h+hc=LpNQ7CXRXMm_uXXNzzP+B-h9v4KVs7fj3Rv=BUFSGg@mail.gmail.com>
Subject: Re: NETDEV WATCHDOG: s1p1 (bnxt_en): transmit queue 2 timed out
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 2:04 AM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Wed, Nov 25, 2020 at 11:39 AM Marc Smith <msmith626@gmail.com> wrote:
>
> > [17879.279213] bnxt_en 0000:01:09.0 s1p1: TX timeout detected,
> > starting reset task!
> > [17883.075299] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
> > [17883.075302] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 1
> > failed. rc:fffffff0 err:0
> > [17886.957100] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
> > [17886.957103] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 2
> > failed. rc:fffffff0 err:0
> > [17890.843023] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
> > [17890.843025] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 2
> > failed. rc:fffffff0 err:0
>
> These messages could be caused by IRQ issues or firmware issues.  It
> seems that one IRQ vector that is shared by 1 TX ring (type 1) and 2
> RX rings (type 2) is not getting the interrupt.  It caused the
> original TX timeout and the interrupt issue persisted during the
> recovery to free these rings.
>
> > firmware-version: 214.0.191.0
>
> This firmware is about 2 years old.  I'll have someone get back to you
> on how to upgrade and what version to upgrade to.

Thanks Michael. After more investigation, I'm not so sure this is a
firmware issue; we see these corresponding events on the host
(hypervisor):
AMD-Vi: Event logged [IO_PAGE_FAULT device=c8:02.0 domain=0x0001
address=0xfffffffdf8050000 flags=0x0008]


>
> Thanks.
