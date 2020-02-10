Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DA3156F5C
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 07:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBJGIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 01:08:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36714 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgBJGIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 01:08:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so5980888wru.3
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 22:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RqOWgLC4rAK1/3FVQvcVawK7eWHcH+JYl4Mu9lHDxM=;
        b=dTjVKSiCeY8J4eR5a2a0lWH0xevh4DMLFAAtBEr+P0V4QL61W66qBXMVSV7q4MtUFy
         7ny+GYDGdlI//0U5KiDaSXpxJpLN6/fIyIACMs2ISSgNAejrG0ux3cpwc3v77l/rKUnL
         QWRPX7GjDBhaVH3d7TTpYZP2S7HhMt5xoq2QYTJsy+JVgLggse7I/c/RSFWWNrfwlh+O
         fJKK75tWmW6oReJye5lOj6uHbw/7FbomHBe5XspQmm7oapSioB7QGZrwO7JRiSh3jY/o
         mCi057qcgr0eWYa+pYDAa98NqNtx1wK6z6Mu6Ab6UGgJCXswjYRFlNOrVh1pCoWefr4f
         E9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6RqOWgLC4rAK1/3FVQvcVawK7eWHcH+JYl4Mu9lHDxM=;
        b=RJ2iXIavOaNCf022QvxMtWt3gdieV75LQrJZqAEt6+SLdzuCtSEj1Ng91q8xgD6FWA
         2Hy1UFo+mExMvXqDO8b+xu3tw0mjL8DYmsrfc1reysp1rnbLTy8AVrdXthW8dhPqSKjG
         xu0urBSV3enO3RZbp0N176CTAjmA1rIqcFUocd7FRlbZnN79w6rIgJMBhh1O1TgP3SVI
         2pA554fTOC6yiy3udW1EXVCuhu1sHrJ6sVuw2tNHOcUso3m20Dg3qb8qiXOd7mrp8EXW
         xEk/QCMf1sDW2dfqfn1bZlWbcgoIH+YoVyP/Dk3h1OuhoWzMiu6661NzCowxrQQIXU2o
         VxRA==
X-Gm-Message-State: APjAAAUUTvu3tJ2xUU51r5e1EUoYs7xW5/xBnJjbeefDE9cqxjw09gB6
        rijM7wJQ94UsHZBy8ppR4kOsN2dH/IYASKo9QM0=
X-Google-Smtp-Source: APXvYqzrZLLqVbgcpi8Qts1yByZYE53mMvipRIb4C0tXFIyAb7VT9jseE5j2vjic8pC3f2gd30U5eeWIokQsMkkxgNg=
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr14991321wrs.395.1581314927548;
 Sun, 09 Feb 2020 22:08:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1580708369.git.lucien.xin@gmail.com> <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
 <85a6a30aac8eeab7c408fdadfa5419dc1596cf5d.1580708369.git.lucien.xin@gmail.com>
 <20200205042239.322cc844@shemminger-XPS-13-9360>
In-Reply-To: <20200205042239.322cc844@shemminger-XPS-13-9360>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 10 Feb 2020 14:09:17 +0800
Message-ID: <CADvbK_eVkpGnJj5mQ19bXp+kzx0m9VSDfeMr09Fyp5jDk8FmAQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 2/7] iproute_lwtunnel: add options support
 for vxlan metadata
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 5, 2020 at 8:22 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon,  3 Feb 2020 13:39:53 +0800
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > +static void lwtunnel_print_vxlan_opts(struct rtattr *attr, char *opt)
> > +{
> > +     struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
> > +     __u32 gbp;
> > +
> > +     parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, RTA_DATA(attr),
> > +                  RTA_PAYLOAD(attr));
> > +     gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
> > +     sprintf(opt, "%x", gbp);
> > +     print_string(PRINT_FP, "enc_opt", "\n  vxlan_opts %s ", opt);
>
> You need to handle single line mode and JSON.
>
> Proper way is something like:
>
>         print_nl();
>         print_0xhex(PRINT_ANY, "enc_opt", "  vxlan_opts %#x", gpb);
>
yeah, right, didn't notice that, thanks.

> Also, why the hex format, this is a an opaque user interface?
>

       0                   1                   2                   3
       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |G|R|R|R|I|R|R|R|R|D|R|R|A|R|R|R|        Group Policy ID        |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

This is the gbp field in vxlan header, defined in:

  https://tools.ietf.org/html/draft-smith-vxlan-group-policy-05

I think 'hex' makes it clearer than decimal to see which bit is set
for users, no?
