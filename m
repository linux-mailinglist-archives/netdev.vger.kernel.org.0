Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA1D563FA5
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 13:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiGBLIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 07:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiGBLHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 07:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9029615A39;
        Sat,  2 Jul 2022 04:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23BA760DF2;
        Sat,  2 Jul 2022 11:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E09AC341D9;
        Sat,  2 Jul 2022 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656760068;
        bh=GXTCFNGJ/qi6q84KgPXHTPGckjOATtaMykjkvdiZ8ns=;
        h=From:To:Cc:Subject:Date:From;
        b=DrrTnbY+g/95s2OoeUYPgsUS7r9KhEaNN9bCC94hZDu/RhdENgPzZoSE1bFGIeu8f
         A7Y7GS2fdeuCvgSTgrN/C3Xk/UA4AOOR8PKrhHb1bqaCJDPjmbmDyW0ool3TYK7/Hd
         CxINUJxSqKohLK3IuucJQULpCltifiDOZOyZyfbIOGyhrjN6eL4nHdwjPVWdsBmNQr
         m10KGXrSflXIA+909EoSQweUfDbpYP0KDii/iawMcZOW08nSgdAA6iekKm5+xmvGOt
         qZOWRpYYA6Df/o1E/Rs8oS6M9Sd+dj4RU3q++vdjNLnLFq1bzTTJ2BD2bq9KC1xlYu
         xlTWaJKAO8emw==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o7ayX-007gro-J8;
        Sat, 02 Jul 2022 12:07:45 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Alasdair Kergon <agk@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Brendan Higgins <brendanhiggins@google.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mike Snitzer <snitzer@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Takashi Iwai <tiwai@suse.com>,
        alsa-devel@alsa-project.org, dm-devel@redhat.com,
        kunit-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 00/12] Fix several documentation build warnings with Sphinx 2.4.4
Date:   Sat,  2 Jul 2022 12:07:32 +0100
Message-Id: <cover.1656759988.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is against next-20220701. It fixes several warnings
that are currently produced while building html docs.

Each patch in this series is independent from the others, as
each one touches a different file.

Mauro Carvalho Chehab (12):
  docs: ext4: blockmap.rst: fix a broken table
  docs: tegra194-hte.rst: don't include gpiolib.c twice
  docs: device-mapper: add a blank line at writecache.rst
  docs: PCI: pci-vntb-function.rst: Properly include ascii artwork
  docs: PCI: pci-vntb-howto.rst: fix a title markup
  docs: virt: kvm: fix a title markup at api.rst
  docs: ABI: sysfs-bus-nvdimm
  kunit: test.h: fix a kernel-doc markup
  net: mac80211: fix a kernel-doc markup
  docs: alsa: alsa-driver-api.rst: remove a kernel-doc file
  docs: arm: index.rst: add google/chromebook-boot-flow
  docs: leds: index.rst: add leds-qcom-lpg to it

 Documentation/ABI/testing/sysfs-bus-nvdimm             | 2 ++
 Documentation/PCI/endpoint/pci-vntb-function.rst       | 2 +-
 Documentation/PCI/endpoint/pci-vntb-howto.rst          | 2 +-
 Documentation/admin-guide/device-mapper/writecache.rst | 1 +
 Documentation/arm/index.rst                            | 2 ++
 Documentation/driver-api/hte/tegra194-hte.rst          | 3 +--
 Documentation/filesystems/ext4/blockmap.rst            | 2 +-
 Documentation/leds/index.rst                           | 1 +
 Documentation/sound/kernel-api/alsa-driver-api.rst     | 1 -
 Documentation/virt/kvm/api.rst                         | 6 +++---
 include/kunit/test.h                                   | 2 +-
 include/net/mac80211.h                                 | 2 +-
 12 files changed, 15 insertions(+), 11 deletions(-)

-- 
2.36.1


