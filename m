Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637C2ACB79
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 10:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfIHIJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 04:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbfIHIJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 04:09:41 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B72E27F770
        for <netdev@vger.kernel.org>; Sun,  8 Sep 2019 08:09:40 +0000 (UTC)
Received: by mail-ed1-f69.google.com with SMTP id p55so6228819edc.5
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 01:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eYFTiHf/XJXqQbMZlPea3bsAkOt7XEdKyhE6qPAWNsg=;
        b=EoWoLdMx5+UfPwzH18x8FCBlGMlzBdZlWinZsjeOpajkIw3wjVs7cTFVzRBTEIYP3I
         Xjbd8jAmLnpNUBfh5cYi2/3+bEGZvHuDOrtp3SbKgm7v6vn8fFgpJVDKMfHMrVdq8pI7
         bwDjEetJazzNrn3wrcL781uqs+Sk/uDznQTBzn1X0NLIMeBKPaH1+NkOqOxIyYbwjE7i
         eh2XgwT6pvuDpB61+KbyHuCruAhYWPcmFyNqKdawtJVp09bxN0k0dBhPrZJm7JmYvDh6
         O8PJXf06dbD6exdopteDmuUzF/YK0YQMCkrQK5f1AFNE8+7khW0foYFRCiepnaZqAv4a
         gjGw==
X-Gm-Message-State: APjAAAXYMITWv8HDE+C8A7SuBpYD1RmIS80aDiDI871W9u9k59Awk1Lp
        qtN2wOx+L+fMCZYPZueYM/j38IrEBTS4HQunxw7yZR5K1CaHLYkOVqhWAXWOScsjxMLvgwZh7qD
        OSWPPvhYshrJyeGNh
X-Received: by 2002:a17:906:76c2:: with SMTP id q2mr1658969ejn.202.1567930179444;
        Sun, 08 Sep 2019 01:09:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwHA56+C9ZKSxLmAb35dVK17bzKlARRPPqRVLX7NY0XVW6IGQQH/QBjDd1sdygu9mlI2xFaUA==
X-Received: by 2002:a17:906:76c2:: with SMTP id q2mr1658943ejn.202.1567930179213;
        Sun, 08 Sep 2019 01:09:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id t22sm2339811edd.79.2019.09.08.01.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 01:09:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C1050180615; Sun,  8 Sep 2019 09:09:36 +0100 (WEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+4e7a85b1432052e8d6f8@syzkaller.appspotmail.com>
Cc:     alexei.starovoitov@gmail.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, jbrouer@redhat.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: general protection fault in dev_map_hash_update_elem
In-Reply-To: <20190908030726.7520-1-hdanton@sina.com>
References: <20190908030726.7520-1-hdanton@sina.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 08 Sep 2019 09:09:36 +0100
Message-ID: <87v9u3w6nz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> writes:

>> syzbot has found a reproducer for the following crash on Sat, 07 Sep 2019 18:59:06 -0700
>> 
>> HEAD commit:    a2c11b03 kcm: use BPF_PROG_RUN
>> git tree:       bpf-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13d46ec1600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=cf0c85d15c20ade3
>> dashboard link: https://syzkaller.appspot.com/bug?extid=4e7a85b1432052e8d6f8
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1220b2d1600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1360b26e600000
>> 
>> general protection fault: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 10210 Comm: syz-executor910 Not tainted 5.3.0-rc7+ #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
>> Google 01/01/2011
>> RIP: 0010:__write_once_size include/linux/compiler.h:226 [inline]
>> RIP: 0010:__hlist_del include/linux/list.h:762 [inline]
>> RIP: 0010:hlist_del_rcu include/linux/rculist.h:455 [inline]
>> RIP: 0010:__dev_map_hash_update_elem kernel/bpf/devmap.c:668 [inline]
>> RIP: 0010:dev_map_hash_update_elem+0x3c8/0x6e0 kernel/bpf/devmap.c:691
>
> Fix commit 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking
> up devices by hashed index")

While this minimal patch does fix the bug (as Jesper already noted), I
prefer to rework the logic instead of just repeating the lookup; a patch
is on its way :)

-Toke
