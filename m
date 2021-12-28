Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC24480DDA
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 00:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhL1XGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 18:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237710AbhL1XGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 18:06:10 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3322C061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 15:06:10 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c3so1348858pls.5
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 15:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Av10FJHZ16PNlaWBwLeHhLYMKvHi/4lm87heoggNDKA=;
        b=hP6OsgRnVWbIWxpX3nkx7UcVDxj72rgqvWPo4u4mUd5yOIkSibWq3BNzRychj9rkyK
         nOyYDZZO4tzNNbopxFVeuavB1cwlJzGlpKpMaf/qNjb9EHTL39R8JG45Qp2jk9WlfQV2
         cILdfjcoDGKo019LrXzdrYPXdGKU3cC+6MtIkjAQ8Axlie8wpoVqp9quP1h1duepwrPR
         o8CFWJQ/cXZsESn8S5p2yVLSdCmYDBlKAc3sk/F0KuniJcHrrvHAkE9HWDmPTgotOgIp
         IGzPa2bXk8s1VSejC7oeJ4T598KReqtEbao+dRWvZcG1V+OfOlWBmNDlPEQBUUrxyDL/
         g7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Av10FJHZ16PNlaWBwLeHhLYMKvHi/4lm87heoggNDKA=;
        b=MgcPCWj0MjW+3tmeorxFHTMXXfw5kCZ9D50j201T/Nwm1Ph7zO/3kNhYAj9LA9qEoh
         5iSUrNryMHZLPQmIaL3J1+pvQtjkJSwGH8Zt1VpF9zRWzsgr5S+WzPiE8zHI6vO1Uf+8
         fxXId2SJqJz+hboEi34fBfbViRoLO/zLEJtH5tFw6UB3Hv6NuuCjqJNsLJqQkKkR4NAn
         ngU7bHy9cCmOV+mGTstfK0K9SVD/9tCw2VllMEAMRp/IKOOQtY9N1Y8HZRLlFC3J4fo2
         eGLm97RjFjK9OmxbZhg+wAu2LDA/hM0rjENv2D2Y76mPMb83TTrog69Pqc7okpPdoPnG
         EDew==
X-Gm-Message-State: AOAM530cUe794VU0+PuJ3Azps2RHHa/RWUIFWopjxji4t6fVnn/eGL3o
        ADW+QWJLXUT9W6TvaTY3hi/7jhAAIq7U8TxT5K4=
X-Google-Smtp-Source: ABdhPJzhr0rd9BJ5iXll8JuFYVjzBaC37xsiXCYWprkd9Z2Nh/v2jAxDuogNAnffct5ORaSVWARhOzO6nH/wn9HqGLo=
X-Received: by 2002:a17:90b:f17:: with SMTP id br23mr29145962pjb.178.1640732770205;
 Tue, 28 Dec 2021 15:06:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a11:390:0:0:0:0 with HTTP; Tue, 28 Dec 2021 15:06:09
 -0800 (PST)
Reply-To: fionahill.usa@hotmail.com
From:   Fiona Hill <tonyelumelu67@gmail.com>
Date:   Tue, 28 Dec 2021 15:06:09 -0800
Message-ID: <CAAVnhxJ8GBs7r6PByEz0cSPEO0Q_dN65j9V3LUcNsPgKezXZMw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi, did you receive my message  i send to you?
