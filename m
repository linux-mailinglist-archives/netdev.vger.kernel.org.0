Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B80D40C307
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbhIOJxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbhIOJwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 05:52:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C85EC0613C1;
        Wed, 15 Sep 2021 02:51:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d18so1265155pll.11;
        Wed, 15 Sep 2021 02:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sUSmr12v9Bo5Byp/V6urxSvl7zwFZywsKFOWRFNJLTw=;
        b=WmI3bi++W0xTdGlhtyNQK3tB9iP5O0nYKnVki6nScCzeYiiyFZaoWhQv6mr1e5j967
         RAzTsH5ZW9QL9vV+PwBQVES/vbRfoFJiMBGRItSFOi/KMtJI4bnXGk45XtjADvebFJJN
         xnxwWMac4MlIXNTHv6W0LPVauK4wniwfFqramxVHciU8h85YudABbcaHd3TOV7yl2wsP
         4gpytibimyjOQeEzlZ/yBcsWXexwOjdPHarmUUWDa66EOw8eC/aAeMT+36XUHuGAL6sP
         amQXmEurNv5EJ7qCoxRUb2p07OOqY4u8lYrawUHMS78XlOkRa7bGb6V4hKzHI6chkfs5
         Sm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUSmr12v9Bo5Byp/V6urxSvl7zwFZywsKFOWRFNJLTw=;
        b=hs8tNWIbtBEmVS+RMjO1YF55OaL4vXP75gxqA5qIAuR7yFzKLD2J+F0D1D2zSFZwzn
         tkiCCBZCmqCwK26qJt1f5aVrstyFAlXIp0KM1LfKTA9wsGeHFCQM7pLxXfvuz6Zkm74+
         k6D6POW0D2vy+kZ2Cu8lk2Z2SfLQxESeg9jiauAXLNgvQeaIn7Kmjc5ARodsoH+DTANo
         jyxabLPYCE9XP9RhFzEzKRfzcYykLEEe9HbkWfNbemPFxm3jibJJJygrp0dMqWu24pPT
         CrR+npajTuiZRfhvo5LYNsnJpWBNZFraZsXmUPiLS9UI61Dv+7OgmamfENHwktOkFs8u
         VNMg==
X-Gm-Message-State: AOAM5328Shq5PiraoaJyikuYVw3OrbQEh4/pYy6Ae/nlSXUyjpJ45IQv
        6cQ9qKP9IZocYe9zns34z9A=
X-Google-Smtp-Source: ABdhPJwGAi9Iv17btUdQrbqckp9UWJ3tdzA/ho65kcTlhQlGitUd9VXOZfxIuhodi6HFUHUjGoTZbw==
X-Received: by 2002:a17:90b:4c4f:: with SMTP id np15mr7525631pjb.30.1631699490057;
        Wed, 15 Sep 2021 02:51:30 -0700 (PDT)
Received: from localhost.localdomain ([212.102.44.87])
        by smtp.gmail.com with ESMTPSA id x75sm14628022pgx.43.2021.09.15.02.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 02:51:29 -0700 (PDT)
From:   youling257 <youling257@gmail.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/10] netfilter: x_tables: never register tables by default
Date:   Wed, 15 Sep 2021 17:51:16 +0800
Message-Id: <20210915095116.14686-1-youling257@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811084908.14744-10-pablo@netfilter.org>
References: <20210811084908.14744-10-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch cause kernel panic on my userspace, my userspace is androidx86 7.
