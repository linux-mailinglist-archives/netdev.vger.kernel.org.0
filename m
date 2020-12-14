Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B592D97FC
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 13:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407646AbgLNM3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 07:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731433AbgLNM3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 07:29:00 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3841C0613CF;
        Mon, 14 Dec 2020 04:28:34 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id y8so8518677plp.8;
        Mon, 14 Dec 2020 04:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=07u9K7qAejnZ1AxQEPtLr06bSZi6WWdia77VeMAOMaQ=;
        b=JcEyTWu2UOHibV9usPkBnZgqxc6g0lA6QrFTY24VeoqEAidkt/WdGG+XbslL0jPO/H
         l5g0bt/7Me4Jt/SMbugHdEjgVMOju/eDaTGDs5ESL7Wy5c5PVPsIgoGgpv0zyOTgMvYD
         pN/ZttlxrNTaQNStVjOvNDyf5m0+vjv/wTgMBtItvnh5jwYI773m0YxikZfaFuRun98K
         yl/T74D/N1kemj6hLvl2usJAMZKu0CEZevKGQDEYaVwexhH6AHbhXlRi1YeoqwLoaPAv
         G5aFhrGzXZy/6LM39akORWCqnpJ86b18LMsTTdTf2TXJXjXv8eHePKBKpruh2hwLu8Ro
         xYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=07u9K7qAejnZ1AxQEPtLr06bSZi6WWdia77VeMAOMaQ=;
        b=USZsaVovCK4bI+Hfc+PG0fjV/4rav5HPsvT+lwn1mbeuDul8t3gSD0JGd28cUcNVva
         TiZ+YzBFQ8Fo5Km6dedDskqQRVqqnynftAltpO1nFgaRALSMFxEf7yFOVBXURp1g2r0f
         Pj0NAOaQThy3M+zy4Qq7qOwvu/oblaORCGgVZdiiirYVQfgGACkuE8gpfJ9hVLKZyEap
         gpkGBQp7aI7QTFiNdNjnMQjF6jc0aafSE4fVBwyoOREqP7PhbZYSfNGwF6dcRtesy/Iz
         g+vuHoIsmc7nlFPzrdq9CtCstypedYu8NRtlRPPMzMSfv1hlh1jk40XS7muoiFY9EcpB
         Qghw==
X-Gm-Message-State: AOAM530cJ6YfuTBmhGyp5VTr5kjZ7r1qZIcYdH6bEpuaRBft5ESH/tPR
        Wnh15RjOZ+z0jpYIQ2e7tVFp8fEg1yg=
X-Google-Smtp-Source: ABdhPJxvFyea72ZXOadXN6hiQN2xi1NxMm3ERgg4Kc38UImajV8HVri2OqtZkR8lGNCqQsmQ7AphMQ==
X-Received: by 2002:a17:90a:a58f:: with SMTP id b15mr17964901pjq.17.1607948914220;
        Mon, 14 Dec 2020 04:28:34 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id i2sm18938458pjd.21.2020.12.14.04.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 04:28:33 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] MAINTAINERS: Update maintainer for SAMSUNG S3FWRN5 NFC
Date:   Mon, 14 Dec 2020 21:28:23 +0900
Message-Id: <20201214122823.2061-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

add an email to look after the SAMSUNG NFC driver.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c1a6ba5ef26..cb1634eb010d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15425,6 +15425,7 @@ F:	include/media/drv-intf/s3c_camif.h
 SAMSUNG S3FWRN5 NFC DRIVER
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Krzysztof Opasiak <k.opasiak@samsung.com>
+M:	Bongsu Jeon <bongsu.jeon@samsung.com>
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
-- 
2.17.1

