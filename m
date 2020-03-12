Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD718338C
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgCLOpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:45:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36670 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbgCLOpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 10:45:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id c7so3194834pgw.3;
        Thu, 12 Mar 2020 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NZ+lJhCu+QsrJxpFxMMQK0Jj5InEr2JGA1/rRMiktCw=;
        b=vFy3soi/FJEG3hhUZVnTAacj/qTv0/ajDulbQHpYmZU5DJ+HWkwZ4LyY1m542FWYt8
         e5p1pRZvwy7dEYZKNAffQuil0MqFa7fbWh5X6y4wc2hrisEvyNRX+XFCqmzwUZQib91b
         YtwctbXRBb2SHZ0qoQWGpz6JL8BpC/JfjoBwspyBGh9kp+sxkDYLpP7JFlkkKRn8KclL
         DLGJacYzv7nNJeSzr7lLyqvVs+64yHSh6BErBS2aRRRqhBswrb94jlysH9z0sskFxcrJ
         OTtVe4VhsUj2PFuVOKYl5VHKx/RyK+J9mmA3wnPT848ZnXZ51Lmk1DHhrg8aPo1zYGaj
         vM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NZ+lJhCu+QsrJxpFxMMQK0Jj5InEr2JGA1/rRMiktCw=;
        b=FQDp1HVHGSGFZu+yD6PtLvj470zsEchN9TL9cCJ4WFfFq+x/cekemR2GazQ3orDHCL
         3Z8stxtIyWBJ5w8NlaBRCo6D0W6ygQSPcJp2TXMC6+cl8/4dZf+5HvaTuI+NnGhjLfKq
         ZnIISERJHmHh56L3XDybwgJFVu0HFF5gNDNwnVwXnWWngmca0QS/laV3JYptPl0Kocqe
         kyiBu6ruqhiwubCqjeXt4UP3T9klLk275o3MKHj2l1CQ95U93QcqYbRk5dANdCEm51is
         Mg1wvt1r4cW+mcl/DVDJRlm3bWjhCe65pOMsjh7qa25k9EuCjUfum5wzrd/PUnY9Qkue
         3jaQ==
X-Gm-Message-State: ANhLgQ0W9Kw1o+YQaqtHa0ecAUqRBmZjAsoazXgJQYxcjd60dDjBvDs0
        uATH69aPJoGg/BbmlgxvY5M=
X-Google-Smtp-Source: ADFU+vur3iR4ikxB3azR1uDq7JVjwFVFlOsseNiwW3RAzJ56iuTJvW23yByzLVpOFe0EbsQoZV+Fng==
X-Received: by 2002:a62:15cc:: with SMTP id 195mr6665778pfv.276.1584024313952;
        Thu, 12 Mar 2020 07:45:13 -0700 (PDT)
Received: from localhost ([40.83.99.199])
        by smtp.gmail.com with ESMTPSA id s12sm31424855pgv.73.2020.03.12.07.45.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Mar 2020 07:45:13 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] mac80211: update documentation about tx power
Date:   Thu, 12 Mar 2020 22:44:24 +0800
Message-Id: <20200312144424.3023-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structure member added at some point, but the kernel-doc was not
updated.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 include/net/mac80211.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 77e6b5a83b06..3acc5afb11f1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1984,6 +1984,7 @@ struct ieee80211_sta_txpwr {
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
  * @max_tid_amsdu_len: Maximum A-MSDU size in bytes for this TID
+ * @txpwr: the station tx power configuration
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
  *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
  */
@@ -3448,6 +3449,10 @@ enum ieee80211_reconfig_type {
  *	in AP mode, this callback will not be called when the flag
  *	%IEEE80211_HW_AP_LINK_PS is set. Must be atomic.
  *
+ * @sta_set_txpwr: Configure the station tx power. This callback set the tx
+ *	power for the station.
+ *	This callback can sleep.
+ *
  * @sta_state: Notifies low level driver about state transition of a
  *	station (which can be the AP, a client, IBSS/WDS/mesh peer etc.)
  *	This callback is mutually exclusive with @sta_add/@sta_remove.
-- 
2.17.1

