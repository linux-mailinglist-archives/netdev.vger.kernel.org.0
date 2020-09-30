Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E8927DDC4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgI3B2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgI3B2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 21:28:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA28FC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 18:28:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F6381280C64D;
        Tue, 29 Sep 2020 18:11:59 -0700 (PDT)
Date:   Tue, 29 Sep 2020 18:28:46 -0700 (PDT)
Message-Id: <20200929.182846.1373007245621519477.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, jacob.e.keller@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, brijeshx.behera@intel.com
Subject: Re: [PATCH net 1/2] ice: increase maximum wait time for flash
 write commands
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930001548.1927323-1-anthony.l.nguyen@intel.com>
References: <20200930001548.1927323-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 18:11:59 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Tony, if you want me to actually apply this series, it must be submitted
properly with a proper "Subject: [PATCH net 0/2] ..." header posting explaing
at a high level what the patch series does, how it does it, and why it does
it that way.
