Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224CF38F3D0
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 21:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhEXTq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 15:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhEXTq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 15:46:27 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EB8C061574;
        Mon, 24 May 2021 12:44:57 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id i9so42277590lfe.13;
        Mon, 24 May 2021 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=zqlrchvvqCsTrFmlJhUAi12gOeUJWgIppgIsyXSVTpY=;
        b=OhlnZ9Kk1ghblTrWgWAgCeF7V5CrdD4whtNabCaf7TID10C2a56GrB7C7uCaj2zDoT
         c9ZR7MIeLMmB6hjkU9MJYaAdMnqzz8wQ2SSC2A4coI7vdIrVm8mB1WVTq2lT3ZnGnCuz
         M5GUt6vLd1xRjIMsTHFhe2ws9vkQ6exaknek4xBxI0L4s4E8x5mydkR6R24RzKyrZ8VN
         TokAFBQ7nJquUHdBFGyMDV+EqLlqKY15804xCj1CFmoyP2m/JHwkc5OBjfRgsa1Ls0aN
         9WLzP8jwLJmMnlyeiWXxeKXfrG54VZBdHzhqWcZugz+e5Zxg/k6WBjB0CigRmUAgjyFd
         3EUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=zqlrchvvqCsTrFmlJhUAi12gOeUJWgIppgIsyXSVTpY=;
        b=FIvNoRbYo73+yPspICuUR7qv7yQN5ChqncqGc4xQl0akaO0mLBAAc6d3papmN/cqKg
         1PRCeni24O4NHpxVDnOfYF++ITDOVh4CnZLXlQxSrrhQUABVD43cmTS+taMP6RaWcSoP
         cUv8NzUvD5pvxVExn7gynoGG91Y1JPMIIJUkZvla0/I6ua+84DYA3A4qVAuy5kwO5eh7
         iKL03PPIBlL5wMZz5oPNKF+XzyF0iDhUb1zT5gjdT6KzHR4aQFUNan+ESKfeh3FbokzC
         o7Vn4bNFCpkxyXRQ4jt11xO9XpNLzp9eIAE3u5r83vFNFNcV1RTgK3WONZp4/wlawxgs
         atAA==
X-Gm-Message-State: AOAM530V79cUAOjtCt4QRSf5tAdRHRxaiqquBBl1u3ofSA6yTkYdkl3o
        8p/BlwSy7K0wuQU7LML9JE4=
X-Google-Smtp-Source: ABdhPJzPzx1BqfelUKMxzmtASz9PY3dMcvzNyGS962wDNTjuymE+WGOWUqZr67RfaJvLfL3CcVmHfg==
X-Received: by 2002:ac2:5146:: with SMTP id q6mr11076045lfd.558.1621885495820;
        Mon, 24 May 2021 12:44:55 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.209])
        by smtp.gmail.com with ESMTPSA id m4sm1955830ljp.9.2021.05.24.12.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 12:44:55 -0700 (PDT)
Date:   Mon, 24 May 2021 22:44:49 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in smsc75xx_bind
Message-ID: <20210524224449.544eab2f@gmail.com>
In-Reply-To: <000000000000dda06805c30fce63@google.com>
References: <000000000000dda06805c30fce63@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/JcayGBPNRVSZ/fjmuC09Ga="
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/JcayGBPNRVSZ/fjmuC09Ga=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 24 May 2021 02:12:26 -0700
syzbot <syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6ebb6814 Merge tag 'perf-urgent-2021-05-23' of
> git://git.k.. git tree:       upstream
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=1334afc7d00000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=ae7b129a135ab06b
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=b558506ba8165425fee2 syz
> repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ca4a35d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit: Reported-by:
> syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com
> 

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master



--MP_/JcayGBPNRVSZ/fjmuC09Ga=
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-net-usb-fix-memory-leak-in-smsc75xx_bind.patch

From a93ac5c6364b739f96448613d1bc196c11adf61e Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Mon, 24 May 2021 22:36:42 +0300
Subject: [PATCH] net: usb: fix memory leak in smsc75xx_bind

Syzbot reported memory leak in smsc75xx_bind().
The problem was is non-freed memory in case of
errors after memory allocation.

backtrace:
  [<ffffffff84245b62>] kmalloc include/linux/slab.h:556 [inline]
  [<ffffffff84245b62>] kzalloc include/linux/slab.h:686 [inline]
  [<ffffffff84245b62>] smsc75xx_bind+0x7a/0x334 drivers/net/usb/smsc75xx.c:1460
  [<ffffffff82b5b2e6>] usbnet_probe+0x3b6/0xc30 drivers/net/usb/usbnet.c:1728

Reported-by: syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/usb/smsc75xx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index f8cdabb9ef5a..b286993da67c 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1483,7 +1483,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		return ret;
+		goto err;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1492,7 +1492,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1502,6 +1502,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
 	dev->net->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	return 0;
+
+err:
+	kfree(pdata);
+	return ret;
 }
 
 static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)
-- 
2.31.1


--MP_/JcayGBPNRVSZ/fjmuC09Ga=--
