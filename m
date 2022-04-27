Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE21511EB8
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbiD0Roj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244888AbiD0Rod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:44:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3244338A
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C595B828AB
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 17:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686BFC385A7;
        Wed, 27 Apr 2022 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651081278;
        bh=nZSNSF+EWjIbhu9mtLR2T19R0sO636SM+f1bzIV2TZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1yoiB1220cO3mszBl9ZNbJnqCtL6s0i/3VTGdTnrUMl0/CnU4MB8TV3lqsOivsXD8
         /zDcvSqGl71guk6gLBHMP+F684nI3l6ZW6Tjp400CzNZcAldKuCTUHCRkoHcskbLfc
         /aobxvBkmS/QZhVNm5DCviHV9+JSAdMzERozyngo=
Date:   Wed, 27 Apr 2022 19:41:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, david.kershner@unisys.com,
        liujunqi@pku.edu.cn, sparmaintainer@unisys.com,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH net-next 02/14] eth: remove NAPI_WEIGHT defines
Message-ID: <YmmAOx4z9mZS0pkK@kroah.com>
References: <20220427154111.529975-1-kuba@kernel.org>
 <20220427154111.529975-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427154111.529975-3-kuba@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 08:40:59AM -0700, Jakub Kicinski wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: steve.glendinning@shawell.net
> CC: david.kershner@unisys.com
> CC: gregkh@linuxfoundation.org
> CC: liujunqi@pku.edu.cn
> CC: sparmaintainer@unisys.com
> CC: linux-staging@lists.linux.dev
> ---
>  drivers/net/ethernet/smsc/smsc9420.c            | 2 +-
>  drivers/net/ethernet/smsc/smsc9420.h            | 1 -
>  drivers/staging/unisys/visornic/visornic_main.c | 4 ++--

This file is gone in my tree and in linux-next, so no need to worry
about it anymore.

thanks,

greg k-h
