Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B807687425
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 04:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbjBBDth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 22:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjBBDtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 22:49:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8227BE61;
        Wed,  1 Feb 2023 19:49:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C315CCE2736;
        Thu,  2 Feb 2023 03:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554AFC433EF;
        Thu,  2 Feb 2023 03:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675309771;
        bh=MRFI+koCygwIOBoCSQ4VzGw7dApiu0YpfN/cLcK8/2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uO8M/yIs6eXfLyx9HDx4Cky/AwPSnHyAdm8GoiDpR85mgEK6/SAY8/N5iuKw9zR8p
         u9eT6IaTBAKV+svRtTDw17xdO1xpGWu2s/Gyq4cEIMWjFyqDlfTVg4WW3HU/XlDAq6
         DDgi+ItQria6Jf3ZptB3sRMTt9kAO449y2uND1sksgBM6eviIRDXbBv2euBI98cRLX
         hMPyk5BfQ/DRC7Xw6SuU2DdoyybaxJI+9W0fT578QU1EubaKwkVYPjSoYB4TRvQQhE
         cnD6ceEDeMlyVDwtixoWnq2P9gsk2XMnNA3IEj6D3+OBIHu77BDakKQ75G5B23NaDv
         AvCndhJo8d66g==
Date:   Wed, 1 Feb 2023 19:49:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v11 0/8] Add Auxiliary driver support
Message-ID: <20230201194925.464b76a3@kernel.org>
In-Reply-To: <20230202033809.3989-1-ajit.khaparde@broadcom.com>
References: <20230202033809.3989-1-ajit.khaparde@broadcom.com>
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

On Wed,  1 Feb 2023 19:38:01 -0800 Ajit Khaparde wrote:
> v10->v11:
> - Addressed unused variable warning in patch 1 reported by kernel test
>   robot.

:/ Why are you reposting this so early, read the rules please:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

We should bump that to 48h for those who can't be bothered to compile
their code before reposting, if you ask me.

I'm discarding your series, come back next week.
