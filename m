Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C60C1BE1E1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD2PA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgD2PA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:00:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149C1C03C1AD;
        Wed, 29 Apr 2020 08:00:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d17so2899315wrg.11;
        Wed, 29 Apr 2020 08:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rygEgNYoXE3RBYcDWl0SZa70KqwTrtI8yAZZsL8kaoI=;
        b=Un+87k17XnbFb+NGQBLDmGTmTJopxnh8Fh4Zcwq1QGxuVTmt85YkFeXzDEE6fl0uLi
         W+1JiCHggQ+MAnEd4sK7IqRmE+rYr15GXGyKhN2DgED4uYrwHXC/8fn3/pcV+Fl4auw1
         T2DEcOcRZv6g6cYm/F0JZT3an8Yaa9QrszqjlvXSGdU/N3CBjxwfQhVs6r5OyEvRynhm
         3mjEvLrVd/oATsLDU02iUFtzIDAXnuqs0u/Z65lpwZgynbtzWvCuttOFNbsBJQEFzKpt
         qyEK7VjbTKnYAOe6CpCt0G6ZXUk8iU8/ZsovVsUhbB3C4LDXOOrD/s65/cAJIcnzY5fR
         ZgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rygEgNYoXE3RBYcDWl0SZa70KqwTrtI8yAZZsL8kaoI=;
        b=XrJ3LqjkpJD9V19KCU8sHeEm7BPev0VfI6AJ77+zKKlEW3O6sX3ldmH+gxTVU/MUHr
         KSyrDGNc6k+zecUd6YvqmxVaG9E+lVy/wSvm/DWlZlEBUsK4xMkwq4evktp2SRwzOgcx
         QQ3pASMRqER/P/P3IJnq9O8U76AUIfbLVd2/CAvCC+uV4qSPd9Rzvn2WHA4R+0pgGOXC
         XD3APCqDbCGSfyAzyCY9VChW2QmO2MEklLRsXxkn5nTekjsWc6DA1xEtRvSx+ODtfRZR
         08IIuWaEpihYGOGXOxeetuZq179IgtZuIDATq6WGttimpFVURl5M6PfPSC8m1Z5Kqg4x
         9H0A==
X-Gm-Message-State: AGi0Pub1bJPqjVd+fFdJVR5iPeG6rPf5qNXuu+9nCcEGLyUy5gNfO92w
        gkX8cVDUeXeeueQnxN0i6H+OK3ld4zGY
X-Google-Smtp-Source: APiQypKbU2Sq1MokQaDGhjgl60I0Hq23jAmKivXdQ1yimY8IgMxCPeEOQ/t4LlSOuhTMWJVwE8G6SQ==
X-Received: by 2002:adf:ce02:: with SMTP id p2mr39471934wrn.173.1588172425424;
        Wed, 29 Apr 2020 08:00:25 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-195.as13285.net. [2.102.14.195])
        by smtp.gmail.com with ESMTPSA id n6sm7894617wmc.28.2020.04.29.08.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 08:00:24 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH v2] net: atm: Add annotation for lec_priv_walk() and lec_seq_stop()
Date:   Wed, 29 Apr 2020 15:58:46 +0100
Message-Id: <20200429145848.6271-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <0/6>
References: <0/6>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at lec_priv_walk() and lec_seq_stop()

warning: context imbalance in lec_priv_walk() - unexpected unlock
warning: context imbalance in lec_seq_stop() - unexpected unlock

The root cause is the missing annotation at lec_priv_walk()
	and lec_seq_stop()
To fix this, __acquire() and __release() annotations
are added in case conditions are not met.
This only instruct Sparse to shutdown the warning

Add the  __acquire(&priv->lec_arp_lock)
Add __release(&priv->lec_arp_lock) annotation
Add __releases(&state->locked->lec_arp_lock) annotation
Add  __release(&state->locked->lec_arp_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
Changes since v2 
- merge patch No 6 and No 4 into one

 net/atm/lec.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 25fa3a7b72bd..7947abb17af2 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -886,12 +886,18 @@ static void *lec_priv_walk(struct lec_state *state, loff_t *l,
 	if (!state->locked) {
 		state->locked = priv;
 		spin_lock_irqsave(&priv->lec_arp_lock, state->flags);
+	} else {
+		/* annotation for sparse */
+		__acquire(&priv->lec_arp_lock);
 	}
 	if (!lec_arp_walk(state, l, priv) && !lec_misc_walk(state, l, priv)) {
 		spin_unlock_irqrestore(&priv->lec_arp_lock, state->flags);
 		state->locked = NULL;
 		/* Partial state reset for the next time we get called */
 		state->arp_table = state->misc_table = 0;
+	} else {
+		/* annotation for sparse */
+		__release(&priv->lec_arp_lock);
 	}
 	return state->locked;
 }
@@ -940,6 +946,7 @@ static void *lec_seq_start(struct seq_file *seq, loff_t *pos)
 }
 
 static void lec_seq_stop(struct seq_file *seq, void *v)
+	__releases(&state->locked->lec_arp_lock)
 {
 	struct lec_state *state = seq->private;
 
@@ -947,6 +954,9 @@ static void lec_seq_stop(struct seq_file *seq, void *v)
 		spin_unlock_irqrestore(&state->locked->lec_arp_lock,
 				       state->flags);
 		dev_put(state->dev);
+	} else {
+		/* annotation for sparse */
+		__release(&state->locked->lec_arp_lock);
 	}
 }
 
-- 
2.25.3

