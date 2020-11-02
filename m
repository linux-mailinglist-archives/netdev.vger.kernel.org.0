Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3882B2A2595
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgKBHv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgKBHv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:51:58 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01E2C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 23:51:57 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x13so10366534pfa.9
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 23:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=3dasOQPk8AxqLg2I4P577c9YF2R7l5DC4TWmPjyd8Eg=;
        b=XqrWaieaUp0ULxLEvexqL+e/P7dEVKv2Vn+HacyxzW3nX6Ktcs2ra7pV07Wc1zHpro
         Oe6xpr+ztmnShwEfWhsmiBlPn8o+9UOM/jQmzLRaH5mn5iQTE51LPuZIROJ7TRqgg1zx
         scYV1qnbZmFnFJ0waeoPKCSoVI3x8GXI/8yTO0aRgkIogBpOTGO/8rRZKY4GuU3GKsjZ
         yEN4zg/Zvn8Oo+eD16Vq8FpfW5bW3yrG8s6ErUFpaYdk13+lRahQFWEbNExrlZnslJDI
         rabLyvtt1GexwqUHcBIyXBe79d+L0cew+PJxYcv+5D9mZDoLkjkPBBYxWrvWIgPpB1sV
         T7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=3dasOQPk8AxqLg2I4P577c9YF2R7l5DC4TWmPjyd8Eg=;
        b=fZJoSEQyPFsHC8/nI5mnyjI/4UGytwA/PSo+vZON7SIALtolct4JBXKuoeGV610s+L
         lmc00dqcPH/S0VRU1Wawp35SUaskzwPe4363VMrzDYd2Fh0YC6xDEToS/OXL9ZZCE06X
         eoQ0OGPcOvn3sNBgbYttiW6ZTM6vhmYJwnVU/piWnpWA2sNvLlKAjYFMzFIYlRuxZygv
         y6N5svlTWe9vrsaSdZ9/ASn0+vGkvFa85Pit5oOA5aMLoVmPAcIw7nTa8l4kPxTpYuJ3
         u5IuR2XCVe295h8hFzoxEHN2sEPeXCOiNz/Z1aNnuo2vt53/IambzppThLcVTQyq1Oxl
         TkrA==
X-Gm-Message-State: AOAM533EzT0r4uz2OW0bVODx3P3rO+uf02gOD6kTbRbHUVvEkE91YJH9
        iyW51fEhwjVsO8E+rnfsusg/L3m0Xd8q7g==
X-Google-Smtp-Source: ABdhPJx7xTxQEcce6ZBWbpkhNNpLBnikloTOAmyegOiN71S/pWAbs5KLKvkB8LHKF9pqZOTWijjKvA==
X-Received: by 2002:a17:90a:fa16:: with SMTP id cm22mr2516089pjb.159.1604303517114;
        Sun, 01 Nov 2020 23:51:57 -0800 (PST)
Received: from devstack.localdomain ([161.117.195.136])
        by smtp.gmail.com with ESMTPSA id nh4sm11054014pjb.1.2020.11.01.23.51.55
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Nov 2020 23:51:56 -0800 (PST)
From:   LIU Yulong <liuyulong.xa@gmail.com>
X-Google-Original-From: LIU Yulong <i@liuyulong.me>
To:     netdev@vger.kernel.org
Subject: update my thread mail address
Date:   Mon,  2 Nov 2020 15:51:47 +0800
Message-Id: <1604303507-30240-1-git-send-email-i@liuyulong.me>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603850163-4563-1-git-send-email-i@liuyulong.me>
References: <1603850163-4563-1-git-send-email-i@liuyulong.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the netdev mail server reject my personal address
to send mail. I just moved to gmail.

LIU Yulong
