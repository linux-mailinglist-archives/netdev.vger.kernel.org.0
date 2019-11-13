Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC3AFB595
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfKMQvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:51:00 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33321 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfKMQvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 11:51:00 -0500
Received: by mail-il1-f194.google.com with SMTP id m5so2441923ilq.0;
        Wed, 13 Nov 2019 08:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=NP8j8j6RNWGWdkRYwKycP0G7EVjWhJ/1/S2VtEbTWEI=;
        b=b3bVHkR79gud8RsdtbJsGQ8MipQ93ILczeh4pBu7MsXxWVjLcj8NFcurtsKaR3kxm+
         aBKpFdzkmKz/9MssldZxYRoBWOwEF5ZcAoGS6N5mYr+JoSZFL2tKMnhtuAD9z8lqgNVL
         fuzx9z1mwv1LkyVd+vRqjTDDbAdG5iQP6X8WBfFBIAsrBd9QBqJy/sZ/dOv3nQh9OIk4
         3diUkn+dpk4AvvU1Gtdq35jXzSdoH7s5/JCnRKn3m9R7IJ9/KeMNvthgowPfHkp/KV81
         y2tRDeg6BIsrPBHAyEZtwhynpWMmicOd3IoTqNcz7S8TIXB6Vut8mTeN810GBpOkyLs6
         Frqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=NP8j8j6RNWGWdkRYwKycP0G7EVjWhJ/1/S2VtEbTWEI=;
        b=c4qPnMTzRykJTkrMwPMXpnuSoGmzjiAI63/dPWfovwVEMc0yM7O7TLd+/5wj4Z78Db
         FOOulpzskFidHnE1warXWl6scZLP5veX+Sw4vLX8a6g7x54LOct4nYLLce5J2SzdO5E3
         GmVejK1U0GEm//0pzLtt6qXJTI1SSoBOjEcZYEO9Sla2XzAZ6Y/4wuVK7hNYFn/fRIVh
         O3J+ZnQ4/MO9cJR31EKZuUsp2QCFZAUK4EeiI3wkDz6yQ9OCDtv7UnHQh7Vwb3Rn7vkK
         Nq9pac8oPNTwr7N9n/q7e1Bj22dlNERmz8DXEtR3Oj6aPymx2JTw6PmFy7pMoq/7ytGW
         2N8A==
X-Gm-Message-State: APjAAAXzXrmbzYPN/smkfk26Ci2YVTaNIQe3TM03cBmsJQHO8YJYIsu2
        Hxwm4QL/HIwn5khQUHBTaME=
X-Google-Smtp-Source: APXvYqxidv/3QuJpKi2UYUh97LztfaRik/hvAhPtTgiijuFqBY3yCbYbxLs2pWGM5VdnkKH6Jirewg==
X-Received: by 2002:a92:83d0:: with SMTP id p77mr4821131ilk.116.1573663859473;
        Wed, 13 Nov 2019 08:50:59 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c73sm345713ila.9.2019.11.13.08.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 08:50:58 -0800 (PST)
Date:   Wed, 13 Nov 2019 08:50:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+0b3ccd4f62dac2cf3a7d@syzkaller.appspotmail.com>,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, john.fastabend@gmail.com,
        kafai@fb.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Message-ID: <5dcc346b151ef_65172b2715e085b42b@john-XPS-13-9370.notmuch>
In-Reply-To: <000000000000f90bb30596c1d438@google.com>
References: <00000000000006602605752ffa1a@google.com>
 <000000000000f90bb30596c1d438@google.com>
Subject: Re: general protection fault in tcp_cleanup_ulp
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit 5607fff303636d48b88414c6be353d9fed700af2
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Tue Sep 18 16:01:44 2018 +0000
> 
>      bpf: sockmap only allow ESTABLISHED sock state
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17fdc73c600000
> start commit:   28619527 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       bpf
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8f59875069d721b6
> dashboard link: https://syzkaller.appspot.com/bug?extid=0b3ccd4f62dac2cf3a7d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13537269400000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: bpf: sockmap only allow ESTABLISHED sock state
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: bpf: sockmap only allow ESTABLISHED sock state
