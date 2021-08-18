Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C063F0A8E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhHRRwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhHRRwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:52:31 -0400
Received: from forward103p.mail.yandex.net (forward103p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78154C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 10:51:56 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id A468218C28C2
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 20:51:51 +0300 (MSK)
Received: from vla1-ce2e345b2df9.qloud-c.yandex.net (vla1-ce2e345b2df9.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3609:0:640:ce2e:345b])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id A0B05CF40002
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 20:51:51 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by vla1-ce2e345b2df9.qloud-c.yandex.net (mxback/Yandex) with ESMTP id gwIcow8dor-ppHOwc9i;
        Wed, 18 Aug 2021 20:51:51 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1629309111;
        bh=O3YSYDiExvwDXO8WAAtMUWXPnthFb34EEG1faLeUETg=;
        h=Message-ID:Subject:To:From:Date:Reply-To;
        b=JXiQ51ruGlrZwJvFyCo3Yh6MbUsx6xeFeHCRok5BjRyZsrsJGa/htcbP5bgiBcwqo
         G6NCtaoDhW5wJxd2LgfYtgtbgAvT7pVwhtcqv4ZA5asGdNnF+zueMIiv62xOqct1gn
         FGc8nJU9dx5bbfCVZXzSfFd9+LvJbPc3CokTgyBU=
Authentication-Results: vla1-ce2e345b2df9.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id YdWS6iEmZp-ppG4ucAe;
        Wed, 18 Aug 2021 20:51:51 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Wed, 18 Aug 2021 20:52:04 +0300
From:   Oleg <lego12239@yandex.ru>
To:     netdev@vger.kernel.org
Subject: reading /proc/net/tcp
Message-ID: <20210818175204.GA15391@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all.

Could anybody clarify what happen if some connection is disappeared between
two read() calls against a line from /proc/net/tcp for this connection?

For example, i read the line(from /proc/net/tcp):

1: 0C00A8C0:E24E E29BCA74:01BB 01 00000000:00000000 00:00000000 00000000  1000        0 57498 1 0000000031ee2ba7 56 4 30 10 -1 

with 2 read(fd, buf, 80) calls.

-- 
Олег Неманов (Oleg Nemanov)
