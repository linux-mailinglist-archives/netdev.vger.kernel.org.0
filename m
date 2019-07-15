Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D96069A67
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbfGOSBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:01:31 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32785 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfGOSBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 14:01:30 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so35613523iog.0
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 11:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=vgoBT1lA+XECKJCdWLUo0VZq3c1uEtUkNmSls9N868g=;
        b=GFai68Wmt9uXhTY8z1kCDVG4WInWG19ZPWDWx4lucfcigvxmEt8LrT2waPE97czQ7n
         x73U3cRzq14MUAecnPbiB+Mk4Db/Eq0z0bdkMDQkzXh6ef+FdMeE45K12Z2Y84LF3CYM
         9YwJE5kPIckPV6mgJaFNiMuOhohmYpqiRv+MOssXFez+31yTF0Vs/Voi/LEzN9E86Mf/
         Nuz7MCnltuJ0wu/i9ozGZumZsenxRiT8yFyHECtbKONAl3y6KQ/h6Qx/MAS3+F3KI8gj
         qjKR/nNhgysFewwbu1pfx+dEvSjV2uyHMlUV/Sy7guwZ/ch9uMGO8Rx8EEaoZVMdgHnH
         yE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=vgoBT1lA+XECKJCdWLUo0VZq3c1uEtUkNmSls9N868g=;
        b=hWcGYHHH5HtmnnNXXaQWdl0eLpgDB6iu3hWh8/raP5ZJRLmEJnbx4ZgfE3kCZph1xh
         jYxZiNFZCC8bfarazM+KiX6sf6iZbBACIrYSoHD8WN0CehPN8j3B/tfV1m5A7zXzb1Lw
         0pYBtS3r6Y2P1sGARO3LKyF58dM0okaMXK+BQvtrTcqPT51U7oItdvErwJEvZZoa1NhM
         okWvi8PPkIOmSXwdygc6QYrxspxD+Ut5Fyy52IOOwGS3mBQ89jJ0hP2XjKUCAfDqY1OJ
         5T/55Vepr1D/t/tSuuznywA9hhUwUMAV37vv1OJQEivkNz5TvsW4cyaCTQlvT6wtXRLd
         VhEg==
X-Gm-Message-State: APjAAAUJYewRqI+Ygq8TVvVsduyiel/nA89iJ7UcgzlSBHOdpqL3xkMf
        X6mPDlRRpDs5922B28raHOn7rqDadO0719S1ud0jdaaJ
X-Google-Smtp-Source: APXvYqzAFLQIr69nxyegDC2zD8G4zSu5e4o6Dk1HoQHbES18X0CcK/yq9u+9y1QUwX9Z6cW6PqylzDmT2e+PgwcRIgI=
X-Received: by 2002:a5d:87da:: with SMTP id q26mr16767556ios.193.1563213689910;
 Mon, 15 Jul 2019 11:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAOp4FwSB_FRhpf1H0CdkvfgeYKc53E56yMkQViW4_w_9dY0CVg@mail.gmail.com>
In-Reply-To: <CAOp4FwSB_FRhpf1H0CdkvfgeYKc53E56yMkQViW4_w_9dY0CVg@mail.gmail.com>
From:   Loganaden Velvindron <loganaden@gmail.com>
Date:   Mon, 15 Jul 2019 22:01:14 +0400
Message-ID: <CAOp4FwQszD4ocAx6hWud5uvzv5EtuTOpYqJ10XhR5gxkXSZvFQ@mail.gmail.com>
Subject: Re: Request for backport of 96125bf9985a75db00496dd2bc9249b777d2b19b
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 6:15 PM Loganaden Velvindron <loganaden@gmail.com> wrote:
>
> Hi folks,
>
> I read the guidelines for LTS/stable.
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
>
> Although this is not a bugfix, I am humbly submitting a request so
> that commit id
> -- 96125bf9985a75db00496dd2bc9249b777d2b19b Allow 0.0.0.0/8 as a valid
> address range --  is backported to all LTS kernels.
>
> My motivation for such a request is that we need this patch to be as
> widely deployed as possible and as early as possible for interop and
> hopefully move into better utilization of ipv4 addresses space. Hence
> my request for it be added to -stable.
>

Any feedback ?

> Kind regards,
> //Logan
