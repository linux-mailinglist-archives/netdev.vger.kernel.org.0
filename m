Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39F714039A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 06:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgAQFdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 00:33:10 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36943 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgAQFdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 00:33:10 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so2759816pjb.2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 21:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=btOu7Tr7FFV0vZ9EXQeVo4aIdvMnVyCJ/+AFdZy1O5c=;
        b=FRC912jAOzBZOBp59Wo1/GT+I0Fc7A71n9GO24mXIR5W/wyFa0SBTVzsVueWenHKSc
         YFcMQhnjAEKUcG0/K0cFYf8ODbChU1+IHs62usjOdQ2z61hixvNsr5T/oYBEAVtXktlH
         2W76Q4SOBB7OAzzu/FF39wNd/L/22bXKzfMmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=btOu7Tr7FFV0vZ9EXQeVo4aIdvMnVyCJ/+AFdZy1O5c=;
        b=p45CP+zVorcIJ3Bp86sqFApK9jiSpr8wwTFn6Oqo4YN+hHOJfpUdXsf3WlK/CdN58A
         Bel/2o8NcPijpVE9lYieKvfW6WDi8KYZ2CW/rRYchTQuBrDciQjYfQ76sG7wFopXs/9t
         FxsvkPsnxGNaBNTi6L7r+ooCGsaIbfeQHPfP/Pgw3tuSEcgPba5UOfxDJVZMR8ZyNWI9
         GLLJM6/5PSKzmMrk95nACu8aEgXdYRS+ZqD6zdt1sVM4bzvCgfFeFxtV/NDYwRfhgW1P
         TEDWcumdqXMHVvmSODk6R06F0m9gxiWDx5COg6OTYPSdqe9JU04SRTx3nqS1NYmtXSYl
         RiDg==
X-Gm-Message-State: APjAAAWv5+4pEhryyn1/sv0PgNChXLWxMZRg0cB32qK/rXPvWbBHvpD4
        iMNswoR3G7aiH5BzI3lPh0bSQEKVvCw=
X-Google-Smtp-Source: APXvYqwf98qm0rrTVjdVrR9/GDwAjJBwMLDfQJZ/EoksKYevzTR3B6LhlrStYt/tX4xJRA+SeEaqHg==
X-Received: by 2002:a17:90a:d78f:: with SMTP id z15mr3686717pju.36.1579239189598;
        Thu, 16 Jan 2020 21:33:09 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c188sm1357142pga.83.2020.01.16.21.33.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jan 2020 21:33:09 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/3] bnxt_en: Bug fixes.
Date:   Fri, 17 Jan 2020 00:32:44 -0500
Message-Id: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3 small bug fix patches.  The 1st two are aRFS fixes and the last one
fixes a fatal driver load failure on some kernels without PCIe
extended config space support enabled.

Please also queue these for -stable.  Thanks.

Michael Chan (3):
  bnxt_en: Fix NTUPLE firmware command failures.
  bnxt_en: Fix ipv6 RFS filter matching logic.
  bnxt_en: Do not treat DSN (Digital Serial Number) read failure as
    fatal.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 29 ++++++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  4 +---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  3 +++
 3 files changed, 24 insertions(+), 12 deletions(-)

-- 
2.5.1

