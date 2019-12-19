Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345321267AB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLSRGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:06:51 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:32814 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfLSRGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:06:50 -0500
Received: by mail-pj1-f68.google.com with SMTP id u63so2815578pjb.0
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 09:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ggI/u1Hdyu9CCu5/c+HTrd/ZpT0m9d7Vzr8WRuTSKCk=;
        b=r/pPQutHWlw6VyAXT2bxHLFev0H77LHp66kYaujlhy2o/5XPZsJkCza1NueqSMvjEu
         Gfn9MrWzJrPce9mN4Bilc40mvgfzFP8McDHK1PnY0IXO/OSgnwi5SRCqzgdxoj8vOVYg
         JGhEJ06OTFGsQP4VTCnUz0aT9hwY0kNFczwWppHEX1v62UTsIK8JI6q+TWiZLA2B9ibf
         OQWNovQd5GsCjBjjNcjeUu1pdQLQj23MTufOY5GeueFFn8VACLt85aPFPnV7NiFby4mV
         In5qUzMSPj1ld61/PaIYVAxDq3EMfhc3h6wHsAmMhJjayWoPHALPPtp8zgOGPnLNzwbL
         VuPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggI/u1Hdyu9CCu5/c+HTrd/ZpT0m9d7Vzr8WRuTSKCk=;
        b=jel9O3TRDnM9yhFhxOw2P65wpAcGnl+DHLnNPaXmgg06+p4QqlYmFZxgyPOaA6wziE
         AaxtsOGYN23hPQzSDu0txoBIyI42+cDIx4p0gjMTckfAV5AJ/OR2uMAeY3f42zIwlmIi
         +5vAvX2d+sHmFbUT2XomNoFW1tXrwXzBClR5dvMNUUozzshh0kK7KP1Fn0itzmEmQ14e
         XE0u1bwWz054EW51Ep/ZejQn0rdpMB4deEpdjwKDxBSwoSe6J3McmWiOk+W17Pq6SSCF
         Uot6xR24skDWjUEHVmiKfIWuyZhJmKoPkZJchCNVZFSGW1yD2wEge6EKfWRhqKNiO/6W
         rL1Q==
X-Gm-Message-State: APjAAAXRmwOomcSpbbN5H6/BjMYHPkfP9/mgg16emW1pcOUDwal5BKCq
        H0f4FVG7lXdWVFz9pf7T4G684X/p7Df8X0glGchveg+z3zSoiA==
X-Google-Smtp-Source: APXvYqxqxsEj2OttOz43YW9dsdsZ9JH2CzkLhBO906Jga6l6c3H9XIl47GBiSOLZiapTHFUKrg0ydPLQ+JWIDI9HDIw=
X-Received: by 2002:a17:902:6948:: with SMTP id k8mr9829302plt.223.1576775209535;
 Thu, 19 Dec 2019 09:06:49 -0800 (PST)
MIME-Version: 1.0
References: <20191211192252.35024-1-natechancellor@gmail.com>
 <CAKwvOdmQp+Rjgh49kbTp1ocLCjv4SUACEO4+tX5vz4stX-pPpg@mail.gmail.com> <87a77o786o.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a77o786o.fsf@kamboji.qca.qualcomm.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 19 Dec 2019 09:06:37 -0800
Message-ID: <CAKwvOdk3EPurHLMf81VHowauRYZ4FZXxNg98hJvp8CLgu=SSPw@mail.gmail.com>
Subject: Re: [PATCH] ath11k: Remove unnecessary enum scan_priority
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        ath11k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 5:32 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Nick Desaulniers <ndesaulniers@google.com> writes:
>
> > On Wed, Dec 11, 2019 at 11:23 AM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> >> wmi_scan_priority and scan_priority have the same values but the wmi one
> >> has WMI prefixed to the names. Since that enum is already being used,
> >> get rid of scan_priority and switch its one use to wmi_scan_priority to
> >> fix this warning.
> >>
> > Also, I don't know if the more concisely named enum is preferable?
>
> I didn't get this comment.

Given two enums with the same values:
enum scan_priority
enum wmi_scan_priority
wouldn't you prefer to type wmi_ a few times less?  Doesn't really
matter, but that was the point I was making.
-- 
Thanks,
~Nick Desaulniers
