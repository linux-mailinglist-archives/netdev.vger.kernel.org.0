Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1010A473
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 20:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfKZT0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 14:26:43 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36042 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZT0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 14:26:43 -0500
Received: by mail-qv1-f66.google.com with SMTP id cv8so7797817qvb.3;
        Tue, 26 Nov 2019 11:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sy4O0jIBu7sikzaZw9xPpxh7Hoq+uKc8+wAUrCduRmI=;
        b=IaKSoBya95ZVS21LtECbNBD2W/zUXL1u2xXRgoUR/j/aEKqZ167dEPDfmKpZMC1AeW
         Xg//KufTNFz3cwLpcfkF48sEPUG7RvUdkZuTMwF5Wxk/rYwK9cr5m1n/xs1s47OQF1LX
         wIRTiWM4+W00fXHH25WXQ/9zQKzgE3fc1oM4VbFX+/gKDLXX+fxoEqio9n5k46feajTB
         PDDJ3l3ur19BBHo9NY5H3O+d342szEJXEKsR8TzQ+lqtUmqrmM8Kk2oOWRq6DxVUc2UM
         YyANOG3hESvbrutjKZiy6cPzqU2kqfEGT4fwvIaRX42BMaTEC2iVfOVp5ohyx7sUrC0U
         W2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sy4O0jIBu7sikzaZw9xPpxh7Hoq+uKc8+wAUrCduRmI=;
        b=oaa7FA1t9XHsxO5gB+jUr2safdBB11suM6VAbqUao8PM97DC/AO7VffP6j2Qdmmn2y
         yl96GZkp2roM8G3DKMljzrLLV3NslFaqsPoYNXIvTU/B6Zhl9J14UZMk3+5MuKecV4Cr
         OANR9wMq0O+NVgbEeWUkGD6QoANbLtanbierjDr6bL3cED8JUG48r5kohqVHPX5nbGzO
         uOndUsyo/fk4QRjuwXDxoOb5f/44vxWEqFqclq/MJ3MAYmo3mYvq3tGyayZaBTVg/EIO
         BqPargLuLeKUsBfriObXqYbOif5jKoFEC1Etgd1xy+EMNaI5LwxoY0Kfmwr3y7Joojf0
         Z+Zw==
X-Gm-Message-State: APjAAAW5sq3Qcz2OWwtFyydC+d15c7T3SpCCxqTtSsny/FqaTJbghY6G
        PHv8pZ/Pgf3xgY6NaQs3LQe+Ym9U4XbLIdUkT5o=
X-Google-Smtp-Source: APXvYqygvCYs5HhYtbjMCao7/k5cvnH8pQnn8YY1qYrJ7tGzS5X0OYUmkkOGCXnR18LGDROl0WI//k/FJmi5NDK3YQc=
X-Received: by 2002:a05:6214:707:: with SMTP id b7mr297023qvz.97.1574796402191;
 Tue, 26 Nov 2019 11:26:42 -0800 (PST)
MIME-Version: 1.0
References: <mhng-0a2f9574-9b23-4f26-ae76-18ed7f2c8533@palmer-si-x1c4>
 <87d0yoizv9.fsf@xps13.shealevy.com> <87zi19gjof.fsf@xps13.shealevy.com>
 <CAJ+HfNhoJnGon-L9OwSfrMbmUt1ZPBB_=A8ZFrg1CgEq3ua-Sg@mail.gmail.com>
 <87o8wyojlq.fsf@xps13.shealevy.com> <CAJ+HfNiq9LWA1Zmf_F9j23__K2_NqcfQqRA5evGVP5wGzi881w@mail.gmail.com>
In-Reply-To: <CAJ+HfNiq9LWA1Zmf_F9j23__K2_NqcfQqRA5evGVP5wGzi881w@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 26 Nov 2019 20:26:30 +0100
Message-ID: <CAJ+HfNgsrFv0zgLy-CORXs-gOtiW2a3Sf=RQ6yDP5akDT+_-kg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Load modules within relative jump range of the
 kernel text.
To:     Shea Levy <shea@shealevy.com>
Cc:     linux-riscv@lists.infradead.org, albert@sifive.com,
        LKML <linux-kernel@vger.kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 at 17:43, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> On Tue, 26 Nov 2019 at 14:25, Shea Levy <shea@shealevy.com> wrote:
> >
> > Hi Bj=C3=B6rn,
> >
> > Unfortunately I'm not sure what more is needed to get this in, and I'm
> > in the middle of a move and won't have easy access to my RISC-V setup
> > for testing. I don't think you can count on me for this one.
> >
>
> Thanks for getting back quickly! No worries, I'll pick it up!
>

I just pulled in your patch in my series [1] (it's not done for
submission yet, but passes all tests); Just to get the idea. Reading
up on the thread, it looks like we can share some more between the
archs (mips).


Thanks,
Bj=C3=B6rn

[1] https://github.com/bjoto/linux/tree/rv64-bpf-jit-bcc
>
> Cheers,
> Bj=C3=B6rn
