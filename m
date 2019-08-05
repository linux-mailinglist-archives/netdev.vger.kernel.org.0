Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93D482717
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbfHEVnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:43:53 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36042 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEVnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 17:43:52 -0400
Received: by mail-oi1-f193.google.com with SMTP id c15so8125180oic.3
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 14:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=InFS1LZhgpWRqGoT9SfCUzkxmt4HhaK5gvLdBysn3vk=;
        b=YRjRo7gteZ8Vt6761ftj7RsCo/3dj2vrfh/BpAjgWfrUxOd2bWAPtni8xWK9QXPCvP
         7Ovkub4cdWmxiyikzqhOHxa1N00vHtirHzu0PdDX9vC35Vpv8leZ97kn4oNbENLa5R/y
         YBI6QohRqu/0kZZvVmlcoeJjqFj5PpTfXSyOtY19826B7oA/I12tnrhNT7IepGOYmsnj
         OuLXHfMPJHbDshsd410fuIjpFLix2moNMeL0h/A/rqFHIF2d+VcVYmIAaLsHSVlrTObM
         IVPm450djSTfdQmZKn40h9WMxliY6oPIoJh7zJY9FLxLPaMF/D3NByWcZyw4EQ2PRafI
         bvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=InFS1LZhgpWRqGoT9SfCUzkxmt4HhaK5gvLdBysn3vk=;
        b=PYCOMJm3JPrwymz/TYtTWtC5SZK1F9VEon3L+a1SIN74m+4KdKLJn/gSkFmSeOluOQ
         Y51NfLa4nHAagXsS+XMpVXGFia7lfKhE5Bky6fdlRCZuP/tegirfs+3FGWC6dUccqSAZ
         a9wij/j8IJAvfhK+FjZ0yaI2oBRKs/VRA9jHFxaeqFrp8OoYuLqJTv8kP/njobOPO2+U
         2Wfv8Epid2vmBPBat0EEEuwMZo31XG+HgOW00KkLcIpd851Y0ydM+axk4TRUTeZWW/XP
         JOQvytFDSFofOhtuBkFBADlJo4cBxqGIsRxyN0gG1HzNFVqV5xtI6G3EUhiz2UC/IAi+
         woOw==
X-Gm-Message-State: APjAAAUGdcXaRjEngt3Xahv4uhYwgPjS7CwZstuqz/6WuWlOJ1MUOaBh
        f16i+aQ4u1SGTbgiBxuakO214bCIIJdqMeRdvBw=
X-Google-Smtp-Source: APXvYqybtISjQmsDe5rp2/KiYDhkGgL7R0e6IKLsy3r13v1cOvGCuzm8k+4wcBcwlzZN7MEloyDZSi/NvUk8UlI7AVU=
X-Received: by 2002:aca:f552:: with SMTP id t79mr288320oih.145.1565041431826;
 Mon, 05 Aug 2019 14:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <1564973771-22542-1-git-send-email-pkusunyifeng@gmail.com> <CAOrHB_C758HjLJxb3jzAn0Wy1a_m4G2o4gsqMDdhJ9PRdT4GUg@mail.gmail.com>
In-Reply-To: <CAOrHB_C758HjLJxb3jzAn0Wy1a_m4G2o4gsqMDdhJ9PRdT4GUg@mail.gmail.com>
From:   Yifeng Sun <pkusunyifeng@gmail.com>
Date:   Mon, 5 Aug 2019 14:43:41 -0700
Message-ID: <CAEYOeXNViMh7kZes73n7eFbRYAgU_Oxp_qb=tW9-Zsp2vF5yPw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] openvswitch: Print error when
 ovs_execute_actions() fails
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Greg Rose <gvrose8192@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Pravin!

Best,
Yifeng

On Mon, Aug 5, 2019 at 1:49 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Sun, Aug 4, 2019 at 7:56 PM Yifeng Sun <pkusunyifeng@gmail.com> wrote:
> >
> > Currently in function ovs_dp_process_packet(), return values of
> > ovs_execute_actions() are silently discarded. This patch prints out
> > an debug message when error happens so as to provide helpful hints
> > for debugging.
> > ---
> > v1->v2: Fixed according to Pravin's review.
> >
>
> Looks good.
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>
> Thanks,
> Pravin.
