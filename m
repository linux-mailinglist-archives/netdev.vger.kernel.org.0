Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74BF5BD3FB
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 19:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiISRlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 13:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiISRlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 13:41:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B772839B8B;
        Mon, 19 Sep 2022 10:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70298B81E89;
        Mon, 19 Sep 2022 17:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B452C433C1;
        Mon, 19 Sep 2022 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663609309;
        bh=OvVnROzD0otzKIOfupvYy7oKYylHoLKLR1yjrRi0+Jg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mpDfuGKMmQ9eRKBxRG0FUHvLIXGgTkhDTMVAmEZ6IdfW6P0bvcHzyaPvnofJtTI2U
         WvF0+nI3vPfMYhbDwqzelJejOeP9mhrVP1mUGnCuqhfzWDc+nqF6UxOt23kmlx1Bb/
         4cvpONlA6W08Hd42GcUJlSW5Y3bEtxTcXPP8L4Zn97pJyKUeDvnXYeZU3Tllzw76I5
         0WFtSiB6EFQ1IcNzHQ+phuKYJVUB1ieY1wSwERvM0OAEXspfZY+PEqKk16MuFTRwwK
         ICj+SUts7pCz/xLNHfg8Q7Qd2rTLEDUU96WO3zviOsJwphCqkREfEzkja+3Z/FShVD
         hYqbr0u7ha/Og==
Date:   Mon, 19 Sep 2022 10:41:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     vdasa@vmware.com
Cc:     vbhakta@vmware.com, namit@vmware.com, bryantan@vmware.com,
        zackr@vmware.com, linux-graphics-maintainer@vmware.com,
        doshir@vmware.com, sgarzare@redhat.com, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com, joe@perches.com,
        netdev@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] MAINTAINERS: Update entries for some VMware drivers
Message-ID: <20220919104147.1373eac1@kernel.org>
In-Reply-To: <20220906172722.19862-1-vdasa@vmware.com>
References: <20220906172722.19862-1-vdasa@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Sep 2022 10:27:19 -0700 vdasa@vmware.com wrote:
> From: Vishnu Dasa <vdasa@vmware.com>
> 
> This series updates a few existing maintainer entries for VMware
> supported drivers and adds a new entry for vsock vmci transport
> driver.

Just to be sure - who are you expecting to take these in?
