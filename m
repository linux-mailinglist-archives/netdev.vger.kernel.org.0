Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F167D7E473
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbfHAUp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:45:27 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:41029 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfHAUp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 16:45:27 -0400
Received: by mail-qk1-f180.google.com with SMTP id t187so455316qke.8
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 13:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starry.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qbsur90HsseJH2gF5FLSwo5gMlfND7QY1zUeFsWY12E=;
        b=HiBltp8lV+xaU0dbb9bCsVabvLaJGTBM/SjNNGy9M4+EhD+e574QlQ3wu13WKd/BVz
         oa/1F2rbmMjeABEv0ZxRQ9/QUyPYwMKrmz6QVEF1jN/fKLB9LWi0oJTBpbXGocoiEZFr
         GlU7/ed3HLcGYYcXGKBpqytgV46EeE5/0VIHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qbsur90HsseJH2gF5FLSwo5gMlfND7QY1zUeFsWY12E=;
        b=hyo+mQ8Xx9QIqfHN68VrBeQFG/TYCO6Cp4FRwW6ECVxBXI9fzyqU1SxHi5WS+8Df7c
         7H/3YmvLgiLJVtzWvme/uz+Ui+YycTO1kQpaEc2dinxRqohW2RjR3qw1iyOS5hRtjvZU
         qvlfuCHpd5+T615nqbFgBXxYPwTeuPatSySVSlr9LPjWuB89JZwxgiUPrehgxgeQJCKu
         cuNmB4Y0ayp6PnySzt5vXvW9Q/hKbidEBintIaSkG5mBpwKwbMZ6huti0JEgbRUDLDFr
         XAu3gQEq6k0zfktTRhipByWuRl3HW7ELyelDUZg9pN2AQH+idJl1pB6gCJAfJQwwTMdN
         +GGA==
X-Gm-Message-State: APjAAAUDc9R9QcEgGpqWOau0zqL4uDSxzZQLboXC9PhRYU6CwOOSWNsB
        EOVBjnwV7D5HlMC3OuAFc8EewDvAv4M=
X-Google-Smtp-Source: APXvYqwT8IWzj0xuwvbNlcAlYvBhlduO8AdARrAHWpwnJDiQNlPbVEm0dJsSdDs/fRumdLx6FmS0Ig==
X-Received: by 2002:a05:620a:44:: with SMTP id t4mr88449732qkt.189.1564692326107;
        Thu, 01 Aug 2019 13:45:26 -0700 (PDT)
Received: from localhost.localdomain (205-201-16-55.starry-inc.net. [205.201.16.55])
        by smtp.gmail.com with ESMTPSA id b23sm42724059qte.19.2019.08.01.13.45.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 13:45:25 -0700 (PDT)
From:   Matt Pelland <mpelland@starry.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com
Subject: [PATCH] net: mvpp2: Implement RXAUI Support
Date:   Thu,  1 Aug 2019 16:45:21 -0400
Message-Id: <20190801204523.26454-1-mpelland@starry.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set implements support for configuring Marvell's mvpp2 hardware for
RXAUI operation. There are two other patches necessary for this to work
correctly that concern Marvell's cp110 comphy that were emailed to the general
linux-kernel mailing list earlier on. I can post them here if need be. This
patch set was successfully tested on a Marvell Armada 7040 based platform.

Cheers,
Matt


