Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A3937649E
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 13:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhEGLmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 07:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbhEGLmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 07:42:44 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB66C061574;
        Fri,  7 May 2021 04:41:45 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 56039C01C; Fri,  7 May 2021 13:41:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1620387701; bh=zvATbqtXXc7IsxVxA0GntM900lZ5dWmrvpd9rsWT9w0=;
        h=Date:From:To:Cc:Subject:From;
        b=v0Jh5EbN+PulqnWxfAH+EdbojiDxLithjdxVXCc5xRdY25JlnrELULCeRe2A6ffPn
         FS4f5B6gAwTELE8YIv4QtZxOgut2robOwrQpaaoo1oXL3IziOwPQ7d0Z4dq+7lbGwM
         jb/oHQxrvgYLFEmE1FnlFmeRF8ypWkolKz/Tk0uS3zyhZEQeAFLBAjGCRncP1PmcWW
         oyCKf71v7V36cFtQBgZ3QaL3nO171omWfbVHMfb+TttijIkNhg5wJYmHo8hiYfqbAb
         sjCmewoLGBjQsDt0IjBkb9LPt2rySUGn6em1qPDahOnL8iSSoiolrT3bSieJy1cXsy
         hcGAK7us+xbOg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 60F4EC009;
        Fri,  7 May 2021 13:41:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1620387700; bh=zvATbqtXXc7IsxVxA0GntM900lZ5dWmrvpd9rsWT9w0=;
        h=Date:From:To:Cc:Subject:From;
        b=xqQabC3bbqBEr7Y9dmTzyk7+j28C/8IqZKPSMVyvKDmmKO+mQSZVyvQvgxYGhlCMD
         KoYTYduzLqB6XORWVUKHOp7ag2U+ydsgXC+lUKFcBZviRrutK8KTiKzEAAuv2l/ScK
         9IlmJ8cRF3m043Bgx3tNvROcsQbWVWQOT2xNDVmpNCb8l7twiwifnIUDYivD2/+6MM
         PYaWdt/GXpqdRqjcIyeVwQjVEBUt9iJUd3Ow/WR+bc2ttUyOqpHQVKTJOsusV3PPbZ
         1An5Q6yp2yGH1/U448puvlWYRg4Z9u8OqjFWJfwYnj91wQnk+G9lJpAa5WeajXNesU
         aIxj865pfT0SQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id f221fc19;
        Fri, 7 May 2021 11:41:36 +0000 (UTC)
Date:   Fri, 7 May 2021 20:41:21 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: [GIT PULL] 9p update for 5.13-rc1
Message-ID: <YJUnYXZBd1hpwW6G@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linux,

sorry for the late request, this is trivial enough and should probably
not have waited for the next cycle...
I had forgotten to add a Cc to stable for the fix and didn't want to
amend the commit at the last minute, will send them a mail after this
has been merged.


The following changes since commit a5e13c6df0e41702d2b2c77c8ad41677ebb065b3:

  Linux 5.12-rc5 (2021-03-28 15:48:16 -0700)

are available in the Git repository at:

  https://github.com/martinetd/linux tags/9p-for-5.13-rc1

for you to fetch changes up to f8b139e2f24112f4e21f1eb02c7fc7600fea4b8d:

  fs: 9p: fix v9fs_file_open writeback fid error check (2021-03-31 07:02:47 +0900)

----------------------------------------------------------------
9p for 5.13-rc1

an error handling fix and const optimization

----------------------------------------------------------------
Rikard Falkeborn (1):
      9p: Constify static struct v9fs_attr_group

Yang Yingliang (1):
      fs: 9p: fix v9fs_file_open writeback fid error check

 fs/9p/v9fs.c     | 2 +-
 fs/9p/vfs_file.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Thanks,
-- 
Dominique
