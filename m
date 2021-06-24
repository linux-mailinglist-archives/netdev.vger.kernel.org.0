Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2784F3B36A5
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhFXTPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhFXTPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 15:15:16 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E737CC061574;
        Thu, 24 Jun 2021 12:12:56 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id k8so9188547lja.4;
        Thu, 24 Jun 2021 12:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=/7atguzqhhItG8XdrJ62mcbNoQ36VRJeGV+YKgCt9sU=;
        b=Ii0m3lqDyJ1XwjYg7Sz/GQoNowcispW8Ipwi3EHWqxGUsStw+EXNE1susBEfZCFm0s
         h3EcqosAlXFq3nLJgbw1xxMOu2qLsitVZerQmVIEsVhFj00F18qzJDZ0/+Z0CAJ2N0zM
         OKMx06PR+D+9+tOi3qb69dFjKHy2N56LoL30np74jsPsqJsvqJ4WH8q+xQMAdUtKjzH2
         SxBLH+rqZbn6Kybdp4cZ2ewDCOk2YMNc9gD/35XTzf6uiPmUVGSvb/fe9o/2h/PNEEvV
         b6DbIg5eW2x1eHouZvUu2UMGzdQEjTLazpIY9S35PF6IDn9vpMzyGOV0dPZFDZDfczwg
         naLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=/7atguzqhhItG8XdrJ62mcbNoQ36VRJeGV+YKgCt9sU=;
        b=FzYltm/AlcewJwir3ppf7AM26jWfWDxUpvWNrmowrc/HuyP9YyyRpe9tHi4ZL0bkW/
         MjnflqzXR5ljNKDVTyjDuVAnUqBsMjOwES4a8NiKZtl0OgcRguDkwqCrELoh+xMKnJ89
         7rWDicf6JkXAd9NMRrYU+ik/OAFSqO0lLmyPzWIAFhPvvao4zWlgltRvJYvVzx9NvqXH
         FLIkAtW4FVr9Ab2Zb9QhsiSmq5JAthj7IJbRrUSWjt0FkHmLJq96qitmiYKeStoqQ694
         lMQTYjX4i0hvwNTR+7mdPhB1zibYUjnxq1FpRtw9/UFCaxGA3Za62c+5F5yL+SfpNqaK
         /9Cw==
X-Gm-Message-State: AOAM53327wszrO8byvJBO+97Phdm2Gx+6kreo9KKNgTV1xmwXKXTsk9E
        oo9rpCZSvEJT0wBVzVKLaCE=
X-Google-Smtp-Source: ABdhPJwmRipjVAHUYvxGPDT5E/TdxhsoEMvZI7jqMSPI6rsh05Q3PQOQqrO8fSRII00+Oqagmtp19w==
X-Received: by 2002:a2e:5c41:: with SMTP id q62mr5037717ljb.254.1624561970827;
        Thu, 24 Jun 2021 12:12:50 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id br36sm299691lfb.296.2021.06.24.12.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 12:12:50 -0700 (PDT)
Date:   Thu, 24 Jun 2021 22:12:44 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in xfrm_user_rcv_msg
Message-ID: <20210624221244.3529b808@gmail.com>
In-Reply-To: <0000000000003f0bbd05c55f7511@google.com>
References: <0000000000003f0bbd05c55f7511@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Oo1lbU9EAqYk9DYcvoe1BdC"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/Oo1lbU9EAqYk9DYcvoe1BdC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, 22 Jun 2021 12:04:23 -0700
syzbot <syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    fd0aa1a4 Merge tag 'for-linus' of
> git://git.kernel.org/pub.. git tree:       upstream
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=17464aa4300000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=6ec2526c74098317
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=fb347cf82c73a90efcca syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=14946548300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d28548300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit: Reported-by:
> syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com
> 


#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master


With regards,
Pavel Skripkin

--MP_/Oo1lbU9EAqYk9DYcvoe1BdC
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-net-xfrm-fix-memory-leak-in-xfrm_user_rcv_msg.patch

From 6c124b1a50375215dcb6fae3f443a70340af1d47 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Thu, 24 Jun 2021 22:10:25 +0300
Subject: [PATCH] net: xfrm: fix memory leak in xfrm_user_rcv_msg

/* ...... */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/xfrm/xfrm_user.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index f0aecee4d539..ff60ff804074 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2811,6 +2811,16 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = link->doit(skb, nlh, attrs);
 
+	/* We need to free skb allocated in xfrm_alloc_compat() before
+	 * returning from this function, because consume_skb() won't take
+	 * care of frag_list since netlink destructor sets
+	 * sbk->head to NULL. (see netlink_skb_destructor())
+	 */
+	if (skb_has_frag_list(skb)) {
+		kfree_skb(skb_shinfo(skb)->frag_list);
+		skb_shinfo(skb)->frag_list = NULL;
+	}
+
 err:
 	kvfree(nlh64);
 	return err;
-- 
2.32.0


--MP_/Oo1lbU9EAqYk9DYcvoe1BdC--
