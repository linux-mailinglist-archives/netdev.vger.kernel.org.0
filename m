Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A30419FAC5
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 18:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgDFQuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 12:50:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32894 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbgDFQuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 12:50:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id c138so7834909pfc.0
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 09:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9JLknV6ae767PUp9rz88Q+OGL7hEADn7zVjKVqjY0to=;
        b=t27DPsSt/aJPS3jMrU8LEKlGn4Knia+kLOMHG82EcsuxzJAqxoY7oXPytJbGDfnOZP
         1Sork/l36ua6t+6QO1DO1qr2Gy7d38FkmpAQ4nSv+zs53X8VRffNkW2OHTvNp0UHu6IF
         KpI8CXjFvLCWJ4MDUA8uzc/ylUhlyxt++jMJ7f9VwaV0FtL28r0fcbHFTcRvoHbKCjx9
         RE0ZMbcs1QUbFLS9DgR0NogFTlrzIeFfyOfHD8s2RA8aAl2c1Thlb06eJUhFD/1lF2pM
         VdE2yTmXwSZ2cG28RZySdaLQ+L5nrIz+5ZSgTmoqdI0mGTN14yjV9BzW9w6wGHzzMTL6
         hH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9JLknV6ae767PUp9rz88Q+OGL7hEADn7zVjKVqjY0to=;
        b=k/KEyPazKUKoBAnLRCM1MfJQ8iirtF17tMDBfDTbbQGMaYbP30Mfr+dGFifQ7mGvho
         rfPABltYyHHSd3y3X2tVWqAKL09KiHyc6d09ffIhyVummtIuXgCRBoJ7pyrIHREZIwsc
         eeGEBRLZyTjVgea7G3RsFsV9OMs6ZaYBVq/vwnD4F229IHKy22hqFqBvwZbXXgCiMMLd
         Mt5kK+z61IEEfhL+CsVLf+Q+DIGfEILcnzqqRf7ks5Er36NWfbThMLEcFe83W5Aro26h
         fDrxZRK57SkXj/tebkH9EyWFcHvOb0QgJgAcqmkPDufIDWeF6IvNPQq07GRV+FehedWX
         2ViQ==
X-Gm-Message-State: AGi0PuaraZyreXy+B31kverysh8SdfGZdV0nDMPA2eSX2f+jxbV1q/V8
        UrO0ntWL9MCbBAfshU5gfYqdHNvb4+aYdA==
X-Google-Smtp-Source: APiQypIXDinyhi8Tc+MaebdC9DWVjYTtWW+AMuy0Pkk/C5MME/sl/Kqaqb45Ii3qaclX+UYEo06/ng==
X-Received: by 2002:a63:f74c:: with SMTP id f12mr1210062pgk.241.1586191803047;
        Mon, 06 Apr 2020 09:50:03 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y4sm12070996pfo.39.2020.04.06.09.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 09:50:01 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>, jiri@mellanox.com
Subject: [PATCH iproute2] tc: fix man page formatting
Date:   Mon,  6 Apr 2020 09:49:54 -0700
Message-Id: <20200406164954.15974-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running make check after iproute2-next merge flags a new
man page error.

Checking manpages for syntax errors...
an-old.tmac: <standard input>: line 86: 'R' is a string (producing the registered sign), not a macro.
Error in tc-actions.8

Fixes: 341903dd3bd6 ("tc: m_action: introduce support for hw stats type")
Cc: jiri@mellanox.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/tc-actions.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
index 21795193b81e..53e4408d0954 100644
--- a/man/man8/tc-actions.8
+++ b/man/man8/tc-actions.8
@@ -83,7 +83,7 @@ ACTNAME
 :=
 .BR hw_stats " {"
 .IR immediate " | " delayed " | " disabled
-.R }
+}
 
 .I ACTDETAIL
 :=
-- 
2.20.1

