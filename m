Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3EC10206
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 23:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfD3Vrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 17:47:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46481 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfD3Vro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 17:47:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id j11so7703589pff.13;
        Tue, 30 Apr 2019 14:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQ0WAt2+S5P4l4hZmXG44smnn0ln0il2ppIEd919he0=;
        b=cFDHUfLc6/URlKC4986lLy3VOh0DkMANDHhCM013EXoI3xF28VWgE85H8IL/gQLGYt
         89BIOeOGLsFp47LS9BQX3CPOQuHSETcgZpBnZNT1xDFdjCfTP96v2v56+GEOtS9wy3GR
         K41p5QIntznSgA+KYcfB47vHfKb60O+WsF28eQjS/1yapSi8K8SlRMnrjvcyayn0xSub
         gzL6BgKVMi+Sgl+pu0fBHfeearI8/U97rZgnEOivc6Mw68ZqfgjOFLhEBPhNajnENeat
         AHNaqnTe0Oewt8piQKnoMiB9CYTK4ZPVPcvxIwvU+GHzhZmG7OJQPf/T0cnp4iXlodcT
         3I2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQ0WAt2+S5P4l4hZmXG44smnn0ln0il2ppIEd919he0=;
        b=E2t0PFTXLA50spCoRGIe1JkyY5URjXK+XoGUFqfWRnHA2iCU7I9FCgeZaNXAQkpRN2
         MK7nL8DBpKaS7fuYB5T99o/93cakpXerUJ0ONCGApR1I6aeRJPtTjkaXQUtwfr9oabUR
         f4AeEEmdqx+sFksJz22h4+6MdlZl/H7cNWgGkNL2MuJYF+tynnXw5WwBhPRzkxH9qdBh
         fsRtp+GqXFMCk28pDLWXo/HIGDTh4QpKIfqy72vWiiIhA5uRLm8kwBDbYaXOkE9O+lCK
         Gp5Gx1X130dFPqCwUW3Rjh6Vd94zD/iLT7KraJhwYdWChAgxBbSy8fX4HYbM4YjPcbog
         JWSA==
X-Gm-Message-State: APjAAAXBAdXcFFQTtR++sW1hV3aISbUzdpaqjq8NA1UoGaKBuV6QeuQW
        kzXX/IpbDUBCZi1GcxrPGW9u9jCrXca8j4FMjG0=
X-Google-Smtp-Source: APXvYqyC9q+19PZsrK2SWaciq9RKvQNg7g5Maf6WSkMcP5SCZbA5NzHt4kmlAo8A0ymH//DqiyMiieZzKrruZE4NQOY=
X-Received: by 2002:a63:1a42:: with SMTP id a2mr27105398pgm.358.1556660864207;
 Tue, 30 Apr 2019 14:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190427130739.44614-1-ldir@darbyshire-bryant.me.uk>
In-Reply-To: <20190427130739.44614-1-ldir@darbyshire-bryant.me.uk>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Apr 2019 14:47:32 -0700
Message-ID: <CAM_iQpXnXyfLZ2+gjDufbdMrZLgtf9uKbzbUf50Xm-2Go7maVw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sched: Introduce act_ctinfo action
To:     "Kevin 'ldir' Darbyshire-Bryant" <ldir@darbyshire-bryant.me.uk>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 27, 2019 at 6:08 AM Kevin 'ldir' Darbyshire-Bryant
<ldir@darbyshire-bryant.me.uk> wrote:
>
> ctinfo is a new tc filter action module.  It is designed to restore DSCPs
> stored in conntrack marks into the ipv4/v6 diffserv field.

I think we can retrieve any information from conntrack with such
a general name, including skb mark. So, as you already pick the
name ctinfo, please make it general rather than just DSCP.
You can add skb mark into your ctinfo too so that act_connmark
can be just replaced.

Your patch looks fine from a quick galance, please make sure
you run checkpatch.pl to keep your coding style aligned to Linux
kernel's, at least I don't think we accept C++ style comments.

Thanks.
