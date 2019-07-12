Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1C766831
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfGLIFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:05:04 -0400
Received: from nautica.notk.org ([91.121.71.147]:40744 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfGLIFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:05:03 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id E4A83C009; Fri, 12 Jul 2019 10:05:01 +0200 (CEST)
Date:   Fri, 12 Jul 2019 10:04:46 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [GIT PULL] 9p updates for 5.3
Message-ID: <20190712080446.GA19400@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

Here is a 9p update for 5.3, just a couple of fixes that have been
sitting here for too long as I missed the 5.2 merge window.

I have two more patches that I didn't have time to test early enough for
this but also are plain details fix, please let me know if you would
prefer having me send a pull request for -rc2 after a week in -next or
if I should just wait until the next window.
There's little risk but I'm usually rather conservative on this.


The following changes since commit 5908e6b738e3357af42c10e1183753c70a0117a9:

  Linux 5.0-rc8 (2019-02-24 16:46:45 -0800)

are available in the git repository at:

  git://github.com/martinetd/linux tags/9p-for-5.3

for you to fetch changes up to 80a316ff16276b36d0392a8f8b2f63259857ae98:

  9p/xen: Add cleanup path in p9_trans_xen_init (2019-05-15 13:00:07
  +0000)

----------------------------------------------------------------
9p pull request for inclusion in 5.13

Two small fixes to properly cleanup the 9p transports list if virtio/xen
module initialization fail.
9p might otherwise try to access memory from a module that failed to
register got freed.

----------------------------------------------------------------
YueHaibing (2):
      9p/virtio: Add cleanup path in p9_virtio_init
      9p/xen: Add cleanup path in p9_trans_xen_init

 net/9p/trans_virtio.c |    8 +++++++-
 net/9p/trans_xen.c    |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)
