Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FBB606F0B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 06:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJUEqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 00:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJUEqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 00:46:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DC1187DF9
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 21:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81DD561DB5
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 04:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA3EC433C1;
        Fri, 21 Oct 2022 04:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666327576;
        bh=VdDqIzvjJw+xKs3EKv+5XTQnwceL1XPSD8LTZweyiK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PEQlesapz94p4mWAQ3QNFS+MUGyWivJR4ofcywPXS3PR8SGUEyVVSd/HwjrUlzIBF
         dXgBuNfYfXo7kMs3tkmOwsRNdIdiwJF2sBH4KbTZ8madhgLEfyVlTFfncRJmSIbSKx
         Q845C7a4rXoTbF7EvRk0LH4Ed4RLppbs3/45/QGTSI5OvlEZPpS1VkJ84rs/ku5HrR
         WAT0oJM6+5RpkplXzqwiLVuNNp0bJYbrpTinvsFvIec3Y79ZysSyiwQm82vOwk/DT+
         +3JA4sdMvFIqk9F2+FG++prMOk5hZ3QJabrujVBkticymrMbniHYOCQm+gqM4I9uPb
         23hnFiyMD6M5Q==
Date:   Thu, 20 Oct 2022 21:46:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Rajesh1.Kumar@amd.com>
Subject: Re: [PATCH v3 net 1/5] amd-xgbe: Yellow carp devices do not need
 rrc
Message-ID: <20221020214615.767a8c35@kernel.org>
In-Reply-To: <20221020064215.2341278-2-Raju.Rangoju@amd.com>
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
        <20221020064215.2341278-2-Raju.Rangoju@amd.com>
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

On Thu, 20 Oct 2022 12:12:11 +0530 Raju Rangoju wrote:
> Link stability issues are noticed on Yellow carp platforms when Receiver
> Reset Cycle is issued. Since the CDR workaround is disabled on these
> platforms, the Receiver Reset Cycle is not needed.
> 
> So, avoid issuing rrc on Yellow carp platforms.

Let me retry [1] the same question:

These devices are only present on SoCs? Changing global data during
probe looks odd.

[1] https://lore.kernel.org/all/20221006172654.45372b3b@kernel.org/
