Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6871B403B48
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 16:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351808AbhIHOQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 10:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbhIHOQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 10:16:20 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4312C061575;
        Wed,  8 Sep 2021 07:15:12 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id AA802C01C; Wed,  8 Sep 2021 16:15:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1631110510; bh=XDwgTEEmY7D5xsm4i63bVcL3f4nzyaOx36vSvg92ttg=;
        h=Date:From:To:Cc:Subject:From;
        b=J5ViWEZdT4YmcsPYMtZ8HER1CNnX19Oan/PeMPxRvVIEjQII+c0zr5BCCFLq4fhnb
         DzE6lu6HNytWbh5Y0aAC/8xLGYQtOEp0aRFk6qOFP+hs/L8iT3K8YtiSATHKxWOnsN
         bm7RwT4OUzG5svzurmvHRK3KOcnrzN6aCnWg6vpUtGPPE+jMTuv4fJCZpOmneGnOad
         981+iriagL9Z5iAznevQWN8NykC9Vpi4ilyc6DfKHxuFh9H5WQZO+xWD+lmf/6Ucs+
         Aedkuacl2xVAAbb/nokXdhF/9Bn9kbcHEm2Ab93suf9Kvf3BAXxjDixK9Jdym5Wymx
         wA+gSO7Hxm4Vg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 80F89C009;
        Wed,  8 Sep 2021 16:15:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1631110510; bh=XDwgTEEmY7D5xsm4i63bVcL3f4nzyaOx36vSvg92ttg=;
        h=Date:From:To:Cc:Subject:From;
        b=J5ViWEZdT4YmcsPYMtZ8HER1CNnX19Oan/PeMPxRvVIEjQII+c0zr5BCCFLq4fhnb
         DzE6lu6HNytWbh5Y0aAC/8xLGYQtOEp0aRFk6qOFP+hs/L8iT3K8YtiSATHKxWOnsN
         bm7RwT4OUzG5svzurmvHRK3KOcnrzN6aCnWg6vpUtGPPE+jMTuv4fJCZpOmneGnOad
         981+iriagL9Z5iAznevQWN8NykC9Vpi4ilyc6DfKHxuFh9H5WQZO+xWD+lmf/6Ucs+
         Aedkuacl2xVAAbb/nokXdhF/9Bn9kbcHEm2Ab93suf9Kvf3BAXxjDixK9Jdym5Wymx
         wA+gSO7Hxm4Vg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 42469251;
        Wed, 8 Sep 2021 14:15:05 +0000 (UTC)
Date:   Wed, 8 Sep 2021 23:14:50 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: [GIT PULL] 9p update for 5.15
Message-ID: <YTjFWjkz0nPb+sZe@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

The following changes since commit ff1176468d368232b684f75e82563369208bc371:

  Linux 5.14-rc3 (2021-07-25 15:35:14 -0700)

are available in the Git repository at:

  https://github.com/martinetd/linux tags/9p-for-5.15-rc1

for you to fetch changes up to 9c4d94dc9a64426d2fa0255097a3a84f6ff2eebe:

  net/9p: increase default msize to 128k (2021-09-05 08:36:44 +0900)

(the commit date is a bit young as the default msize change has been
sent fairly recently, happy to delay one release if you'd like it to sit
in -next for longer than a few days before merging but large msize
codepath is already widely in use as the impact is big on performance.
Changing the default should help people who don't know about the
option.)
----------------------------------------------------------------
9p for 5.15-rc1

a couple of harmless fixes, increase max tcp msize (64KB -> 1MB),
and increase default msize (8KB -> 128KB)

The default increase has been discussed with Christian
for the qemu side of things but makes sense for all supported
transports

----------------------------------------------------------------
Christian Schoenebeck (2):
      net/9p: use macro to define default msize
      net/9p: increase default msize to 128k

Dominique Martinet (1):
      net/9p: increase tcp max msize to 1MB

Harshvardhan Jha (1):
      9p/xen: Fix end of loop tests for list_for_each_entry

Xie Yongji (1):
      9p/trans_virtio: Remove sysfs file on probe failure

 net/9p/client.c       | 6 ++++--
 net/9p/trans_fd.c     | 2 +-
 net/9p/trans_virtio.c | 4 +++-
 net/9p/trans_xen.c    | 4 ++--
 4 files changed, 10 insertions(+), 6 deletions(-)
-- 
Dominique
