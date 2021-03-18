Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A85F33FF2C
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 07:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhCRGDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 02:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhCRGCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 02:02:39 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3589C06174A;
        Wed, 17 Mar 2021 23:02:39 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id m7so3247997qtq.11;
        Wed, 17 Mar 2021 23:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56XoAJgGy6sdIbPpn/yZfdT8dNjDuptUpp5Nwc44OIk=;
        b=tfIMQGiJj/2lRNKlDdgnVozttuv+wmNCDDnmgW8npAgM4C+OLGj2UxGJTSS8hJe79h
         /0CXOPSUH/inmmL2y/71i6K2HocK2VvOAnd83pYoBPEUCrVIWgDj/jaGiFrr/rfgKyD+
         PRX6r/JUpyfO6/YJw2MlYDTSzlbSYmVhkSxF/4+xPix8K67mNsa3N7DOIy7kn5mA9yHG
         mTSCU072le31YPjAKgfXYhQxfSoUBXS8fBvFJJk+wR2uHfINPoNeAgWCPZiIQoTsqNsE
         4XDUEpcdt9+4hVzAMlgv/TWa/6WidSQlDlHf6v35qItRJ6ECWR0vmgymsy2dFuEcvPOn
         eEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56XoAJgGy6sdIbPpn/yZfdT8dNjDuptUpp5Nwc44OIk=;
        b=E4AVtAI0pLp4sV2XQSBJd5rBnjhMGJyY0yxzcU8c/+OWQoe19nv9UKCFMXHTyxRqf2
         7oQiyKIwQvgkW76b6pfmD4p+YBcZPfyhO1D0t1dplft22DKSRMClgnSUSkmNmk0wEc16
         dU+Mps6DxdhiqHcNvbT71BMMW1I8XgsFh60NneZm9v89XndBsxh/KrCzbeFbiOhEnWlZ
         MS9U+xPDJ8tdG5/azPsFvjZlrg7CsyBGSTxx2JOL2Q0IqsUEliSd8GvjMpSCNg4K65aI
         FtS8CJ8K0FS+LCwJumoLirdaNG+PkUKcDcdqFk+sxoO2kmZqBveuoMokQvvwO2modMLZ
         NOVg==
X-Gm-Message-State: AOAM531AjpxmscRgwM2yVTpR5EjJ4jiHrXxbh3TbvAT4XD/02fVlyPSJ
        zuSENUqGJrPD+wimdEMEFOs=
X-Google-Smtp-Source: ABdhPJxNi01FJ4qYBic2mBZZysg0y+fBo18qw/XXU2Yi0qqNZaZgW0F8C66iMjbjLod98eEYDwSNnA==
X-Received: by 2002:aed:2fa3:: with SMTP id m32mr2319207qtd.359.1616047358966;
        Wed, 17 Mar 2021 23:02:38 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.26])
        by smtp.gmail.com with ESMTPSA id z4sm1066079qkb.94.2021.03.17.23.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 23:02:38 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yuehaibing@huawei.com,
        unixbhaskar@gmail.com, gustavoars@kernel.org,
        christophe.jaillet@wanadoo.fr, vaibhavgupta40@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] ethernet: sun: Fix a typo
Date:   Thu, 18 Mar 2021 11:32:23 +0530
Message-Id: <20210318060223.6670-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/serisouly/seriously/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/sun/sungem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 58f142ee78a3..b4ef6f095975 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -1675,7 +1675,7 @@ static void gem_init_phy(struct gem *gp)
 		int i;

 		/* Those delay sucks, the HW seem to love them though, I'll
-		 * serisouly consider breaking some locks here to be able
+		 * seriously consider breaking some locks here to be able
 		 * to schedule instead
 		 */
 		for (i = 0; i < 3; i++) {
--
2.20.1

