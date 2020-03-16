Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59BB187298
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 19:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbgCPSne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 14:43:34 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:34270 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732266AbgCPSne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 14:43:34 -0400
Received: by mail-oi1-f171.google.com with SMTP id j5so2928121oij.1;
        Mon, 16 Mar 2020 11:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dD9qGn/FmD1rIVTC9XP6vGVct8WmBBkX3v6FBswGPLo=;
        b=qPklYHLCneQYnLnLAuHPk57rpDZzsWz3K6SRFn0fDVDZdvkVpEIjhBlAovqQ8qj7dZ
         ONYunPZVW5FtWoTjGOewUBWS9c1Xv3Lt1wXpN962S6A14Wq5yFrYwAcj4ndbl184pCB+
         FYTgghoVLHXlZMM3GcGvhA+ffX1uERgpxLu28bHRHiRFnQkhaOgsKtNrq17wK8+X972n
         eBC0+0Ytn4ofjqAsih3uh6ohGrUDSvZDyZDC2faoEmkWeuJISLCgiTf4iapzsBKQl67R
         HDklMmukED5HY98AxqPNTsC50ZjnYDnZOS3DJkzUdBVPTJUlUiO4/xLkbsjd3KA6suXP
         j8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dD9qGn/FmD1rIVTC9XP6vGVct8WmBBkX3v6FBswGPLo=;
        b=b4bd/uKPnhYt2pAX+xwmDScrwCn72O6/24R90ku8hpEUaiAP/Pef1CVW/4Ig3qx4kq
         NMqI5nHcrfzqtjfyEG1SlkhVIrSYFcZT+8FV0joS0ST/+7iC5tjfncKw9ap2m4/rkxJE
         d0AKa/tzTJzRA1ZNVj8uOTEnyqVR8gh91FILBQZumfya2iOO2H85gWOlm9aaEQvONwJq
         EZaPo1e6pCgufPEnRBq5rfNc6AMWPJPDQu52B8kd9RMZE1rSFobYlQ7jsKzkt23LN2mk
         e62niiEa8t//eQGMZoa0VnTzFz+mg+/zCf+8F6kLQiXK7f77NFBCwI1BvLQ5ASy0ygmP
         wKfw==
X-Gm-Message-State: ANhLgQ2P45KDV1b0PMy0D7SYpfbXmGbn+Hiu1JNh5vfbBwGO7AhRXbZ9
        oLiP6Qv/cFQRku5uM8PHlrhxzMrZniiePeh/RmQ=
X-Google-Smtp-Source: ADFU+vs9PPuyakBZRDZ95842Gfc1Ru01hW25AAJ8x+JdGIb+qZf0HycyTBcYTeePqJrZ51D8F7502G9bz/IHL9vD5WI=
X-Received: by 2002:aca:ecd0:: with SMTP id k199mr729813oih.60.1584384213857;
 Mon, 16 Mar 2020 11:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000061573105a08774c2@google.com>
In-Reply-To: <00000000000061573105a08774c2@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Mar 2020 11:43:23 -0700
Message-ID: <CAM_iQpUe0ofTrSHeWMTSd8nf01pBzBanZk51mcNpwHYz-=MDSA@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in route4_change
To:     syzbot <syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net_sched: cls_route: remove the right filter from hashtable
