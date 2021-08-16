Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8880E3EDEF7
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhHPVFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhHPVFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 17:05:30 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B9EC061764;
        Mon, 16 Aug 2021 14:04:57 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id c24so37024753lfi.11;
        Mon, 16 Aug 2021 14:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=qgWuFVDRT4OUjF2IBMPSEIvHlIqy9JyfPdGRKPLOLHA=;
        b=SCxFDdHiNYq8A9cXDiWKQeVjFJHsHiOsGnoPuIj7jvPMLWbpN85CLnLEBqPG2j6gLc
         dR8BYqtBfOOSt8DcueYseq1qyCcFSeCGOb+q9K8K7j7DdGuaYfXt9dWZQ8i1E7b9+YZd
         24CeRwcExZSdasO9rBcb4/TZxEXYeBI9yqDg1FR/K5bXHFbyby1CaY17UsLBRJV4ckmA
         IvmA06GZNps7zJtDopbpvAhMA8iyMzjARigcLX1YPcqOyA0vDxQJ3rrPSrDKeiltrCpf
         WsoG9UfrrzMiyr3MXp7pvedfIpaXY9wkLjX800fVbqUKPbi7kkxggDBbNFmbjtUNWCI0
         B4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=qgWuFVDRT4OUjF2IBMPSEIvHlIqy9JyfPdGRKPLOLHA=;
        b=ZHCJ5BHEe1sqb/9mO/uVUTWvCpssHpu4WJcN8Kwx1QZNgq+QnhLYDC1uhEjp0lLzX0
         d0NwVsNdQ8WntxVxCWBAPdnhEw0fEAHEKSyYGCcnsDzJ0Kgo38WbQI34NX7CV73f7ZlJ
         WicEZ5QeIK6CWnz+vCVQqAloQlKnA1OBiFlhafmjExVtUUKScRyzg/Zws6zPFmtfPWpG
         9Gnu+1idf5EBbnHayo0TOKdQH2fgLNnFU/YZYEBGFhq6uDB39YTdY/YsYLHsdzUAud91
         DO2vH6kvm/hKZnoDYE8G6En1hzc0copi7+RUmSO7R+MQ1OArsiOFSuDxkXRLhgPLWzim
         LvMw==
X-Gm-Message-State: AOAM531mbScuqsYpJTfa0fEvPSFSXQAyNTKFbCCdNoyPvbiaFwOhVf1/
        7DYuPlnp6gY6Uhed+F2esao=
X-Google-Smtp-Source: ABdhPJx/k1fwWiFCDf8nfgLXSNmRI6Sb0u3HD1zFlz5Ph96HsZqdoIdb4zxFjMiwtM9MLb0XYRoLTw==
X-Received: by 2002:a19:7603:: with SMTP id c3mr188506lff.543.1629147896117;
        Mon, 16 Aug 2021 14:04:56 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id b6sm2219lfv.167.2021.08.16.14.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 14:04:55 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in hci_req_sync
To:     syzbot <syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000027061b05c9b38026@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <04cbd217-21d2-c623-2d06-35d6040a3479@gmail.com>
Date:   Tue, 17 Aug 2021 00:04:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <00000000000027061b05c9b38026@google.com>
Content-Type: multipart/mixed;
 boundary="------------1F033F9083733B0C5330BE2B"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------1F033F9083733B0C5330BE2B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/21 12:01 AM, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> net/bluetooth/hci_core.c:1346:18: error: 'HCI_MAX_TIMEOUT' undeclared (first use in this function); did you mean 'HCI_CMD_TIMEOUT'?
> 
> 
> Tested on:
> 
> commit:         a2824f19 Merge tag 'mtd/fixes-for-5.14-rc7' of git://g..
> git tree:       upstream
> dashboard link: https://syzkaller.appspot.com/bug?extid=be2baed593ea56c6a84c
> compiler:
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=145874a6300000
> 


Woooooops, I forgot to build-test after define rename.

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin

--------------1F033F9083733B0C5330BE2B
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Bluetooth-add-timeout-sanity-check-to-hci_inquiry.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Bluetooth-add-timeout-sanity-check-to-hci_inquiry.patch"

From b03640e820c7cd3d577e3e472a61a9a7e64a4305 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Mon, 16 Aug 2021 22:52:29 +0300
Subject: [PATCH] Bluetooth: add timeout sanity check to hci_inquiry

/* ... */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 include/net/bluetooth/hci_sock.h | 1 +
 net/bluetooth/hci_core.c         | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/bluetooth/hci_sock.h b/include/net/bluetooth/hci_sock.h
index 9949870f7d78..1cd63d4da00b 100644
--- a/include/net/bluetooth/hci_sock.h
+++ b/include/net/bluetooth/hci_sock.h
@@ -168,6 +168,7 @@ struct hci_inquiry_req {
 	__u16 dev_id;
 	__u16 flags;
 	__u8  lap[3];
+#define HCI_INQUIRY_MAX_TIMEOUT		30
 	__u8  length;
 	__u8  num_rsp;
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e1a545c8a69f..104babf67351 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1343,6 +1343,11 @@ int hci_inquiry(void __user *arg)
 		goto done;
 	}
 
+	if (ir.length > HCI_INQUIRY_MAX_TIMEOUT) {
+		err = -EINVAL;
+		goto done;
+	}
+
 	hci_dev_lock(hdev);
 	if (inquiry_cache_age(hdev) > INQUIRY_CACHE_AGE_MAX ||
 	    inquiry_cache_empty(hdev) || ir.flags & IREQ_CACHE_FLUSH) {
-- 
2.32.0


--------------1F033F9083733B0C5330BE2B--
