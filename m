Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022D115D560
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgBNKTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:19:02 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:55384 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgBNKTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:19:02 -0500
Received: by mail-wm1-f52.google.com with SMTP id q9so9357861wmj.5
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHfNm2zDxCLI/bNXuYBWMkgw+GGDiFOI1xgqjO8O23E=;
        b=XM6rE5dYpAbU0RpSMVVBGaVlE61QObJqZz8UdcUKiINgxdMZaBf1qyeALbXW478Gt/
         yMrLzu9uaMHJMFQ3Lf2i+2i7orvT7Uty+/XzC71k9yIqkDkLMVXrWU4cw4bjJAcHUgyE
         ncothtFAKVwSEQSE0uTyoWWfbPdb5j8RG60wKMhmNUIyRUmIyQrRhV0t9Fl3+K66NtRE
         LkQ8EwuUmfOC3WIsUNbhIqUWhsdcOtUQlwVoSr+b4/WQnMtWmdiLMu9iy4OnPDuTfcfB
         4gRKGG6zky4WbY2HWC+zY/Rwr66kfEPshCE8ayRYkVaYN7uPB5Y3KEwlJNQ6ILIA51K2
         tGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHfNm2zDxCLI/bNXuYBWMkgw+GGDiFOI1xgqjO8O23E=;
        b=FA80db4IYfNxX2Z1O9ZVQ9hSi/f/E44WWarDYRMZ67mCznRIBOiX/lu6ELbArBF2zv
         5Ra7TWAESlD6cKIhoR32HPu8BYxCuzkpsmHMtZqspZ3gCl6x7NPd0KGQ946sKhTgQszE
         rn2gPpgHBk6p1rNkrrEm95/Fu9kuCBn2GYoEucGbd4puSKUXYstU4fvZ5RZGHzWyL3z7
         vrJTPD5hw8Kz3SoCqPSm4BBqrX6/b627QyfP7LtXUhhp9S2RlhxAfbF/1HYOm7+NkCFc
         fVn3XTN4xmR6kyQixTljpTz0Qc4bBIDrnGL5VBel1gHGnMhCqlvgXzBu4fXcDFzqMGl5
         Wrfg==
X-Gm-Message-State: APjAAAU1nOOjYiIOlgEB134Xpag450AWkISo9zVXGQMOj64shR4IUvft
        PyliEFnQmQoH7LVFeAIfLkM5LQke/L1ailNx6V8=
X-Google-Smtp-Source: APXvYqy78gWjp1cos4e7ajcAkiSrnGHmucT+zv9xiPkYzL56JCcr/hU7bJsOCmqNOfbG1/7rDUMnUpyrkClr65NGhBc=
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr3908782wma.87.1581675540748;
 Fri, 14 Feb 2020 02:19:00 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581594682.git.lucien.xin@gmail.com> <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
 <20200213082635.0fde6ab8@hermes.lan>
In-Reply-To: <20200213082635.0fde6ab8@hermes.lan>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 14 Feb 2020 18:19:44 +0800
Message-ID: <CADvbK_dbq8MFf7tS9gi7AZDYfd+77ZNSO2T55ZnorG0sjEioPA@mail.gmail.com>
Subject: Re: [PATCHv2 iproute2-next 1/7] iproute_lwtunnel: add options support
 for geneve metadata
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 12:26 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu, 13 Feb 2020 19:56:59 +0800
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > +     while (rem) {
> > +             parse_rtattr(tb, LWTUNNEL_IP_OPT_GENEVE_MAX, i, rem);
> > +             class = rta_getattr_be16(tb[LWTUNNEL_IP_OPT_GENEVE_CLASS]);
> > +             type = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_GENEVE_TYPE]);
> > +             data_len = RTA_PAYLOAD(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]);
> > +             hexstring_n2a(RTA_DATA(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]),
> > +                           data_len, data, sizeof(data));
> > +             offset += data_len + 20;
> > +             rem -= data_len + 20;
> > +             i = RTA_DATA(attr) + offset;
> > +             slen += sprintf(opt + slen, "%04x:%02x:%s", class, type, data);
> > +             if (rem)
> > +
>
> Please implement proper JSON array for these. Not just bunch of strings.
will post v3, thanks
