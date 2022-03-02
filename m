Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86DB4C9A01
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 01:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbiCBAoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 19:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiCBAoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 19:44:14 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0E75E776;
        Tue,  1 Mar 2022 16:43:32 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id y11so405307pfa.6;
        Tue, 01 Mar 2022 16:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fp/ZzC2cCQ2Io+M+604eQm7eXnqtJaZUFyzMY2YG4e4=;
        b=MfFzGIps6M/RpO6zEdt6Gh5s1OyHw8P6HX6DsV3Ua9TMoQF+2a6ZDXJeuhDVvFxY1H
         TkjpTdvzJMdM5x7mNJqkXJZ7jRdHMCHk2lGvCl3Fyiao09PTeZkLtaGTKBEXdUUPmJe8
         6s2JZy3Er2b8tfOoftN7Tf3rEPYw1CBVk90ccdGvazcHQF25FbdXZ6T1Wfxw6A7iZ7RR
         /lpz9AJNu6llTUwBjrcq+OIjJfOAc5BJD/D12tKZJ9hmQaPloELTFlPQcbZqYHiLldE3
         6AXI3kz6xSgTpesmBz03ML7k8aRonqPnS0zTtNhYLt9C27gTIc9P/oV/QmntahSyeroF
         FrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fp/ZzC2cCQ2Io+M+604eQm7eXnqtJaZUFyzMY2YG4e4=;
        b=tYm3NvSBSKVAjTPVM11tDs/FKrjctuy7+g6gE9b4lJIKBgrODB/QtYn3DvDu813M1p
         mdMgVnAaPbYOQGBnXIrzanrZAG+oMH5xhRSJCbtBjATGCPnRmA49KCnk9RXTrXVuedQ3
         883yEjkwzmVofH3UBXlOhAS1+cqmpPbeuZ+aOxU1L67aNFN91wU7UJVhtRSg5GYyWddM
         MBzxYJsBrfPAGs/7Qd6kcdwCAg2jN+0lwE/OqKXGWBfwxqNZmx03m8t0+ULnL9zeiKMA
         i+VCpeEFMSFfSMa+Yo5LtB5Tmnae9AW5NR41Hp/piTXKx4FKbBh8YS4TliEMx3Q5Gcto
         3jfw==
X-Gm-Message-State: AOAM53138qfDM3jUIyQK949OYABp0mCkrX9yCzVqq1Ucy9C2KXnavLkc
        xXjrzXDh8OjERmDxgvqJgCdcCvkV8Eg=
X-Google-Smtp-Source: ABdhPJxEg290Uy1RuipYnwv0zJsQxgPpaDyhoftDKqyws7uGD5nLvyxlPaD10XUTCITGaP8iB1FXiQ==
X-Received: by 2002:a63:e54d:0:b0:375:5987:af5d with SMTP id z13-20020a63e54d000000b003755987af5dmr24160022pgj.14.1646181812227;
        Tue, 01 Mar 2022 16:43:32 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id 6-20020a630006000000b0036d11540db8sm14046833pga.76.2022.03.01.16.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 16:43:31 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-03-01
Date:   Tue,  1 Mar 2022 16:43:30 -0800
Message-Id: <20220302004330.125536-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The following changes since commit caef14b7530c065fb85d54492768fa48fdb5093e:

  net: ipa: fix a build dependency (2022-02-28 11:44:27 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-03-01

for you to fetch changes up to 275f3f64870245b06188f24bdf917e55a813d294:

  Bluetooth: Fix not checking MGMT cmd pending queue (2022-03-01 16:10:58 -0800)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix regression with scanning not working in some systems.

----------------------------------------------------------------
Brian Gix (1):
      Bluetooth: Fix not checking MGMT cmd pending queue

 net/bluetooth/mgmt.c | 99 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 63 insertions(+), 36 deletions(-)
