Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D340BC93B3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbfJBVu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:50:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39322 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbfJBVu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:50:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so475591plp.6;
        Wed, 02 Oct 2019 14:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Xo6Oycs9HL8Xp9z5j59qXmau9yDW1OlsVALr3jxVyow=;
        b=iCfVyZ3vqv8kQhxtKZI7oMU0rET++mZeVYAkNtjtyiDIB3cmQLeZ6GgJKKNZubeTNT
         eyeBnUA5ss6i1Bz7zk0+QHNP/lv1FgJ3SEFHPryFfEu3+ynNkyvfUyBHlp4S3DnuRLxs
         RX5x6J/a6z+pxC1semj5uxeVnmjOgZdFzGu0OOvTQ1KbGBm239ELzTkeVVVN7qoRTQ+a
         2MDIf2JIRnRCGYbkAIAwRnBbHqxcOBf/AqET1AyeNY7FWyjXCsWBAiI4DkKmyiqa9YBw
         y7pJVB5UOo8VEA3eNDnrrEo8yXgPs59wTpiuyCGBPNbIA5RGo131eH2wcqj5MrmQhhUH
         7Olg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Xo6Oycs9HL8Xp9z5j59qXmau9yDW1OlsVALr3jxVyow=;
        b=RbjvqKZ8WCsgA5xXj7iNvoiswqORj34BkPiaIpLYpgryBDOghV3l78vuv2Y2788PO8
         xlTl1Oz1r+75mglJxCfCavuVRY4WcMawNOZymVtXZZ/FPLtkfcqq9R608g30hpyHgzvg
         S05X6Jh74Vo4o60I2zuLbGmsGztBoYwMy6VxyqKWLmsDkZO13TzFKBktnML+9SqREpva
         pJOB7CHnRmuqsSPHqnEQ73gOw7X5UkxvRNy+jwJOIhsAtEBckvKaeURspSV8zvIsI6b0
         rPvm+Gy2iSkW/WmBo8xTcoV27Bh7oKbIHhZcViRnl9VZQhItjCOyvNkMCtyauW/slkPZ
         H/qQ==
X-Gm-Message-State: APjAAAVXXxQE+2lEZh1jc0kH4U8zpC3UUT+Y8Rp2+dhBHVIHq6kbXDiN
        qhVV7OE8Z6Mevui7C7+PtBI=
X-Google-Smtp-Source: APXvYqzlDAQEIGYUTuQ+X0sTs5ngrTFT3yvZ8+1eJR6i7LpH6ysoSYLV+KJVD6EvBe4srwU7TNXd5g==
X-Received: by 2002:a17:902:9881:: with SMTP id s1mr3774340plp.207.1570053055394;
        Wed, 02 Oct 2019 14:50:55 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id r2sm442735pfq.60.2019.10.02.14.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 14:50:54 -0700 (PDT)
Date:   Wed, 2 Oct 2019 14:50:52 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rt2x00: remove input-polldev.h header
Message-ID: <20191002215052.GA116229@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver does not use input subsystem so we do not need this header,
and it is being removed, so stop pulling it in.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 2b216edd0c7d..a90a518b40d3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -23,7 +23,6 @@
 #include <linux/leds.h>
 #include <linux/mutex.h>
 #include <linux/etherdevice.h>
-#include <linux/input-polldev.h>
 #include <linux/kfifo.h>
 #include <linux/hrtimer.h>
 #include <linux/average.h>
-- 
2.23.0.444.g18eeb5a265-goog


-- 
Dmitry
