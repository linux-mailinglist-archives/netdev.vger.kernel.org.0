Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F747149C31
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 19:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAZSAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 13:00:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54945 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZSAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 13:00:17 -0500
Received: by mail-wm1-f67.google.com with SMTP id g1so4353422wmh.4
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 10:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehfFqDA5+vGaGA7FlJAJJaHq4pvlxoPRFQpgnrBb/oE=;
        b=GtcqgTUjke7avoVrsxXsMdFFWFlXZe6dLJF7swiD9YucHH7PUc/B80EIJn2MnHDhrc
         KxifYJeaWxoX3PD9eR1FTvSOJlhbbnghXeeH4mYJoMBbwPyhCMRYc3Zva+D7drv24gJ8
         A6KPoyeGmDEHICef9c6oDieBMypHRkN4GoTBf3Bp7Ultp1xqgJw/Cl6mLY3+krVw65cG
         D+PgS1uWDh4sXLG1PMDJA1jj6OmsHLyej5qRZWy8o/+9B7zvAeq38sMcYbW+3cK7fT6g
         bW+NC888TuZRvmn/8AnwOmbkhbdM91RELPXcBgRMn7cv2bDOlv2jmdKeUrwQqphajRzy
         0w0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehfFqDA5+vGaGA7FlJAJJaHq4pvlxoPRFQpgnrBb/oE=;
        b=d2XQrTJJEseunGydK0SlyPFLwx1+I+v+5q6JrpZlyENz/nIh+pBaeZ0V3FVw9q5rtl
         R1ddE2enh9f4is665bTOqUFZ0p8AUAS80JhHZHAr9kXncYHEsmxhHKZ6qQbCCDw8Wotn
         YCG9S5tqeeg0ddVphNjFx06Wr/3z0Iv4pcPdfdHgB7i/2o/L4keQt9b2cJFLxqJ9Er2e
         S1uipy5GwoKKs5YoqAxS0EivxHSI9jeSb+YwGby4+r6RvUKTdzOkFEteyTAJJTF/K3B4
         xFFeXVNkvK6rSdzpcCeuqpCLmDe1FMCGREj/cMKy8co+RacLKJMau9SKhrqp0efw1kT6
         N6PA==
X-Gm-Message-State: APjAAAUgUcYHLsBxQLR3xaoG+HRjxgREWeuauyIRfodC2gRvAnVOOw5P
        CMr7wErGM7RQ1CMCR2zhGIv47iJiSSLkg0kV1D0=
X-Google-Smtp-Source: APXvYqz3kmzih1cSUzIf3EfeAbCZXAl1fMkKoQqLDlj36wHlDyOEQ371kt6fiWG6GWp0d+FeS0eaKclGTi3cOWVtQv4=
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr9506557wma.89.1580061615354;
 Sun, 26 Jan 2020 10:00:15 -0800 (PST)
MIME-Version: 1.0
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com> <20200126.120059.1968749784775179465.davem@davemloft.net>
In-Reply-To: <20200126.120059.1968749784775179465.davem@davemloft.net>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sun, 26 Jan 2020 23:30:04 +0530
Message-ID: <CA+sq2CcQk47hZ9tue1-yjGmUFF7RONfG47c2T77SRU5t8ovpVg@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] octeontx2-pf: Initialize and config queues
To:     David Miller <davem@davemloft.net>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Kubecek <mkubecek@suse.cz>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 4:31 PM David Miller <davem@davemloft.net> wrote:
>
> From: sunil.kovvuri@gmail.com
> Date: Fri, 24 Jan 2020 23:15:42 +0530
>
> > @@ -184,6 +192,72 @@ static inline void otx2_mbox_unlock(struct mbox *mbox)
> >       mutex_unlock(&mbox->lock);
> >  }
> >
> > +/* With the absence of API for 128-bit IO memory access for arm64,
> > + * implement required operations at place.
> > + */
> > +#if defined(CONFIG_ARM64)
> > +static inline void otx2_write128(u64 lo, u64 hi, void __iomem *addr)
> > +{
> > +     __asm__ volatile("stp %x[x0], %x[x1], [%x[p1],#0]!"
> > +                      ::[x0]"r"(lo), [x1]"r"(hi), [p1]"r"(addr));
> > +}
> > +
> > +static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
> > +{
> > +     u64 result;
> > +
> > +     __asm__ volatile(".cpu   generic+lse\n"
> > +                      "ldadd %x[i], %x[r], [%[b]]"
> > +                      : [r]"=r"(result), "+m"(*ptr)
> > +                      : [i]"r"(incr), [b]"r"(ptr)
> > +                      : "memory");
> > +     return result;
> > +}
> > +
> > +#else
> > +#define otx2_write128(lo, hi, addr)
> > +#define otx2_atomic64_add(incr, ptr)         ({ *ptr = incr; })
> > +#endif
>
> So what exactly is going on here?  Are these true 128-bit writes
> and atomic operations?  Why is it named atomic64 then?  Why can't
> the normal atomic64 kernel interfaces be used?

otx2_write128() is used to free receive buffer pointers into buffer pool.
It's a register write, which works like,
"A 128-bit write (STP) to NPA_LF_AURA_OP_FREE0 and
NPA_LF_AURA_OP_FREE1 frees a pointer into a given pool. All other
accesses to these registers (e.g. reads and 64-bit writes) are RAZ/WI."

Wrt otx2_atomic64_add(), registers for reading IRQ status, queue stats etc
works only with 64-bit atomic load-and-add instructions. The nornal
atomic64 kernel
interface for ARM64 which supports 'ldadd' instruction needs
CONFIG_ARM64_LSE_ATOMICS
to be enabled. LSE (Large system extensions) is a CPU feature which is supported
by silicons which implement ARMv8.1 and later version of instruction set.

To support kernel with and without LSE_ATOMICS config enabled, here we are
passing "cpu   generic+lse" to the compiler. This is also done to avoid making
ARM64 and ARM64_LSE_ATOMICS hard dependency for driver compilation.

>
> Finally why is the #else case doing an assignment to *ptr rather
> than an increment like "*ptr += incr;"?

This device is a on-chip network controller which is a ARM64 based.
Previously when i submitted driver with ARM64 dependency i was advised
to allow this driver to be built for other architectures as well for
static analysis
reports etc.
https://www.spinics.net/lists/linux-soc/msg05847.html

Hence added a dummy 'otx2_atomic64_add' just for compilation purposes.
Please ignore the definition.

Thanks,
Sunil.
