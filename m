Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAB23E0BE
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgHFShz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbgHFSf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 14:35:56 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10ACC0617A2
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 11:35:55 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id x1so20985240ilp.7
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 11:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bEsJyh9TB2eoJaH29qp1fprNlZMNm6MiT+LfZmdRNks=;
        b=d6yimodqQ1spT4SScFDg7Fqurbd2EQnbbtn09MTcJ89exZyEGYU9OOVCeBh3M47wRT
         pVgGnotxuE2pdcKEM29GHBsNQ+ysd576A3fpSwcV8DjLJYF9N3RbPgKkvol9WiTpAmgc
         1PHYgvxIepKmtuG/Fcnb0ZqOkKkYgmLqmfAe2KkMopexPmWAIVB/2Lo9byWLkIYxa4pr
         QOjpyPeTz0BUG/6AjEv3WWs1DC4S7+b5ygUIW/chKTZgo4sLRzAtPPbM/67Ai25DCUEd
         +QeF2f6998hE3W++vMvyWB91bGsWnpGslM/j78iIqgT+o5vMqlRX+VUxJreo2/jmF/aQ
         MFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bEsJyh9TB2eoJaH29qp1fprNlZMNm6MiT+LfZmdRNks=;
        b=Q15lt0D+ue7QpWb0wl9SuEHwnl8p8VSe8i8kBMjbghL1voJ0bdcNEK1NsZKgmvAC2L
         B+A0o05G/o2UKioRjlq6zu/75WHuAnDA4pP7kWAQ4Yniwl7cPnqhIJjuL+8qDe3dUZ6P
         s+cbMDfu1jjSDKVfvZaw1p6fTEbdwhcu2MX7M5NEIY0Y/MthX2vcq3DCJ3JpX5FvHHw9
         yAK/o1vrdFxVqvPdBV3/yXmIgeCWAwDHNX3h1Iwly5cw9dr/aqKHlSuNHIfDSKiXp3Ss
         jQvjIwgU1HDkkTDLf+VkwErptZM9iSBg7ONLDZ6/YMqSXCvVi+PbABIcQjpCcTn5GhzI
         IkqA==
X-Gm-Message-State: AOAM531XAKksDitmVnhd4aAJG9LQN0BEsWBIcN2pg2BCdrBiJEZ9hM9R
        G1tmdRSLheeNRpolvKqn57T3N5IYNFaz1Q3ceDVolA==
X-Google-Smtp-Source: ABdhPJwD7OAfSvDHUkwjiV+OjCio0j9ivFPmWGhWVx5QFCeNCeG480zON6VF6WV1IBIQo/Hz6aGA2LM3Jdxxs1izJZ8=
X-Received: by 2002:a92:9116:: with SMTP id t22mr275723ild.305.1596738954788;
 Thu, 06 Aug 2020 11:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
 <CAM_iQpWhwQc4yHvfFh-UWtEU2caMzXFXs4JM4gwQaRf=B0JG5g@mail.gmail.com> <CAFbJv-5KYtxrXwiAJmyFuKx9zVn1NaOmt-EA7eM+_StS-+dbAA@mail.gmail.com>
In-Reply-To: <CAFbJv-5KYtxrXwiAJmyFuKx9zVn1NaOmt-EA7eM+_StS-+dbAA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 6 Aug 2020 11:35:43 -0700
Message-ID: <CAM_iQpVSP=2Rd8WoOu3bJVVnt63pjLQWmj5TaG6J+KDh0Xghxw@mail.gmail.com>
Subject: Re: Question about TC filter
To:     satish dhote <sdhote926@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 10:21 AM satish dhote <sdhote926@gmail.com> wrote:
>
> Hi Cong,
>
> I tried adding below patch i.e. "return cl == 0 ? q->block : NULL;"
> but after this I'm not able to see any output using "tc filter show... "
> command. Looks like the filter is not getting configured.

What exact command did you use? If you specify "ingress" rather
than "ffff:", it is exactly _my_ goal, because prior to clsact, only
"ffff:" could match ingress qdisc, the keyword "ingress" did not
even exist.

Of course, it may not be Daniel's intention, he might expect
"ingress" to match ingress qdisc too for convenience.

Thanks.
