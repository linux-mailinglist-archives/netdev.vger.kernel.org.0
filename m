Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04AB3CA220
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 18:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhGOQUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 12:20:49 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:46892 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhGOQUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 12:20:48 -0400
Received: by mail-wr1-f54.google.com with SMTP id d12so8480317wre.13
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 09:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YFzBIzyB4rbfdbuKHENoQkz8Bi5GR8SjmGIjzTXZ7qA=;
        b=lYRHRijL14/orcTZjtwCIMraMeHZyY4claJgTwPMSVw6O9pXlIa7mHCcmEBUBOZbKx
         SbnRJx4KPE2STnX7iyPpKuteAs4xUfGpXwVhyHZjhpcLETP0pWRUV88yEn72traVgeRr
         wSVaRv32JX/hzHk9j9/FtrHrj3cQI3gvPH0AvR1TQirOATEMjRo+MeapkpnVtncAAVgS
         PhoHMKPR9XG/Z9QJ5hntILjKH1+nlq5yDngldOL0FzxnAI0ixiOZbdC9k6ft9IWXlmFa
         /XfJzL37ASOHORzGhsI+oIJ1UYOPEuUIkbH2do74Svm4gwSJK4F6CvO8PWyg3sGB2mZE
         TKrg==
X-Gm-Message-State: AOAM533Qyu7UibbxxnAqtHX6Qq351fDzBtTWK4Qw3YKo+SA+3wR3xJ52
        hGYGrC0lgFaXCG0rpEMD4QBYqbz3ckE=
X-Google-Smtp-Source: ABdhPJznYQNrBS+A9v4HkhYbErMT4l9O305CSPBzA2JhX6Ba8Wmw9GNCimXqKOXFAEFsncFgXXA4qA==
X-Received: by 2002:a5d:48ce:: with SMTP id p14mr6742510wrs.170.1626365873649;
        Thu, 15 Jul 2021 09:17:53 -0700 (PDT)
Received: from BigDora.home ([2001:a61:1082:9b00:171b:30e4:d45a:27b5])
        by smtp.googlemail.com with ESMTPSA id j6sm6700827wrm.97.2021.07.15.09.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 09:17:53 -0700 (PDT)
From:   =?UTF-8?q?Christian=20Sch=C3=BCrmann?= <spike@fedoraproject.org>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20Sch=C3=BCrmann?= <spike@fedoraproject.org>
Subject: [PATCH] man8/ip-tunnel.8: fix typo, 'encaplim' is not a valid option
Date:   Thu, 15 Jul 2021 18:17:36 +0200
Message-Id: <20210715161736.487310-1-spike@fedoraproject.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 man/man8/ip-tunnel.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ip-tunnel.8 b/man/man8/ip-tunnel.8
index 9a510af0..57e030dd 100644
--- a/man/man8/ip-tunnel.8
+++ b/man/man8/ip-tunnel.8
@@ -235,7 +235,7 @@ flag is equivalent to the combination
 .B It doesn't work. Don't use it.
 
 .TP
-.BI encaplim " ELIM"
+.BI encaplimit " ELIM"
 .RB ( " only IPv6 tunnels " )
 set a fixed encapsulation limit. Default is 4.
 
-- 
2.31.1

