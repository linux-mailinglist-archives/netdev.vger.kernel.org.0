Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F142247E3
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgGRByt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGRByt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:54:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E08C0619D2;
        Fri, 17 Jul 2020 18:54:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB44311E45914;
        Fri, 17 Jul 2020 18:54:48 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:54:47 -0700 (PDT)
Message-Id: <20200717.185447.102704737441559323.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nsekhar@ti.com,
        grygorii.strashko@ti.com, vinicius.gomes@intel.com
Subject: Re: [PATCH 1/2 v2] net: hsr: fix incorrect lsdu size in the tag of
 HSR frames for small frames
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717145510.30433-1-m-karicheri2@ti.com>
References: <20200717145510.30433-1-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:54:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Fri, 17 Jul 2020 10:55:09 -0400

> For small Ethernet frames with size less than minimum size 66 for HSR
> vs 60 for regular Ethernet frames, hsr driver currently doesn't pad the
> frame to make it minimum size. This results in incorrect LSDU size being
> populated in the HSR tag for these frames. Fix this by padding the frame
> to the minimum size applicable for HSR.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Applied.
