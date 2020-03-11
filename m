Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50693181083
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 07:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgCKGRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 02:17:15 -0400
Received: from mail-il1-f179.google.com ([209.85.166.179]:36973 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 02:17:14 -0400
Received: by mail-il1-f179.google.com with SMTP id a6so924127ilc.4
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 23:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0zARp+sb4FkTLT0jYnCszLXCpi4bodGLy7Yq787Kc/0=;
        b=MavqWFJzoiKHJLHpoO5MfwF3+XaqYapedsVfSZ/+EKPQVk/8hcHXimaFpAVHiKDi+l
         Gv665ZlS71kpZ/eTVjqD83PxnYa6GUBkW68OkArxT0jNN808AhOso/264An/Yk86kEQb
         xzuY8I7UmluLA0j6mns7/XzKBznvC1zZbMrGEsCZKUcMEmsMWqhjVkpmQJYCYXWGKwVZ
         LOzzgLpDvwemfxjPvLGtY8ctJO2yA951LsFGzFmlG+605LqePR5saoGJQHWKNvMIC8UM
         /S83AKsaxx5GC159IuW9CiaRcAXq3xTs9tTrT1/ZB3T+An3LLlq1sFx4Xzt6qtKuff8c
         J4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0zARp+sb4FkTLT0jYnCszLXCpi4bodGLy7Yq787Kc/0=;
        b=a5JNkOBk/n0Mlt11XIzJYrq5hyzNcVaLe+4pgg7PyPG/JCUgLBpS3gtQczMJKH7OX8
         7WX6ez0hBJxcuxdfqp3vjbI/LoKlrxCfItTO4IqzsYvB9c4WpnBRIF5WwVxAXI8PHxxC
         scDqRLrr85pnmsbgLkIhDP7oep4gjgsZJLuVq+UFBwUuKdPiMQBS7WFiV/U/7Ln0DQ7o
         C9ExFDyyQe2XGFbEbWk6A6YDgMbd47mK45++j5gtwwonDKzaGHDJ3pR3nO5GhZWyPtJn
         T//Ovk0IM7oAXBQQVuJbNGofyHeYUWA/elgufNLHNwDIecau80L8s4qmzDdOSJL1rA5f
         ehWA==
X-Gm-Message-State: ANhLgQ101v14a+KcApNFlk4pmXbFc2H0ePBUD6OyTB7rZXxWcAMjiIhJ
        XlEaGF3IGiG5/rT7fzqSs2ZHxmNthQVROsiZGZDMYE0v
X-Google-Smtp-Source: ADFU+vu9WCrA+URZ7rzwXV+LBdF9N2+AuCNpng3tI7dlbzCr5dV80fSQyJ3tdkT6oLtImL0BuIX2hb+b7cuGvJY2k4I=
X-Received: by 2002:a92:8cc7:: with SMTP id s68mr1660083ill.268.1583907432206;
 Tue, 10 Mar 2020 23:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAHfguVw9unGL-_ETLzRSVCFqHH5_etafbj1MLaMB+FywLpZjTA@mail.gmail.com>
 <20200310221221.GD8012@unicorn.suse.cz> <CAHfguVy4=Gtm0cmToswashVSwmS+kOk57qg+H+jspaHrH8tJkg@mail.gmail.com>
 <20200311055343.GE8012@unicorn.suse.cz>
In-Reply-To: <20200311055343.GE8012@unicorn.suse.cz>
From:   Andrej Ras <kermitthekoder@gmail.com>
Date:   Tue, 10 Mar 2020 23:17:01 -0700
Message-ID: <CAHfguVwX2REz95wf1MeSey6yTqhqawi63nrDnMwqP4MZ_Hzxag@mail.gmail.com>
Subject: Re: What does this code do
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot for the explanation.

On Tue, Mar 10, 2020 at 10:53 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, Mar 10, 2020 at 09:11:06PM -0700, Andrej Ras wrote:
> > On Tue, Mar 10, 2020 at 3:12 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >
> > > On Tue, Mar 10, 2020 at 02:42:11PM -0700, Andrej Ras wrote:
> > > > While browsing the Linux networking code I came across these two lines
> > > > in __ip_append_data() which I do not understand.
> > > >
> > > >                 /* Check if the remaining data fits into current packet. */
> > > >                 copy = mtu - skb->len;
> > > >                 if (copy < length)
> > > >                         copy = maxfraglen - skb->len;
> > > >                 if (copy <= 0) {
> > > >
> > > > Why not just use maxfraglen.
> > > >
> > > > Perhaps someone can explain why this is needed.
> > >
> > > This function appends more data to an skb which can already contain some
> > > payload. Therefore you need to take current length (from earlier) into
> > > account, not only newly appended data.
> > >
> > > This can be easily enforced e.g. with TCP_CORK or UDP_CORK socket option
> > > or MSG_MORE flag.
> > >
> > I understand that the code is appending data, what I do not understand
> > is why is it first calculating the remaining space by taking the
> > difference using the size of mtu and if the difference is <= 0 it
> > recalculates the difference using maxfraglen. Why not just use
> > maxfraglen -- All we need to know is how much more data can be added
> > to the skb.
>
> Ah, I see. The first test checks if we can fit into an unfragmented
> packet so that we check against mtu. If we don't fit, fragmentation will
> be needed so that maxfraglen is the limit (maxfraglen can be shorter
> than mtu due to the rounding down to a multiple of 8).
>
> Michal Kubecek
>
> (Please do not top post in developer lists.)
