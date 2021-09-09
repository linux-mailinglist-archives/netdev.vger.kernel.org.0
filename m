Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B0D4058B7
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbhIIOP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhIIOPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:15:24 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AA0C08ED3D
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 05:28:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x19so1633177pfu.4
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 05:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pm4g3CirBG1n+zKeuWRRu/MVxE9MptX+oCeyJyzwsFg=;
        b=AVU21uGD7xD7qmDleMlS+FeTmKClNId7C6oqWwz20c4fzsi0829qLyzyIzsmzoNlJ2
         X9f2NNDpHg4CVCKLF7BJZOP2Xeqgd0RLCfiHLsmk+pUg05ivomh9z+n9hgcveugpIvTW
         uGETJmKiuG+ploaZsNaeYmmn8gKKK8MxjMD68ra8hDiRbBjhy3WraNfQEvbap7chx5Mj
         7xpCNx45IYTDF3Ka4KY5H9XLX4uadQZwTyN31BFwWmBH91sB7i5hy1+wXOGFgLkIs43P
         6qCpKncEJIxD1shDe6BlhaceXh1Mr3oSZCOz9JimRMQ2A3+KxdQLkoQPU2Y9JuQq1YXC
         jCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pm4g3CirBG1n+zKeuWRRu/MVxE9MptX+oCeyJyzwsFg=;
        b=7F7X7TvQZ0fWjxjBnAC5Zd0kGq294eaeGs4xKi2CriwwetPL1vr5mJiBDWFIAWqn5c
         34gqtCemxgMbmxjYsoW83I3bpDaRBxIT9lFY7TDKKlJDBEV7xbTSWYWQNaQ70APWUFy7
         9t2doQH4REKjjcMv5HR9EdOZReL7HsMHa/C1jkYFTbaK0LOv6P/FM4ZknpXnXWmv9TSr
         WLnrgfpQii4N6Tpsu2qk1xJAYa1fl2Ipgup1NgQiyzmWcbzMEYU+Fe/tNSs6g1ybV5+8
         m+vgIcviUhnFbDj0fLb/RRpkRNuBKZWjjouSXjMivdI8DALXhF+qoWlTr/WgTolNfQk7
         Zzkw==
X-Gm-Message-State: AOAM530ulWpE4AsqAyA/m79kmpfJ7XqQWU0XBP6qr1GTQd5xtJTLBKzz
        PcOUFF6u1ocTWSWcOTIPrFS0ec+jwKi03lOwH9F3XxHI
X-Google-Smtp-Source: ABdhPJyyNZXQqZgCJ4gyS2h/xwoPj4dqObHB8Sw8gc1CF7pjKrvVBCwTWuAMIpK2TFHDAjTR1YNov2RmzqWPSQh7DZM=
X-Received: by 2002:a05:6a00:7ca:b0:3f5:1a6d:bcf8 with SMTP id
 n10-20020a056a0007ca00b003f51a6dbcf8mr2610128pfu.55.1631190506879; Thu, 09
 Sep 2021 05:28:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAE2MWknAvL01A9V44PaODencJpGFHuOzH36h4ry=pbgOf4B9jw@mail.gmail.com>
 <20210908093315.404558c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210908093315.404558c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Thu, 9 Sep 2021 17:58:15 +0530
Message-ID: <CAE2MWk=VA72f+RoBnRPZQZ4L=8vdcRN3BCaTHzQbp7-xviaCpQ@mail.gmail.com>
Subject: Re: ip6mr: Indentation not proper in ip6mr_cache_report()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kernel <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the suggestion, I will do that change and will submit a patch.

Thanks,
UjjaL Roy

On Wed, Sep 8, 2021 at 10:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 8 Sep 2021 07:55:45 +0530 Ujjal Roy wrote:
> > Hi All,
> >
> > Before sending the patch, I am writing this email to get your
> > attention please. As per my knowledge I can see ip6mr_cache_report()
> > has some indentation issues. Please have a look at the line 1085.
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/ip6mr.c#n1085
> >
> > Sharing a patch based on the latest stable Linux.
>
> Please repost with the patch being inline in the email.
>
> Try to use git format-patch and git send-email for best results.
>
> The subject prefix should be [PATCH net-next].
>
> Regarding the change itself - since you're changing this code could you
> also remove the ifdef? Instead of:
>
> #ifdef CONFIG_IPV6_PIMSM_V2
>         if (assert == MRT6MSG_WHOLEPKT) {
>
> do:
>
>         if (IS_ENABLED(CONFIG_IPV6_PIMSM_V2) && assert == MRT6MSG_WHOLEPKT) {
