Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC76A4CCCDF
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbiCDFQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiCDFQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:16:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DA3793A2;
        Thu,  3 Mar 2022 21:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA26B82746;
        Fri,  4 Mar 2022 05:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EDCC340E9;
        Fri,  4 Mar 2022 05:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646370959;
        bh=TVZ5d7fMwsEWL0wbEKdL7/uuIoUi5h9sH5M7YaQw/IE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cxw05bgcLyUrvmDUXQwXwzq+RszfEgXr6TSM5XQwY/WgXBiDSw0yjaOQzf5Qu1OmL
         aJrTSxCfdQ8AZtzicJIeqFIvBPDiJGOvzk6DGkvpDHTr5RxVOoyjUF1TDgin8RGGh3
         XfC3AVxu5m4AEavd76m7nwJQM07LGiFwEv9go7wJDDBT/K8K6YhRafaCtwwp5pBjxR
         MZoMlpfAzbF3rHY5LkLE4v5jj5QGe1BAFFh1Kl6DxR+eSVkAezcp4/kz+YlJXpSAYl
         klxgBDhpGVR2U7WL75yN5S1K00Ue/WFT00nKatkz7FSbUCF/56VtBKhPYTWti/mz49
         hplKEC8r0Ke+g==
Date:   Thu, 3 Mar 2022 21:15:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     isdn@linux-pingi.de, davem@davemloft.net, zou_wei@huawei.com,
        zheyuma97@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hfcpci: check the return value of dma_set_mask()
 in setup_hw()
Message-ID: <20220303211557.16458976@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303025710.1201-1-baijiaju1990@gmail.com>
References: <20220303025710.1201-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Mar 2022 18:57:10 -0800 Jia-Ju Bai wrote:
> The function dma_set_mask() in setup_hw() can fail, so its return value
> should be checked.
> 
> Fixes: e85da794f658 ("mISDN: switch from 'pci_' to 'dma_' API")

The change under Fixes only switched the helper the driver uses,
it did not introduce the problem. The Fixes tag should point to 
the earliest commit where the problem is present.
