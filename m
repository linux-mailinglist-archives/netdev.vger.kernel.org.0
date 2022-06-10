Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327B5546E13
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350557AbiFJUJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350511AbiFJUJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:09:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D6C23D9B9;
        Fri, 10 Jun 2022 13:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4AFF60908;
        Fri, 10 Jun 2022 20:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B2AC341C0;
        Fri, 10 Jun 2022 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654891744;
        bh=iwnIUaWssTlHqycGijCDdgg7r32DPi0ilgri/+5YyAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RZqW19XiHxniX1vI+hPIGPdhpVzh1qA+4vF7yCUG5w3gttxIs0U64yy4B4ZWvXzHC
         GdSaR2FYi3wsghxQS7AEmdiBLt4qehKK/48UCZCGjEBE0b9Myh6imoUb2PposDfimo
         SLUK7XTxWnApGDRFTwkFX2gpuOD6OZBqB2UmVhXlIB3DfX0sQcHrBtpTKY5vaDo0Yp
         /hcXWudhme0PUKm5UKADcIohLrwmG44dl0+LnKJK2O4S3JDNhutsp4GHYJsVXyRnUB
         B/qAGDlZMQ0gew0+SggS0lbmhm+zSHVc+xlvUezvaH6TlPtJyQuOmkTuLjVcpW/iy6
         IBtewMQAhYCyg==
Date:   Fri, 10 Jun 2022 13:09:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 0/6] Configurable VLAN mode for NCSI driver
Message-ID: <20220610130903.0386c0d9@kernel.org>
In-Reply-To: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jun 2022 00:59:34 +0800 Jiaqing Zhao wrote:
> Currently kernel NCSI driver only supports the "VLAN + non-VLAN" mode
> (Mode #2), but this mode is an optional mode [1] defined in NCSI spec
> and some NCSI devices like Intel E810 Network Adapter [2] does not
> support that mode. This patchset adds a new "ncsi,vlan-mode" device
> tree property for configuring the VLAN mode of NCSI device.
> 
> [1] Table 58 - VLAN Enable Modes
>     https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf
> [2] 12.6.5.4.3 VLAN
>     https://cdrdv2.intel.com/v1/dl/getContent/613875

Please don't post the same patches more than once a day. You posted the
same patches 3 times within 15 minutes with no major difference :/

Why is "ncsi,vlan-mode" set via the device tree? Looks like something
that can be configured at runtime. 
