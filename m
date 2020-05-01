Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E881C1DEF
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgEATdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgEATdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:33:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5C9C061A0C;
        Fri,  1 May 2020 12:33:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F6D414BE8274;
        Fri,  1 May 2020 12:33:09 -0700 (PDT)
Date:   Fri, 01 May 2020 12:33:08 -0700 (PDT)
Message-Id: <20200501.123308.956105770476039545.davem@davemloft.net>
To:     mchehab+huawei@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, chessman@tux.org, netdev@vger.kernel.org,
        andrew.hendry@gmail.com, zorik@amazon.com, stranche@codeaurora.org,
        irusskikh@marvell.com, jdmason@kudzu.us, haiyangz@microsoft.com,
        linux-x25@vger.kernel.org, wei.liu@kernel.org,
        linux-hyperv@vger.kernel.org, kvalo@codeaurora.org,
        kuba@kernel.org, subashab@codeaurora.org, dsahern@kernel.org,
        kys@microsoft.com, kou.ishizaki@toshiba.co.jp, jreuter@yaina.de,
        saeedb@amazon.com, shrijeet@gmail.com, netanel@amazon.com,
        stas.yakovlev@gmail.com, gtzalik@amazon.com, maxk@qti.qualcomm.com,
        akiyano@amazon.com, linux-wireless@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-parisc@vger.kernel.org,
        klassert@kernel.org, sthemmin@microsoft.com
Subject: Re: [PATCH 00/37]net: manually convert files to ReST format - part
 3 (final)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 12:33:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Fri,  1 May 2020 16:44:22 +0200

> That's the third part (and the final one) of my work to convert the networking
> text files into ReST. it is based on linux-next next-20200430 branch.
> 
> The full series (including those ones) are at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=net-docs
> 
> The  built output documents, on html format is at:
> 
> 	https://www.infradead.org/~mchehab/kernel_docs/networking/

Series applied, thanks for doing all of this work.
