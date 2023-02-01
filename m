Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AFE686E71
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjBAS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBAS4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:56:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B267CCB5;
        Wed,  1 Feb 2023 10:56:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C0861901;
        Wed,  1 Feb 2023 18:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE74C433EF;
        Wed,  1 Feb 2023 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675277772;
        bh=J3mScy0duEQ4C/TbG+Q0Ky1LIPqn9ACVteYHvWf9814=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PI8FNSAQxjNW+JYm54GHaytKw2TgQDVmr1etRorRbsgHWxSzNHzAcVQMP4F0TCcWI
         Z0gZjw6FkBWVZfv2Wuy+2zTJeRnhgcShijGq0ZRPcA4zkwfWvLNPcvFqUH7qmisft9
         0mAjy8JL5Nsl+QCgYTSnQJgldg/Xz/g1fQupPtaGsuMASqlTCLKyQfBtgUGM9JuHpt
         WNlXtkPtAe3zKRYi0WQpVwhDzTQEtrC+10ogXhxkXs/ER/PLCG1vzfRdh9nZcci1rl
         j3Xp9drKsphzb3iAAk14RTWj11xTBRsy9gz7mG5cX0aW8yRLF1Ms9Cuig31qYy/0ll
         pwCJrozw9TNvg==
Date:   Wed, 1 Feb 2023 10:56:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v9 0/8] Add Auxiliary driver support
Message-ID: <20230201105610.709139bf@kernel.org>
In-Reply-To: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
References: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
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

On Mon, 30 Jan 2023 21:25:49 -0800 Ajit Khaparde wrote:
> The following are changes since commit 90e8ca0abb05ada6c1e2710eaa21688dafca26f2
>   Merge branch 'devlink-next'
> and are available in the git repository at:
>   https://github.com/ajitkhaparde1/net-next/tree/aux-bus-v9

This is not a valid pull URL, try running git pull on it yourself.
Also the tree must be based on commits in Linus's tree if you want
both us and RDMA to pull it.
