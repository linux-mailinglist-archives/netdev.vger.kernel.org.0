Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2875AF6ACE
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfKJSfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:35:15 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42830 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKJSfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 13:35:14 -0500
Received: by mail-qk1-f195.google.com with SMTP id m4so9393394qke.9;
        Sun, 10 Nov 2019 10:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vp+6rgiL5xMOe38YcCHV+HC0DZtAyESExnNOvqhihE=;
        b=anvWAlMrvoL818rXPXemqtj7rHh983tj0l1WWbQEzrg39/Knn+37mIdaISMZ1kpnlZ
         1OI5xNcx9YK0WvWaY6/KQndK9ouaw5TBzwVPq8vIYNKxdthZ0enAGVwaxlI4SFtipRbz
         xTnnTmRlnuE52ep189+1ZEPTRLC5EO24luLt9em06tUNzgcQw0vTIBMvr/ePDRDBf/yd
         aeqyYF81qjIW81/YBuFplvHSXnVmziaShHWYBwwLmZJDi2nzSxkbj/khI5nCIpAafNQL
         esHoOQIWIXM6DYyVlCMTnJT8Ay4p+Z3ce1ZHOtCaUbL8IgocAbtl5QDYxYvf82sOT9OD
         KHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vp+6rgiL5xMOe38YcCHV+HC0DZtAyESExnNOvqhihE=;
        b=DwAUeTUgJLAtYN/67hpB6aq5xJYQoFXr8esRFTo2S8GuXqTQyLtjwMqyLilhj1rjzI
         VgNMafdj2YgGNVXFzBw1pjN1dgdcvrD/KK9pscJlfRpmx1mRNNUN8peclpG6ZZe2qzkW
         Xm/qvrnzAFS1SwdQ1UUnCGZDWGY42hSiZM+qjlDQ5CSCfeTMkGDcZ/ZkZQkNFC+DZOGi
         k3F2ysnbqgOBavr3zVax8GjaGOkL6cBLbVeMvZTZa1/Od2PiOP6cwsb4j4vpFryDqYjo
         JtWtzrekniduaMyvbBMaj1bLyH3WDPnNoJQP6h6uHG/NVcCzLOuZQZdKxyyERymxqMjp
         cykg==
X-Gm-Message-State: APjAAAXZ8fYZcW7UCPiRbQ3KWKBf3Fo/uhTU5ymAoErsaTSkmyPVJDA+
        Kt/4MUZFxLb/pqzgRAPCobG8VEsCh6QcmEuQ7IE=
X-Google-Smtp-Source: APXvYqxsPOhWCIRcmv4yToNEd8xkAeivswjilNBPOMrvu33XuB69RlXL/hOUAhfJQngHkGlQZB6N2/1EfgCVY7NmI60=
X-Received: by 2002:a05:620a:210d:: with SMTP id l13mr7245457qkl.174.1573410912219;
 Sun, 10 Nov 2019 10:35:12 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-3-git-send-email-magnus.karlsson@intel.com> <BCCF2352-9793-4546-8353-A8F926F4E02F@gmail.com>
In-Reply-To: <BCCF2352-9793-4546-8353-A8F926F4E02F@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sun, 10 Nov 2019 10:34:33 -0800
Message-ID: <CALDO+SYcK4NCA7M4S_yp-0Kmzb2Oq8ArFpfBcMsdbi9_qMxZfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] samples/bpf: add XDP_SHARED_UMEM support to xdpsock
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 2:59 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:
>
> > Add support for the XDP_SHARED_UMEM mode to the xdpsock sample
> > application. As libbpf does not have a built in XDP program for this
> > mode, we use an explicitly loaded XDP program. This also serves as an
> > example on how to write your own XDP program that can route to an
> > AF_XDP socket.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Tested-by: William Tu <u9012063@gmail.com>
