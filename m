Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0269E328C69
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 19:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240508AbhCASvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240675AbhCASs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:48:59 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4630EC06178A;
        Mon,  1 Mar 2021 10:48:19 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d9so17443703ote.12;
        Mon, 01 Mar 2021 10:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J5FMZq58d8FKQgaQNO3cOtAsZ73OS8FhCj3Iq1iyMs0=;
        b=CxkT6CEpP/tZKwk8UOC64BmAI76MsqBbAE8gCIrm5IQoW8I+LfU9vTVMFmTmPSHggl
         r7t5HtjPF6MJUDq/NLSjzjQHLpAvwPrA43kVy/9siTCRWda6A5Tpv8Px3xCBDpOiP6VG
         WfhUuO5ggpeaZIXTX4NUMkLvh0Ti4d+Em+NFoBQ2agF1BaS1v5ftr8Lis8464Vo0NDGl
         fJDUBX4rAnfvmu75LMMTYR76lXATAvfjzbs69MXu6Svvs1ywJ5J61eGXojl3WOMrlvkt
         vJyePvMroOHiPlWq2MTy1yw7uhXt/xCc22Q8LyfH3BvGgpT/o7UUkKXILv/B6ac0fngl
         UjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J5FMZq58d8FKQgaQNO3cOtAsZ73OS8FhCj3Iq1iyMs0=;
        b=SN0kSPACB6YJ1yjGwbRwMLSSPK8ntQ0uO383IyjQ0+nW6qzLT2iRiqLC7toMVsAgTb
         KL+SgygK0YhEbuUF8VcwrverP4WGKFfk8msPbyU5hUkFA5UXNp6InNik1em6g1xQY2Ij
         SGQH4oeOuzIFsRLgB9H1TNsY6G46YthGfHCZ/TIIlWzuBKMQZqQ0XaZjNCIlrA7y4Eqs
         dX54yC1fChxAg+8vyyRAbDtel2opRkUvjt02zWugHjuPnLAsvbOsHfkaO772k/hSRMx2
         g2UtIbuDjJe3w98Qun+3AkikHQXmL//puOA8C/2gzyriWEUiAAQ7oIc7iO73VbDWLToc
         yR9Q==
X-Gm-Message-State: AOAM531XG3Pi2w7JE44ZK1tsuVAY/a8Z2cALjukD1QYFFh/iDlblETDR
        Tz6OjrEerUjOZ5R0fuTn9xDDSx7cjLN4qg==
X-Google-Smtp-Source: ABdhPJxOS4yI7zQAX9xFJNvp24q3I1leQez3xL6CDHirBvRqFk/7eb4v4xoMAsoE7Zs1c2QX1TCENw==
X-Received: by 2002:a9d:226a:: with SMTP id o97mr14744062ota.362.1614624498505;
        Mon, 01 Mar 2021 10:48:18 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id 3sm3562185oid.27.2021.03.01.10.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:48:18 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next] skmsg: add function doc for skb->_sk_redir
Date:   Mon,  1 Mar 2021 10:48:05 -0800
Message-Id: <20210301184805.8174-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This should fix the following warning:

include/linux/skbuff.h:932: warning: Function parameter or member
'_sk_redir' not described in 'sk_buff'

Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bd84f799c952..0503c917d773 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -656,6 +656,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@protocol: Packet protocol from driver
  *	@destructor: Destruct function
  *	@tcp_tsorted_anchor: list structure for TCP (tp->tsorted_sent_queue)
+ *	@_sk_redir: socket redirection information for skmsg
  *	@_nfct: Associated connection, if any (with nfctinfo bits)
  *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
  *	@skb_iif: ifindex of device we arrived on
-- 
2.25.1

