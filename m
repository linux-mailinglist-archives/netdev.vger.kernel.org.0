Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79163102936
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfKSQWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:22:11 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53692 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfKSQWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:22:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id u18so3866736wmc.3
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8YRPPIovItQUl6ADDgTdiPd9ZfWTs2W/KaWlvRREH8=;
        b=rW12vXW5syexbWtWbFtNDRu1IzYCQDaT7hjuq9pqJDpR568AzxKzcACkfaEYa40FaO
         2JlDe7/yKgh0vCHnmHJh5+m+a+5BUDGFzb+AoYFX7VHOEDRvU33JDk4fE/Ft1UcAvRWA
         VBCQTFo7KqRX6F0u9kttajav3peUiNsqHgACZHqRkSCwWK0blUYUa5+1RbNXhais1Y6Q
         Grq5VnC2J+md9Cj0nsNoHHRqiXHXrCuqpChGeAhkNufIkrPWljVB8GVTjo1meuJzFtSw
         Cu3mUMf9291vRWzp0PV3FkNjt0mkjJCcmiEH2XdqOuKkEExujRfE2qIojdPgNB4G/yCs
         LnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8YRPPIovItQUl6ADDgTdiPd9ZfWTs2W/KaWlvRREH8=;
        b=lDrCx9hG0y6JGXFP9Ts+rCy8+NDtE188aV1dBWACy/rXXEi64C2TzzFhKKFHOT7mue
         p+TgLBAm8oVizL0xIqt0N8GHaNgaqsfdv5kTBV7e/+87fmW6sSPC0GjXb38zpp0ffn1t
         TOF8QJn/403ZHnhq+5isbN6XMXN0xTxE8ta3N1Y+JMVagdn4M+vzaBvv7cFTaC5CGOO8
         ANDSwtgd2HhCF+kQI1sJvR04JNKhL9cJx44BqAbcSyZubEDtQnw2bNQNdkX3O0Aue2lK
         cKu7yKK9ZsvwIy3wigcsfRgpzD2HH2T9+eK5OHx76r2xD9bdVVwD/KeSpES6MZEiDzjD
         h40w==
X-Gm-Message-State: APjAAAVEKb35zYBPhYxwI7Hu7v3qVmJ99tOrkdnWxkmR0YDCoR/PhfUB
        j+UfeFA+qwdiF8K21S7zTSOmT8lAwMc0y+VVRP0=
X-Google-Smtp-Source: APXvYqyBCue5eVSGbqEWWhUQHaGzKGVdvXSox7NSz1nQ5usWidt8Yd2BTVcbMH/DU7IL6MKWCZTtVofvNvIONsyIFBo=
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr6273275wmg.99.1574180529867;
 Tue, 19 Nov 2019 08:22:09 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574155869.git.lucien.xin@gmail.com> <CAHvchGmygFXEiw6k7FTzN16YBJu6WtCm_tE7zQAbUaHE5N+KQw@mail.gmail.com>
 <CADvbK_ciTYDuF+CEEPoTTJnqq1rng_3XPT4VaivfQ3SC1V=xRg@mail.gmail.com> <851ru3x33u.fsf@mojatatu.com>
In-Reply-To: <851ru3x33u.fsf@mojatatu.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 20 Nov 2019 00:23:03 +0800
Message-ID: <CADvbK_c8tbqwwa5ZRkak7ZbY5WijH94Jn3yn1HnvM-Tmxe7AQQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: sched: support vxlan and erspan options
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 12:06 AM Roman Mashak <mrv@mojatatu.com> wrote:
>
> Xin Long <lucien.xin@gmail.com> writes:
>
> > On Tue, Nov 19, 2019 at 10:18 PM Roman Mashak <mrv@mojatatu.com> wrote:
> >>
> >> On Tue, Nov 19, 2019 at 4:32 AM Xin Long <lucien.xin@gmail.com> wrote:
> >> >
> >> > This patchset is to add vxlan and erspan options support in
> >> > cls_flower and act_tunnel_key. The form is pretty much like
> >> > geneve_opts in:
> >> >
> >> >   https://patchwork.ozlabs.org/patch/935272/
> >> >   https://patchwork.ozlabs.org/patch/954564/
> >> >
> >> > but only one option is allowed for vxlan and erspan.
> >>
> >> [...]
> >>
> >> Are you considering to add tdc tests for the new features in separate patch?
> > You mean in selftests?
> > I will post iproute2 side patch to support these first, then
> > considering to add selftests.
> > (this patch series is the kernel side only)
>
> Yes, I mean tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
>
Sure, and it can only be done after tc userspace supports it.
Thanks for pointing this .json file out.
