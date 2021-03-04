Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9DD32D8AB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 18:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238609AbhCDRfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238054AbhCDRfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 12:35:31 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEC4C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 09:34:51 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 18so4596605pfo.6
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 09:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=2xQkEOsdGwG+u+CFWHs2eb6pdZOOXhDpLU358vUysAY=;
        b=cibd0BXvekrWeRL7XEmAJ2rp5GBMqsbXiuGfvojavs69YFWqTvYXWd6u4gsSsBQn0X
         hshjVGPwA/pd89Xpu8MosA9FqOqedFuJfzebUhtk6AdRpb1MmYFhdkFKAGBPFEneF0Cn
         gIG/5TkBIFmY82N0IfSxsv9syOxK4cgMyouhTSPg/9/uT+4qMySSVLJjnM+g2eNHb2Ny
         2mwUEvM3UU8xZd2HQHUMAygwAozClXLzrpmFMAQMk3fJiWAY2qC492MxukbaS7bj2EMk
         yvdjvcJDyNdNZFFka/XGVaOrgzkn0mLSLtleXQv7e60+TR+Z2fxpuvOuBxys26AoGYm8
         K+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=2xQkEOsdGwG+u+CFWHs2eb6pdZOOXhDpLU358vUysAY=;
        b=G/pYnDUoKUjv/Gm/jAzck4XXAIxTfc94H1bs9p7r/juj6Zy/VjrqqKXKUSqWG3aCLl
         7WFzz2DH1z1mpRhCkUHPzZ4ZTCjPCsYlXvBZciKakEFIFHb+NQTObWBGQaHBbKZXQoTv
         tZpEQrzOXnI9oQ8CYm7tAKRWa8tSkmMzTN/OvobxwG4EBKAwPgWpOdr/sAZPoDNnduDQ
         e7rtCScqDFA4kHw6ocFXnuIYaNfYC7Yw3fSTauRgDEqL9Mch5ZmyjkVGosYNirIqfZfH
         KXsi1PVbhbHGbFNcFjqmv/k8dlNJ8cN19aOHlNXCYzUfyLZJ54DlQNAqEUGzQkLD9AiN
         1AnQ==
X-Gm-Message-State: AOAM5301oojbU+A2/9meo+ob81DakRwzhd5lv8UQlUvIEoXuFdCQZkly
        vUqiU6p7mUqMfIQANHWYPKnJbg==
X-Google-Smtp-Source: ABdhPJyMTzFNz5SqWebXQnpNR1W+OjS/3GuwgF49leYIwFDLReBtY+Sz76ywmtfuLjehwUDaNXTm3A==
X-Received: by 2002:a63:d118:: with SMTP id k24mr4539897pgg.420.1614879290507;
        Thu, 04 Mar 2021 09:34:50 -0800 (PST)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id g6sm48971pfi.15.2021.03.04.09.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 09:34:50 -0800 (PST)
Date:   Thu, 4 Mar 2021 09:34:46 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Minor update to bridge-utils
Message-ID: <20210304093446.356ba862@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small changes to bridge-utils to address some minor issues.

1. The default branch is main not master

2. Fixed some compiler warnings because Gcc 10 and Clang now
   do checks for string overflow.

3. Made a backup repository mirror at github.

4. Fixed version string printed

This is not a required update, none of these are important
or critical to users.

Do not intend to do any new features or serious fixes to
bridge-utils; all users should convert to iproute2/bridge command.
