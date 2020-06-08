Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485A81F1AD7
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 16:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgFHOUC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jun 2020 10:20:02 -0400
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17478 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgFHOUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 10:20:02 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2020 10:20:02 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1591625097; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=fw8s1Ddw2WDjfVB4TIfrGurSVTLMfRsuDwduIYprPXsHR9JvdlnqNS2jUiFEIwli+9q8c1cByJqfXbFXRi/HqJuWMK18mPpyeFuj94oR5L+tuhxFo6FiTAiRj+Zl2XJ/seSM3mi+Y8WMLUOEY79wq4PYFjCcwteN4AW2yGbNp/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1591625097; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Z+8wvRBJalmtpBnwOhUhu7XAQ7zQzr7IvaGDa5uNfwY=; 
        b=E+/earc6VCHFXA6TE7UmF5jQwCL1RdRGtILJ6+B4j62UgtTNplqMZTTaaiLhYxyV5nJWfDEjGSXONTZhppeD563J1ZmtKwgz4xwte79F12b2aOcpGeLLOYRm5JuFFgL/uaP2ccAB28x6pQWHLmSmuvDCD7K5hH9v2hvz7Nq7w+0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com> header.from=<dan@dlrobertson.com>
Received: from gothmog.test (pool-108-48-181-150.washdc.fios.verizon.net [108.48.181.150]) by mx.zohomail.com
        with SMTPS id 1591625095973357.72307675578963; Mon, 8 Jun 2020 07:04:55 -0700 (PDT)
From:   Dan Robertson <dan@dlrobertson.com>
To:     netdev@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>
Message-ID: <20200608140404.1449-1-dan@dlrobertson.com>
Subject: [PATCH 0/1] devlink: fix build with musl libc
Date:   Mon,  8 Jun 2020 14:04:03 +0000
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was unable to compile the devlink tool with musl libc. It seems like
the signal.h header should be included.

Cheers,

 - Dan

Dan Robertson (1):
  devlink: fix build with musl libc

 devlink/devlink.c | 1 +
 1 file changed, 1 insertion(+)


