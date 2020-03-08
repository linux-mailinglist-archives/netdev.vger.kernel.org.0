Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD8817D20C
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 07:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgCHGXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 01:23:49 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36669 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgCHGXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 01:23:49 -0500
Received: by mail-pl1-f194.google.com with SMTP id g12so2686136plo.3
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 22:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z6s+tzVbeTK+R5xTBtNEEQEuPi2Z5WtL86XbOP9AYDg=;
        b=KBMFuFsNE4z12brDOUmAkbwx4TgF8ZVnihDa2fV4qQDoD2AqwXZ5UmQ2NBhiNoClXV
         /oi0dqbFxXuV1G4QndagZEX/Bm4xotZC2s9fCpI4j9Q5v+dKKkTy0guwTEe07vE42/yG
         wvgcP7sByjY1iF88wK6ulZdiXn0a3KFIQcmj/NiofDQbFUTgTXtes6ddTMOqScvSbPN0
         wBrrE1Md1b6HfkONepNNJ30gqSMotGEdunwVZ82qEbeMrdZ3xyge7TMNvlzrL0+HrHwT
         BaepAkUuKFVHyx0PKVZyl8a5yg6Cgz0ehPszskCrB1+NFmKZWbpEPvaMcSdbxtzs5iaj
         zBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z6s+tzVbeTK+R5xTBtNEEQEuPi2Z5WtL86XbOP9AYDg=;
        b=pyx9bcmv+9jmEfWTpfYHrSQLZDV9GmerCo/edoz4fFZe9zkdW61tws8BbO4uxUejSf
         fVy3xRNRgZVQ99hsOU670XrSDgaGNhH1PDqdc7T51g5Lp22K8Z3iY9oax2bpcVRTck6U
         t+tPBFTUIqWtAUNbB2ZD2kLEAgwZ/cR4xK8K6jc5RHD4yTeWe5KYCGOmKHAM9gBhrcoZ
         HbtF/aG/4mOaB6c9ynh+LlroNpebLemGsEFMVzqRbSaxPXex/BtTY90J0fpzoGurFNH6
         AifOXeKmb5jRR591quxjNKLn6v+4ITx42eUxovj89LRcc3NrYWtMqs0Ojcl2QMfoS3pC
         s1sw==
X-Gm-Message-State: ANhLgQ09KvpZZXBO2Ag7v5kYDAj1Husue5DGclDFHL1fufej/wzZEFo6
        WkaO8ubwWpmHUlSGkbQnp8ML9dIpRgs=
X-Google-Smtp-Source: ADFU+vtRS8Fjtt3J513y4GChpjZxTgt9p38bc73ocemD+qQ0dHCoXBAoQDIKTZaLCSAvkOa1nWpfgw==
X-Received: by 2002:a17:90a:a617:: with SMTP id c23mr12133761pjq.32.1583648628140;
        Sat, 07 Mar 2020 22:23:48 -0800 (PST)
Received: from localhost.localdomain (S0106bcd16567bb27.ed.shawcable.net. [68.150.202.68])
        by smtp.gmail.com with ESMTPSA id w31sm14536618pgl.84.2020.03.07.22.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 22:23:47 -0800 (PST)
From:   Jarrett Knauer <jrtknauer@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     Jarrett Knauer <jrtknauer@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 00/10] qlge.h cleanup - first pass
Date:   Sat,  7 Mar 2020 23:23:14 -0700
Message-Id: <cover.1583647891.git.jrtknauer@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset cleans up some warnings and checks issued by checkpatch.pl
for staging: qlge: qlge.h as an effort to eventually bring the qlge TODO
count to zero.

There are still many CHECKs and WARNINGs for qlge.h, of which some are
false-positives or odd instances which I plan on returning to after
getting some more experience with the driver.

Jarrett Knauer (10):
  staging: qlge: removed leading spaces identified by checkpatch.pl
  staging: qlge: checkpatch.pl CHECK - removed unecessary blank line
  staging: qlge: checkpatch.pl WARNING - removed spaces before tabs
  staging: qlge: checkpatch.pl CHECK - added spaces around /
  staging: qlge: checkpatch.pl WARNING - removed spaces before tabs
  staging: qlge: checkpatch.pl CHECK - added spaces around %
  staging: qlge: checkpatch.pl CHECK - removed blank line following
    brace
  staging: qlge: checkpatch.pl CHECK - removed blank line after brace
  staging: qlge: checkpatch.pl WARNING - removed function pointer space
  staging: qlge: checkpatch.pl WARNING - missing blank line

 drivers/staging/qlge/qlge.h | 42 ++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

-- 
2.17.1

