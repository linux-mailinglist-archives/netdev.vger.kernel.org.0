Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23E623E106
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgHFSkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbgHFS3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 14:29:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08A0D206A2;
        Thu,  6 Aug 2020 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596737641;
        bh=cTDFY6e9XbsVg5M5M8qrth0ZUAqNLBrGztIVgptNGgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zco0Fv7OomTblCt+TSZIE7kmS4eZOhsPBYtALr7GSSmJ/F+cWPQ2NRbt9Tpmko0NC
         UxR0BhR7NPP1nCdv2OndPM8SMyyu4j4LZsA4WCLN/8P3c+h5UR6kXSSZ6RaqpC0bSj
         GCtnswe0Qen27QfRnSOFxIaDUXtVOiG2QXouYm/k=
Date:   Thu, 6 Aug 2020 11:13:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Elder <elder@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2 0/2 net] bitfield.h cleanups
Message-ID: <20200806111358.2b23887c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKwvOd=YBL_igN-Z1V9bePdt9+GOqkKq-H4Wg8GBZvBsdOHeOw@mail.gmail.com>
References: <20200708230402.1644819-1-ndesaulniers@google.com>
        <CAKwvOdmXtFo8YoNd7pgBnTQEwTZw0nGx-LypDiFKRR_HzZm9aA@mail.gmail.com>
        <CAKwvOdkGmgdh6-4VRUGkd1KRC-PgFcGwP5vKJvO9Oj3cB_Qh6Q@mail.gmail.com>
        <20200720.163458.475401930020484350.davem@davemloft.net>
        <CAKwvOdmU+Eh0BF+o4yqSBFRXkokLOzvy-Qni27DcXOSKv5KOtQ@mail.gmail.com>
        <CAKwvOd=YBL_igN-Z1V9bePdt9+GOqkKq-H4Wg8GBZvBsdOHeOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Aug 2020 10:44:30 -0700 Nick Desaulniers wrote:
> Hi David,
> I read through https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-how-often-do-changes-from-these-trees-make-it-to-the-mainline-linus-tree
> and noticed http://vger.kernel.org/~davem/net-next.html.  Since the
> merge window just opened, it sounds like I'll need to wait 2 weeks for
> it to close before resending? Is that correct? Based on:
> 
> > IMPORTANT: Do not send new net-next content to netdev during the period during which net-next tree is closed.  
> 
> Then based on the next section in the doc, it sounds like I was
> missing which tree to put the patch in, in the subject? I believe
> these patches should target net-next (not net) since they're not
> addressing regressions from the most recent cycle.
> 
> Do I have all that right?

Nick, please repost the first patch only (to:dave, cc:netdev,...,
subject "[PATCH net resend] ...") and I'm pretty sure Dave will
re-consider it, it's a build fix after all. In any case reviewing 
a patch with a short explanation under the commit message on why it's
resend is easier [1] for a maintainer to process than digging through
conversations.

[1] may be related to the use of patchwork on netdev
