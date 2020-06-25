Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EE12098B2
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 05:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389585AbgFYDBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 23:01:13 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37278 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389500AbgFYDBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 23:01:12 -0400
Received: by mail-il1-f199.google.com with SMTP id x23so128790ilk.4
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 20:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wKHziB1HTjinXOROzU9x8QSF9UVTTl5CGULxlu3fS2A=;
        b=eRR5+ehI6V9GmTCpfytN2ODcv/cdNPyqk9swliyf1d9spy6qd8GZxZMIzaUu9MYlV9
         M5Arz+VUmSl6FujpUuRk/Lxtss6us0I84qNZZpikmk0yirkGxE6y63w0w2kYgquq7su0
         OizgsWf2dQCscj9kPmF8FgJN7K407ft5KEcMPVCCSOopSSi6ubJl5CqJy57foQIcgUJP
         i9RhHoWBaQkJsjA/5Ph9KgXXITGJUYgt0b9M9pwfccYmVv30QIyDv53L2FHWNFxjkSHd
         f3uydIpbF/sLIL9dkxNVV6anAcbVGO/l80eP1FO/hbIAG6gsuQQUkov9NJEoKJhypaK0
         +iCg==
X-Gm-Message-State: AOAM532IA5asGR727RoLpuaU1I5T2TS9MLZJUFDJKzkVZjeD5Y7JDcjY
        I3iK7VupYCGvVOKR0dAmg41LGvN4tWMkpfd10NRymMPgRWm/
X-Google-Smtp-Source: ABdhPJxbs1SAyL/M/fgk3l40cIJl7wJzsJfAm+GKPt/0zA1RuUK6bKXZkytrERisRhBiK2xMcbSQIrQom47jw0jbMN8Qdv/m0rQo
MIME-Version: 1.0
X-Received: by 2002:a92:290b:: with SMTP id l11mr31731641ilg.145.1593054071282;
 Wed, 24 Jun 2020 20:01:11 -0700 (PDT)
Date:   Wed, 24 Jun 2020 20:01:11 -0700
In-Reply-To: <00000000000047770d05a1c70ecb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006e0ff05a8dfce2d@google.com>
Subject: Re: KASAN: null-ptr-deref Write in blk_mq_map_swqueue
From:   syzbot <syzbot+313d95e8a7a49263f88d@syzkaller.appspotmail.com>
To:     a@unstable.cc, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        bvanassche@acm.org, davem@davemloft.net, dongli.zhang@oracle.com,
        hdanton@sina.com, jianchao.w.wang@oracle.com,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug is marked as fixed by commit:
blk-mq: Fix a recently introduced regression in
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
