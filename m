Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327851EFBF8
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 16:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgFEO57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 10:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgFEO57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 10:57:59 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1B5C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 07:57:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y13so10457541eju.2
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 07:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ahJ6Nnu2OQZzN0CklnLnCc1ayXBQg+GU9X0yvkMZDqQ=;
        b=B0BGbo9/tHQANd0fO26TL0SMXYmXlWsDZtSv81zV7RsqM4xJWlTqQrsXEylaOP6Jzt
         +mlIZHU+zj5tr8mU7A8rcSJEIkVLKpzsmtRUR0HuDQmw+eW2mVwaPYxlg0J3zwmX6XYc
         cLI/cnXb7Vst6SAzuV9On2kchplMfF9L67Uh7E0jVgrj/Us4fW6OVvYyGOA7Sq+/5qlO
         bxy9IqGwNpXEfjar+XKPqQJoORtHD0pZ+l1h8uyiA2z6goe98nbJjPBWroLq3V6M0Urf
         KenL7xGPGY1m23pVde2cgxxQJF0HIYvLc7MzhLdAVl2Q/Pxx+1BUE7xs8hjoh8JpUjhm
         yT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ahJ6Nnu2OQZzN0CklnLnCc1ayXBQg+GU9X0yvkMZDqQ=;
        b=Gg/u+TdJdjJeTRmtdrD7oFgFU6cwQ5TRQL6ZbdBTD2lDdROB8r8MGmGV4kEFobXFds
         tyRNvGBZCUZ+1F/yEuwdyTjLk5Ht5FNGYB9ItY39uWoAzASOAk1OO9aa4Q/9H1t2JPqx
         OAob3IrVQlmb3g0DG/tcToFIAs1Wj7F3juWWUpQUJcdYpgBrrBYFcmMbllDpUdivr8zu
         RFqMnVp8wSsrKuvJIhl2jzUkfccnUk+sGiSSCirINDYqE6RoA7Yxzzda8rXzUnOjoyIy
         5eQyBK03TVx03lRWCpY6GAm1r7M8+5+ZiDq95RMz/mUg61EHefuzf1w5HYi81QkmUcmc
         rLRQ==
X-Gm-Message-State: AOAM530Q95P6JdXb1hdgZghSjUP8BjjD2LMrjb0ZLOorqNIsZ7qSvU5X
        tjjBmGWb9uIDQJxvrlt7edguzfTrYnvFmWKy5FY=
X-Google-Smtp-Source: ABdhPJwKpolnkKF9FhoxgDz67jkCpml+pZ04NELZ8d8SX/rtXjoQw/ffySUMafyU/IOT8oVCbPKf+G+XALk97+WJk/U=
X-Received: by 2002:a17:906:f185:: with SMTP id gs5mr8760331ejb.223.1591369077503;
 Fri, 05 Jun 2020 07:57:57 -0700 (PDT)
MIME-Version: 1.0
References: <538FB666.9050303@yahoo-inc.com> <alpine.LFD.2.11.1406071441260.2287@ja.home.ssi.bg>
 <5397A98F.2030206@yahoo-inc.com> <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
 <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com> <878029e5-b2b2-544c-f4b5-ff4c76fd6bd3@gmail.com>
In-Reply-To: <878029e5-b2b2-544c-f4b5-ff4c76fd6bd3@gmail.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Fri, 5 Jun 2020 07:57:46 -0700
Message-ID: <CALMXkpbNeRCrOnQFWAWR8BzX4yRgDveDMPZgS6NupjXrHFX1pg@mail.gmail.com>
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leif Hedstrom <lhedstrom@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 6:28 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 6/4/20 4:18 PM, Christoph Paasch wrote:
> > +Eric & Leif
> >
> > Hello,
> >
> >
> > (digging out an old thread ... ;-) )
> >
>
> Is there a tldr; ?

Sure! TCP_DEFER_ACCEPT delays the creation of the socket until data
has been sent by the client *or* the specified time has expired upon
which a last SYN/ACK is sent and if the client replies with an ACK the
socket will be created and presented to the accept()-call. In the
latter case it means that the app gets a socket that does not have any
data to be read - which goes against the intention of TCP_DEFER_ACCEPT
(man-page says: "Allow a listener to be awakened only when data
arrives on the socket.").

In the original thread the proposal was to kill the connection with a
TCP-RST when the specified timeout expired (after the final SYN/ACK).

Thus, my question in my first email whether there is a specific reason
to not do this.

API-breakage does not seem to me to be a concern here. Apps that are
setting DEFER_ACCEPT probably would not expect to get a socket that
does not have data to read.


Thanks,
Christoph
