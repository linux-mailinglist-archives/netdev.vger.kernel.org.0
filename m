Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1375A15E1
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241998AbiHYPe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbiHYPe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:34:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFD22AC6A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 08:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3A0EB82A16
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61696C433D6;
        Thu, 25 Aug 2022 15:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661441663;
        bh=FuGs9oh6Ba9YfGLaXLnlC6A7RkzSz3dNE3QeVySG520=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jRgCT3+Xb3qX2yxvXPu6CoNMDqGZ5pE4oURE4jaUBVnNRk5ngzY8GKx9G/L2/iubv
         74c/b9/PqPy5S99BtQb+xuhKBmGq/vQtl3rgvTTeUIChiB7ncVsJCD0v/tfz16RYxm
         0KtsgkvF05nBE7u/6jNSIF7v98rf7UGZ/mjBXvyBUaAknIFyJAI09DAnNmFsAcsROu
         8tc2khnOZx2TQE4yH14C10m5AvJhAmtnh6ukCbURvxXB39RxzYSyF0I1MyCHYfam52
         WzBLLdbohO8hR+hmdTLNBfON1Fw6jiWPg2kjT1iT2TVvVF8P7tfyFsFeUg+r2MpJqd
         ZIvaOKXiX6VtQ==
Date:   Thu, 25 Aug 2022 08:34:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, mkubecek@suse.cz, johannes@sipsolutions.net
Subject: Re: [PATCH net-next v2 6/6] ethtool: report missing header via
 ext_ack in the default handler
Message-ID: <20220825083422.7a401821@kernel.org>
In-Reply-To: <Ywdotl9Zn2MlBhCF@shredder>
References: <20220825024122.1998968-1-kuba@kernel.org>
        <20220825024122.1998968-7-kuba@kernel.org>
        <Ywdotl9Zn2MlBhCF@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 15:19:02 +0300 Ido Schimmel wrote:
> Nice idea. Wanted to ask why you kept the error messages for some of the
> devlink attributes, but then I figured that user space first needs to
> learn to interpret 'NLMSGERR_ATTR_MISS_TYPE' and
> 'NLMSGERR_ATTR_MISS_NEST'.

Nod.

> Do you plan to patch iproute2/ethtool after the kernel patches are accepted?

I think ethtool may be doable, I don't remember iproute2 having good
support for NLMSGERR_ATTR_OFFS (i.e. resolving offsets), but no, I'm
not planning to patch either :( Too few hours in a day :(
