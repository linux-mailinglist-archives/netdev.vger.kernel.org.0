Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96933287890
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbgJHPyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731618AbgJHPys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA48DC061755;
        Thu,  8 Oct 2020 08:54:47 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b19so2974961pld.0;
        Thu, 08 Oct 2020 08:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I43T9rqU2Yy7/RstrGAR68lAPYaJ6wKQTNNf5yp9YhU=;
        b=VCDjSCxFXfUzcQca+YkqX+Kk2ruVmbHkDOsEhXriyzE7ik9bFFBLINnhN7m70CT001
         vRjt0cr5TO5wwrm+sozcmacfFptRVbQR0Rs8XHzbBof2NnLa0cTVYGVLDdgp91jfwgpb
         Z+xEZHOKQM91iJEeYe2ntLNMrjK+/POUqHnLMLymcHEqUbA6fHOtPUpk7Ve03xO8M4g4
         X55iHHeMuNZrv8bfwY48WIrPm8snF075oB5s53MYhIkY50Pv7A5/lt6i1gW2hbrj6Phf
         Fwmsqm//RIKy0DKNgBfXZtS2rg2saaz92EGYZqZDjpViZVuMQ8shWl6uSZjiZarLBUrJ
         FQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I43T9rqU2Yy7/RstrGAR68lAPYaJ6wKQTNNf5yp9YhU=;
        b=XH1+deSjic2MgRJzep8iahECsWJVzH53mhXYBoRqmokjVtZAerSSzgOKpXzZBlhwb+
         5o4kp2Yk77Hz0p1YrZzG7l8WLgzFkLBoT9AOdplbdA0dCMzyFwoWRidYxghnYAamBkoP
         oLa6sAJsUGQloWiTeHUJAZI3Bh4Z1B+DrQS4Lpd2EpCtyo0AblLuFBmTVq2VAOLpjo+K
         wzusSBtAbKsxUXlM8WZDqhrbsh4VNa0B7UlWUzwD60N64RnvsijRBNfrettn43FdKNLD
         me2cEqsqZ+XT2Rftd8uoQZ9TEQ9g7KuuXSkftVFW7f6ZipzFnFerjHTQicNGy3g+L+Zb
         ir9Q==
X-Gm-Message-State: AOAM531grpAygVkcf/3Ha0uzstxUr8DhsOn3uMhH3272CWJ7drgrlTVg
        nn2YkJDSRx0ascmTP90q4oU=
X-Google-Smtp-Source: ABdhPJzFkGTvCqd3V3FFyUoVKSLilk86qLjgbvjmVGu5I57n65M1TeVSVldCa3PvNjuE0LxxIHLfXw==
X-Received: by 2002:a17:902:ab89:b029:d3:9c6b:9d9a with SMTP id f9-20020a170902ab89b02900d39c6b9d9amr8065376plr.58.1602172487448;
        Thu, 08 Oct 2020 08:54:47 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:46 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 047/117] iwlwifi: mvm: set .owner to THIS_MODULE in debugfs.h
Date:   Thu,  8 Oct 2020 15:50:59 +0000
Message-Id: <20201008155209.18025-47-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
index a83d252c0602..5bf4f7801b83 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
@@ -63,6 +63,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define MVM_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)		\
@@ -87,6 +88,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define _MVM_DEBUGFS_WRITE_FILE_OPS(name, buflen, argtype)		\
@@ -95,4 +97,5 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = _iwl_dbgfs_##name##_write,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
-- 
2.17.1

