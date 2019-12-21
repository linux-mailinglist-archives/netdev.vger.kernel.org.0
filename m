Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681D41285E8
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 01:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLUAMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 19:12:34 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35534 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfLUAMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 19:12:34 -0500
Received: by mail-lf1-f68.google.com with SMTP id 15so8325978lfr.2;
        Fri, 20 Dec 2019 16:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MrGmPqolGd96pP/FN45eyt5MVuiGVslvVqixyKEBxIw=;
        b=uwGOyvgskx5fOmdYxsdc1IF+KcCZt4uvfiOJYLYg2UIH49tMuB5boig7DMmtX31K1a
         0UIMVls0SpSEkqSOIKbAmYmHuNXqBrsH7halBzoHQZMWNpg/nv8q1S5lDPDg6Jz/rq5S
         cuboFThIK54f9D/vkl6m6w2uTInMGn9/TwXFDWrqpJAniGuyVD8bqY5NAyWGjxvc7n79
         tuFyGSZnF1Umyuids2V06riV9KE1VNGXNmhmrPXvIc3v0fJUnGFc5ZUbBUDQkPFdugtR
         zgqsRYzTOUJllkbxHPItrNI2O98Hm2AbDaeF11d/tSPwT5rI6ccQREv58FVdAbvOD9h2
         Zr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MrGmPqolGd96pP/FN45eyt5MVuiGVslvVqixyKEBxIw=;
        b=DX+jxVTtOj5/WzkGf8UeRTr/60qzb9det5MGQodgdUfKOUzFK3mtrDAxfXf1V9wk/L
         +C6owhvvjB8FBInT50mUwBqje9D3Hp/Xtlvc64QLLrQN99anfAJHpcbG5myyoJByiUCl
         9cjaI8jOJ6BnjNiN8f19S2Y0Xqcakw+3EXNu9zIxtWaMcqCao/z/CTVKHt4TTgqChdU/
         FY9lO3xOAXdAi2JxJ8aGg66w8PA8P0iO97vc8DPpSsUrVCknpn/si8dzLHb5yM2PzloG
         3o8Y8gUwXT0hG7jqPBI92b1lUbJV/DAu52UJWujL2sS4safW3W/iy2lxFPRQ88zCiLTu
         C9nA==
X-Gm-Message-State: APjAAAUufI/s5Y4dcMOAlcd9os9TXM5Z7BlU1E/3WrrSIUrkvivNOlkb
        INS2kV22aV6lGn5KkcBpLAaM7H8kjiZgKMARK5k=
X-Google-Smtp-Source: APXvYqxL8EO4L3VAXuf8woaA/SqlX99jKQ511pDru1vKnAmEXZf+mPcnUX0TJ7aHGb3v6MwcmhtUkT25tD1cAGvPJfs=
X-Received: by 2002:ac2:44d9:: with SMTP id d25mr10962987lfm.15.1576887152151;
 Fri, 20 Dec 2019 16:12:32 -0800 (PST)
MIME-Version: 1.0
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com> <CAJ+HfNjAC-hFdW14yCDSkBUZVmRM=ya+GFyWV5AOYAi8=KBV6w@mail.gmail.com>
In-Reply-To: <CAJ+HfNjAC-hFdW14yCDSkBUZVmRM=ya+GFyWV5AOYAi8=KBV6w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 20 Dec 2019 16:12:20 -0800
Message-ID: <CAADnVQKYkasST76L=49kqG0E8rOFh3Ja47AmaMPuCjDAVjgZZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] Enhancements to xdpsock application
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Jay Jayatheerthan <jay.jayatheerthan@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 2:04 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Fri, 20 Dec 2019 at 09:55, Jay Jayatheerthan
> <jay.jayatheerthan@intel.com> wrote:
> >
> > This series of patches enhances xdpsock application with command line
> > parameters to set transmit packet size and fill pattern among other opt=
ions.
> > The application has also been enhanced to use Linux Ethernet/IP/UDP hea=
der
> > structs and calculate IP and UDP checksums.
> >
> > I have measured the performance of the xdpsock application before and a=
fter
> > this patch set and have not been able to detect any difference.
> >
> > Packet Size:
> > ------------
> > There is a new option '-s' or '--tx-pkt-size' to specify the transmit p=
acket
> > size. It ranges from 47 to 4096 bytes. Default packet size is 64 bytes
> > which is same as before.
> >
> > Fill Pattern:
> > -------------
> > The transmit UDP payload fill pattern is specified using '-P' or
> > '--tx-pkt-pattern'option. It is an unsigned 32 bit field and defaulted
> > to 0x12345678.
> >
> > Packet Count:
> > -------------
> > The number of packets to send is specified using '-C' or '--tx-pkt-coun=
t'
> > option. If it is not specified, the application sends packets forever.
> >
> > Batch Size:
> > -----------
> > The batch size for transmit, receive and l2fwd features of the applicat=
ion is
> > specified using '-b' or '--batch-size' options. Default value when this=
 option
> > is not provided is 64 (same as before).
> >
> > Duration:
> > ---------
> > The application supports '-d' or '--duration' option to specify number =
of
> > seconds to run. This is used in tx, rx and l2fwd features. If this opti=
on is
> > not provided, the application runs for ever.
> >
> > This patchset has been applied against commit 99cacdc6f661f50f
> > ("Merge branch 'replace-cg_bpf-prog'")
> >
>
> Thanks for the hard work! I really like the synchronous cleanup! My
> scripts are already using the '-d' flag!
>
> For the series:
> Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Applied. Thanks
