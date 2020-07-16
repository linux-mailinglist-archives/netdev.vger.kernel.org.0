Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160F8221A88
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgGPDHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:07:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726770AbgGPDHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594868828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dyjbv015TKmCzPaPw/0NvH4rVIk+vvfPLdP5HvX3BsY=;
        b=Krdv3QHLBFAItBphMmUlujKR+n6dfLNpEu3UhMtWdXXRh7s3bl2aHwJ+5cnNOyaBBvPFhV
        bkvR9ivwNV8DHzxM6Ef0xqv90VP3wrtsFt+foP2d7jyxIILGUF/chqxR23HHCWtf3v53/w
        IjnyT2onmpH9MZHa0UiZIka91zl0qnQ=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-XnIdwGh8NRKTMKhRn-IV_w-1; Wed, 15 Jul 2020 23:07:07 -0400
X-MC-Unique: XnIdwGh8NRKTMKhRn-IV_w-1
Received: by mail-oo1-f71.google.com with SMTP id e19so2024025oob.8
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 20:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dyjbv015TKmCzPaPw/0NvH4rVIk+vvfPLdP5HvX3BsY=;
        b=X0Zk9BV3XuYNuf1w+Xl0Bg1j+POj/F+u/qr9m95MZJdrU6Ygyvlqu9e25R3+kag0iS
         ucOFCAmVOTFbtZBvU/RX+ylbBo9/HHD2YJPY7F9QfdRbkY3WWIcR1gym6MbWvWZ+WIiN
         ZE3g3twqDI4XXzQu/Sn2vuoqV+6/9V0p8Xn6Emxs3lh2E7rLNCPlUsNJFCr37Z1L/mds
         OZfgz9WFm50ReCQzHtejs6Em+yuhCnQtEZoJlQotLCdrclbqwxd/RIt9sYqXWQGVKWW9
         MxpURILJHJai+I7gTDHwRzwbCX3l3po134QVUveU7q/9GqWvVTaAtEFrcyXShWFMmUKP
         YzYQ==
X-Gm-Message-State: AOAM531VB/+dQORot0slxdFSgMsO02KkQiGwmEncMOSrdo5jQTFBmZOx
        9EIjztuLLE7mjvXeMsiz/XDIQdSTua6rKTdSDOQn6UEJgq5QFrNVnItJViUOrGwVH62nKKDpspr
        1ODmvEeaHwMqNFs3r+9a0Si+9OSlTyv3n
X-Received: by 2002:a4a:2f15:: with SMTP id p21mr2291640oop.20.1594868826250;
        Wed, 15 Jul 2020 20:07:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDHsWqEH2UNfR+NwcoA8IhhYtHj3Np+Pgr0MWAcs9ZbRsVQrYUsznUxAaHRsgrYQmY/Dp7UY2adnEPvBiBZK8=
X-Received: by 2002:a4a:2f15:: with SMTP id p21mr2291624oop.20.1594868826039;
 Wed, 15 Jul 2020 20:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz> <20200713.180030.118342049848300015.davem@davemloft.net>
In-Reply-To: <20200713.180030.118342049848300015.davem@davemloft.net>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 15 Jul 2020 23:06:55 -0400
Message-ID: <CAKfmpSeqqD_RQwdFwsZG212tbNF0E__83xKWT44nGYs4AOjDJw@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     David Miller <davem@davemloft.net>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 9:00 PM David Miller <davem@davemloft.net> wrote:
>
> From: Michal Kubecek <mkubecek@suse.cz>
> Date: Tue, 14 Jul 2020 00:00:16 +0200
>
> > Could we, please, avoid breaking existing userspace tools and scripts?
>
> I will not let UAPI breakage, don't worry.

Seeking some clarification here. Does the output of
/proc/net/bonding/<bond> fall under that umbrella as well? I'm sure
there are people that do parse it for monitoring, and thus I assume
that it does, but want to be certain. I think this is the only
remaining thing I need to address in a local test conversion build.

-- 
Jarod Wilson
jarod@redhat.com

