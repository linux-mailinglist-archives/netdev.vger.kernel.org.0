Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E62861321
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 00:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfGFW0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 18:26:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58398 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfGFW0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 18:26:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9314A151CCAAA;
        Sat,  6 Jul 2019 15:26:46 -0700 (PDT)
Date:   Sat, 06 Jul 2019 15:26:46 -0700 (PDT)
Message-Id: <20190706.152646.270873493821496746.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     gospo@broadcom.com, netdev@vger.kernel.org, hawk@kernel.org,
        ast@kernel.org
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add XDP_REDIRECT support.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 06 Jul 2019 15:26:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sat,  6 Jul 2019 03:36:14 -0400

> This patch series adds XDP_REDIRECT support by Andy Gospodarek.

I'll give Jesper et al. a chance to review this.
