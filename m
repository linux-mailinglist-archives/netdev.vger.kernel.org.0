Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA721C0454
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgD3SDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbgD3SDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:03:47 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A542FC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:03:46 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z6so3049392wml.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nAYOfWcSDzqJHbetzae7LSUBpm8hJGe9JUFNGPJTyHc=;
        b=uOUuyjrZ/vKSxqEPMks9pR1xDyJfSgmz8LGuB8OzVtr4iqjdCp0vuS9u1bdgaW0c5/
         ajNzcvnXn1g84FaCCU2H1ByuhaPXwD16J3Ah3c4sv1rKkl/enb+rgFBAs05JBD5u0wAD
         KnYnZ0/CzsIUQ4uk140SDDeuVnCf8qo9HT8qdenOY7L/NFgp3d1dHK/Ohq0mRpb20zxQ
         uQ1NSUCq9VIU62WTlkcqxaKl7zq7MDnzHqO9gSIyrHfBDQnHzD/5KSvxNIoNUs9tAdBx
         kQqrnEAJSKSGW6XK60SWraW7rdeCaTi10GBNGiHPo3yKEMxAJTpmSOju3RcRajWADNk1
         cULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nAYOfWcSDzqJHbetzae7LSUBpm8hJGe9JUFNGPJTyHc=;
        b=mwWAU/k+VO5O6VXNf7n8lbbm0Lz00ICxLu3vJFr6Ws42njigeH6Z9qGiDeYmMJZ5m1
         8MGCESM3Ctkr2Jd+rc0kDnVCfWdh/PmTZjVtkmTiqSNl6CkyA+59GMvKFMVidsVc3h04
         dpOZrxg0g23fMY5SilzhBlp205EeuD9Tjm5C3wR3yhSiOnMJoX9qzPfV8Z5R/RITkK0p
         RP0Viw/GimlYfMDU81Jq8hWVwJXfTibDa9gQstPrOE0TxbYLmSwZXsTx/ykWfKx5Xw6/
         RJe7/zbWv22+J/269eIS5DFmW/38pZtHYzPxZFHzR+j/HX+CivufD3ytbUvxpPvkZpjF
         Zoug==
X-Gm-Message-State: AGi0PubFyozaZY/zOP/Jko2e0NHh1BpQNwzmOUH4lGJIWaic4CIrgD8v
        FUoAQYdm4tzvRsvOyDpHbCYa4VnVmvBE8T6uhSk=
X-Google-Smtp-Source: APiQypIsLxPBXUGp9EvQNWmQt7gAXXLtSwrIyz0YJRThXGZIoteWPs+YbSomT2uvl63lyM9VKElc3mbJRrqGV1ejevo=
X-Received: by 2002:a05:600c:29c2:: with SMTP id s2mr4195347wmd.111.1588269825341;
 Thu, 30 Apr 2020 11:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587983178.git.lucien.xin@gmail.com> <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
 <1cd96ed3-b2ec-6cc7-8737-0cc2ecd38f72@gmail.com> <CADvbK_cSTXakVS9qkiESu6swXPsEZyDvfPggQp1cWXYHg6hC5Q@mail.gmail.com>
 <3896333e-1c2b-8f9e-c41a-48662b2d60b6@gmail.com>
In-Reply-To: <3896333e-1c2b-8f9e-c41a-48662b2d60b6@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 1 May 2020 02:09:11 +0800
Message-ID: <CADvbK_d9oMKR5-bmPPCBFt1ag=030KTfK23ss-OG68t5PpX-8A@mail.gmail.com>
Subject: Re: [PATCHv4 iproute2-next 2/7] iproute_lwtunnel: add options support
 for vxlan metadata
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 1, 2020 at 12:19 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/29/20 11:12 PM, Xin Long wrote:
> >>
> >> gdp? should that be 'gbp'?
> > Right, should be 'gbp'. Sorry.
> > The same mistake also exists in:
> >
> >   [PATCHv4 iproute2-next 4/7] tc: m_tunnel_key: add options support for vxlan
>
> yep, saw that.
>
> >
> > Any other comments? Otherwise, I will post v5 with the fix.
> >
>
> LGTM. I can just edit the patches and fix before applying.
Great. thanks!
