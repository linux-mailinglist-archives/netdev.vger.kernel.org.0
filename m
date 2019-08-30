Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D301A3ECB
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfH3UJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:09:42 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33582 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfH3UJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:09:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id go14so3835879plb.0;
        Fri, 30 Aug 2019 13:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iUyLbFrRRfn8yBr4b5/WswzF/k/TMDXNh3dYn/pQ9TI=;
        b=VUYWYHJQ7vIBHao0CvJlTLxuG3skA829TGT4qURdUfeQ5SKl/E91DiysBDzaoTs2r3
         s10spdHjlEEqEctwWePmoFBNwvr4doLUu0TROUbIrpctRauR4rMk8XW4Tzl9Cb4rNFpu
         zTijlEjKRFUzGYRM4wwQl8bHMgJLT4M1Dbo9x+66hEf8LMTrBiY9UB4lUpR/ZTxHC2Tg
         9Y+9CufCjhWhzPNGylcK/HEP8yCIa5KKNOon4riEuEZSshcHLMqeVSn2ZRtIAN6Yy1oE
         Uk3h8zXzwDHoZfoLDhF1/tZ0ZBHHAo4jwa66cmyJccnmsUaUOf00a3VaVgpvWCEIDwvp
         iVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iUyLbFrRRfn8yBr4b5/WswzF/k/TMDXNh3dYn/pQ9TI=;
        b=fgQrIkMoM2Fk6OSJjbLxn1wbFECr/2Bl/0AZRdmY+OEVQ4EiuTk9oRKoeiX5oxVFTW
         ZLeY+bMqXYox1vWaUjUDNWstqNGSf8y+hrDsqq7uyVybuEZ0Btu9reWtJ4cIiu7zGBCk
         YlnzpgpZA7fzQWJaNJ6xE0L61tlFQTHuC2jpgL/CsOfWsUF6/P9yfbo1tyYTX7dh94u0
         g+XQfZHoGkwW34qWL89Vti2rstpBgR2GFkdZbj/XPH2oODDpAf05WKLNB4nZzkd2fHsC
         RC90LeCOeVpbBSzmffBmYAs6ZoOw67uF63zlcovWKn656e11FqzVS+RUduyqaFqc2UBK
         rkyw==
X-Gm-Message-State: APjAAAXpUrY4QK0IUSHRYz5kNQ7ohrbRghkrpvIb8nWpmM1I08MbYOnM
        nBbAVfnVctLjjodFtTWLcJiReVi1gwvmViYZSjU=
X-Google-Smtp-Source: APXvYqxoPxx7Ty+7NNRV2ZwlZygvtNhIEFwB7150clgIgwejwOIGPA+6QbNCp5AT0pl3Fj8AIu6cs0g0yOB4qqWMy08=
X-Received: by 2002:a17:902:26b:: with SMTP id 98mr17601048plc.61.1567195781332;
 Fri, 30 Aug 2019 13:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <1567191974-11578-1-git-send-email-zdai@linux.vnet.ibm.com>
 <CAM_iQpVMYQUdQN5L+ntXZTffZkW4q659bvXoZ8+Ar+zeud7Y4Q@mail.gmail.com> <1567195432.20025.18.camel@oc5348122405>
In-Reply-To: <1567195432.20025.18.camel@oc5348122405>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 30 Aug 2019 13:09:29 -0700
Message-ID: <CAM_iQpX-pBBQ=AEzogmZowWm6=XJWnuMeOOxRWKYT0KTD3PnLw@mail.gmail.com>
Subject: Re: [v2] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
To:     "David Z. Dai" <zdai@linux.vnet.ibm.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zdai@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 1:03 PM David Z. Dai <zdai@linux.vnet.ibm.com> wrote:
>
> On Fri, 2019-08-30 at 12:11 -0700, Cong Wang wrote:
> > On Fri, Aug 30, 2019 at 12:06 PM David Dai <zdai@linux.vnet.ibm.com> wrote:
> > > -       if (p->peak_present)
> > > +               if ((police->params->rate.rate_bytes_ps >= (1ULL << 32)) &&
> > > +                   nla_put_u64_64bit(skb, TCA_POLICE_RATE64,
> > > +                                     police->params->rate.rate_bytes_ps,
> > > +                                     __TCA_POLICE_MAX))
> >
> > I think the last parameter should be TCA_POLICE_PAD.
> Thanks for reviewing it!
> I have the impression that last parameter num value should be larger
> than the attribute num value in 2nd parameter (TC_POLICE_RATE64 in this

Why do you have this impression?

> case). This is the reason I changed the last parameter value to
> __TCA_POLICE_MAX after I moved the new attributes after TC_POLICE_PAD in
> pkt_cls.h header.

The prototype clearly shows it must be a padding attribute:

static inline int nla_put_u64_64bit(struct sk_buff *skb, int attrtype,
                                    u64 value, int padattr)
