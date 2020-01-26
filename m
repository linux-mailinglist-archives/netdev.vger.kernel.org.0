Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29888149C71
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAZTMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:12:15 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35928 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZTMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 14:12:15 -0500
Received: by mail-pl1-f194.google.com with SMTP id a6so2957759plm.3;
        Sun, 26 Jan 2020 11:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eP6xMoPCig2/HzkgQ7KOnjUmZ+p8+wvhn5hX2zOjjeI=;
        b=vJwVt3b57kFu5gNuJb+7ttUR6qGyMQ5iw1r6HV2O68DlNYyplzRE6JOy5GsnpEIq7n
         4HwNloKOo6FiprGjbebs3iUAellkI7dT++WNXHKT5vEkBeRPFPfPTwb92BWWffXHyqLs
         vxX4qoRure/aUATJjiSh+nx1eml3uDGAZOQCyB6c5NUVzNMOU9q6/GQDlp81AvwtUmDa
         JISrjaZI4JjFmKWpgcMNxSNcs6Olq9clFswQlE+ya6nSUPKBFcL17lQpNz4bSKl4pP3b
         dTGIYCTK+kNRGrXDmjA335AqAipndzxbIEKXPfgveWWjXZ2ggLI/4LfII/pQqtEuHwql
         WN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eP6xMoPCig2/HzkgQ7KOnjUmZ+p8+wvhn5hX2zOjjeI=;
        b=KSTf/sL0SY50EDo7rLTMG+GAQujlxQt1YYtZF74DYQzyD5v33Xvt2yA3xt1j+Ey0H0
         0Idy1coIj8SS0c7qibcpB844zH0qA75yw3RbgVquE5LkWSOdxtOg4s3xeVkGCG0hGpNi
         AeBaJ3wxWi/STwZ4B5MxvYVG8Ici8xCimWtSVGWDQcld375t/k+MsfMTndd4OuTaKGcH
         mstxVJ3eD0DaA85UVBMWRgLY61Iy/k/K7QrjVr9GBcqlIgESt4LbYmEok+/D/kklQRRs
         MQpHP74y90S1gXjVvE6CwVfqhyALKS2O32dOQ68TY4Hr01E9ROCaMDzdX2NRmttZJbNV
         +dUw==
X-Gm-Message-State: APjAAAUJfvTSVTMASjE2TC/G3/16deNqp+cpt4JQZaULidHdVEOP8zTv
        6mS1Uy83mDqJMWl3ni78lKk=
X-Google-Smtp-Source: APXvYqy2Qxg7EZY/r53BdOkTqJYTylNzR69cnHzV8CoK0eVKOoCnabV6VSSIkxFvPCSwFsBNgToqHA==
X-Received: by 2002:a17:90a:c981:: with SMTP id w1mr9197251pjt.129.1580065934239;
        Sun, 26 Jan 2020 11:12:14 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id hg11sm13064978pjb.14.2020.01.26.11.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 11:12:13 -0800 (PST)
Subject: Re: INFO: rcu detected stall in addrconf_rs_timer (3)
To:     syzbot <syzbot+c22c6b9dce8e773ddcb6@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
References: <0000000000003021ea059d0c98b4@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7f746a56-07d9-282d-02b6-1724350b90b7@gmail.com>
Date:   Sun, 26 Jan 2020 11:12:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0000000000003021ea059d0c98b4@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/20 7:25 AM, syzbot wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit d9e15a2733067c9328fb56d98fe8e574fa19ec31
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Mon Jan 6 14:10:39 2020 +0000
> 
>     pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1625d479e00000
> start commit:   a1ec57c0 net: stmmac: tc: Fix TAPRIO division operation
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7159d94cd4de714e
> dashboard link: https://syzkaller.appspot.com/bug?extid=c22c6b9dce8e773ddcb6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168e33b6e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178c160ae00000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

This sounds legit.

#syz fix: pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
