Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A71E5102
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgE0WLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0WLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 18:11:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFD0C05BD1E;
        Wed, 27 May 2020 15:11:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7489128CEF9D;
        Wed, 27 May 2020 15:11:47 -0700 (PDT)
Date:   Wed, 27 May 2020 15:11:46 -0700 (PDT)
Message-Id: <20200527.151146.209703742963070529.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, ccaulfie@redhat.com, teigland@redhat.com,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Subject: Re: remove kernel_getsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527182229.517794-1-hch@lst.de>
References: <20200527182229.517794-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 15:11:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 27 May 2020 20:22:27 +0200

> this series reduces scope from the last round and just removes
> kernel_getsockopt to avoid conflicting with the sctp cleanup series.

Series applied to net-next, thanks.
