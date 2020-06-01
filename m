Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7801EA295
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgFALSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:18:51 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:38709 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgFALSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 07:18:51 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 1be68f30
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 11:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=UW7c3FOIe8NfL3ecX7uTUfefE2Y=; b=HQGs5V
        F+EvIm0aELxwxvnGXVt7OYBGLETBySq0yBxrlHH2WjsW0fNHzckGbnudFg+NhQfd
        R2eZXafEv48k3AMK59+k4LGyDyy11/TihP6YFmycHH2RJeX8ExOGS8z6Fzs2+MnZ
        npYZBWc7W9G1cCZdDec9kcFKMqEFEehzNdClxMpAvTnxtlp/R7BsxiHZNwTeXCmX
        4p+4dZAIQcrifJmFAsPMoDS1gspcNU84srxUv25LrRVENxsaYR71SHbpa4goU2g4
        s9ZXLBTH/zC5x1aAVAUhqYcskTIgugRbKR1ITxF39sZBjjOSYWk/z7SQ4SSRx01/
        8ewiyQl3waYcUayw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d45600aa (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 11:02:46 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id j3so8944876ilk.11
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 04:18:47 -0700 (PDT)
X-Gm-Message-State: AOAM533xkMmAAhwF7DiUO41oL1uT8/c9pBAfATn026TNEdX8ygjUX89U
        cFpy+q0iiFPWNQAwXNgBFIPp7FIUd8tZ1UweV1o=
X-Google-Smtp-Source: ABdhPJxStAdyQbink3dezSh0PfJBzdE/Dqlt6vgBTK0t+wlNy9FTIFSRF2Wnelm5+p0c7oN59dL442WBNPQvnda9FWs=
X-Received: by 2002:a92:af15:: with SMTP id n21mr14384848ili.64.1591010327243;
 Mon, 01 Jun 2020 04:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200601062946.160954-1-Jason@zx2c4.com> <20200601062946.160954-2-Jason@zx2c4.com>
 <517a1ae3d93ff750263008c9807c224fb127b704.camel@perches.com>
In-Reply-To: <517a1ae3d93ff750263008c9807c224fb127b704.camel@perches.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 1 Jun 2020 05:18:36 -0600
X-Gmail-Original-Message-ID: <CAHmME9pf7i6u4UXS0eJ_YN8q5K2wtUx0iAS+rb4b=7FiWJNwKQ@mail.gmail.com>
Message-ID: <CAHmME9pf7i6u4UXS0eJ_YN8q5K2wtUx0iAS+rb4b=7FiWJNwKQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] wireguard: reformat to 100 column lines
To:     Joe Perches <joe@perches.com>
Cc:     Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 5:12 AM Joe Perches <joe@perches.com> wrote:
> Newspaper columns are pretty narrow for a reason.
>
> Please remember that left to right scanning of text, especially for
> comments, is not particularly improved by longer lines.

I agree that extra long lines make reading text impossible -- 500 is
madness, for example -- but 100 columns is a marked improvement over
80 in reading quickly for me, where I can take in more text on one
glance. I regularly will reformat long emails in vim with gq, and I'm
not the only one who does that; it was a nice suggestion made to me
years ago.

Either way, I would prefer not to bikeshed these minutia. If you want
to impose a different column limit for comments than for the rest of
the code, I suggest you bring that up in the original thread where
Linus was discussing this stuff and codify it there as part of the
style guide. Please don't derail this patch before net-next closes
tomorrow; that will make things a larger headache than necessary.

Jason
