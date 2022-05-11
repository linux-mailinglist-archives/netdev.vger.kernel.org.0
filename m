Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC18523BAB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiEKRgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiEKRgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:36:12 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFDF65D0B;
        Wed, 11 May 2022 10:36:10 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t5so3364037edw.11;
        Wed, 11 May 2022 10:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q+sQrzaE7q/wJ6M9e4FJHPDLoako2RAr16Pq76NbOZk=;
        b=WvBgvMgu4OutIFewhlEQT4/Q1Bd3fS5amVCGjf6MOewd1YKvZd9ahbz3Vz6ArX8QA4
         kq6RbKI9Cv601VnSFjDtyxN/3KNItwU+PIyC39fNYw1kY5C+LXLieFFGY1mTiTR84pcJ
         phP0/eGMn7+mmI3gV1MJZo+c+4SJ1ibDZ5gwTQCD4/iOU9RzpTV8tgwitTMkcLtKRlmG
         BqZDyL0F1tz3pn3wzobYa8bD+wPh5A1EiLg3zPE4VbV4vHZo2Xp35BGbHq7ux2/1IN+Z
         lDPrbBuMk4xpqyKwDFAbJFvwlVazPXVyRlSBvX/zR2HC3ed4hJq1fgRW9Rs7tym46Eov
         uGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q+sQrzaE7q/wJ6M9e4FJHPDLoako2RAr16Pq76NbOZk=;
        b=mMsDVJwCo7+DqZqRhzP8RBhdsIVz4Zyinuk5q8Ic6FgehXdljZcvxLfcjgpoHfgc3A
         g4Gadu3HpfOee80mJGrl2SGDLhdJVwKd/Kg/INzneLOja9tQCYJP6qOdewUuwin7hBqc
         iSWiIcOkd81+vQdqfiaAZzEnpgwMwucBYkfufNLCXTuy5dhq/mXubThZ+hs15TptGZq7
         4CNzt/zqZBZdxGaPpq0Qbe7z7LQGkIiF4iDR3e8TW0kEdseQUu2eVUc+04T4LUcwq/tp
         5H7Rjka0O5LDMGsz7lG/I7bK8FfsGc31xKJ1995gmAbmPq7xBevpcTOsbfi36pej9lFe
         DZ9w==
X-Gm-Message-State: AOAM533EQZch2F7ioAtBXGS2N3308xhpz7m/H7RjCD8T2Ns9TR7F1oSd
        1lrN0Ie+16d2V/tAVSyvLaLCMJYOE59Wa6YoJz8=
X-Google-Smtp-Source: ABdhPJynENfmraW6oQiF/P+GETWKUOT7bj4NNo/dDUhDEXz+AGnRCKll2vkap09kaqq+rGv0ZOJjPDHohINe34Ie+RE=
X-Received: by 2002:a05:6402:51d2:b0:428:48d0:5d05 with SMTP id
 r18-20020a05640251d200b0042848d05d05mr30732830edd.28.1652290569273; Wed, 11
 May 2022 10:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X> <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
In-Reply-To: <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 11 May 2022 10:35:54 -0700
Message-ID: <CAA93jw50TyLohZRQNkGf+LKSfzPykh9XcbYb8FCN5hmEd4Pc4g@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: last minute fixup
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 2:54 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> but what *is* interesting, and where the "Link:" line is very useful,
> is finding where the original problem that *caused* that patch to be
> posted in the first place.

More generally, inside and outside the linux universe, a search engine
that searched for all the *closed bugs* and their symptoms, in the
world would often be helpful. There is such a long deployment tail and
in modern bug trackers the closed bugs tend to vanish, even though the
problem might still exist in the field for another decade or more.


--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
