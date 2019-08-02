Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4095F7FD32
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfHBPOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:14:34 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45415 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730256AbfHBPOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:14:34 -0400
Received: by mail-lf1-f67.google.com with SMTP id u10so14435354lfm.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hasXSOmpvRrsmZsmPGjkxh0TMdpo1Q4XDBPh34uiIqM=;
        b=Sg2SYkvk48SBxBhWxZuAxxVRWkMx3xU9WEGubQtRD931GSTGL4ugZzJ7THYqeSmqIN
         EOgzykrOBap4CBAkL8OGLavdPewd/hR8CS0vfYaVmiBtdJ16iqOVFcEjm36on8t1vj5z
         lcySw658LONtiu7nKgtf4re8lwdn+oRkiMbBlONcq+IDM7GmJV78+uSu34TYJTDq+hrj
         bfViCWmo9HnK71WmPXvIJxUG0Eald5UQi1tnqDVbvIVsSC39s0PpSO+i2dRXw/KrNdU5
         MgkyV5tpsYUhhCG9hQA0Gz+3mXy8hKj+If4nkLYjCyN0eM6omDxOZVHUqbSJ863MRG4v
         zQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hasXSOmpvRrsmZsmPGjkxh0TMdpo1Q4XDBPh34uiIqM=;
        b=nCtOkjyF5MimvPa5fLF0eLp4spvBzlWhGFbFeaOxGrV7NZeGwpkb9lbV/KWgptl+j9
         lakcmy/Ok/KeIqXexkGlAh7lPKxgSMKy2tdvpRJM0qDbBSCOC2jTf03UmUnPA0p0CKuv
         MPHkNxbQEr+J/RsjXCpNfd/Haf5x00RymVEYKqXaIRtyZNydvoypI+PSAOEvaZsepiwt
         t03o/0mra0NBP7Ltv4vlA6QvjOjb/z/eazUCMk8yuuV5oTx06uFKxwvuqaD949s1AGCZ
         X4L6cEcyAz0eLrqRnq+YOY1JmqakXMu6SIuLN7KLVtnYueVZZOTWml1g448hXQQl0GxN
         5Dyg==
X-Gm-Message-State: APjAAAUO+XdCE1vmbvzqfMQqPk5ZdH8EfVzFucNxd8PH7eAkboe4ocsm
        ZUx9/yKdNf2Fz716lP4W2e4RK7BOJTR1SjLL+6g=
X-Google-Smtp-Source: APXvYqyRuCjTFJ7okEuSqhIM3xbI3fIllni1EWvFk5kgJ0i8qOfyXS0yiG7gGPr8TVVqD1fifOl72V4cVt3T+HN4c3A=
X-Received: by 2002:a19:6e4d:: with SMTP id q13mr23305735lfk.6.1564758872573;
 Fri, 02 Aug 2019 08:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190801185648.27653-1-dsahern@kernel.org> <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
 <4c89b1cd-4dba-9cd8-0f4e-ae0a5d8bc61c@gmail.com>
In-Reply-To: <4c89b1cd-4dba-9cd8-0f4e-ae0a5d8bc61c@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Aug 2019 08:14:20 -0700
Message-ID: <CAADnVQLLKziv+3oOEijh=woyBZ7KsxoJ8=BB9ax+XJT9wxTuYQ@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 9:04 PM David Ahern <dsahern@gmail.com> wrote:
> ...
>
> >
> > with -v I see:
> > COMMAND: ip netns exec ns-A ping -c1 -w1 -I 172.16.2.1 172.16.1.2
> > ping: unknown iface 172.16.2.1
> > TEST: ping out, address bind - ns-B IP                                        [FAIL]
>
> With ping from iputils-ping -I can be an address or a device.

the ping, I have installed, supports -I.
The issue is somewhere else. Ideas?
