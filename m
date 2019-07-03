Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE835ED68
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGCUVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:21:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCUVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:21:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 338A7142DB850;
        Wed,  3 Jul 2019 13:21:08 -0700 (PDT)
Date:   Wed, 03 Jul 2019 13:21:05 -0700 (PDT)
Message-Id: <20190703.132105.950623325064957510.davem@davemloft.net>
To:     mka@chromium.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org
Subject: Re: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703193724.246854-1-mka@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 13:21:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please repost this patch set with a proper "[PATCH 0/7] ..." header posting
describing at a high level what this patch series is doing, how it is doing
it, and why it is doing it that way.

Such header postings are absolutely essential for the proper understanding
and review of your changes.

Thank you.
