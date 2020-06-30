Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD221005A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgF3XMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgF3XMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:12:43 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BD0C061755;
        Tue, 30 Jun 2020 16:12:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a1so22408510ejg.12;
        Tue, 30 Jun 2020 16:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EEziaIM/P7+22lxNofy08U1YgTxMBEFHBjSY3HZLox8=;
        b=U13XQ12RtySqRFFcdAgVVayD93hsV5QjurKvCaIPjTMREpQsx3IQt4i7+vB+/1hohA
         h9cZs7pdDcaPptjlXXYOP2CGaXtSG/jt1rRJuPGmOHgfLCwReY4AtBtqTzNOtDAnWK3V
         VGdXHZnqK0vO7NJp0JDlnNCAYvvxI7tLA+EnX3JsUjXfPnroG7VFEMlYkKfdox2bnLmI
         tpBjAPEq/U15BCusKwJcc0rsLqUxKIwbOgk9VI6jpPJBSi7Er8NBQt0fNHT3ectSqID1
         LYfEyFhhLHwEkCrL2Zi3evslp+ZoE3PDAhJjPukqpHJnItQ1iYrKm80RXqhFAKgZQ34c
         tmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEziaIM/P7+22lxNofy08U1YgTxMBEFHBjSY3HZLox8=;
        b=n5qYMKJoqNm1DnpvxdUkyzhNSqL3X+7QVregikh7sNNdD6Iwjuxq/5xVTQcgNOZINg
         FKQWX3OIqjgiyHiQ0mDvc/kZHgzTA96fSGw46LtVuCFNR2p+FAx3PaGUG7vvON/ZVrjG
         Su/ofEIpUxJbDMQSX0g/C50FRLEYBZ7o7EELJihAbNgSS/TSm1IzxKrzOPUmjPEDok9l
         /zGToo82/s7XPLQPrZRJMIROE81Kl+f2emo8RHNhm6CWIVq1efGcuealNPaFidaL9EYx
         DsqqcnJ6YwaCdQV6q7HTf2IxqNNuFNq8tG2hWDYMv2vbZzqzuxxRaXUAm/Ku7Ye1R6or
         BXfA==
X-Gm-Message-State: AOAM533QF5XKgMk+ko7ThNZSdPfRhChz89Ug26cOiZ9ThlXcXE3K9WF+
        oeo901tG3eY7nV4keT3b2oNdcHKlPfqYdTGQkqEJZF1t
X-Google-Smtp-Source: ABdhPJyfoxgKsOwNFi4UiM4o394ThnPEmsLIf5RI7arVjkMCEBGVByy0HnH8XipAyieXjvVmACz92Ad9o0yYQwdYmMM=
X-Received: by 2002:a17:906:fcab:: with SMTP id qw11mr20041483ejb.456.1593558762319;
 Tue, 30 Jun 2020 16:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200515163956.GA2158595@mit.edu>
In-Reply-To: <20200515163956.GA2158595@mit.edu>
From:   Dave Airlie <airlied@gmail.com>
Date:   Wed, 1 Jul 2020 09:12:31 +1000
Message-ID: <CAPM=9tz3heu1-xTyYDA4huszt3LLgF87pKcifc+OCFqJv-KWdA@mail.gmail.com>
Subject: Re: Maintainers / Kernel Summit 2020 planning kick-off
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     LKML <linux-kernel@vger.kernel.org>, inux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 May 2020 at 02:41, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> [ Feel free to forward this to other Linux kernel mailing lists as
>   appropriate -- Ted ]
>
> This year, the Maintainers and Kernel Summit will NOT be held in
> Halifax, August 25 -- 28th, as a result of the COVID-19 pandemic.
> Instead, we will be pursuing a virtual conference format for both the
> Maintainers and Kernel Summit, around the last week of August.
>
> As in previous years, the Maintainers Summit is invite-only, where the
> primary focus will be process issues around Linux Kernel Development.
> It will be limited to 30 invitees and a handful of sponsored
> attendees.

What timezone are the conferences being held in? It impacts on what I
can attend quite heavily :-)

Dave.
