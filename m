Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3685B62F0E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGIDti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:49:38 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44748 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbfGIDth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:49:37 -0400
Received: by mail-qk1-f196.google.com with SMTP id d79so10731996qke.11;
        Mon, 08 Jul 2019 20:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KskYFE/Ug0iwkacs3vqwqivOLXYCEi71ZnQKnzUX30M=;
        b=cIPz3WCgEnb0VMxGUsvqL96sOL9BnY0u5UhIhfuMiadfYLJnB528+qruGwr0ZaHgQ2
         Qe+wyJ78woji2ZfoTBDiEgz/JCwRuzcLC3qAqOqVYrPG+nMgSYRZjX8RLqYJ6bFYyjfw
         dA54FcvAlWqoRgA/v26irblTCRQK/q6PlR3rOM6o66b9KrkN2qNfjduUEQLkoDQL6T/Z
         BHc3ZV3jjRVZd+i0/hF49PLAaTib/RsC00xGy/hZ5O+Bnd5oUgYCI8aDCkYzNbuQYUdI
         lOLNsLdzBBpwi712iaaq3cqH0NWj7cgrjD+Ec7U4lShSWfBE+ZS7SXvXt/Lz+PwBi65p
         dJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KskYFE/Ug0iwkacs3vqwqivOLXYCEi71ZnQKnzUX30M=;
        b=BDLjCxgtOtym8FlqLx2YRZktLmnWDle4KqMOYUXxsSuu2elONAORodgvrgOM8oB0oz
         Z8fR1WOuIxV9ipYSIXkpVJghYJB2lFHyHPQAxFIc5GOnytO7alEqCg6Z3pLqUzFtxZuT
         bb5TCmRkE6U81HA8fuq3hQ+xJFqdnVPXdS2CEYvdmGXD4Sa8mR/QD9j5AoPU9D86eoKM
         reBfKsiOWa3TDLAsdlWxQOZxk30BBJGcrS4vZ0pGRf+o/pS7ePnEWuvVBWDhVncOQBRd
         Q1kWlcQ0m+hfm2fjegGgLbGD9q6bYJJ/eH4/ahf9ZDBhrYL6Bo7m3pnTyhyqSSHoWDGS
         lzDg==
X-Gm-Message-State: APjAAAWdYs33t5zOohULLq/Qb5wkNLnXj8pl1LUjLTLYWO8CMJzSYsxo
        0o2PqgcHzIt3yuQ5Aepolh+rNNRmwNVZsZM1Pvw=
X-Google-Smtp-Source: APXvYqzjbKB8azSowHGtx9AS51EbPcJglyrtLqksfB1ogI0ZeH6D2CKl94ZNbdBM9ZNpiQydQYeVO7NEm1xV0pXMIfk=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr17248085qkf.437.1562644176501;
 Mon, 08 Jul 2019 20:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b13e1d058d2da276@google.com>
In-Reply-To: <000000000000b13e1d058d2da276@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Jul 2019 20:49:25 -0700
Message-ID: <CAEf4BzaUEWwGL3k0VeiFYFqyJexQU9cDZWN69jSDpBjP1ZEcpw@mail.gmail.com>
Subject: Re: WARNING in mark_chain_precision
To:     syzbot <syzbot+f21251a7468cd46efc60@syzkaller.appspotmail.com>
Cc:     aaron.f.brown@intel.com, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        jeffrey.t.kirsher@intel.com,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, sasha.neftin@intel.com,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/anakryiko/linux bpf-fix-precise-bpf_st
