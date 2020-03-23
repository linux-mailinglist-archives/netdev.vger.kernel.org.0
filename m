Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3F418FBA5
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCWRjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:39:07 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:37468 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbgCWRjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:39:06 -0400
Received: by mail-ot1-f48.google.com with SMTP id i12so14278767otp.4;
        Mon, 23 Mar 2020 10:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dD9qGn/FmD1rIVTC9XP6vGVct8WmBBkX3v6FBswGPLo=;
        b=THXfYa3e6ysgx56bVbZpmupyp0Ih36h05qzY94R5KTQAHDQ3WB+re4Cb0Ty/PAT5nY
         LcowIYaX7nnuvC1EEnzTwl31LTuJHtIK4zj4HRTGTICWr99w69jT/H3W3NmkgZn5oOqo
         /9F8BVRY8+SQsCB5CcCVZ9GuOk3Q69p6f1gU8/3YzpUwyv+YKwBQApQDJfy8tO0GKsPO
         i8xuUh0W6mNuXfDorGeuqo/WMhujS/eLb/1IrwnGnulz8ZRE6p1tBpJwUT4kyWKwgDUF
         XwslHHCpbsgKM8jqe6iupr31Pm8iovMzwxzAxIZttUUWaU8TvGkiBsQuLzXBwa9lFfE1
         oPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dD9qGn/FmD1rIVTC9XP6vGVct8WmBBkX3v6FBswGPLo=;
        b=HeP61D+hZYsyQOfShDXlqiwdWE+TvgKtI/ZEWhtHvLNah7FRIRawn6jp4PDqOhfope
         WqHSAUYGN9KV6vhtjsglSgXFA/vbCZFFGIh5TKpgp2DfhcrpunSxt8H2KdRqdOoCfxG4
         klzoOS0N7ERhT67BNvP5C3E/mkQuxVsZXjDO4isT/D+hlbt/dovOrJo49wgQa5EFjMcl
         hyJmIb0vzQ9Qjprh5Ap/p+ZGSwr6Xufw65hgGfGGG+m7BIO/rrdaDX8LWwDYbt0N/Qfd
         splQcqXAZynM0Wr2D03vzh+aBJ9XEJVTVyh8ay/sgBFGBqqc1teRPAIMWVygmY6lri6A
         pWkg==
X-Gm-Message-State: ANhLgQ3675cPwdjUeP9o4uTETyu2IOmYU+aZBaD87af8421mGxYzU3NI
        +RGz7G1OrBIuvmmxG2KitU9HU7Ns7pS1g2XNDVc=
X-Google-Smtp-Source: ADFU+vt09Bb6TZc4dAiUj2Yj1Ykjp5oxtvNzfnZBIcbKFT3ggFudWr7fyO8Qfcocz929/9D2y6WanTdMdQppixdYBBA=
X-Received: by 2002:a05:6830:1e96:: with SMTP id n22mr18243768otr.189.1584985145809;
 Mon, 23 Mar 2020 10:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000088d4fd05a182e5c9@google.com>
In-Reply-To: <00000000000088d4fd05a182e5c9@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Mar 2020 10:38:54 -0700
Message-ID: <CAM_iQpU+ins6nTYbAdhwiGjaGj0NOdKAk36uKaehwr8T26mgHA@mail.gmail.com>
Subject: Re: general protection fault in hfsc_unbind_tcf
To:     syzbot <syzbot+05e596c4433eae36069b@syzkaller.appspotmail.com>
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
