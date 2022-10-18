Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D46032F5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJRTDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiJRTC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:02:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7D7BE510
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8DF8B820EF
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D02C433C1;
        Tue, 18 Oct 2022 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666119775;
        bh=39qAuu9VJy/xT3XJ/0K/qJYd+1DdYfUhwfm5pOGaHZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sL7nQXKlHKCRSMCRWt+lzizNeh8BoxYVP0ZlO4sfqwxS2+qpgK2t/2v4Y1KcCQUSd
         ViqpiJS8wC1JPdMI4I0oS6NjozuNEMD2uDcy3nrHHVstAI0/KG9qA7ZG0bdSmBiFlo
         pmvi97sXjSlDFqBZ8Hr+HfsX1R104SBl3k6ZOjsoktDVl3zAypWWrFj+ZeQ2afXt2j
         T1dzd1VG1V3hqBPahE+Dq3NI1PCMctSLUHMh2vQecKzTP9dghH+6gVJhqGgmLgH+6l
         QP/G5Z7xEyFm4Lsxh3Xbdcgwt7LMcAmaohGXhjIU4fXv6Dp8i2wKPGLafvOjhE6IWS
         6MQrf9Y3S3ogQ==
Date:   Tue, 18 Oct 2022 12:02:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com,
        aravindhan.gunasekaran@intel.com, richardcochran@gmail.com,
        gal@nvidia.com, saeed@kernel.org, leon@kernel.org,
        michael.chan@broadcom.com, andy@greyhouse.net,
        vinicius.gomes@intel.com
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP
 packets
Message-ID: <20221018120254.752de264@kernel.org>
In-Reply-To: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 09:07:28 +0800 Muhammad Husaini Zulkifli wrote:
> v1 -> v2:
> 	- Move to the end for the new enum.
> 	- Add new HWTSTAMP_FILTER_DMA_TIMESTAMP receive filters.

Did you address my feedback? How do we know if existing
HWTSTAMP_FILTER_ALL is PHC quality of DMA?
