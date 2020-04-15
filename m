Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB9F1AAA7E
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370887AbgDOOlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636732AbgDOOkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:40:16 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93936C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:15 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 198so2819020lfo.7
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q8JYXWie+ekBTIqOv7hUYZhiSqpE6DoV8lqw4ugbPoc=;
        b=mhUmAxqr5LW9qWRbBv8VUSRiZ2USvEd3QXBVwKcFPmJPqiFPJ7afE/vDoBo1dZF4Zn
         jap0YP23K1V/2eglo/jfGcxklGU/INeUhVhvRgSPvryo4sG3NLkg8nmOtK2SMtVVQEFB
         gL+FG7rY/ZyqYaYR+hkhGUw/oz1Dk0FyqTXEiOVyd04BlV+7f3vnV3C4HXrX0ON3R9Nv
         NaK8VGN9Fvjgyigf+9gE5kSfrzOq1qFkJs9/zffaCTqmYVzSqnKjjgLC0V1AxnFgbhqM
         GOIKlCuX//PlUNpSX+zwRZ8aTuLmBowrfCm3srd6WpbZLowyDtj+DLMBuVK2nuWbb7J7
         /Pwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q8JYXWie+ekBTIqOv7hUYZhiSqpE6DoV8lqw4ugbPoc=;
        b=NVkaZ0GbtV3mRLUmbUtI5Q7sPSdU6Ojet3SW0T6PH2DdDaBO55sYyy6Pf7dZdu3bQz
         NK6wHYc+nDaWOCeApVXaldRRiJhGbQauqxDn099yqvlLMmMQ8iJFvdNcfmA4U+AZjzHI
         BhyHm7Na8OvIxmSXX2k3iApGJyUb+lJh1UwgAJ7/pu91hM/m0HaIuVhhrVybNnK4fAYj
         Hk4zCH1PT4KaDWqEI4bzz1SJzkBPDA+H75wW3F9OE6KPYtNjTY8PYVf2Sl5OYvbD2WCu
         b6b1dSQ+9InPD9zj7Fro7OVIedzVMCHzqahrZV1mYKu+F+BYbxKmBBEf2y8L3CGl3h9g
         sCBg==
X-Gm-Message-State: AGi0PuaPhjLctZqS2Hz9yRZrfNfvuyq4OY3hCgifGBLG5kYVhwI7iM2O
        E9Sv3qhjkDNDuiV7MhCjBKWeRQ==
X-Google-Smtp-Source: APiQypLnVoSvDk6WfaSnUbrWjLE/VERL3fQIbVVxM3dV6hiryLD1WpvmjgjHROc6t82nvRX+YD7zAQ==
X-Received: by 2002:a19:7706:: with SMTP id s6mr3276769lfc.31.1586961612244;
        Wed, 15 Apr 2020 07:40:12 -0700 (PDT)
Received: from xps13.home ([2001:4649:7d40:0:4415:c24b:59d6:7e4a])
        by smtp.gmail.com with ESMTPSA id l22sm1860327lja.74.2020.04.15.07.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 07:40:11 -0700 (PDT)
From:   Odin Ugedal <odin@ugedal.com>
To:     toke@redhat.com, netdev@vger.kernel.org
Cc:     Odin Ugedal <odin@ugedal.com>
Subject: [PATCH 0/3] q_cake: minor fixes and cleanups
Date:   Wed, 15 Apr 2020 16:39:33 +0200
Message-Id: <20200415143936.18924-1-odin@ugedal.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some minor changes/fixes to the qdisc cake implementation.

Odin Ugedal (3):
  q_cake: Make fwmark uint instead of int
  q_cake: properly print memlimit
  q_cake: detect overflow in get_size

 tc/q_cake.c  | 15 ++++++++-------
 tc/tc_util.c |  5 +++++
 2 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.26.1

