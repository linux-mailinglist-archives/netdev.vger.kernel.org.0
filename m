Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CC932B3D8
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840212AbhCCEHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361017AbhCBXLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 18:11:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41D5564EC9;
        Tue,  2 Mar 2021 23:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614726638;
        bh=ItBmd4sAHE6X1z9zTZ3sUEN0p3nvvqLsAfjqagRywdc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L5NAVBcToL/EdMyr8d463suXTn1Uff0KfAiCAs8c3MgknaFuSzX0768IuiFS/nKqO
         63bFgTOBMJZGDK436Hb25TqKrZE3D++KVJ4MenlMozsvwDM1nS+bHzXj4A13Kekj/7
         UHYpQxa+GrY4ruQtFYkW5yRm0gGeOv26m4Qmt8W2/mdKlQ/R8PvFjgIPLrinlK2J8Y
         gbmBPGixViRGcJNI5o9Wo4Lq2LXJNUdYhpp01u0HnCggp6kH/88GKbuY0kosq25HZX
         7IIfMx5fXRStKlzuqzOw8dt7abmw25ZM5UM3DO+x/HzT3FGp9Glmi+nxyT+swv+eFE
         P7ek26IydSg/Q==
Date:   Tue, 2 Mar 2021 15:10:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com" 
        <syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH] netdevsim: init u64 stats for 32bit hardware
Message-ID: <20210302151037.2dc70600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACT4Y+Zv-p56cbs3P7ZEUXdYaN7jXB4AELG5=S19wVH4kj3a9g@mail.gmail.com>
References: <20210128024316.1425-1-hdanton@sina.com>
        <20210128105830.7d8aa91d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <60139ef4.1c69fb81.8d2f9.f26bSMTPIN_ADDED_MISSING@mx.google.com>
        <CACT4Y+Z7152DKY=TKOUe17=z=yJmO3oTYmD66Qa-eOmV+XZCsw@mail.gmail.com>
        <603e0005.1c69fb81.e3eed.6025SMTPIN_ADDED_MISSING@mx.google.com>
        <CACT4Y+Zv-p56cbs3P7ZEUXdYaN7jXB4AELG5=S19wVH4kj3a9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 12:55:47 +0100 Dmitry Vyukov wrote:
> On Tue, Mar 2, 2021 at 10:06 AM Hillf Danton <hdanton@sina.com> wrote:
> > On Mar 2, 2021 at 16:40 Dmitry Vyukov wrote:
> > >I hoped this would get at least into 5.12. syzbot can't start testing  
> > >arm32 because of this.  

FWIW the submission never got into patchwork or lore so we had 
no public source to apply from.

> > Or what is more feasible is you send a fix to Jakub today.  
> 
> So far I can't figure out how to make git work with my Gmail account
> with 1.5-factor auth enabled, neither password nor asp work...

LMK if you get overly frustrated, I can get the patch from my inbox and
resend it for you :)
