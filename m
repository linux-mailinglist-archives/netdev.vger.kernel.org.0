Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273A6545071
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241852AbiFIPRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiFIPRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:17:19 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFC949F0C;
        Thu,  9 Jun 2022 08:17:18 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id f13so3895255qtb.5;
        Thu, 09 Jun 2022 08:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oq3dIDNIMEkgkkjigIKDX3xIp8j86P4uihh5ubzqFg=;
        b=FdREmWVOPAv3GeOUL7CtFCW1judfDet+b8i1w5liolWNQ5pfT1bbQMHPoZOqQuwuWQ
         OlNVotfk1kF6k9s1lijnlLNxvHNy7+gbVOj5SfCLMG/Dln34/dYr9HcQClf1Wvhodgg2
         MQXdLL3ApIBUIdfedQQ8CMoeW18uWicrOk5yeTMwtZqvwPYYzkp3y0KO9EJgIff70ZV/
         JJp14nWGCpk2RgoJLhEBUBbIwMK3y77O6ST1Zwfp2LM/0hib+3GBhIp97Qoejen8zEF/
         5RGOSNmMpm3BkcQeA//vNRcoWTrxsnCoDa65gUTX9RxXKoN/JaoMEFI9LV7KoDRUyeCj
         2JOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oq3dIDNIMEkgkkjigIKDX3xIp8j86P4uihh5ubzqFg=;
        b=5wYOra59AhkGPvLY/G9WnfuCzwoCNUjhG7wr+T7894BmMwQt+Ai+C7gk3Lr+T2iCe8
         ODbR7DI+QiweeIswRwFad3V7AEUfBxu3fJ/JG+0QinRAnkfVvYw/e1LVHKOp5NA9BO9g
         Qn+F7mvaPiZz6tFgCw+ZqNkIIZ7HfG1Cw3EGklAOMCurnz6N+lhsnrYyV6j3CVj5Dfqg
         5qKHtF9Vg+TK1VZnRUrVUslPlFLFfNTYZELfAWGQTegg8tGv16bPTKZqL/2gMBB/sqOk
         0NdooDcphDFL5glIMXH7qhlyoICESUuQ5zJshLCmV9oIRgM9cFuDC0WqdJ9qcmVvMRBw
         wmlw==
X-Gm-Message-State: AOAM532eyJIYI9HnMHC5wL4nL6RFFzPY/Vq4noXyg2jKSarD3ilbX5hE
        wfmoFT0O9LEkCbVwevqNvGKZTowr6kxZkg/B
X-Google-Smtp-Source: ABdhPJz2fCSRAWKt8/L59BHSYWtHP07ohwCntcKU+gudiIFYH5iGk57ffyop+pEGR4bKqI0Uum18Mg==
X-Received: by 2002:a05:622a:86:b0:305:7c7:b87d with SMTP id o6-20020a05622a008600b0030507c7b87dmr6115960qtw.24.1654787837040;
        Thu, 09 Jun 2022 08:17:17 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n64-20020a37bd43000000b006a60190ed0fsm18199469qkf.74.2022.06.09.08.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:17:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCHv2 net 0/3] Documentation: add description for a couple of sctp sysctl options
Date:   Thu,  9 Jun 2022 11:17:12 -0400
Message-Id: <cover.1654787716.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a couple of sysctl options I recently added, but missed adding
documents for them. Especially for net.sctp.intl_enable, it's hard for
users to setup stream interleaving, as it also needs to call some socket
options.

This patchset is to add documents for them.

v1->v2:
  - Improved the description on Patch 2/3, as Marcelo suggested.

Xin Long (3):
  Documentation: add description for net.sctp.reconf_enable
  Documentation: add description for net.sctp.intl_enable
  Documentation: add description for net.sctp.ecn_enable

 Documentation/networking/ip-sysctl.rst | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

-- 
2.31.1

