Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2FB1028DC
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfKSQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:06:32 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38005 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbfKSQGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:06:32 -0500
Received: by mail-qt1-f196.google.com with SMTP id p20so25184380qtq.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=321lVVKmV9C77CQekXL6loL9pCKY7ivnwl1F/aQ/q/Y=;
        b=vv8392F6UkiHDuUMswfPJKVfI9D7pP5EZdxrqFXv6xzs8eU3G31D0zcvyAp4epTNvf
         SXkTJgb2k/V4iSWNM8d5ZdU2bBydHaa9+aA/AkjC9nzCCwtgAE2FsdEKmPdVXFlmgNzA
         VHgdzGYYYiE08TtbKuHwdpvyf+0su8DbCa+PN1+ssQyHw9Pfti5xrsX+0Kc/ah/WUt1V
         RFtscQlWan7nCXgQnoywTBqNljC709BOPKlUjsLAS3w9RgXcLCdaylEwekS4Oosw2tIX
         qig2Vt/XhhJIDyrfcvhs/F5c9iLn5QF5l2fiIy7edMS9GfTX/AYU0WN4GuU8OROZZdmF
         LwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=321lVVKmV9C77CQekXL6loL9pCKY7ivnwl1F/aQ/q/Y=;
        b=nPN+VE4/7HLlN5qSYuTm3BElg0UzcjKVSGeFUqrALR6KwYkboGSKLRoOEp8jPdAsEB
         G+Nd5OZAwXfhfTx+GYv2HGQ6PMlv4vcyUh+8BZN1VSkNY40Q1YU6aYyaIXQgDnX/a1Au
         OkK1QwAS1sGWeaqoU+8DPo+vG9o0cbXW90aeNTY0CZu5uHqjldvbDksTLj2ODmaIB/g7
         yOF/0Pvnj8NvEXhv1aA4BV8U5kf3q+os5IOi/QrgCQ/goJRmGaxaW9pEzbBcrem61M9i
         q37J8X0FFuND691kpydnKGK++pnh13B/D6DPwBnmqSSWzDRINNCeI5Q3XNi2HIUjLaj7
         QG+g==
X-Gm-Message-State: APjAAAXeObnEOQDKFg7xEEDxjCRSnrViGuUhx6xIO8Hoh5yln122+Vah
        PN7wRtok1d4Ii4LETLBSEElqABCtSK4=
X-Google-Smtp-Source: APXvYqzoi2ZYno9XpOehXoT/W2gjeTu8SvPqUw+YlN4NEhK/oKtXMjzLeqAkisfKSLg4PHaU3MMbIA==
X-Received: by 2002:aed:2907:: with SMTP id s7mr33582696qtd.265.1574179591617;
        Tue, 19 Nov 2019 08:06:31 -0800 (PST)
Received: from sevai (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id k65sm12175194qtd.14.2019.11.19.08.06.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 08:06:31 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net-next 0/4] net: sched: support vxlan and erspan options
References: <cover.1574155869.git.lucien.xin@gmail.com>
        <CAHvchGmygFXEiw6k7FTzN16YBJu6WtCm_tE7zQAbUaHE5N+KQw@mail.gmail.com>
        <CADvbK_ciTYDuF+CEEPoTTJnqq1rng_3XPT4VaivfQ3SC1V=xRg@mail.gmail.com>
Date:   Tue, 19 Nov 2019 11:06:29 -0500
In-Reply-To: <CADvbK_ciTYDuF+CEEPoTTJnqq1rng_3XPT4VaivfQ3SC1V=xRg@mail.gmail.com>
        (Xin Long's message of "Tue, 19 Nov 2019 23:55:23 +0800")
Message-ID: <851ru3x33u.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> On Tue, Nov 19, 2019 at 10:18 PM Roman Mashak <mrv@mojatatu.com> wrote:
>>
>> On Tue, Nov 19, 2019 at 4:32 AM Xin Long <lucien.xin@gmail.com> wrote:
>> >
>> > This patchset is to add vxlan and erspan options support in
>> > cls_flower and act_tunnel_key. The form is pretty much like
>> > geneve_opts in:
>> >
>> >   https://patchwork.ozlabs.org/patch/935272/
>> >   https://patchwork.ozlabs.org/patch/954564/
>> >
>> > but only one option is allowed for vxlan and erspan.
>>
>> [...]
>>
>> Are you considering to add tdc tests for the new features in separate patch?
> You mean in selftests?
> I will post iproute2 side patch to support these first, then
> considering to add selftests.
> (this patch series is the kernel side only)

Yes, I mean tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json

