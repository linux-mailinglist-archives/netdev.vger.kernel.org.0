Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DC323CEEF
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgHETKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgHESfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:35:51 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11512C06174A
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 11:28:51 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id c6so3131637ilo.13
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 11:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b++LoBh3fWjC+WaLkOK5I3Hi48SN1RsxpQ3n0PRz/HQ=;
        b=Xaoc8TN2ZmUlzCGCghnDLv4nNleHfXfNEaMQid39KOyg+3R8DRldq/PaVNPd7ajxIL
         mdwNozoIes10Oatdmb5F+1aeiR7sh20bw+2/vyr+nn409M1IuyCBTmvvZim1CHK/mDqp
         H00tATHpQooJryyIm6CSAARfOQ/LoVk7no2BYJ5khWT9qXB68PFPT52S9LqvgjsHXEr4
         8pf0L0gYBY7mlZpuFjSeUdlj98SHH4R3mOfsjRPLhlhDwERiE56szJN+L60n/kSj20LR
         VkDmDyqnCKWGCtP3eC/uEsvwROZ3nBhEsg1DW9P6vSm3EGavhzTtkDqRTWwuDYXPyZkP
         KhgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b++LoBh3fWjC+WaLkOK5I3Hi48SN1RsxpQ3n0PRz/HQ=;
        b=TyFDFpbwGERIcAX42uev26bEzCzNdYGgY1TqnL/n6v50E29hSfhqrBOPLKAFbgszrk
         yYz9GsuYRxg2XBDifmrlsQknAnyIJ6z+wprQd3fY4DoWedRGDy11jYe8KPWBV58JZQWo
         p9gQuDuoipMfC+kJIjy4Qfs++RlOcqV05uNpzDfknP507Rm9PcBS8D7Zj9Lgwi3beunz
         g4RHKSRg2nAFKYeEv1dW+2eRw6LljV78e9Gmi+wn5oKe1NLWZUhVGXqK9f9VkK0r77Ip
         29f8Aiw+CLWI5DBddo7dGMFdVj+/4ZYUpG/rfJtavq4hkyuehY0en4YTl1gZMa9orRSR
         KVJQ==
X-Gm-Message-State: AOAM531ZCd2XY+uDYuyyP7msg30RnYCzg6WvpgM8NsfosLDWAYel7yKo
        j8FyQKOqjbYdy4ogV8VyGPe5KHcNOf1bAZNVXOc=
X-Google-Smtp-Source: ABdhPJz5JbXzDpXdhGsWVoO0N+kWCAdcueNKaO4a/WB9lerE8J61/vA5cndXbbMfyjiHJxWmcevFlhbh/ac++0YXCmU=
X-Received: by 2002:a92:9f9a:: with SMTP id z26mr5107596ilk.277.1596652127314;
 Wed, 05 Aug 2020 11:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
 <20200805094553.69c2c91f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200805094553.69c2c91f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   satish dhote <sdhote926@gmail.com>
Date:   Wed, 5 Aug 2020 23:58:36 +0530
Message-ID: <CAFbJv-4vf7j_z+eSnyWm3FD1OJBZJYRJwaon_1cisFMMxFHftg@mail.gmail.com>
Subject: Re: Question about TC filter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thanks for your response. Below are the OS and Kernel version I'm using.

OS: Ubuntu 20.04.1 LTS
Kernel Version: 5.4.0-42-generic

Thanks
Satish

On Wed, Aug 5, 2020 at 10:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 5 Aug 2020 11:08:08 +0530 satish dhote wrote:
> > Hi Team,
> >
> > I have a question regarding tc filter behavior. I tried to look
> > for the answer over the web and netdev FAQ but didn't get the
> > answer. Hence I'm looking for your help.
> >
> > I added ingress qdisc for interface enp0s25 and then configured the
> > tc filter as shown below, but after adding filters I realize that
> > rule is reflected as a result of both ingress and egress filter
> > command?  Is this the expected behaviour? or a bug? Why should the
> > same filter be reflected in both ingress and egress path?
> >
> > I understand that policy is always configured for ingress traffic,
> > so I believe that filters should not be reflected with egress.
> > Behaviour is same when I offloaded ovs flow to the tc software
> > datapath.
>
> I feel like this was discussed and perhaps fixed by:
>
> a7df4870d79b ("net_sched: fix tcm_parent in tc filter dump")
>
> What's your kernel version?
