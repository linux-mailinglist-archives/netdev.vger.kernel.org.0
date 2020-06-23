Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3765205874
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbgFWRYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732565AbgFWRYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:24:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474CCC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 10:24:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h185so10406095pfg.2
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 10:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4MF/jSggblUQtpRz+SrD+6Y1SBuzeSInekmXLwzhUfc=;
        b=QY8e15EV/lOqQjzm7sBhD7h9hPARrmqF6kIRLnqjlcsJ0X0+huM9cJPb1ItVii/BM0
         Fr9BWCb3QB/IgdfP6Exrk0QENGBnYSYwrbT6YsJO/m6XSe6hbNeXl0J9yE/iruQyqxtD
         8Szmou6RsTHdbiUJp1LK5IVKkcaEp1eQ4g4lSYz+j8tK1vm8GP9i/+qXDG0EL6zzEI55
         mlCdwo2VTr7DKaRyE6d3EQTIHPa01qVCJAZV0OjlNCqGnA7j3tkBx480I2Vpba6VCJlX
         7LT/QK+hIWiOCn/eAidD8aHiqJPCHLpisfI+6uiSMRbTZGVy55l7mAkZvHuy7kzNI4NV
         XouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4MF/jSggblUQtpRz+SrD+6Y1SBuzeSInekmXLwzhUfc=;
        b=Bfc/R0OyvHuHwFSOl3tKebXqVdmLGgBU4CASqHcWEp1rrPcu1vWjIp3p8NJ0UhsTf3
         ALbtoa3FoDEjEFVhHrFvLEQosycst8PbEd8sxGr0t5AILfCu1EPWXrOI4hHo0jKBEW3j
         oiUflyo4JsuMLLBDxZ2igd3pq7oHb269ohQR5esIaXyWJ7FWw8+Z9T6dqN39ECvWz6yc
         LVLYpRgK3AGHxg7w8iNTaxDYXann4lSKYJ+chYijdBy8ZLCLjH/4lt0wMZQ3oT7qLLzT
         HpPJOxddtwgPKgD/ktrBK1a+zA0O7dP7oTx1r4VCbzzW5RDg1oBReQlMvV1NsKferXtN
         cZBA==
X-Gm-Message-State: AOAM531ZNgr8HKYpY4XSGaQ5ySnGP4uRBZYi5sMUN34JM4OOMOipExas
        z9SuXsOxRDhQYMTpoa2Zo9FHjryii4c=
X-Google-Smtp-Source: ABdhPJx5YBQkY7Smpf/jFf0VTa5RQXg0bpGV8eQlyNr8isqqBzx8E965LYlaJNvn7XK3wxv038ErcQ==
X-Received: by 2002:aa7:9818:: with SMTP id e24mr26819011pfl.30.1592933060234;
        Tue, 23 Jun 2020 10:24:20 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k2sm14379805pgm.11.2020.06.23.10.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 10:24:19 -0700 (PDT)
Date:   Tue, 23 Jun 2020 10:24:11 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [ANNOUNCE] bridge-utils 1.7
Message-ID: <20200623102411.4bd23197@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been over 4 years since last bridge-utils release.
The code is deprecated/dead/frozen at this point but worth putting
out release to get rid of enslave references.

Current git repo is at:
    git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/bridge-utils.git


Also, it is opportunity to make it clear in README that no further
changes are expected.

Aleksander Morgado (1):
      libbridge: add missing sys/time.h include in header

David Michael (1):
      libbridge: Include the configured CFLAGS when compiling

Stephen Hemminger (4):
      brctl: fix signed/unsigned comparison warnings
      Remove out of date TODO
      Replace references to enslave
      README: mark bridge-utils as deprecated
