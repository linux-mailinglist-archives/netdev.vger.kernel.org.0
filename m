Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D88210C022
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 23:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfK0WVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 17:21:49 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46422 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfK0WVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 17:21:49 -0500
Received: by mail-qt1-f193.google.com with SMTP id r20so26951621qtp.13;
        Wed, 27 Nov 2019 14:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=otxiMd0l6riNdSE7OSItmdvrSBc8N+W+v/4nkIlyazQ=;
        b=RQP5pXqwzoUtskHrYAlwr97uAnCC7oisEf/vhz6/+mD8Anotr29Jmbcp1OsIe69Tuw
         0A07pM9BToSi1HQ9CxaWvtHPrghDyMPuemOfZhM2321xX9KmeiVxgiSnjUQIBsLeRS4o
         R9zvEDph33VWXPQAgQ4LGvSjFr4epgCXz2F2PJuCxiJnRYBb10J8fD2mPSzpKza4punW
         KbLTS5b3XmLY2fhyyoBCxBSo0g3mhVqKolxzp1FUvnnCSMNNR99KoyiIv14Y9OINZM7S
         89OBRM3zJh807xtlqHssY5KwD+AZu1k/hOks+ORgzTRPddjl7piKvJVo9wVFBsy2e3FC
         pKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=otxiMd0l6riNdSE7OSItmdvrSBc8N+W+v/4nkIlyazQ=;
        b=VjQ/9UrivBSw+tUuaHjexuzNHGhWbAip6WKw5wuh7Q6hSLpFvoyIdPj7yOq1xbz9A7
         bD+C/WdoxTD8hV2WmSeX+mlkc/HPQrSow9dgKnHmpFvOxu8MnNcL8JdY4bjPP2eI5sZD
         srmXDsJ1DWAF2FEKqLwsFm3tatjf9mscsRO+RhW1ZHfoPzFYPT0GFt3V2HwP5OXQ4vKE
         99g/6BhrvD+V6uSnANS86dSIjvcCFggM0ZP6jCsWTH9oLZVIkDFQXut0QIVwaKOE8WUz
         FP0vT7GF9xDgJD0/UJZCVZ/Rb085AsX7tCxi+NH4/dpzmQVrLW1rJz40GZ3EKKB7M0MT
         GjeQ==
X-Gm-Message-State: APjAAAUrcWZdQhIgRkOLK1z6qDuc2wNVSetAo2fB9LfZ6wsvMeriP+wo
        +OrYGY4AoJc/hxPuvbIAedNaZC39o0YOCXEHKsk=
X-Google-Smtp-Source: APXvYqy0F9gnB7YBK+zsp8V0IkP9CmjbBRcRUX0suieWlH88wWb+/2l2kHHjCnezybi9Y5JCjvlUe8cugNRtcIy1mP0=
X-Received: by 2002:ac8:2b86:: with SMTP id m6mr10619893qtm.190.1574893307208;
 Wed, 27 Nov 2019 14:21:47 -0800 (PST)
MIME-Version: 1.0
References: <20191127054358.GA59549@LGEARND20B15> <46dfe877-4f32-b763-429f-7af3a83828f0@cogentembedded.com>
 <CADLLry4jOr1S7YhdN5saRCXSnjTt_J=TB+sm=CjbcW9NJ4V7Pg@mail.gmail.com> <0101016ead12c253-18d4624e-98eb-4252-ba3a-fabf74d831f2-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ead12c253-18d4624e-98eb-4252-ba3a-fabf74d831f2-000000@us-west-2.amazonses.com>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Thu, 28 Nov 2019 07:21:40 +0900
Message-ID: <CADLLry7Dcdz9bcfK2BQY3UcYVEL7z+cYqMjab916B8fkfDqHFA@mail.gmail.com>
Subject: Re: [PATCH] brcmsmac: Remove always false 'channel < 0' statement
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019=EB=85=84 11=EC=9B=94 27=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 10:35,=
 Kalle Valo <kvalo@codeaurora.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Austin Kim <austindh.kim@gmail.com> writes:
>
> > 2019=EB=85=84 11=EC=9B=94 27=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 7:=
48, Sergei Shtylyov
> > <sergei.shtylyov@cogentembedded.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >>
> >> On 27.11.2019 8:43, Austin Kim wrote:
> >>
> >> > As 'channel' is declared as u16, the following statement is always f=
alse.
> >> >     channel < 0
> >> >
> >> > So we can remove unnecessary 'always false' statement.
> >>
> >>     It's an expression, not a statement.
> >>
> >
> > According to below link, it is okay to use 'statement' in above case.
> > https://en.wikipedia.org/wiki/Statement_(computer_science)
>
> I don't have time to start arguing about this, and I'm no C language
> lawyer either, but all I say is that I agree with Sergei here.

Thanks for your opinion.
I will use 'expression' rather than 'statement' when I upstream
similar patch later.

>
> > Why don't you show your opition about patch rather than commit message?
>
> But this comment is not ok. Patch review (including commit logs) is the
> core principle of upstream development so you need to have an open mind
> for all comments, even the ones you don't like.

Oh! I Agreed.
If I were you, I would leave similar comment.

Thanks,
Austin Kim

>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches
