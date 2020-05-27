Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4AE1E50C9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgE0V6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgE0V6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:58:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2797CC05BD1E;
        Wed, 27 May 2020 14:58:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB871128CE44E;
        Wed, 27 May 2020 14:58:40 -0700 (PDT)
Date:   Wed, 27 May 2020 14:58:40 -0700 (PDT)
Message-Id: <20200527.145840.1913157604943344679.davem@davemloft.net>
To:     wenhu.wang@vivo.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com, trivial@kernel.org
Subject: Re: [PATCH] drivers: ipa: fix typoes for ipa
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527031924.34200-1-wenhu.wang@vivo.com>
References: <20200527031924.34200-1-wenhu.wang@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 14:58:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Wenhu <wenhu.wang@vivo.com>
Date: Tue, 26 May 2020 20:19:24 -0700

> Change "transactio" -> "transaction". Also an alignment correction.
> 
> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>

Applied.
