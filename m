Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9583362F09
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfGIDtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:49:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33303 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIDtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:49:20 -0400
Received: by mail-qk1-f196.google.com with SMTP id r6so15054392qkc.0;
        Mon, 08 Jul 2019 20:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KskYFE/Ug0iwkacs3vqwqivOLXYCEi71ZnQKnzUX30M=;
        b=i/lSK/sGsCjIv7NK4j211T9EVDJQrekIqOlLKS6Af+/tyS/4Ah6LC0pzIwcthHOpeK
         kRaiXZb5zhaAM2qbBCPR5S8atFRKJW3nKToNFaCoPnneeLk0+lcohoqx9vFvpKq8+QJR
         +K4nhp3FsPuapZykCCpDfGKFEi0qeZUii3AIeq62G7E9rSUEnKXJ2gJlj83ueS/igMWc
         KsUdHwFWPFkdpFoAa7+0+dsj4UT8YesXMUjlCBEVVbnFtnsv6XOx24Spgz+BW/yb863o
         QJ1r//PQeNA2NKa/kpvhDBs3E6CWZe7QGnU5tNSSPX1SkzqXvXebS4+WH9W/G0uOivf/
         76ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KskYFE/Ug0iwkacs3vqwqivOLXYCEi71ZnQKnzUX30M=;
        b=qZ7Tu7y2MYBXuNzQiF+bAfpeUx1dMesYimOwBD8mfWwVLMzFl9BRmwLdWhxa5K5oTT
         +wCYeAbtnIKfwMeKHqBD3bOumTBFU1AvgHHnmmmJb0oR8XV7wMZxfETEDU+IarNiqSSq
         kNLCyeLoM3FPivaJVlYn9JPon/OhSQxOS0m61hrQXEQIkENZPbkrmLLFsPisBYrB1u4P
         ViwfezMYhCWQPv/ucXYRpSJFWcwxIwoHuIZmZcsoDTKCvfNNrhyCYhLnYkfEZ/s4Wj7f
         i3cuT1vMBs2OoNIjeHymnbjInqAs7qHmOGarYOIdu3z2MTxZ3EbAKDbusJwetUpIDKoU
         ppLA==
X-Gm-Message-State: APjAAAU9I500JMcjhXUW3A9rdqy98JrBLniBANAjwnqpETovAcBjbmiB
        O0KXfKly3a/oQ6kQ5B2w22y+7fw1CEhPxTjjjGw=
X-Google-Smtp-Source: APXvYqyHEPt11qvDNytVkWwFfFQJWbcpFr7QvnTFs5hkJOjlcIKBKaKfbxKCFFuklVb6b7rIZsFc549dQgGP5eJ6qiM=
X-Received: by 2002:a37:660d:: with SMTP id a13mr17326893qkc.36.1562644159307;
 Mon, 08 Jul 2019 20:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a5d738058d2d1396@google.com>
In-Reply-To: <000000000000a5d738058d2d1396@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Jul 2019 20:49:08 -0700
Message-ID: <CAEf4BzZfqnFZRbDVo1-=Vph=NpOm1g=wGuV_O5Cniuxj9f9CsQ@mail.gmail.com>
Subject: Re: WARNING in __mark_chain_precision
To:     syzbot <syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bcrl@kvack.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, xdp-newbies@vger.kernel.org,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/anakryiko/linux bpf-fix-precise-bpf_st
