Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F1B2A1894
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgJaPbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727355AbgJaPbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604158262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=BRPS/M3iG4bxBoaR/bG+BCL+obGe/+2vovBN8FRsbKs=;
        b=D2YEM8dF9V6W84uKpQUDCRIhvsWOmSH1Lr60niU3RomI8Se+LjHTIGJGrWDtW73bzlRpDz
        I9KSTI5jT1k5dtYBTukeg52UAhqFuHyQUVi73aEuRzsTO+G+WsFwtwlQJPUA+f8LM0UenA
        /EZ5Bl9C66bvlOKRJVBbEOqfVrqlkbQ=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-Qrg0e9U_M3iW0NXf-IMqsQ-1; Sat, 31 Oct 2020 11:30:58 -0400
X-MC-Unique: Qrg0e9U_M3iW0NXf-IMqsQ-1
Received: by mail-ot1-f69.google.com with SMTP id g51so3900970otg.9
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:30:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BRPS/M3iG4bxBoaR/bG+BCL+obGe/+2vovBN8FRsbKs=;
        b=sicMwZtiHFLnNaFe4XzgCMP+jtZDqBlyb6nytfYeisbybeEJtRZ4B3ooRf9Jf51hcc
         RQX6m6oe8YBP/tWcQWysCLi1z+BAsyUOALD4ze345W9ooR/nTFgz98N/JABe7cr0fEIi
         v4VEzDdnh4RzmM0gOymPFrE5fiJQlaY67MF93WrnH7R3tXSnjevidIUZOcnGtnyxXcAM
         TnaVC13CjmUmwpLlFefDqKpOWAd+KILdToXROtE0MjNdW6PyecYA4UTWZlabcthex059
         fEk3+3gVdrrPqfWONjVeNUp+dCNba6xB3I/skFqS1K820fH5t5BhmYenAYS4Cb+HbeAo
         9tjQ==
X-Gm-Message-State: AOAM533vvNQuwoUVJyq2IbAc6iZjDQmW2Sv0q7euowhO64pJbtJqFaZD
        ZWIF7tEZ9d18Q2zoUw2L6B5UZv0PtDmpNkG/gXICAHLod3pCa/vxQ5QllpzGZhrkmigi9Q/IrmS
        Jil0EkCDbmZfcSdVM
X-Received: by 2002:a05:6830:1254:: with SMTP id s20mr5548499otp.314.1604158257553;
        Sat, 31 Oct 2020 08:30:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/IyisipqTEuMgkmCrVYr0MlG5l72Ah14nIj7NlV7mbGx+z3QpQCOjzufuvwyWdBRq1Rw7OA==
X-Received: by 2002:a05:6830:1254:: with SMTP id s20mr5548483otp.314.1604158257398;
        Sat, 31 Oct 2020 08:30:57 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id g3sm2227839oif.26.2020.10.31.08.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 08:30:56 -0700 (PDT)
From:   trix@redhat.com
To:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: dsa: mt7530: remove unneeded semicolon
Date:   Sat, 31 Oct 2020 08:30:47 -0700
Message-Id: <20201031153047.2147341-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index de7692b763d8..771f58f50d61 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -558,7 +558,7 @@ mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 		val |= 0x190000 << RG_COREPLL_SDM_PCW_S;
 		mt7530_write(priv, MT7531_PLLGP_CR0, val);
 		break;
-	};
+	}
 
 	/* Set feedback divide ratio update signal to high */
 	val = mt7530_read(priv, MT7531_PLLGP_CR0);
-- 
2.18.1

