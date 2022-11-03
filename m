Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF867618990
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 21:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiKCU2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 16:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiKCU2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 16:28:22 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1171F2E4
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 13:28:19 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id r76so3195252oie.13
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 13:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jz9oya0mAQbN17Ux09dhqha/NVhy+XUohDccZRU9/28=;
        b=INJbEY8Lm6nwBG7KujAHSw20M+tt+Te4grRfQmVpLflT/OXVlEluF1zLCDhEXZVACl
         V7wxW3yNnn0K2wenxNIV/dUgjwvz7SG35Sc9b1Z9a4nfskgaqZLJAMRGNltFSOyAjOfa
         DbOwRBkdcYg2NW5ppPsSrv0oWNlUuHN7QV/JQTnbnAJCCiq362Cj54cWwIIrYhsV2t7I
         XlLjwYGDMUCZNxLH87DykklNrr2+X0ettNh+7PVDX6DcschgI14dDjufz6VKYhO8AnBr
         2pZ1ZBE46Q5bqkfReXxH1IpnP1ZMVX5sz6xuXRMDcoorhJzS+RjiieYloT1+Z/mIJgJw
         hXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jz9oya0mAQbN17Ux09dhqha/NVhy+XUohDccZRU9/28=;
        b=oA9cUnzG4DWII15w28b4IXwmb1KRFFWEJQ/aTZMZTXFWfuSeJHgih6lHQzU2pS0E+Q
         xPMLQubM15l1dDSH6/JDI42RsBmTkqxON2iZWphM1w9QnU5s98h7s/HMxt1VWer2zRjw
         0NIXbEuz5MWulu4y4kgJI+kB/FGWyey35tMxRavrIP33yJelt1GOErby4ZYztUlKxUO3
         ezPFxvtM37zQS3K7rXz9VlokGsvv6Z/C3RSVWGFDP2U8Sj7rcxKicUW3oQEMRfiWnLC4
         IUXLkjwlYZzWvxdTUqNSEPI9nID9fq+wR6bVKoHNzivLXJHTHDgzfd8jux2szzf5r/1s
         0kbg==
X-Gm-Message-State: ACrzQf1+7zXNEBdMGIIPf9hXeqw2Wme8S+PHVD8i+tXGuTvCvViVwDjA
        DnMy/3liAcMVd/f/z75IxbXMpJxNrD2iDT+uOXw=
X-Google-Smtp-Source: AMsMyM5Bzj/lnbnHLbjGgi+ja3zN2eML7hMk1NSVhptcsIl0smHB+60lbCWHUJh2WrDiMNqXuB5TQZrr1FfdsSL8IXQ=
X-Received: by 2002:a05:6808:1826:b0:35a:573f:c8b5 with SMTP id
 bh38-20020a056808182600b0035a573fc8b5mr1341506oib.190.1667507298887; Thu, 03
 Nov 2022 13:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <Y2OmQDjtHmQCHE7x@pevik> <CADvbK_cA=7czAvftMu9tn+SkDp9-NpdyxeKsf70U8WO7=0i22g@mail.gmail.com>
 <Y2P5YsTuko5tgYJK@pevik>
In-Reply-To: <Y2P5YsTuko5tgYJK@pevik>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 3 Nov 2022 16:27:53 -0400
Message-ID: <CADvbK_eEOPJa5JXCysaywF9JYSd2vZUcjbKZ9T5ZZmbwrCLupw@mail.gmail.com>
Subject: Re: ping (iputils) review (call for help)
To:     Petr Vorel <pvorel@suse.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 1:24 PM Petr Vorel <pvorel@suse.cz> wrote:
>
> Hi Xin,
>
> > On Thu, Nov 3, 2022 at 7:30 AM Petr Vorel <pvorel@suse.cz> wrote:
>
> > > Hi,
>
> > > I'm sorry to bother you about userspace. I'm preparing new iputils release and
> > > I'm not sure about these two patches.  As there has been many regressions,
> > > review from experts is more than welcome.
>
> > > If you have time to review them, it does not matter if you post your
> > > comments/RBT in github or here (as long as you keep Cc me so that I don't
> > > overlook it).
>
> > > BTW I wonder if it make sense to list Hideaki YOSHIFUJI as NETWORKING
> > > IPv4/IPv6 maintainer. If I'm not mistaken, it has been a decade since he was active.
>
> > > * ping: Call connect() before sending/receiving
> > > https://github.com/iputils/iputils/pull/391
> > > => I did not even knew it's possible to connect to ping socket, but looks like
> > > it works on both raw socket and on ICMP datagram socket.
> > The workaround of not using the PING socket is:
>
> > # sysctl -w net.ipv4.ping_group_range="1 0"
>
> Well raw socket requires capabilities or setuid. Because some distros has moved to
> ICMP datagram socket, this approach requires root.
>
>
> > > * ping: revert "ping: do not bind to device when destination IP is on device
> > > https://github.com/iputils/iputils/pull/396
> > > => the problem has been fixed in mainline and stable/LTS kernels therefore I
> > > suppose we can revert cc44f4c as done in this PR. It's just a question if we
> > > should care about people who run new iputils on older (unfixed) kernels.
> > cc44f4c has also caused some regression though it's only seen in the
> > kselftests, and that is why I made the kernel fix. I don't know which
> > regression is more serious regardless of the patch's correctness. :-).
> I'd prefer users not being affected than fixed tests and ping not working.
>
> BTW can you be more specific, which kselftests is affected?
> Ideally link to lore. In [1] you just mentioned "Jianlin noticed", I haven't
> found anything on lore.
Sure, here is the bz you can check for more details:

https://bugzilla.redhat.com/show_bug.cgi?id=2054023

>
> > or can we put some changelog to say that this revert should be
> > backported together with the kernel commit?
> Well, this practically means new iputils (compiled from git) will not work on
> older (unfixed) kernel. Probably not many people will be affected, but why
> to upset anybody?
>
> If the problem now is just broken kselftests, I'd prefer keeping it long enough
> (at least 1 year?) before reverting it.
I'm okay with it as no real customers complain about it so far.

Thanks.

>
> Kind regards,
> Petr
>
> [1] https://lore.kernel.org/all/ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com/
