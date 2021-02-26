Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498383269A6
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBZVi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhBZViX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:38:23 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861D0C061574;
        Fri, 26 Feb 2021 13:37:43 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p21so6973203pgl.12;
        Fri, 26 Feb 2021 13:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YZ8sIE0SfUCNUaFWNqwI5F5nfIUi/RZN8Zp0MikDfW4=;
        b=i9Nyay78GChs7jbzOmoAdgqg2exELjiHMJpXn0xXQsrVmlYs2bKEpuCliUi17NxX6Y
         RZ9KKGWZGS4/CPyBx29o+yH9ijVoATREa8oO+ggIqLYt+DVww2WhK02ehvzNMF3B+u+K
         s8xwLRfsWBScbdPCqJXU3bfnGvixyshKKUwk/qZXo2SOAwH+Wo2pL9O8bCbsVkbxsfr7
         cH8ip7YYTO4aQiySvtXVkXu80IkOj9lQ/de4/2Vy64szna4fJP5NkmpQAsjZKKGwn1XP
         pW/rP5A9CfFAJFDgYlOonbUBxk1XajRjrE54A2Uyc3sBX94mnS8ucpYTvVuUyP1cHglP
         h5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZ8sIE0SfUCNUaFWNqwI5F5nfIUi/RZN8Zp0MikDfW4=;
        b=E0ea4WozcJVkk5wmlr+P2TDq7UCA6AwBZ/W/BHop0iDtfacS98+tEU1z7BDQd3lwpb
         CjmB0ebVqg/BPKlsS/NstqXw6I9PiTQg5xlpf2Y96cnfPuipZa5XCO2484jNzlWSXgt9
         AaS9gTr601Wspnrfl3I5pm1NKnzb/44qrGYxGbhl5N7joh3fmN5yuopObf6ADEXeZCvj
         9A+IPI3fK/2EXHIB1azvzwsyY/fl2ldrXMSP6vi2aV8VwCq9coP+x2UMC8FuNYtQWI9y
         pAdpVFA/CvoD/4D2r5NYIaBoWSzejjSehoaGh4US05fv3WOnfRwuuv0BIfCxr7/nMzWy
         1ndQ==
X-Gm-Message-State: AOAM532OpiWqUu47znYiezJmWVsjH/I869+sFzo4JO8gTdl/3hs9PEzT
        bPc5jPiYE0syA77wm3mHLA8JU/QMEimMk4AY
X-Google-Smtp-Source: ABdhPJwfctXVVUNuksWHVLJXgIc1k48O98MFJJ/pvbjn7X7n+H8LYq6eiUWsEquGlp7/oCbFfzJwiA==
X-Received: by 2002:a63:f91b:: with SMTP id h27mr4719212pgi.133.1614375463113;
        Fri, 26 Feb 2021 13:37:43 -0800 (PST)
Received: from localhost.localdomain ([216.243.37.48])
        by smtp.gmail.com with ESMTPSA id b187sm9277958pgc.23.2021.02.26.13.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 13:37:42 -0800 (PST)
From:   vic.michel.web@gmail.com
To:     weiyongjun1@huawei.com
Cc:     emmanuel.grumbach@intel.com, gil.adam@intel.com, hulkci@huawei.com,
        johannes.berg@intel.com, kuba@kernel.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        mordechay.goodstein@intel.com, netdev@vger.kernel.org,
        Victor Michel <vic.michel.web@gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id tables
Date:   Fri, 26 Feb 2021 13:37:22 -0800
Message-Id: <20210226213722.37192-1-vic.michel.web@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210223140039.1708534-1-weiyongjun1@huawei.com>
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a BUG triggered when loading the iwlwifi driver, which reproduces
consistently when I compile the kernel with LTO_CLANG_THIN.

Tested-by: Victor Michel <vic.michel.web@gmail.com>

