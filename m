Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA9F67308D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjASEsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjASEr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:47:27 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB106A40;
        Wed, 18 Jan 2023 20:42:53 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id br9so1519469lfb.4;
        Wed, 18 Jan 2023 20:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DtDJTYU8IQbrJDzbr5O6n1dEsQoWlgEN9W+rVKPgh8E=;
        b=WWGTHcijH4H7fpQK0uUkoZ0nBgwCaROpz+B+nm6k3j8Jj3ANt1DkujCkFtDDK6y1KU
         1kLjHP0o/Da16AClAyEEaGmp0YA2VRup+fDV9Um6nzDxJABDafT7dQC4ApNE3fKSn7AW
         cjck46z+8hGYWqf8bu0vq7VPl/rJ+qlMX7XUQkw9/+OuAE5KuToi01w4N5RrFWQ+fW50
         TzqkmQDPsZyIBFRVt788yXMuiaMxdszK3fnhs9YZ5X8+lDMGKZxWFYRJMx/QsX98Ndj/
         cwy7FFHWS0x+U3Jc91PrT1wX2i+R83nCuJ/XqkCUgxjWSO323b3gW4UoKLY57YMLK5NK
         RdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DtDJTYU8IQbrJDzbr5O6n1dEsQoWlgEN9W+rVKPgh8E=;
        b=mhpUMgj7LVLbMEKnEIxEnidx3QTQL0vWBR7rP0XQC3S/9MXeJe0IoiX0xYjT0EOpDT
         7iHla0j8Xd/Kx7ODlYS3GQOPKcStLYbg8H9wvsnn6SkarC4M+sqnZQxwywcfEMsSLtKo
         tslVH45e0Xjj2YNdlx9lRO8K7bivP4UFk7HT1t1OqOzuJph+s+MfF8NR6a0tePlGvhof
         2k5E2mEpZrHDwl8cAgYAunnpkb+PZIocw3OII9NdD8yLE/I0/uOih+c6Ygagk5tLXGdx
         SqsVloBfvEhbXZKrKYw2gaUjBj8ZOLdClp7eEbht8+ZLdy5kdT3DpIaCJdQeUIAY7WU4
         hWLg==
X-Gm-Message-State: AFqh2kp6Gx0bhA6YXPsI0V8lzMth4BsoqF2jJmZbFz2ghJR0nxkVXz4F
        Ix3lhWdFAA3aBe3AAfF0WTRXmQ7qUcS0PS6rhL4=
X-Google-Smtp-Source: AMrXdXvoxhGxJdgDx5sJ/XpyewEboRPn/nOKW83Kdl8MInWFXe61sElRK2+7lYQuj2gJAm+Ir+QmhG1b+RPfXXqQMkQ=
X-Received: by 2002:a05:6512:96a:b0:4c4:dd2a:284f with SMTP id
 v10-20020a056512096a00b004c4dd2a284fmr585669lft.440.1674103371385; Wed, 18
 Jan 2023 20:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20230117221858.734596-1-jmaxwell37@gmail.com> <20230118203849.7c00187a@kernel.org>
In-Reply-To: <20230118203849.7c00187a@kernel.org>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Thu, 19 Jan 2023 15:42:14 +1100
Message-ID: <CAGHK07D2K7JajnzDGYV5sLeMVX1TDUtkTqLO62ib3h+GWrRWfA@mail.gmail.com>
Subject: Re: [net-next v2] ipv6: Document that max_size sysctl is depreciated
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 3:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 18 Jan 2023 09:18:58 +1100 Jon Maxwell wrote:
> > Subject: [net-next v2] ipv6: Document that max_size sysctl is depreciated
> >
> > v2: use correct commit syntax.
>
> change log under the --- lines
>
> > Document that max_size is depreciated due to:
> >
> > af6d10345ca7 ("ipv6: remove max_size check inline with ipv4")
>
>  ^ commit

Okay I'll add that.

>
> the word "commit" should be there before the hash
>
> > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index 7fbd060d6047..edf1fcd10c5c 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -156,6 +156,9 @@ route/max_size - INTEGER
> >       From linux kernel 3.6 onwards, this is deprecated for ipv4
> >       as route cache is no longer used.
> >
> > +     From linux kernel 6.2 onwards, this is deprecated for ipv6
>
> 6.2 or 6.3? 6.2 is what's currently in Linus's tree, net-next
> is 6.3 and the commit in the commit msg is in net-next only.
>

I'll change this to 6.3.

Regards

Jon

> > +     as garbage collection manages cached route entries.
