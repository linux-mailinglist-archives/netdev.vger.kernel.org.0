Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD937AA1C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhEKPCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhEKPCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 11:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F217613C1;
        Tue, 11 May 2021 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620745297;
        bh=CGntqTzT0CjwBnD8m2IoNs2tKZ5vRmYFfQ0jAL/UEb8=;
        h=From:To:Cc:Subject:Date:From;
        b=panu4sVvuTFMZuqoZPlBkXPO1+Kh+4Bp7wMgfwwhZeIJ22TPqPX+LNgC81uNqjndt
         Yr99x1IRXYnyYKXssWNKnICXlOMNRnUy0uE5I3bPlgo2t9CStA38Vy3VkQC5iqM6ni
         apXbgb5KKoleKiXgAGhnYEV3iXjZTDgpkKJKqo10RnzxpF0C/p8ixNRp0t857htG06
         RvTMwBONaCF/Z3OZOfdrF0JmxogubCngp2wgSEjXEUoRlOKrakqnOZlp9ktaXJYMhq
         EJ7nfcBbg0H39QjX+8+xJtNS6UOYdTcYNKJda7JGVIJy69mksb5VWbVtI/oYJuVijz
         9Ft1gfPEazwXg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgTt7-000k0z-Pq; Tue, 11 May 2021 17:01:33 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>, Jens Axboe <axboe@kernel.dk>,
        intel-wired-lan@lists.osuosl.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/5] Fix some UTF-8 bad usages
Date:   Tue, 11 May 2021 17:01:27 +0200
Message-Id: <cover.1620744606.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series follow up this past series:
	https://lore.kernel.org/lkml/cover.1620641727.git.mchehab+huawei@kernel.org/

Containing just the manual fixes from it. I'll respin the remaining
patches on a separate series.

Please note that patches 1 to 3 are identical to the ones posted
on the original series.

Patch 1 is special: it fixes some left-overs from a convertion
from cdrom-standard.tex: there, some characters that are
valid in C were converted to some visually similar UTF-8 by LaTeX.

Patch 2 remove U+00ac ('¬'): NOT SIGN characters at the end of
the first line of two files. No idea why those ended being there :-p

Patch 3 replaces:
	KernelVersion:»·3.3
by:
	KernelVersion:	3.3

which is the expected format for the KernelVersion field;

Patches 4 and 5 fix some bad usages of EM DASH/EN DASH on
places that it should be, instead, a normal hyphen. I suspect
that they ended being there due to the usage of some conversion
toolset.

Mauro Carvalho Chehab (5):
  docs: cdrom-standard.rst: get rid of uneeded UTF-8 chars
  docs: ABI: remove a meaningless UTF-8 character
  docs: ABI: remove some spurious characters
  docs: hwmon: tmp103.rst: fix bad usage of UTF-8 chars
  docs: networking: device_drivers: fix bad usage of UTF-8 chars

 .../obsolete/sysfs-kernel-fadump_registered   |  2 +-
 .../obsolete/sysfs-kernel-fadump_release_mem  |  2 +-
 Documentation/ABI/testing/sysfs-module        |  4 +--
 Documentation/cdrom/cdrom-standard.rst        | 30 +++++++++----------
 Documentation/hwmon/tmp103.rst                |  4 +--
 .../device_drivers/ethernet/intel/i40e.rst    |  4 +--
 .../device_drivers/ethernet/intel/iavf.rst    |  2 +-
 7 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.30.2


