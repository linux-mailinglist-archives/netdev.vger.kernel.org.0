Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E21FBBAD
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgFPQ2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgFPQ2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:28:07 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BE5C061573;
        Tue, 16 Jun 2020 09:28:06 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g2so4517442lfb.0;
        Tue, 16 Jun 2020 09:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fz7QOfXyJipF4uPMWTiiiIMpfVcAu9truFSnZP6SMHA=;
        b=O13eBNxCDggJZ36IU7Z5sO+UB7U2zGxNvOjWGmlpFdTP3vv2OOzgh3602YgQe9YuG9
         zTulN+glqa8njOEtBmMzO5odsDFqh9cuoWMWxyONan4m/9mWMF9GluzxwEPo3pk9EQ+U
         CdvmjjvzHljrIjk5JA47NztKx2OvSNRSCq8Xutc948dlw/moGy1YsC27mbKmzaqiK9wx
         VBBoEiMnZ+SZK4Ipbv+j3uyo/HSb5XBSD7ChgwY7dqrl6o0LK0O1EYHz2z0KNczBuS4V
         VrbXV2PUs0EYvFHBjkrG+9Gfn9LS8P5Tb/Mc6KOMRIs2YGOKuzDgsblQyA/p5NUhwEW1
         RCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fz7QOfXyJipF4uPMWTiiiIMpfVcAu9truFSnZP6SMHA=;
        b=H84s65mhofmmFkb2sj9GAg3oM0UeylREAmJ9NEQuZun6YIFJyEu/pR8vZzVkalqVhG
         wuSUrU05XUKPCZKqKAZfwY1WxixkqhC6+Ob/hhyayEXe2jGKIboh5xi0ec6Qjk2Nb+kz
         q30v4SDHiZk91QYJHlCqemyyqpHA5GiePpkDqGkY/cE0uLkQK3Z7cQYKNUA/vzMwppGb
         m8fPV9e/wjurf3IXMJWCyCjKoildnNkrTty6UzoMbjySmSOduLU5Q7byDQJ2ir/1QbFP
         8/QhNb5Aku6Ui0T1MJpx0PA3CyymahnT8jlxu1EZdd4PlZYT8Q2vQj+JD0BAr/qhXz8I
         MZAw==
X-Gm-Message-State: AOAM5316nZTGSIQPH5FSmxU3/Zinr4wKxYWfpWoR+vOEZHOIjqrIADOp
        GqQi2mLlh89vpr+SUXifOB+5J0QXHBLriGoHZIM=
X-Google-Smtp-Source: ABdhPJwysUnpOO/sfxEQHGqcErwxCDyiLkhinlHUlxDfZcgMD8/A+HanYqVR8QKPaDnJOiGMV1AXPMXAC2aGh9FA5/4=
X-Received: by 2002:ac2:494f:: with SMTP id o15mr1611759lfi.140.1592324885439;
 Tue, 16 Jun 2020 09:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200615154114.13184-1-mayflowerera@gmail.com>
 <20200615.182343.221546986577273426.davem@davemloft.net> <CAMdQvKvJ7MXihELmPW2LC3PAgXMK2OG6bJjPNJkCgE6eZftDVw@mail.gmail.com>
In-Reply-To: <CAMdQvKvJ7MXihELmPW2LC3PAgXMK2OG6bJjPNJkCgE6eZftDVw@mail.gmail.com>
From:   Era Mayflower <mayflowerera@gmail.com>
Date:   Wed, 17 Jun 2020 01:32:02 +0900
Message-ID: <CAMdQvKtrzFtg9PwZhyMQ96S48ZLG5gAu3gk8m=k+tFVMHeshXQ@mail.gmail.com>
Subject: Re: [PATCH] macsec: Support 32bit PN netlink attribute for XPN links
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:02 AM Era Mayflower <mayflowerera@gmail.com> wrote:
>
> On Tue, Jun 16, 2020 at 1:23 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: Era Mayflower <mayflowerera@gmail.com>
> > Date: Tue, 16 Jun 2020 00:41:14 +0900
> >
> > > +     if (tb_sa[MACSEC_SA_ATTR_PN]) {
> >
> > validate_add_rxsa() requires that MACSET_SA_ATTR_PN be non-NULL, so
> > you don't need to add this check here.
> >
>
> validate_add_rxsa() did not originally contain that requirement.
> It does exist in validate_add_txsa(), which means that providing a PN
> is necessary only when creating TXSA.
> When creating an RXSA without providing a PN it will be set to 1
> (init_rx_sa+15).
> This is the original behavior which of course can be changed.
>
> - Era.

Sorry for the time issues, just noticed I sent the previous mail with
future time.
Fixed it permanently on my computer.
