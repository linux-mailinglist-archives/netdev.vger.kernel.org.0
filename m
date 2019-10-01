Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE95C2FC9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbfJAJOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:14:09 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:45187 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbfJAJOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:14:08 -0400
Received: by mail-qk1-f181.google.com with SMTP id z67so10454940qkb.12;
        Tue, 01 Oct 2019 02:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=rbkqOgmCAmTchnhuT6j7dwG4a9biyzXaYvBZyg2/GrQ=;
        b=Qt7MnjkhNYKBSOuQZz0mucQuFLRalnF5uLG+XoZU6jowxFZeFcS+ws6254IT1ieLO5
         ugs+6gAmvYNMfNuzFtb9jvOc7bMHYLlNP0L0t3gRmk27Ujj777KPWIW8nYLbDXVIYT8r
         BycZBT644xep/oTg7qqoEL0SCMHnUbWK7lb5YmK40Ho2eS5g2zdIxm4tUQxy7BEm3Vf1
         bRhCAyvSq2tvuzHMbfYpHiuPBgdGPJARVrSjAMoh0dtRkV46FQ6V2sZBy6UVMBv2YbTQ
         Q+AD0boWm/dudanSl7QRPrM/2gf3xp0eFV5Pjb47i6qPgTDzqc1Z3XgkeTbvKoB4AZtk
         naXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=rbkqOgmCAmTchnhuT6j7dwG4a9biyzXaYvBZyg2/GrQ=;
        b=uLeKXz0Bu9xGAsPyTYyOtl+FB8upFdZto/MxwOphjZyRGJ8YJ4TYPrt3fePY/jisdP
         ac79aMLC90rjubWXjNs1R6epI5PANOKbefr5503rcfJVBuf5pR1dhoLNFUgwEo4v4uE6
         SRQIb+4La+vzsszrKY9+O/4yWvianMFGlzYrgaL5kU+3A0aFuCk3nq/6lTqUchn1nfZ9
         VbHabiUWICDlSELFnswFYpEsgtiGHGovPh9uXPyfNg6cNnrJ+WGELDJNAdsLJLqYUhEB
         EnEN8R9lQsUY7nFNabEy2b8JmkthkxlbbPMOe7Sq5gB2KR2MBG0ZolluS5C4rQSuH9ED
         CfXA==
X-Gm-Message-State: APjAAAWaV4PoB0Gqz09kGfom4dHgoblrdmDCpQZJ0e2zIl+sJUDSKYnf
        9a2TLcWGW8m2Y6qhSR++qvfYc3bgG7jteJ24f6d4lP6qLsu3aA==
X-Google-Smtp-Source: APXvYqwREToTpGSyx66MnUvNYQkCjxLExuvnyImZvyqPyzlKPfWaTdvYt3NG0/sXk4DQ6nFC5ZFqBAmSsASMICvAeEQ=
X-Received: by 2002:a37:68d4:: with SMTP id d203mr4840354qkc.333.1569921247721;
 Tue, 01 Oct 2019 02:14:07 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 1 Oct 2019 11:13:56 +0200
Message-ID: <CAJ+HfNgZGzOM70oTV35YfMdn6PRcGCjsybypGYqsDQRe-NZdyQ@mail.gmail.com>
Subject: Broken samples/bpf build? (bisected)
To:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Cc:     yamada.masahiro@socionext.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The samples/bpf/ build seems to be broken for bpf/master. I've
bisected it to commit 394053f4a4b3 ("kbuild: make single targets work
more correctly").

I'll take a look, but if someone with better kbuild-fu already had a
look, please let me know.


Cheers,
Bj=C3=B6rn
