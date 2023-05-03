Return-Path: <netdev+bounces-123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 962BC6F5493
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5D0F28108C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA949467;
	Wed,  3 May 2023 09:23:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F10EEA5
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:23:21 +0000 (UTC)
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061EA49CF
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:23:20 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-32b65428489so34121855ab.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 02:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683105799; x=1685697799;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sGQwBgpI0bqdgO8pKEEKbKv8+LeoHbpWth2gSQz7m8c=;
        b=IZ3FEkRfOExshIENXLqJ1Ku5HAlJ/gEUByAzqyH/HDbAOxbO/S2pji8zZyIOH1YHZi
         RGtW/h9sBJsxIlEJsp9hwJbJx7zZlrvtjWm/6nMxEcEOwbZdiC8TtRpJNqwZgT6Yektx
         9ZNqyxZisr2hQfuDhCjMqCRlRDYkbnLQTkMHz0/ADlIdYPD2ZDprfteLOmGg4y5O2KvF
         GbxKNbSDaPM74KTuKEsO4q3GDFSRs+vbEV/WZ2+0G7oXx2/xZyUfchASRy1pr+NQhBYm
         LiQn9JXmbqjZmpOO7DhThXUiEz8GYO47ZLU1sjCXZPctHkJPv+7BgivyytT8qtAMtPmO
         Ycrw==
X-Gm-Message-State: AC+VfDyeBKMEtpDY3/ThtB/+xFSIJqa/xn3ywG7567h+XYOpQH6M/+oI
	r7Dbl6rypqDNPbnMCPK6KYFhV/zez/j8m3AxAHMrY4G8YaPJ
X-Google-Smtp-Source: ACHHUZ5aG/XfDHqoKqO+ew2JWIPDDza1z+e6Rp2DamFuAlgepSexYCvFh5GJosvlwf7Pk/iL0j6gaCeA1MFSQp8enMVfNw4U3owM
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d98f:0:b0:331:2d3a:2cf5 with SMTP id
 r15-20020a92d98f000000b003312d3a2cf5mr3245587iln.2.1683105799342; Wed, 03 May
 2023 02:23:19 -0700 (PDT)
Date: Wed, 03 May 2023 02:23:19 -0700
In-Reply-To: <00000000000090900c05fa656913@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004a34a305fac69bcb@google.com>
Subject: Re: [syzbot] [mm?] [udf?] KASAN: null-ptr-deref Read in filemap_fault
From: syzbot <syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hch@lst.de, jack@suse.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot has bisected this issue to:

commit 66dabbb65d673aef40dd17bf62c042be8f6d4a4b
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Mar 7 14:34:10 2023 +0000

    mm: return an ERR_PTR from __filemap_get_folio

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15220608280000
start commit:   865fdb08197e Merge tag 'input-for-v6.4-rc0' of git://git.k..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17220608280000
console output: https://syzkaller.appspot.com/x/log.txt?x=13220608280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d1c8518c09009bad
dashboard link: https://syzkaller.appspot.com/bug?extid=48011b86c8ea329af1b9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137594c4280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10cfd602280000

Reported-by: syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com
Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

