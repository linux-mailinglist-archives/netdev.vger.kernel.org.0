Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAB017AA5B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgCEQSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:18:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36787 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCEQSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:18:33 -0500
Received: by mail-lj1-f193.google.com with SMTP id 195so6742294ljf.3;
        Thu, 05 Mar 2020 08:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gL5vBbbeMCoQRZdd2e1f8gMNmmGKEAstYFkdjKYQP2U=;
        b=tQ7kI+vZlDdHob+x+uy3xOsqzwzkF3iMNJrWA7mPzmfVQrGmL5R6GniM8JLUlteZMk
         78OZEIZFjYz4KxTlUst1zuwa8OHDTMjvnAM+4UQaR0r5KaKun8XLSk8pzuNny7s4pHvt
         NI2np9vW4ogMKbXlRBE2KZ8WhETsFDJ+2uut78ZMM423sQQudi9A34C60j8ms/IJl1UY
         j71kgX0CBDuPLvraUriJp4ns0FgXV9HM21Q6TfVW5hH0ERji0lPVNeEJe9fEo579JUy2
         k1eHTvcUaZixyzUeb9TxymRo/J9IN/fWV9GzmU+HF0CodeySV7SBo6G0v/nTPoe3TACw
         py1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gL5vBbbeMCoQRZdd2e1f8gMNmmGKEAstYFkdjKYQP2U=;
        b=IfW7JXDaJurUnavZk/pt4vT1a9LpWTG/xE8YogHx9/R1be2aiL5y8eG4qZIQCLG+Vr
         QyX8VptXsgme4N93lIQ6QQo2UVjRHB+DUmG8S+n7aXNQ1Oq0aM0kMlGpl+J6Mwz/7Rrd
         DA5D79WMmNG5Hm/oEx6Yud6JYP+camxPU1UgBGbXBssRjaZVT5OLZ8CjJ+UNYYXt2xe+
         814HINWdKcIgmi0bSJsz8lz2X3mkmOwC0INM8T7oqS/E3QS91gfHIDn9qJicTMaSsNoj
         wbKylmYrQrzsDB1guD975SU7ZNEr70kbBTtg0EMwIEMIwAfAt+XXtALpiDQg2RXB1YrJ
         3vIQ==
X-Gm-Message-State: ANhLgQ2moHaUPIvzrElmATP2KMbrE4N1y8F6OaRIBq4Bg+hByxYMDAem
        SGvVayiqgcUUahCDLt8gA4nvSv8+LtmVFfRpxgw=
X-Google-Smtp-Source: ADFU+vvp3u9GLRfD1+dhOGMdYX1FlWnML3O5d5yjTuDlsEDFfAlc3TL+sRTabNGpYAHGUGOtvTQdg0X41+kRh1xVA3k=
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr5926578ljn.212.1583425111097;
 Thu, 05 Mar 2020 08:18:31 -0800 (PST)
MIME-Version: 1.0
References: <20200305175528.5b3ccc09@canb.auug.org.au> <715919f5-e256-fbd1-44ff-8934bda78a71@infradead.org>
In-Reply-To: <715919f5-e256-fbd1-44ff-8934bda78a71@infradead.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 5 Mar 2020 08:18:19 -0800
Message-ID: <CAADnVQ+TYiVu+Ksstj4LmYa=+UPwbv-dv-tscRaKn_0FcpstBg@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 5 (bpf_trace)
To:     Randy Dunlap <rdunlap@infradead.org>,
        KP Singh <kpsingh@chromium.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 5, 2020 at 8:13 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 3/4/20 10:55 PM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20200304:
> >
>
> on i386:
>
> ld: kernel/trace/bpf_trace.o:(.rodata+0x38): undefined reference to `bpf_prog_test_run_tracing'

KP,
Please take a look.
