Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF2A1C00D0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgD3Pvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:51:46 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:44658 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgD3Pvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 11:51:45 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 9ABB22E158A;
        Thu, 30 Apr 2020 18:51:39 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 85zTOPVXSi-pcXGcM5i;
        Thu, 30 Apr 2020 18:51:39 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588261899; bh=Ku8M8hsNgp8O42QWYAa8JWNrA46x0d2sORiVmI0TciA=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=SNX33+CpmExEVsZns5imat3HdhckqaXSC6iG/J79Z2CPidsWhPrMXZlVBmZPr0tmi
         cbaNs3mNs4LBHCeHqDw1y5l46E33Y4GLhecXvVb8ewx+omfkOHuWnDgHLL/U0f3qMz
         PnczXtC3Alr9vj5AG/U6mg/Xigu0qQbYqp9v5PhE=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.215.84])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id GL4sw8JMR4-pcYGgWrR;
        Thu, 30 Apr 2020 18:51:38 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru, tj@kernel.org, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 0/2] inet_diag: add cgroup attribute and filter
Date:   Thu, 30 Apr 2020 18:51:13 +0300
Message-Id: <20200430155115.83306-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends inet diag with cgroup v2 ID attribute and
filter. Which allows investigate sockets on per cgroup basis. Patch for
ss is already sent to iproute2-next mailing list.

Dmitry Yakunin (2):
  inet_diag: add cgroup id attribute
  inet_diag: add support for cgroup filter

 include/linux/inet_diag.h      |  6 +++++-
 include/uapi/linux/inet_diag.h |  2 ++
 net/ipv4/inet_diag.c           | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

-- 
2.7.4

