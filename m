Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24353B0B12
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhFVRIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFVRIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:08:14 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCC0C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:05:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 55F644FE766D6;
        Tue, 22 Jun 2021 10:05:57 -0700 (PDT)
Date:   Tue, 22 Jun 2021 10:05:56 -0700 (PDT)
Message-Id: <20210622.100556.369690653202936593.davem@davemloft.net>
To:     lorenzo.bianconi@redhat.com
Cc:     netdev@vger.kernel.org, mcroce@linux.microsoft.com,
        kuba@kernel.org, sgoutham@marvell.com, sbhatta@marvell.com,
        stefanc@marvell.com, brouer@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        mw@semihalf.com
Subject: Re: [PATCH net-next] net: marvell: return csum computation result
 from mvneta_rx_csum/mvpp2_rx_csum
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YNGdw+T283xPwQDM@lore-desk>
References: <73619ca7d64b1dee91ed8ed2dcf0ddbbc57b4b0a.1623943981.git.lorenzo@kernel.org>
        <YNGdw+T283xPwQDM@lore-desk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 22 Jun 2021 10:05:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Tue, 22 Jun 2021 10:22:27 +0200

>> This is a preliminary patch to add hw csum hint support to
>> mvneta/mvpp2 xdp implementation
>> 
>> Tested-by: Matteo Croce <mcroce@linux.microsoft.com>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Hi Dave and Jakub,
> 
> I have just noticed this patch is marked as "Not Applicable" in patchwork. I
> tried to rebase it on top of net-next and it applies and compiles so I am
> wondering why it is "not applicable". Am I missing something?

It did not apply cleanly for me, please resend.

Thank you.
