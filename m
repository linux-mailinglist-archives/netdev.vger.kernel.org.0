Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCD0279546
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgIYX6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgIYX6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:58:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C876C0613CE;
        Fri, 25 Sep 2020 16:58:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31B2C13BA1172;
        Fri, 25 Sep 2020 16:41:54 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:58:40 -0700 (PDT)
Message-Id: <20200925.165840.1911569696596024615.davem@davemloft.net>
To:     fabf@skynet.be
Cc:     kuba@kernel.org, mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/5 net-next] vxlan: clean-up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925131541.56410-1-fabf@skynet.be>
References: <20200925131541.56410-1-fabf@skynet.be>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:41:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 25 Sep 2020 15:15:41 +0200

> This small patchet does some clean-up on vxlan.
> Second version removes VXLAN_NL2FLAG macro relevant patches as suggested by Michal and David
> 
> I hope to have some feedback/ACK from vxlan developers.

Series applied, thanks.
