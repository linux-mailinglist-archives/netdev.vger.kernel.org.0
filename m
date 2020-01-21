Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2DB144282
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgAUQxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:53:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39078 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbgAUQxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:53:01 -0500
Received: by mail-wm1-f67.google.com with SMTP id 20so3889067wmj.4
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 08:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXpTERqJrRasbNgwCyYgAQ3fvZVSSaG/yVh8KhBjsms=;
        b=jEkj11pIvH9+R6457Q9uCS338mafw2wodWdMp+/yFm9CBXt+SHrWWO0Uu9UgqjdNAe
         jypRRpF3u5D8bogNuCmQuL7t0t2fXSd0TioxZD5UQuLy29wA2midRw1ViD2PZUJ9D4c6
         Xr1GH09dG2KNwqyn0kIeNZnzWfrrmKg4NCzFIpi+b8GnuEHtEbx92UdIG5Sj1xxSj0Xx
         cHs3cbcyXAvZavk4039I2BArA8I7VRfkgfyn9vYzAlkjxi3FxPfrc0gLJcRiPB4euK++
         v5f1iGS164IYqenNAkLmaP0ojRLAaHD2q6v0wOQuhHXYrPRJFAl1vqZuTbmqZrmSVn4e
         4cvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXpTERqJrRasbNgwCyYgAQ3fvZVSSaG/yVh8KhBjsms=;
        b=KKTDrqoy/R+J3agzdsUfVLxC/OGCZr1V1atq7Fq8S+/LngEam9decPtOeHf+8bkp8K
         sHyzVrDeyCxhD+F1nz6kzaSGaoblKqKL8fHbXOxtE0ic9Q7Md36OWOPLQP/DT1DNX/e+
         MrdG+flC6sAj3d/fHOU4zK2zbGMTOVtTZ69wQbrM76ZBQ9ydgFiLTJNl4brStDHzaK0k
         8rT2DaKk6otL9XOTYFLm60ZkIMT8PH5Eu2fnWPRetvH9lu2NXD2YKq+LYUEd8oJIiYly
         R1CYZpsfNIgJ0Ivt/6Wdtnc7qGP6iDGsm1oaAM3uDZy54ZKwO36X46+h9Yc6y2VyAjaa
         lRRA==
X-Gm-Message-State: APjAAAU29eUj/vvah+9cNSLGs48Qs+KyzlaubwgewH05WztAcFkklNf2
        9wafSfC2jZPiV8G/07/BW5i5uhMaxXerMwSf9KI4Wj6p
X-Google-Smtp-Source: APXvYqy3t2cs13wYvviBJ4MXisbDXcDujQhQAr4thzcZVJljk7f7ErbZW8aZiLlXQgdQ4QL0IEJzmUW4Ba0AvpfmbQY=
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr5257133wmp.30.1579625579013;
 Tue, 21 Jan 2020 08:52:59 -0800 (PST)
MIME-Version: 1.0
References: <20200121141250.26989-6-gautamramk@gmail.com> <20200121.153522.1248409324581446114.davem@davemloft.net>
 <CADAms0zvGp4ffqmvZV6RVOTfrosjt6Ht6EkyQ594yJYQFTJBXA@mail.gmail.com> <20200121.170905.87149625206286035.davem@davemloft.net>
In-Reply-To: <20200121.170905.87149625206286035.davem@davemloft.net>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Tue, 21 Jan 2020 22:22:22 +0530
Message-ID: <CAHv+uoEEwagyM1fVQY1gE_4-5O3wTBba3ANHgZZex1v6XDA6sA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 05/10] pie: rearrange structure members and
 their initializations
To:     David Miller <davem@davemloft.net>
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 9:39 PM David Miller <davem@davemloft.net> wrote:
>
> From: Gautam Ramakrishnan <gautamramk@gmail.com>
> Date: Tue, 21 Jan 2020 21:14:50 +0530
>
> > On Tue, Jan 21, 2020 at 8:05 PM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: gautamramk@gmail.com
> >> Date: Tue, 21 Jan 2020 19:42:44 +0530
> >>
> >> > From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> >> >
> >> > Rearrange the members of the structures such that they appear in
> >> > order of their types. Also, change the order of their
> >> > initializations to match the order in which they appear in the
> >> > structures. This improves the code's readability and consistency.
> >> >
> >> > Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> >> > Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> >> > Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> >>
> >> What matters for structure member ordering is dense packing and
> >> grouping commonly-used-together elements for performance.
> >>
> > We shall reorder the variables as per their appearance in the
> > structure and re-submit. Could you elaborate a bit on dense packing?
>
> It means eliminating unnecessary padding in the structure.  F.e. if
> you have:
>
>         u32     x;
>         u64     y;
>
> Then 32-bits of wasted space will be inserted after 'x' so that
> 'y' is properly 64-bit aligned.
>
> If in doubt use the 'pahole' tool to see how the structure is
> laid out.  It will show you where unnecessary padding exists as
> well.

Thanks David. Do you recommend we discard/keep this patch? pahole
reports no problems with or without this patch. However, we'll be correcting
issues with other structs in sch_pie.c and sch_fq_pie.c.
