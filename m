Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1828810765F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKVRYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:24:38 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:54592 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:24:38 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 47KNb62SwHz4Y;
        Fri, 22 Nov 2019 18:24:34 +0100 (CET)
Date:   Fri, 22 Nov 2019 19:24:31 +0200
From:   Adrian Bunk <bunk@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Please backport "mwifiex: Fix NL80211_TX_POWER_LIMITED" to stable
 branches
Message-ID: <20191122172431.GA24156@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please backport commit 65a576e27309120e0621f54d5c81eb9128bd56be
"mwifiex: Fix NL80211_TX_POWER_LIMITED" to stable branches.

It is a non-CVE kind of security issue when a wifi adapter
exceeds the configured TX power limit.

The commit applies and builds against all branches from 3.16 to 4.19, 
confirmed working with 4.14. It is already included in kernel 5.3.

Thanks in advance
Adrian
