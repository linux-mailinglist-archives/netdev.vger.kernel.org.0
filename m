Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93152180D35
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgCKBJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:09:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33134 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCKBJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id r7so2008438wmg.0;
        Tue, 10 Mar 2020 18:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mTevPPqt7Byz2iW4VlqfulQbF215jKF3/le85wzWr0I=;
        b=YKuENWRK693BKjcrL/rIXIj1DEo5ifJVAOc/OhV9wHm8biVGWLb8+aWJCvVVWq8Hd7
         LgEJ9WxIsccjuWhlZVHad0pqK45RttMMXERCmg/CtaCpcGfLNb48g5+G6O4u/y2+PVZS
         Eo2HMC9COaJuJbiggJWywxeuh+q84hPQOjdpUhchhgVYRHHxrzdu0s6BxELKIVYl0XhY
         L0tJ2lj9eW5NJ+pq75hM6Y7mZFwH8hXyXRu6L6XZqB0sUxvm7QQ23qe6M8frxOa6ww74
         NULuuVZZ52cEe3+st+Vauo5OWv+JNwo+j6rwHkVOQjhLcAvRzHsPRsGowskc/jS6IBuL
         DyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mTevPPqt7Byz2iW4VlqfulQbF215jKF3/le85wzWr0I=;
        b=YUgO7YfUPKvZbKPWdwawoK2GJgtgIhaKfdd69NElNkJS8I6SpRbw2fSoBsA+c9ua09
         0vZ6XCxXNhI9eey5OEmlEQ+nPOFfiI8+chyBZZ59FZkG2+deTAMg4QVuNCqzb8NJCxH1
         kqRfwWX+LnYdNNonn6rCDWw6rs/xEYtqDGWyNPmh5HLJ7ky6Z0OW2XiKDnyqnwlJDXi6
         i/WEaQOVZprsXsOMZduJ+8AWb/S1+Fkio8ro8k9ssz5GNZu3o+Rd3iRrm5/mAC7M25kA
         pLusz2Zr9PpIC/oYOYyGtuDdPEUKfqorrG4RHSPZb/MCTBw/onWX5voLmdlh2bVmggxe
         PwoQ==
X-Gm-Message-State: ANhLgQ2RR9DnECh0/6ehlbasBQZdqXo5Gw7OKDMuVPAejfgxt2o6zYGt
        fKCICGzta6ei/3f8tcRgXw==
X-Google-Smtp-Source: ADFU+vtWINBjYzCfJMDsBqDQoGkpe3aoZ8Lx+XNa2Y5W1KreW/65W/6vW7K3fnXIz1UC+2strz0Zeg==
X-Received: by 2002:a1c:6608:: with SMTP id a8mr398186wmc.113.1583888974292;
        Tue, 10 Mar 2020 18:09:34 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:33 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Patrick Talbert <ptalbert@redhat.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 6/8] net: Add missing annotation for *netlink_seq_start()
Date:   Wed, 11 Mar 2020 01:09:06 +0000
Message-Id: <20200311010908.42366-7-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311010908.42366-1-jbi.octave@gmail.com>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at netlink_seq_start()

warning: context imbalance in netlink_seq_start() - wrong count at exit
The root cause is the missing annotation at netlink_seq_start()
Add the missing  __acquires(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netlink/af_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 7a287dc73f63..99eef04a51ec 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2582,6 +2582,7 @@ static void *__netlink_seq_next(struct seq_file *seq)
 }
 
 static void *netlink_seq_start(struct seq_file *seq, loff_t *posp)
+	__acquires(RCU)
 {
 	struct nl_seq_iter *iter = seq->private;
 	void *obj = SEQ_START_TOKEN;
-- 
2.24.1

