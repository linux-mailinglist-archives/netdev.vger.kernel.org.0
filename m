Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2A48FCBF
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 13:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiAPMcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 07:32:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41274 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiAPMcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 07:32:20 -0500
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9EA16841772D;
        Sun, 16 Jan 2022 04:32:17 -0800 (PST)
Date:   Sun, 16 Jan 2022 12:32:11 +0000 (GMT)
Message-Id: <20220116.123211.1251576778673440603.davem@davemloft.net>
To:     krzysztof.kozlowski@canonical.com
Cc:     kuba@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] nfc: llcp: fix and improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 16 Jan 2022 04:32:18 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please don't mix cleanups and bug fixes.

Thank you.
