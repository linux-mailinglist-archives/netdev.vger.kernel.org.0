Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671D47D469
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbhLVPyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241550AbhLVPyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:54:35 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B4FC061574;
        Wed, 22 Dec 2021 07:54:35 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id v22-20020a9d4e96000000b005799790cf0bso3370854otk.5;
        Wed, 22 Dec 2021 07:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OWqHf9RwExEX02mM6sNQXY+S885OoA0iDcOlmlgZl2w=;
        b=e5N/2N7NBlpQCi+P4VjjINxY4cuNeV8TWff6L1hT5bD9v7xGvRiPcDGQhAmYK/AaLo
         OYEZoPfw9PX0SW4D4pGJVrKIaFiquiHe6YXaI+/iJCeA/enrx0UG+CvFafLsj3dVe/UD
         tajR3mXIKWvVyr+FOXEwC05RhtblwlO+Xi1huJslZwfSFXHiKC7tem0tsDdB7+co6obe
         4fDGcr7ZA3ki2gNjqJ6MpjvjWHaM17GlwCQX4w6T5xUHptS1FTZY1QhYbkDLwTLMSM1V
         oe6yvKpa1rElA5bZJ97Jf8BxQYpekzGVzK9b13N59feQwuYicsr8WWAJmG05SXwViIiX
         fT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OWqHf9RwExEX02mM6sNQXY+S885OoA0iDcOlmlgZl2w=;
        b=So7iJnx8zVr59Ue2hWRg6AVzD7WZaMJRiNcRDC/2ofG1dyDov43omvScX8mafh+Ga6
         kx8KV5adynT9qR9MQVwqNKFKrVTPS3Q2X8ozrsYC81xQBUaLGTRZVpPY+1BgwXkb27DW
         3rq6rGyCeTqZ24pReoFlArrUjFtaOyDZ59UQ09bwYaak+tN0BMNjR1LWw6t/o71Gug/O
         oMLxvgW5MEMP9FglF2RNUWg6B++RVaSFtNSqrHgkUzbOR5RY0+sUtBW/7YxtX8eiu7fo
         4CkexYAyiq3TLxg1OqALoXqep8pJLYNNYBcFOtsRSgfS8kitCNTWm99RRr/HroOCNDkq
         J2BA==
X-Gm-Message-State: AOAM530hAxkuF+7PO661RfKY/9h5Vjb5Dbf4AGuSBIq5IJzb8I5GApfu
        zlDqz/d10JlxI+ChsP8GbaCIhIht2PDXfP5ZO/DeaHRV74MVAQ==
X-Google-Smtp-Source: ABdhPJxU2NWgN4LPh9bXhuEtubHV8t86zxqhLznXU6BBtSL4oHPijI2oc5d9TqQefknv9bhoAUAgdoDZmaWgwbZa0iw=
X-Received: by 2002:a05:6830:2082:: with SMTP id y2mr2419000otq.15.1640188474637;
 Wed, 22 Dec 2021 07:54:34 -0800 (PST)
MIME-Version: 1.0
References: <20211221145013.767d833b@hermes.local>
In-Reply-To: <20211221145013.767d833b@hermes.local>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 22 Dec 2021 10:54:23 -0500
Message-ID: <CADvbK_fAxF4s5_gmpwdRk9T92vjtnyNTykH8AJmRkbiZJNa6xQ@mail.gmail.com>
Subject: Re: SCTP ABI breakage?
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 5:50 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> Looks like changes to SCTP events create kernel ABI breakage in applications.
>
> If application is compiled with new header but attempts to run on older kernel, it doesn't work:
>
> Reported here: https://osmocom.org/issues/5366
>
> Looks like bad design assumptions about how setsockopt here:
> static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
>                                   unsigned int optlen)
> {
>         struct sctp_sock *sp = sctp_sk(sk);
>         struct sctp_association *asoc;
>         int i;
>
>         if (optlen > sizeof(struct sctp_event_subscribe))
>                 return -EINVAL;
>
> Because of that the commits that add new events cause code built with the new
> header to not run on older kernels.
Hi, Stephen,

This is a known issue, and we're sorry that this can not be fixed.
please see:

https://lore.kernel.org/netdev/20200501131607.GU1294372@nataraja/

Thanks.
