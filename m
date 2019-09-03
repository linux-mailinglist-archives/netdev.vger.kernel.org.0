Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55120A7642
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 23:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfICVcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 17:32:14 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34242 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfICVcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 17:32:13 -0400
Received: by mail-qt1-f196.google.com with SMTP id a13so21922723qtj.1
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 14:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IYBiOaZnylPAyvBRtjuJJugmlxGUEWO40VSIEvur7MU=;
        b=ldX73UrlYb/SfB1Y+QNKLKHlHQoetlB8wjksWbqh7uuSu+pC/QBA9RQuxP7Rr1IyyY
         wTLlN3lF3NJPE/WqeSkNMf6KHeQsU1rQR3Mo79uojvjR++kau7u4NGOeIvNAwBaikvQe
         0Z8B71M6GF8+0I0rdMn3B58afgikpItgcYTys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IYBiOaZnylPAyvBRtjuJJugmlxGUEWO40VSIEvur7MU=;
        b=chYvpwPOzeTOn8KUg4L8NucokjFc3p7z/AJRzdTCVEluTimATkFWqRQHUM98zFjXie
         EpLLqy3TuylouV9wuZdLMwG8TBJM7eyr0GJwHWY9tHdCd0INwxQz4y4Dzyp8ZsCBrFhu
         A+lSuFCmC5m0KZ2uFSrO8dXA5G/P10AjdRb8NvJyrxS/qst92n+EnV2954T+IzjpRwJQ
         btzriF6XGEM9GB8UauNSkQnEIfYo/i6iT9FPq362t2g3Ahtn1Z/fozIMOpHLUAf2Y+x1
         cNs8teQM3OL3SI6vjPJ+XxmXqxPU4KwWin5zJaStqIYmou9vsID3vnc+0b8FGITxymLp
         Bvhg==
X-Gm-Message-State: APjAAAWh5eoTQNB16MCsuIHp2/44ALixJYDLNM8RTdf7NNmiRQ6pMYTH
        36k1LpXjlavJqAUGwNG7OPlJ9oW318GI0gM6c+Mpww==
X-Google-Smtp-Source: APXvYqwm3ckWcMUnDQElnCku6LE62c264Wiusvcm08pK5ln+ecvZDxzkyqmvIrwHJD3nyJ2JzOaIFuQozGH45mgdd50=
X-Received: by 2002:ac8:4542:: with SMTP id z2mr36302364qtn.265.1567546332341;
 Tue, 03 Sep 2019 14:32:12 -0700 (PDT)
MIME-Version: 1.0
References: <CACeCKacOcg01NuCWgf2RRer3bdmW-CH7d90Y+iD2wQh5Ka6Mew@mail.gmail.com>
 <CACeCKacjCkS5UmzS9irm0JjGmk98uBBBsTLSzrXoDUJ60Be9Vw@mail.gmail.com>
 <755AFD2B-D66F-40FF-ADCD-5077ECC569FE@realtek.com> <0835B3720019904CB8F7AA43166CEEB2F18DA7A9@RTITMBSVM03.realtek.com.tw>
 <BAD4255E2724E442BCB37085A3D9C93AEEA087DF@RTITMBSVM03.realtek.com.tw>
In-Reply-To: <BAD4255E2724E442BCB37085A3D9C93AEEA087DF@RTITMBSVM03.realtek.com.tw>
From:   Prashant Malani <pmalani@chromium.org>
Date:   Tue, 3 Sep 2019 14:32:01 -0700
Message-ID: <CACeCKadhJz3fdR+0rm+O2E39EbJgmN5NipMT8GRNtorus8myEg@mail.gmail.com>
Subject: Re: Proposal: r8152 firmware patching framework
To:     Bambi Yeh <bambi.yeh@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Amber Chen <amber.chen@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ryankao <ryankao@realtek.com>, Jackc <jackc@realtek.com>,
        Albertk <albertk@realtek.com>,
        "marcochen@google.com" <marcochen@google.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bambi,

Thank you for your response. We'd be more than happy to assist in
working out a solution that would be acceptable by the upstream
maintainers.
I think having a maintainable and safe way to deploy firmware fixes
would be much appreciated by hardware users as well as upstream devs,
and certainly more manageable than big static byte-arrays in the
source code!

I've moved David to the TO list to hopefully get his suggestions and
guidance about how to design this in a upstream-compatible way.

I'd be happy to implement it too (I feel this can occur concurrent to
Hayes' upstreaming efforts).

David, could you kindly advise the best way to incorporate deploying
these firmware patches? This change link gives an idea of what we're
dealing with: https://chromium-review.googlesource.com/c/chromiumos/third_p=
arty/kernel/+/1417953

My original strawman is to just have a simple firmware format like so:
<section1><size_in_bytes><address1><data1><address2><data2>...<addressN><da=
taN><section2>

The driver code can have parts to deal with each section in an
appropriate fashion (e.g is each data entry a word or a byte? does
this section have a key which needs to be written to a certain
register etc.)

We'd be grateful if you can offer your advice about best practices (or
suggestions about who might be a good reviewer), so that we can have a
design in place before sending out any patches.

Thanks and best regards,

-Prashant

On Tue, Sep 3, 2019 at 2:01 AM Bambi Yeh <bambi.yeh@realtek.com> wrote:
>
> Hi Prashant:
>
> We will try to implement your requests.
> Based on our experience, upstream reviewer often reject our modification =
if they have any concern.
> Do you think you can talk to them about this idea and see if they will ac=
cept it or not?
> Or if you can help on this after we submit it?
>
> Also, Hayes is now updating our current upstream driver and it goes back =
and forth for a while.
> So we will need some time to finish it and the target schedule to have yo=
ur request done is in the end of this month.
>
> Thank you very much.
>
> Best Regards,
> Bambi Yeh
>
> -----Original Message-----
> From: Hayes Wang <hayeswang@realtek.com>
> Sent: Monday, September 2, 2019 2:31 PM
> To: Amber Chen <amber.chen@realtek.com>; Prashant Malani <pmalani@chromiu=
m.org>
> Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org; Bambi Yeh=
 <bambi.yeh@realtek.com>; Ryankao <ryankao@realtek.com>; Jackc <jackc@realt=
ek.com>; Albertk <albertk@realtek.com>; marcochen@google.com; nic_swsd <nic=
_swsd@realtek.com>; Grant Grundler <grundler@chromium.org>
> Subject: RE: Proposal: r8152 firmware patching framework
>
> Prashant Malani <pmalani@chromium.org>
> > >
> > > (Adding a few more Realtek folks)
> > >
> > > Friendly ping. Any thoughts / feedback, Realtek folks (and others) ?
> > >
> > >> On Thu, Aug 29, 2019 at 11:40 AM Prashant Malani
> > <pmalani@chromium.org> wrote:
> > >>
> > >> Hi,
> > >>
> > >> The r8152 driver source code distributed by Realtek (on
> > >> www.realtek.com) contains firmware patches. This involves binary
> > >> byte-arrays being written byte/word-wise to the hardware memory
> > >> Example: grundler@chromium.org (cc-ed) has an experimental patch
> > which
> > >> includes the firmware patching code which was distributed with the
> > >> Realtek source :
> > >>
> > https://chromium-review.googlesource.com/c/chromiumos/third_party/kern
> > el
> > /+/1417953
> > >>
> > >> It would be nice to have a way to incorporate these firmware fixes
> > >> into the upstream code. Since having indecipherable byte-arrays is
> > >> not possible upstream, I propose the following:
> > >> - We use the assistance of Realtek to come up with a format which
> > >> the firmware patch files can follow (this can be documented in the
> > >> comments).
> > >>       - A real simple format could look like this:
> > >>               +
> > >>
> > <section1><size_in_bytes><address1><data1><address2><data2>...<address
> > N
> > ><dataN><section2>...
> > >>                + The driver would be able to understand how to
> > >> parse each section (e.g is each data entry a byte or a word?)
> > >>
> > >> - We use request_firmware() to load the firmware, parse it and
> > >> write the data to the relevant registers.
>
> I plan to finish the patches which I am going to submit, first. Then, I c=
ould focus on this. However, I don't think I would start this quickly. Ther=
e are many preparations and they would take me a lot of time.
>
> Best Regards,
> Hayes
>
>
