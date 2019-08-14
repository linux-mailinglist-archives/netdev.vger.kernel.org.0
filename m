Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5E48DF4F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfHNUvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:51:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44298 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbfHNUvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:51:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so125698plr.11
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 13:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MEnN9cIkoprgGXZCvLAId1lzXJ/S4r3niCBe1YQXTy0=;
        b=MdZWJqAHrl9ARqMkSb5qxqaRLJdN45KgdIAXDLXqxXmoWALiG20tiCPDJTFneqJC3D
         4nZdXoZUhxtl8fW3Gk0ibOEA8zsFCiiaUn3xdMkKnD6d79wGv54d2vFvywhfi4jrYhzV
         GqX5cK3hLDRZuIy+2XR2/QhY7zOe7wKBMeKqMUkQm5/33U2EyVJdyPfzAIk1LLOpIyZf
         +EqsIZ7GPmrc+xk5UeOnh9E3HblpEkLPMrKcO6duTldugFeZIEK8pafLtMTgNEwhXgWv
         maXLm1Ues0xmhCEbt0bpqBYpiBsBIKFHiDMuCeudyt7RxNpKkcZ2c9XBzAQkTpv/L3po
         UPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MEnN9cIkoprgGXZCvLAId1lzXJ/S4r3niCBe1YQXTy0=;
        b=QXTlA6WzHJC2z9oTcD8mCLUvSrmX/TadqlvNDlIprHjJk8nN3bfP8S35KTkNrgb5kt
         fCrrSQDDa8rUuk6mUpulP3SAUDPKY5gpexMf+1esTEbjHEg9mr1KyoYkYK9doKq97G6o
         /VOkbejr2M1v2Wyws+YRqy4cACdA2rIOmjiExiNz9tYmYz1+jO+rp4ia+nbfnJEousuG
         phmcswmwqJrIPQZJnE+E7grtkB0jmwIoQ35IRKfgtqPS2Gc3lnaqJSjqpagf29Jeq+9U
         C+ouYRGQj/7syP1E35VZL2qg3uumphW4gZiVIGTAiM0dHP8dfoKfHSck8eyKwAxt9osh
         EvAA==
X-Gm-Message-State: APjAAAXXWgROFe0LCjH8icI+orkvtnUg1RcOwtaHfm0CTpiOzuOX/9RL
        MLeWwPMs5ZjRCoWNLrtV05BexcHl9R61ptO+txgixktD
X-Google-Smtp-Source: APXvYqyWimjHWiPhdHszTv+d5Dv/M7Uq7RTTuk3UxMJ/Z6q/WbBkJnME9bJnCmWIXkJkMXewIWxLvAMGfUCdCTrOX5s=
X-Received: by 2002:a17:902:7286:: with SMTP id d6mr1186743pll.61.1565815898371;
 Wed, 14 Aug 2019 13:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAAT+qEa6Yw-tf3L_R-phzSvLiGOdW9uLhFGNTz+i9eWhBT_+DA@mail.gmail.com>
 <CAAT+qEbOx8Jh3aFS-e7U6FyHo03sdcY6UoeGzwYQbO6WRjc3PQ@mail.gmail.com>
 <CAM_iQpW-kTV1ZL-OnS2TNVcso1NbiiPn0eUz=7f5uTpFucz7sw@mail.gmail.com> <CAAT+qEYG5=5ny+t0VcqiYjDUQLrcj9sBR=2w-fdsE7Jjf4xOkQ@mail.gmail.com>
In-Reply-To: <CAAT+qEYG5=5ny+t0VcqiYjDUQLrcj9sBR=2w-fdsE7Jjf4xOkQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Aug 2019 13:51:27 -0700
Message-ID: <CAM_iQpXNVgpi0+4BHw6zDN3z=dRpERqr6+ohjytf=zKoLd+CLg@mail.gmail.com>
Subject: Re: tc - mirred ingress not supported at the moment
To:     Martin Olsson <martin.olsson+netdev@sentorsecurity.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 2:02 AM Martin Olsson
<martin.olsson+netdev@sentorsecurity.com> wrote:
>
> Hi Cong!
>
> Ah sorry.
> Already implemented. Great!
>
> Hmmm. Then why don't the manual at https://www.linux.org/docs/man8/tc-mir=
red.html to reflect the changes?
> That was the place I checked to see if ingress was still not implemented.
> In the commit you point at, the sentence "Currently only egress is implem=
ented" has been removed.


This means that website is out-of-date, not sync'ed with latest man pages.


>
>
> Question:
> Is there any form of performance penalty if I send the mirrored traffic t=
o the ingress queue of the destination interface rather than to the egress =
queue?
> I mean, in the kernel there is the possibility to perform far more action=
s on the ingress queue than on the egress, but if I leave both queues at th=
eir defaults, will mirrored packets to ingress use more CPU cycles than to =
the egress destination, or are they more or less identical?
>

Hard to say without measurement. There is no queue on ingress
side, by the way, so it could be faster than egress, regarding to
lock contentions on queues.

>
> Question 2:
> Given the commit https://git.kernel.org/pub/scm/network/iproute2/iproute2=
.git/commit/?id=3D5eca0a3701223619a513c7209f7d9335ca1b4cfa, how can I see i=
n what kernel version it was added?
>

The kernel commit is:

commit 53592b3640019f2834701093e38272fdfd367ad8
Author: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Date:   Thu Oct 13 09:06:44 2016 +0300

    net/sched: act_mirred: Implement ingress actions

which is merged in 4.10.

Thanks.
