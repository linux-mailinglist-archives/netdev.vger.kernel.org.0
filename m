Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E009F318545
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhBKGoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBKGoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:11 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E8BC061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:30 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id k204so5008680oih.3
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=InYMZ4izNpMO2fL1kuBwqbCI+UVM/pZn4Lt83w969Sk=;
        b=m7EtmEfEWrWLQmFkoOCkZV+4konbkcWqB34K+js7wZ+hjGqBW0qvRfH7n184Aznizh
         /b1YCJgq8r14qvcMtb0YMXxnwwJLpkK3yo2ml9A25UGtiqJCxv5bHeEVI5WyzgL4pyap
         oo/5sQMOVW51UPD2uh8dDAfYaJ10GQq2AhGRMUN8VCIv9bYgHyZGKlz0++xh/HFlDfPw
         QAmCMiGagSAtWIV1dhEssItawcita6Kr30Pc6evnfMIsxdMBcbLCLz2qtHzwkbzwwdnT
         MOq20EQ2ul5vvRHeYk9OLD72ob5taeH5fpb5ibiZ4xdxRGUjMFHnmgOGNBnK/RPDNyFk
         xHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=InYMZ4izNpMO2fL1kuBwqbCI+UVM/pZn4Lt83w969Sk=;
        b=qzT0S1411+PrqOCQULu21C2catTDGT+MA02PaBoUXcHdvx9OWRDPYxMGIS90bsCX/t
         nIWHfqd5uIz3LKbiTPHOXULzctBS0OTBqTBB0jfreR1va+5lZUbRBvcd2ZDYYHj/hid+
         EJv0aG9C5niWLLTFDgczjaL25Yn9CykDkLalwIXEdd0EHozZMdhbArlvYOPS628qhj3n
         aIA8Mmgx+Gqpu7YQSXzcXwSEIhygrCks4/tOQVovy+/768CjnCM2szj5UwJE7iiAK70M
         VAKe+8gwtLruQ3OoleGt7+azLH89eQeEq8EBtcQmFvt/HJoudc3MqoeW9eWiHMH81rBo
         R3Gw==
X-Gm-Message-State: AOAM533QSXwfuUK9YAnd2apxdZrwAOJzrTSs7SSahf1JBla8KwwbNt82
        5uGnB+ITJ4/hxE0oAzPDJRtc12sF+PQ=
X-Google-Smtp-Source: ABdhPJzCZU/SQudiLzyPDuAwWyXxICcZ6XNS6KXaa9ulsNdKH8Ctbxx2V9AeSSnBcsn1vUmAGRIZpA==
X-Received: by 2002:a54:4193:: with SMTP id 19mr1831298oiy.168.1613025810079;
        Wed, 10 Feb 2021 22:43:30 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:29 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next v2 0/8] a set of fixes of coding style
Date:   Thu, 11 Feb 2021 00:43:17 -0600
Message-Id: <20210211064325.80591-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series address several coding style problems.

v2: rebased on top of tree. Add the Reviewed-by tag from v1 reviews.
    patch 8/8 is new.

Lijun Pan (8):
  ibmvnic: prefer 'unsigned long' over 'unsigned long int'
  ibmvnic: fix block comments
  ibmvnic: fix braces
  ibmvnic: avoid multiple line dereference
  ibmvnic: fix miscellaneous checks
  ibmvnic: add comments for spinlock_t definitions
  ibmvnic: remove unused spinlock_t stats_lock definition
  ibmvnic: prefer strscpy over strlcpy

 drivers/net/ethernet/ibm/ibmvnic.c | 71 ++++++++++++++----------------
 drivers/net/ethernet/ibm/ibmvnic.h | 11 ++---
 2 files changed, 38 insertions(+), 44 deletions(-)

-- 
2.23.0

