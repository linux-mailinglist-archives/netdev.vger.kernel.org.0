Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB9635BB10
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbhDLHnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbhDLHnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:43:46 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D8DC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:43:28 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so11971681otk.5
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gvpmTEzF8bheKrRvmeulsRr1rrBhc1dlID5nRIUcm+Y=;
        b=Y6V6N+YDa2TX0dv8bLZ5Sim+LMYJdEs8SUuLTd0gBkE+0Gx1IlLR+g3JnjXJxAzePO
         jBOtKnA9kY/UyrAAr92Z8K6MKqBMD0qumlzJCqZ7u1x2ZcmORw1TpTTYtKibGYOuncOW
         bZBNLXER0EndKunoZNbzl/u7odpts5ImHMZJ00UgDrIBkZ/Nvq2JGlgi462SE8wzKu9c
         jdmYXmDq6vSF4yp5QOsKrWPo1BO0xcE/bZqfe9XexTTwHq2MGOjW/YcFqjrlz54ocW7Z
         ggUisj0lXho0z3XRlyCmaglsah8jWCYm3a7SoWbGf1c9YhbREbi9ZdK9aA41iXU+CaFZ
         q4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gvpmTEzF8bheKrRvmeulsRr1rrBhc1dlID5nRIUcm+Y=;
        b=nxKht+MjGZHqxh8qwrDp/aWVmYB7cRsrWpzWWMAycpZBqk2LV0oP1ySqWWzuqwSS7g
         MV89pLlkpT/vHBwoQsJeTUDPrNu9JhBBiu9SRg/m6fUa8YM1akn6bcuRC3UAiMA64TyF
         xpdzmsfbLdEBS5hC8M3tDrk5e86DR2RkNucoIS3Bi+y+UZcnTeZ0b3dqzJXC4JivwThk
         4gPaHMNjT76Xql0EzXxyThoEz1LkjTVUkKyjtQNdqoNTzoEoNQdxbc1qRCwkx/g/Xwii
         aiLO2hRuGMnL/LZ43NCN8iRjXNT85utcLhHEvad2JEFXAWIqMHYE0XNlHstvqDqPGPor
         XSfQ==
X-Gm-Message-State: AOAM533j/GWy184ykVh8MDWPC1UwsZSf1jLWR3STxPQsXEhGCe0uy4S/
        j0S4TR4j5FhRINdxamDng4yTlBtUbVk=
X-Google-Smtp-Source: ABdhPJzi9zx6H9xTZILgYOkcbhso8mZn/KVeRF4AcxOpM/t0C7LvnEWf9INX81JJWFWTd5BDKgK1ag==
X-Received: by 2002:a05:6830:1694:: with SMTP id k20mr23013753otr.241.1618213408192;
        Mon, 12 Apr 2021 00:43:28 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:70fe:cfb5:1414:607d])
        by smtp.gmail.com with ESMTPSA id f12sm2485676otf.65.2021.04.12.00.43.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:43:27 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 0/2] ibmvnic: sysfs changes
Date:   Mon, 12 Apr 2021 02:43:28 -0500
Message-Id: <20210412074330.9371-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 improves the failover sysfs entry.
Patch 2 adds sysfs entry for timeout and fatal resets.

Lijun Pan (2):
  ibmvnic: improve failover sysfs entry
  ibmvnic: add sysfs entry for timeout and fatal reset

 drivers/net/ethernet/ibm/ibmvnic.c | 56 +++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 5 deletions(-)

-- 
2.23.0

