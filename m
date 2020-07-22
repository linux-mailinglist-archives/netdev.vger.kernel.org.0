Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A776F2299B7
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbgGVOFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGVOFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:05:07 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6A9C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 07:05:07 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q3so1365927ilt.8
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 07:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OAeGgQu4jioOJl48SPH+c4XNeQGt2jSuKJzTYsNn85I=;
        b=cTiFA8AKTT6oJ8XCuNJcKJRdPWXJmxQCPZLldv0hxGbi8P2pSP4umP9H1RRZuVJmlE
         hXL6AetHt8rBvp73UGTIVLE8ESJlpf28f0rrpNukNSFSezvPqxFXPJ3JjUkXCFQKfkaL
         Rq4njcFD0TsUPzDF1jYqtfa7q6KFvER1g7YtkOhSOpUywoRneTBMIfRGrtUfILQGd12x
         0JWav9Vr3BxlomZqggCBB3Zf+hZpgkzByek2/9ikIAkaSCmz10IlgUc6NxBVVsb1nd30
         OQ2RcbhI/wKiffomIzls3pdjwNHpNx+XHo9itr0PHrVQbO4Bon7u3H9xk9RwzqyCYOG8
         lVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OAeGgQu4jioOJl48SPH+c4XNeQGt2jSuKJzTYsNn85I=;
        b=EynK7kLorVY0/0E5MaD4HbGns/YirHa5Vt+FEYC+6/1tVKJrA/9sPhCr09Vp5GAPtl
         i+hvGI+KbBzZVFLqRMGVtpMElPGPYbuDpcf8VgiO58VEUaHR4TKF6niewobnekZYMPQD
         m5sN2jlr4FczGs+0EMdBM5KrMfxp+JXJTXVk3+C58Cw1sZDMpe6gZTRS9fBd0KIR3EGX
         jsOnLYrCX06SkvAQbGOAsoDOK4SmZSr7BrrAFPInS3RXKrKX94RPgJN2kX4XPEKTWIjl
         2fryi7OB6cQrCJdEua2DeGbmp5yj9OR/Gy8SI++MRff697f2WmvLtiTnAfRqD2cgnG7H
         t8jQ==
X-Gm-Message-State: AOAM532KIv3ikt+KD3w42zXy6E5blQpOS9V3NZDTCBpN3wqUBvWdtnSf
        BMsC/nuNkGNfhWPfI+JscYtUs/TJC7+90ZTHQQM=
X-Google-Smtp-Source: ABdhPJz0OVSnke8Whw7GRM8dyFD4N0ioTnzjoFjZRW/NJgbgearJlOfgyuGpyEllBkc9VpS4kWwWUe4gM0jyO/fAMzg=
X-Received: by 2002:a92:bb84:: with SMTP id x4mr21536ilk.177.1595426706857;
 Wed, 22 Jul 2020 07:05:06 -0700 (PDT)
MIME-Version: 1.0
References: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com> <20200721.161728.1020067920131361017.davem@davemloft.net>
In-Reply-To: <20200721.161728.1020067920131361017.davem@davemloft.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 22 Jul 2020 19:34:55 +0530
Message-ID: <CALHRZuofbFnE8E-wpdosvKP6m3Ygp=jjcHz9QUn=R3gUbyNmsg@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sgoutham@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Jul 22, 2020 at 4:47 AM David Miller <davem@davemloft.net> wrote:
>
> From: sundeep.lkml@gmail.com
> Date: Tue, 21 Jul 2020 22:44:05 +0530
>
> > Subbaraya Sundeep (3):
> >   octeontx2-pf: Fix reset_task bugs
> >   octeontx2-pf: cancel reset_task work
> >   octeontx2-pf: Unregister netdev at driver remove
>
> I think you should shut down all the interrupts and other state
> before unregistering the vf network device.

Okay will change it and send v2.

Thanks,
Sundeep
