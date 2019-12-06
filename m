Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E66B1156DD
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 18:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfLFR6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 12:58:53 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44542 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfLFR6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 12:58:52 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so5884503lfa.11
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 09:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7NoV/MZ+gAAoZ3Ywqfb6WiDTdgr5NlWMlKnaR0k7Lzk=;
        b=xPIWUQdV5LzJHwy1Das6+ElrkvtWT59j1TuYG5c0CnFe8LLvlFSbV1AtTFeH0eWFXm
         2HnkXvu4+LhaB/Yyc6Ebd3e9DMzQ73EOBA1BaGU3IKNO1wb/NW4fMm1QBsghglhTDEsh
         aXfN2NpslfWhdWrWWlqkiLSCx3qcUFW4tLvoU2mPH8fARaN/V9jIpo9b7v4OnPr5RxMY
         Kd7JixMDVB6cbCQF91N8w16hdQxNpvwTU7Aq9EhAY4NyuLPEXBLiEWN7kTZ0ZZaTyRpE
         fh+15LYfm2UTLuQdzbkGChhYwzZWsUZHpcmFNXb8TTHSPsKoU4uMeGzaLsOW6cZNteyT
         A7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7NoV/MZ+gAAoZ3Ywqfb6WiDTdgr5NlWMlKnaR0k7Lzk=;
        b=Y6bI2exaHXobSXkaalTqv6hJlZO1rS1WmSZsCY6aFbtdnkczYB9+7nqO93xTjCBCEi
         r4bsm4YigxGy2cHqg/OqhqScmhC+SDQGBXwI+MF0XeMS/dHMyfolszLq9l9GsAA/PWAi
         cz9inepI4VICToeF+05/bCEU1klfRcobAUWSAUHS5OPBjoFmZOu4LRXlinPCs2l7exh2
         2AJB3VKrtuqVGlLYiRBAcguknnapZzHFBuZFF1hmu8kxdd/FQ8wT6QNRvFF/r1e1c5wZ
         LbNU/zCBULTzRd5h7XsoApmEyMFsNVTd6c2VAd2YT5jB9F09rP0sQzm8aulLcJW4Ue8u
         ahWw==
X-Gm-Message-State: APjAAAXI/eO0IQu6WMHcT9GHVo9FGLJUVKxL0LHKIHfvWke8oUE1js5E
        OM3snZyFupimJQusIzL4WNR8oA==
X-Google-Smtp-Source: APXvYqxjLx+wuStYVrUdLvIoHiJhniLWG67QUZ6v3B2GX1ZIkBURojsq0dmiv9FisfdZMreI2xy4vw==
X-Received: by 2002:a19:84d:: with SMTP id 74mr8623455lfi.122.1575655130609;
        Fri, 06 Dec 2019 09:58:50 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c9sm5959949ljd.28.2019.12.06.09.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 09:58:50 -0800 (PST)
Date:   Fri, 6 Dec 2019 09:58:39 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+5013d47539cdd43e7098@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, dirk.vandermerwe@netronome.com,
        edumazet@google.com, eranbe@mellanox.com, eric.dumazet@gmail.com,
        john.fastabend@gmail.com, kafai@fb.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Subject: Re: kernel BUG at include/linux/mm.h:LINE! (5)
Message-ID: <20191206095839.29d2024c@cakuba.netronome.com>
In-Reply-To: <000000000000fdad650599064dc5@google.com>
References: <00000000000054cc6d05834c33d7@google.com>
        <000000000000fdad650599064dc5@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 06 Dec 2019 02:14:00 -0800, syzbot wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit 9354544cbccf68da1b047f8fb7b47630e3c8a59d
> Author: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> Date:   Mon Jun 24 04:26:58 2019 +0000
> 
>      net/tls: fix page double free on TX cleanup
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ebd77ae00000
> start commit:   9e9322e5 selftest/net: Remove duplicate header
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=47f2db597668ac40
> dashboard link: https://syzkaller.appspot.com/bug?extid=5013d47539cdd43e7098
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148763eb200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1416ff3d200000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: net/tls: fix page double free on TX cleanup
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: net/tls: fix page double free on TX cleanup
