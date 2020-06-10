Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D260E1F5EAC
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgFJXYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgFJXYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:24:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D39C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 16:24:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07AE511F5F667;
        Wed, 10 Jun 2020 16:24:18 -0700 (PDT)
Date:   Wed, 10 Jun 2020 16:24:18 -0700 (PDT)
Message-Id: <20200610.162418.891670428984296558.davem@davemloft.net>
To:     olivier.dautricourt@orolia.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, panfilov.artyom@gmail.com
Subject: Re: [PATCH 1/1] net: stmmac: gmac3: add auxiliary snapshot support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200610115508.303844-1-olivier.dautricourt@orolia.com>
References: <20200610115508.303844-1-olivier.dautricourt@orolia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 16:24:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


net-next is currently CLOSED, please resubmit this when it opens back up.

Thank you.
