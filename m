Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D2C1A7FF7
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391032AbgDNOiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391025AbgDNOip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 10:38:45 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E18C061A0C;
        Tue, 14 Apr 2020 07:38:44 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id f14so7278731ybr.13;
        Tue, 14 Apr 2020 07:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DBov4c0FPAs/GB0H+VoCLMbjb3xE9YZh3UekJ0w2xxQ=;
        b=SZp9pqL4/SIbGKiZ7G9fbmeTOsbsGmxutmHCVoNe/hXlc9azzXMGyscO0MRHYogJEs
         tqOv7GyZ0j1FaqLUHrsHIuG9hU5VqzkUVH1cAIHZzh0bZl5Ru/FBUOk/KEsD2cYyn8wn
         jyNlSBPjeVDiL4ojSURzeLww7OA8yliMEctkSAJLrm+iCe0W30L9yRp77gUuQtBz2qcI
         Yj98HrlQwvNl5jkZ+mYkrRTg3mN2txEyM/0UQHcvvspUWa62e/baS8R82rxMaHAIzCBn
         68Zggnwxe90ejy//YBICiWJHGeb4q1IajiJSMCNb7N9Y3XWb3H5W0JUoe7LzE/h94f4r
         4aXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DBov4c0FPAs/GB0H+VoCLMbjb3xE9YZh3UekJ0w2xxQ=;
        b=BapCplQFmQh6VVtc/lcnh4wuh3kKE+ahzqtT5E2nbcfjUd5kwahgx7SDse0XEa3kV8
         onBISHAYtWPH0m+ut9ZUDoWW64a7TegMpRxDxx10TRfQyIxNPK0ZUk0tChLgOTgyahNX
         Q6FrCK+hdbOoE+ioQTUrssKuXUFp9l3492WOTylsHNGVk0KxH7ymi+iziTISOb/4Ql4u
         7EBqkU2ixmORBIfWSzmoKD7fOwBFdnWurA8BXEuro3xvKz6/XWbPNzJasaeB+BTEAeT5
         E/U5EYOjbVT8f43CGQ8M2pJR+G+MtQ4tymAzItW0ao3MJPk5FQVfN9KNeMNXGSZ/DjWR
         LYgw==
X-Gm-Message-State: AGi0PuZ1b9i9aI7gpSyd5DXKpsX/KZ9Q6WFJcblcCBWfkhietBSPPCBl
        Nyx9qhphB1RdhfOtKdQz7x5oHdUELCdZR9OCPP5XUWIfcqg=
X-Google-Smtp-Source: APiQypIi8Iiyo9TUqXdYboNOEyl3RMyffO46vk+0FWqxXmUbGe7kuvCG0mTEml7Cy73IVaLlNmqICEmmkmsLtv9zzu8=
X-Received: by 2002:a5b:5cf:: with SMTP id w15mr432551ybp.215.1586875124002;
 Tue, 14 Apr 2020 07:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200411231413.26911-1-sashal@kernel.org> <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm> <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
In-Reply-To: <20200414110911.GA341846@kroah.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 14 Apr 2020 17:38:32 +0300
Message-ID: <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for representors
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 2:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 14, 2020 at 01:22:59PM +0300, Or Gerlitz wrote:
> > IMHO - I think it should be the other way around, you should get approval
> > from sub-system maintainers to put their code in charge into auto-selection,
> > unless there's kernel summit decision that says otherwise, is this documented
> > anywhere?
>
> No, we can't get make this a "only take if I agree" as there are _many_
> subsystem maintainers who today never mark anything for stable trees, as
> they just can't be bothered.  And that's fine, stable trees should not
> take up any extra maintainer time if they do not want to do so.  So it's
> simpler to do an opt-out when asked for.

OK, but I must say I am worried from the comment made here:

"I'm not sure what a fixes tag has to do with inclusion in a stable tree"

This patch

(A) was pushed to -next and not -rc kernel

(B) doesn't have fixes tag

(C) the change log state clearly that what's being "fixed"
can't be reproduced on any earlier kernel [..] "only possible
to reproduce with next commit in this series"

but it was selected for -stable -- at least if the fixes tag was used
as gating criteria, this wrong stable inclusion could have been eliminated
