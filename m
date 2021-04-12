Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BAA35BAFD
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbhDLHlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhDLHlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:41:46 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864A0C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:41:28 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so6861832otf.12
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gq//SnHwrJPV5+n/C8BhTXZvsus40jgi7G+pIZOH7rU=;
        b=FW0lKfj329NPEZeEwwIYXXihV0NzFrEkzj+Nz0VlsJujs8guvarWVjwweqfnsTCim8
         SsJ5BCCERW4kueTHqrdELWQOA3YsrnIZX4ClsCD7ZUZsh5NNVfXMJfkPrz8BMFU1NGqb
         i3/UA+0TXBTMw74D5f5tRi/UmUpVObc0gRhtmELvHoTauQWZKZ/HpaMUe19EHAYUCFKi
         YYSK5do9dFW7f+7/5S/0eLdNXy2VhizPAdYxSHidN/A+GVKk1zMID9oybJDi3RP1BG6n
         GoaoITLGUDJbrePi+uBwhUfwEHqULr9O+7i7f7Luiq2Xr9PUig5NPJS56R98RP9Dey6w
         8jBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gq//SnHwrJPV5+n/C8BhTXZvsus40jgi7G+pIZOH7rU=;
        b=fwmUaSiwoM8X/xnfjNMFXcEhorQj/QPMgSj5mipA1QrI/cs9mhzCUFGtfiNYsYNKxC
         a47tc5a30l6ISCB7sSJWBnKf+mZoQ3kdT7IXGpPyiqv5kXCitP19eWb82M6U5pzopDgU
         J87icIfpc83X20NknbtC/iSnTqDG7iLe4rgQQuFDuzEGYxV0Ls9kaub6ytYAhvvvBVeC
         qA65CZe5n/Db1quwq+PM8tgSA5sxZ8iQ6bV/3qnkPWynu7MxzyvRmqVxZA19pRVa5TNw
         LWAZf3WWvauk3nZsMQ6yBNJrC/n7+ZTNAcOdVixDSX3cm1mHd244W7eRq8M2sujJjOI6
         Gupw==
X-Gm-Message-State: AOAM531afuGLX6OfDHVMhelmY+EppLOFGMYO8bGfkCThSpKmmoPg6g6I
        pC4shaVmx8hrmaRq646E1PlVC136mSw=
X-Google-Smtp-Source: ABdhPJwM+iX2PQOrdfobTUxdnKNjxh8nVq3KyE9/S+WU/KDViRbOqZSaY2WbA51+GnWfdxCoeKqLLQ==
X-Received: by 2002:a9d:22a9:: with SMTP id y38mr11853599ota.345.1618213286329;
        Mon, 12 Apr 2021 00:41:26 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:70fe:cfb5:1414:607d])
        by smtp.gmail.com with ESMTPSA id 62sm2508421oto.60.2021.04.12.00.41.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:41:26 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 0/2] ibmvnic: improve error printing
Date:   Mon, 12 Apr 2021 02:41:26 -0500
Message-Id: <20210412074128.9313-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 prints reset reason as a string.
Patch 2 prints adapter state as a string.

Lijun Pan (2):
  ibmvnic: print reset reason as a string
  ibmvnic: print adapter state as a string

 drivers/net/ethernet/ibm/ibmvnic.c | 98 +++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 23 deletions(-)

-- 
2.23.0

