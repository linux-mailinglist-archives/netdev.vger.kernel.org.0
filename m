Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB64550E943
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbiDYTRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiDYTRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:17:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439312E0BA
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 12:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E666AB81A0A
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68760C385A4;
        Mon, 25 Apr 2022 19:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650914049;
        bh=e+58mBVPEiHiPeY+/Is+JGrGhzncK6SOUIsWtfleP+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c457JwD/7Cb4zLRx1smdtcdGe2PAkNHs0x01mHA+q3PhnAf8cWVrr6SIlCgjZxVVN
         lwzIK+eIoOWErCchKH17K1GED7CXsGRAa3n74zNJghUxV+MnNfc2gF8OmCua/h20xE
         QessXasMFJcD1W4FbtqDnfhXNrm3HviD1Gdf7A58HyBpT3re9jgVPs06IgbpfdRJvO
         /CKHD9xpEfuicAGmNBHV05NoykliNdolljMvNAL7lRNqoOCxMrSc7fG/VI1w2s1PAP
         BVBIiQgqwi42JzXUXF9os5BkCugrIOJbiEciIj4BTQ1gjVwh2L72ohVCBDXpBtgrvC
         ULUa+ReqXwKyQ==
Date:   Mon, 25 Apr 2022 12:14:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 03/28] sfc: Copy shared files needed for Siena
Message-ID: <20220425121408.69363c36@kernel.org>
In-Reply-To: <20220425072257.sfsmelc42favw2th@gmail.com>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
        <165063946292.27138.5733728538967332821.stgit@palantir17.mph.net>
        <20220423065007.7a103878@kernel.org>
        <20220425072257.sfsmelc42favw2th@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 08:22:57 +0100 Martin Habets wrote:
> > This ginormous patch does not make it thru the mail systems.
> > I'm guessing there is a (perfectly reasonable) 1MB limit somewhere.  
> 
> I think the issue is with mcdi_pcol.h, which is 1.1MB of defines
> generated from the hardware databases. It has grown slowely over the
> years.
> I'll split up this patch and see if I can manually cut down mcdi_pcol.h.

FWIW the patch did finally make an appearance on the ML but the point
stands. Chiseling down the auto-generated protocol definition for a EoL
part seems like a very nice solution.
