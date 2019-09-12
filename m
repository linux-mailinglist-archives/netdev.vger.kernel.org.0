Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910AEB156D
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 22:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfILUac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 16:30:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55075 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfILUac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 16:30:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so346312wmp.4
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 13:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rMpdmvZq87azW7dCXHOKxTnknBr662E++HF5oLD5YCM=;
        b=mRPk4TF8KdljzoYYhB3LdTfGNzlho2wZA5ZO1QaCresg8lX6eQ6CrsjOTGGxYakUVG
         lCXXo/GOyjpjHSDdtqcTdHbr/VTNZDjF5gBUAw3pN95aN/Sbcr+GBwvYk3Yk2/KweKyG
         HgRXeKLS6y7R2xTMItolzFRi+WBGSDyNvojXiX+a11Z783qkVxj9i95fv6EPp6p79YzB
         Q2PoazMPNMLb5gzZhby2ff8jCd4XdtknOTLeG3KhK6Nmt9vDb85ywXxvqmVTKKvttc5r
         VkwzyoRnEON+6fnhLhj2Gz8KawtTnKVFVaCbvh8kHOc8ELlWwQUYoTqS54PrvL0rWmfg
         Yq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rMpdmvZq87azW7dCXHOKxTnknBr662E++HF5oLD5YCM=;
        b=acpTx7Gwp7Nx4zXOebhPBDjFB/gqB/i9nFKpb3jszXAAd37dBaxohH98C1rg08msdX
         IN/axCIAMMjz5cLcMlQnD8QH3cEUBE1d1Z+nzVnT9hL+oN0W7iIR289ueVmcKNgJH9Lr
         fDstswMO6uX/YJd/QBkVQZqVQ6HdAqiNuwLrupSmYPpgwQu6UHuevknTFj8rczFGMuJK
         C+R3grAVOMZDyqJGJNSDHQtAYx1GvqWn/dFNlc9LCj+5aDHpFoad2cIXQa/dxhfGhrZw
         pqGEn680RxMXcIntflhyOsYR+Ar4X5RWHg9SUAvJRyJnzy5ak97jyBaXcPqqJO5DJf0S
         wIWw==
X-Gm-Message-State: APjAAAWQCE3BTVjaPqpCqWm24vGaEPPkhRPdClWaJ/rT6qWxOFFzsRWe
        DipYT9Vja6V73qkfa8HScy7rEw==
X-Google-Smtp-Source: APXvYqwn8t4YvLH7RrhGUWTi+HiVoWFPhkrbj/FofBee/Hd/kfpHcZNS/KXJQzVkcs0Hh8rADSxZJg==
X-Received: by 2002:a1c:608b:: with SMTP id u133mr342904wmb.27.1568320230488;
        Thu, 12 Sep 2019 13:30:30 -0700 (PDT)
Received: from localhost (ip-213-220-255-83.net.upcbroadband.cz. [213.220.255.83])
        by smtp.gmail.com with ESMTPSA id k9sm47723885wrd.7.2019.09.12.13.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 13:30:30 -0700 (PDT)
Date:   Thu, 12 Sep 2019 22:30:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [Patch net v2] net_sched: let qdisc_put() accept NULL pointer
Message-ID: <20190912203029.GA2330@nanopsycho>
References: <20190912172230.9635-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912172230.9635-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 12, 2019 at 07:22:30PM CEST, xiyou.wangcong@gmail.com wrote:
>When tcf_block_get() fails in sfb_init(), q->qdisc is still a NULL
>pointer which leads to a crash in sfb_destroy(). Similar for
>sch_dsmark.
>
>Instead of fixing each separately, Linus suggested to just accept
>NULL pointer in qdisc_put(), which would make callers easier.
>
>(For sch_dsmark, the bug probably exists long before commit
>6529eaba33f0.)
>
>Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
>Reported-by: syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com
>Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>Cc: Jamal Hadi Salim <jhs@mojatatu.com>
>Cc: Jiri Pirko <jiri@resnulli.us>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
