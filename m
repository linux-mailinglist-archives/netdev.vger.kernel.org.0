Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE041C7547
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgEFPqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgEFPqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:46:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918DEC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 08:46:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a32so1084844pje.5
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 08:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dFcfaGK+YW9/7hUe01vze5nROPa4vpk0jsys3j1ArXI=;
        b=J7pLYjncdlUKmGoKrMKJZ5OQpl3drdWR3KqmSBN+U2yWPu0nYSCcq8zjb6GqU9ENP4
         1w3ei8kXs/C6WLPgnT5Z9UumT56lnnQXOf4Nr2ivuDpQsWcnpNvInKv2CUy9vwBfOipf
         HwxJa3rwQAYrsddn79fAx2PUZU0/LMIFWgk8oHxqMVYbFikwrZelqtJaQzMSA5qlhYwe
         vt+fTkBGCZ1G4sFbXXs/YgRkCLNuuQKelpUdFkWFXYc9FMwcswQBbMUVWA2hhVkWhrSy
         u3JyT3VFkhQeIjEa90TPOfmvuJnR0Tsf3qksluX4nbTtaxTfUJjH9somuR4grYxyfTSK
         WcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dFcfaGK+YW9/7hUe01vze5nROPa4vpk0jsys3j1ArXI=;
        b=C1sdvw00gEw7AVT4LsNgb5+Qbcy7rRTcPazVWHhDVXcGWIotZTp4f55TYJP3Vp3Eyq
         hlotWbk9pv9NHGeoDaRipX9JeXteWt/xs8DrU8lMfVDD9d8/wvHPLWbHaKw0qX3fRhIy
         R2F3dJoHbM+X3ZqakjM+65jVpjz4O5b4VSks2TFsPJJKxWiLJAlHSSt4j6XtcIJXZAhW
         vHnHTOu9SmN1wd0Q816DkcOS80CR1YLlA5P0NCnsYgtPzqpmCrd8ShI4NzHsAxmVOMIg
         M8ZamHQe85GK4NzbTjpb8XjC6mHanPb8x6bKsf2MKY/kV6HAwpHTeBuYkU5Nu5iseF0Z
         n+2Q==
X-Gm-Message-State: AGi0PuZ2NfS2qblv5RAig1QEbt9T9RfOXAqyIfq+wPdqXnDS5XPuXjMo
        PS+ABOhPdYKauCo4KDcaIVI=
X-Google-Smtp-Source: APiQypLJeEeIRL7LYnPeJUNOBNPL3MjKsdjdwbvbjZlyRwiHJ9omSwICqjaqBOhnjjg2HTLv8QD9SQ==
X-Received: by 2002:a17:90b:3598:: with SMTP id mm24mr10721529pjb.132.1588780001798;
        Wed, 06 May 2020 08:46:41 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id e196sm2201563pfh.43.2020.05.06.08.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:46:40 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 0/2] hsr: hsr code refactoring
Date:   Wed,  6 May 2020 15:46:34 +0000
Message-Id: <20200506154634.12352-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some unnecessary routine in the hsr module.
This patch removes these routines.

The first patch removes incorrect comment.
The second patch removes unnecessary WARN_ONCE() macro.

Taehee Yoo (2):
  hsr: remove incorrect comment
  hsr: remove WARN_ONCE() in hsr_fill_frame_info()

 net/hsr/hsr_forward.c | 2 +-
 net/hsr/hsr_main.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.17.1

