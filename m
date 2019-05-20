Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B70323F5E
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfETRrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:47:05 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41703 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfETRrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:47:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id q16so2301145ljj.8
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 10:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GyTJpL1BHuLaRSZ/rqTHzZ6DUBpP18SUBBGFoSOcny8=;
        b=P2qRbdB/3qn8Csvs0eihGH9A2fSsD5rOfPD9ur6vii0dljoTnuaXIsKtuxv8ROfGwL
         mFHDWDi4uePTp4hZlzUIflMW+CEtuGwdWLPD5hKDLQBQxfYSUnrKhmN7Uy6Ug1Za9vzv
         yO3L+NGW02wQgxfJmx0kPoOuCQkC8hFMggYGicZU2bDLuuqXljKjpBni+XAns8falGr9
         yYY/bS9rp0063zImi9ydDUtqDA3++sH2zLEnQY/jCV31hstaTLlStEevwJpe7sOJ/vZT
         2acIHlPz3OhoSwGA6YxUUEDi901vlgq9cZVytbI2qWdz4sqoEBwwguJ6auGcdl5PIgMt
         NLPg==
X-Gm-Message-State: APjAAAVN9boJIxbrqhuLPf5nZW9nEXDiiUQJstFXaZRPp4Ob0lNxjHlw
        Os/DQ46QXpH+mkkjOvlD5YyZZ3xLbnrD5sHWwOW+XA==
X-Google-Smtp-Source: APXvYqy3i8sepeeUBj1Jv7zSFSVFg/7+UvwGF5/OmKEWwccotlb1NKSO/wXNPyHb3czO1wZpyt4wnf9VlD16bxAiD00=
X-Received: by 2002:a2e:4701:: with SMTP id u1mr32888626lja.38.1558374423668;
 Mon, 20 May 2019 10:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190518004639.20648-1-mcroce@redhat.com>
In-Reply-To: <20190518004639.20648-1-mcroce@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 20 May 2019 19:46:27 +0200
Message-ID: <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] samples/bpf: fix test_lru_dist build
To:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 2:46 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> Fix the following error by removing a duplicate struct definition:
>

Hi all,

I forget to send a cover letter for this series, but basically what I
wanted to say is that while patches 1-3 are very straightforward,
patches 4-5 are a bit rough and I accept suggstions to make a cleaner
work.

Regards,
-- 
Matteo Croce
per aspera ad upstream
