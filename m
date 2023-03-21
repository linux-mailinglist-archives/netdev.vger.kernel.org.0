Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6536C295C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCUEzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCUEzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E5832518;
        Mon, 20 Mar 2023 21:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A617861940;
        Tue, 21 Mar 2023 04:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A286EC433D2;
        Tue, 21 Mar 2023 04:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679374510;
        bh=V9ZOV3yq4nPKmmMRt/qHgn8cIp4h3DeTpXQRZwqCP5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=faJqTBWmShb+vMkFJYMaSKi6QdhOc0BIVCBwtYTnbayCR0upSLDgaOUqYSA821zBp
         9liONRMu9aCwJrdFTmn9MPzZ0Yca8MNQ3i3tDAZqHlwbCm35/Tq68GiI1PtackVtqa
         nAp5df0vPk+ciMPfGGdbn2EmjNz5UspKCWg3mpFVkeCYqoPgWvBn/kR2sGJAvE1/t9
         MWcxGDmZQj/7f+f1DDo3TbM6FmQxOB47ew1lKSvQSKAX0jIW+H5mBDptXFEYvxClfv
         itzYXkTGhq256SDSdfKC6cFMyAH0sPSAvzUZFRFRcfcxdpZpkjDSc5TSuvuM4wL/Nr
         FuPEDi4MUseVQ==
Date:   Mon, 20 Mar 2023 21:55:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Lundin <glance@acc.umu.se>
Subject: Re: [PATCHv5 net 1/2] net: asix: fix modprobe "sysfs: cannot create
 duplicate filename"
Message-ID: <20230320215508.27ddf9ff@kernel.org>
In-Reply-To: <20230317181321.3867173-1-grundler@chromium.org>
References: <20230317181321.3867173-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 11:13:21 -0700 Grant Grundler wrote:
> "modprobe asix ; rmmod asix ; modprobe asix" fails with:
>    sysfs: cannot create duplicate filename \
>    	'/devices/virtual/mdio_bus/usb-003:004'

Code looks good but now you posted only one patch with [PATCH 1/2]
so patchwork is dutifully waiting to receive [PATCH 2/2]. And not
running any checks. One more time, please :) You can keep Simon's
review tag.
