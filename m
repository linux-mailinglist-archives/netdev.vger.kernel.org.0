Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA3A2A29CE
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgKBLrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgKBLp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:59 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8047C040208
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:51 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h22so9215626wmb.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5oUC6Va014UtrlRcCbDs4GNP4CgSuaSNLLRcp4b0LvM=;
        b=iQF/a9CoUruapBJrFnUqxVwaWOKGPXgbLBMakAGZC8BLtPxjKyqanbtEfHKkO5YIGZ
         16Q0NhUYBg8tiGlNHEHHTD85UpWtPH5RsswHkfSI9DT0c22fd/epWbrqkkWrxEHmMtdE
         NS6ZKm4kqh72EPuoeO4BTGqXzFde8oFuOz8bYviEl7GinDDUkHlaGreje9hjQOLxq/td
         NCbIi6D8CwZzsCOpTZdl4ySvmr5jvBDlqsMf5o3xyfjRj1AjKixP0d8pRarRDZo5sl6Z
         lUl7uLCw8utg6bBrDZ+oHf5VxvVxP8o2/hFOjw+iVhwI8IU4wgJq5fYty+3iRb409uUP
         vqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5oUC6Va014UtrlRcCbDs4GNP4CgSuaSNLLRcp4b0LvM=;
        b=sxx8Vkl94i+Rj4QjayBzA9bz85DlpyJz9dh7vX34bwFUfKvv56Dv6L+AxW4l4CX9Dm
         ow5UAQs2/ChrB68c8knZ8J1JkMAwOOSrezXb2Qfmb/mad1xfwfDFHgd0+Ly6OPXa52rd
         UcRHsqpNV93b0Bkl8/RTMOPq8gTIKGzbFfSZt1nlaBPar9uUPqhshLe94rwxN4Mddpxl
         kx6vaAs6HJlLecZh5hIqpG00z3zVcqJJIurbh1eUOPewonDxmMboszxmNnB+YYcRNVx5
         peJDvmq0Q8J8S0JtPVFVnst/nAL5wsKl7xaqm+jZrxOMCmqAkzNfpxxLoJbH2NAKj2ul
         Bu7Q==
X-Gm-Message-State: AOAM531sKJnp1jjrVOtu0hJRXpoGzxlIsjia0yBtnO7rUiywFwtqmhyo
        bkF6MQnvMZweIOsZHPyOEA/0DA==
X-Google-Smtp-Source: ABdhPJz0YApYIF0oABznSZuXC8NHJa5ODWlpRrd9yMx7G/7RbC0uBlfVBHVg3Uo3fJHnxsi+eXwYNQ==
X-Received: by 2002:a1c:f417:: with SMTP id z23mr16497597wma.57.1604317550516;
        Mon, 02 Nov 2020 03:45:50 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Subject: [PATCH 25/30] net: macsec: Add missing documentation for 'gro_cells'
Date:   Mon,  2 Nov 2020 11:45:07 +0000
Message-Id: <20201102114512.1062724-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/macsec.c:113: warning: Function parameter or member 'gro_cells' not described in 'macsec_dev'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 11ca5fa902a16..92425e1fd70c0 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -101,6 +101,7 @@ struct pcpu_secy_stats {
  * @real_dev: pointer to underlying netdevice
  * @stats: MACsec device stats
  * @secys: linked list of SecY's on the underlying device
+ * @gro_cells: pointer to the Generic Receive Offload cell
  * @offload: status of offloading on the MACsec device
  */
 struct macsec_dev {
-- 
2.25.1

