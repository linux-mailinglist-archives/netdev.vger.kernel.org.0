Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7FA1581EA
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgBJSCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:02:45 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41723 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgBJSCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:02:45 -0500
Received: by mail-oi1-f194.google.com with SMTP id i1so10032155oie.8
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 10:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w/Bx0kL+G2z4OIA/a/DkjpZXfuO9hWJS1SYiRIUCguw=;
        b=TScI2P41Yef5dX3dJlPRKzF33TxWqfrtdSYbvcaybWmJg0rZUctc+t69WdXpK4u/5Y
         vNH8h9dh9oe+G0SZI/BC4YRx6IrXZIsnKBnFCbGvFTL6H9k1hS6uI42yvKTNTDcT2qpl
         YWD5OyjU6uX+vpbmc96umwuRT/1nIoB40TcVggIy2Sy/atyexDb75Vdciumf53nBCQoN
         iu8kZsY8gcXR95fYXHUIXeN4L2N/NSVL/FJjAHIZkP1zp+0thSJnFoCthmCSNjGh4aZD
         Zn/lCOQcWUNL112t2Wv/fVLLOSpWqhK81ZJNKwxDynTcimZI1/qwk8vASE2iiL2jMxNN
         ZAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=w/Bx0kL+G2z4OIA/a/DkjpZXfuO9hWJS1SYiRIUCguw=;
        b=G3OFkiu8j9y56OVSMe5wMM90f8jUIJq57KIoWTwAChRHA9PrTPJ77G/2+9AbzV+u5X
         Lhr1apdjNGj3kV4i1HXWzS3T8i7PCycnokQSM1nCuLRmfWyFAn5j5AAmawZCc6vWCueV
         apopfz5Kc1tut+gJR89V4WAT26WK/LoVs4msu+mmuq09bN5JcnCKwFM+NhvdlO8xWZ5f
         yJjzZ/6Iy6KhYDDEhorJrxp+L2ZAsvMrzjo2/eF9FXnzC0WzWQFCgOD43sisGGgSfuGs
         AhGwEmirssQVYuRFUf7NMhCj+nW86Fi1j5cEW2HAapKLj4V4rRzOkTPAeFIy/L8Z1Mjf
         yWcQ==
X-Gm-Message-State: APjAAAX9HLdmonIHfocI8Q564WkErJHiCTX7z96L2uu7ne9k7ZYRQZJT
        WHyiydiHzL/de27g6fqySxw=
X-Google-Smtp-Source: APXvYqx2+33w4R1qCWSA9bTv/S7dsaWSdgtgFsVk8NS9hL4k0BXhIziIGOCpKEV9UTk3jYO/zG50Jg==
X-Received: by 2002:aca:514e:: with SMTP id f75mr174684oib.103.1581357764522;
        Mon, 10 Feb 2020 10:02:44 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d131sm313031oia.36.2020.02.10.10.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 10:02:43 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "devel @ driverdev . osuosl . org Pietro Oliva" 
        <pietroliva@gmail.com>
Subject: [PATCH 0/6] staging: rtl8188eu and rtl8723bs - some fixes and cleanups
Date:   Mon, 10 Feb 2020 12:02:29 -0600
Message-Id: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was recently reported that staging drivers rtl8188eu and rtl8723bs
contained a security flaw because a parameter had not been checked.
The following patches fix that flaw and cleans up the routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Larry Finger (6):
  staging: rtl8188eu: Fix potential security hole
  staging: rtl8723bs: Fix potential security hole
  staging: rtl8188eu: Fix potential overuse of kernel memory
  staging: rtl8723bs: Fix potential overuse of kernel memory
  staging: rtl8188eu: Remove some unneeded goto statements
  staging: rtl8723bs: Remove unneeded goto statements

 .../staging/rtl8188eu/os_dep/ioctl_linux.c    | 40 +++++-----------
 .../staging/rtl8723bs/os_dep/ioctl_linux.c    | 47 +++++--------------
 2 files changed, 24 insertions(+), 63 deletions(-)

-- 
2.25.0

