Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699976A4FBD
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 00:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjB0Xk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 18:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0XkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 18:40:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D351EFCC;
        Mon, 27 Feb 2023 15:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02ECD60F05;
        Mon, 27 Feb 2023 23:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBBCC433D2;
        Mon, 27 Feb 2023 23:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677541222;
        bh=9IxQJE3j4dmxMZbzznAmN8B1dh5sGXAOcy0FKIivJoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mWgMzMsYow3d5/oPP6Yw+TiUfU1bb3O28f+nzzOTKWFw3Ck27DHlBEOZH/dL9H83N
         QdyJl0Awby3W7MNl4DwbqdhWlSZYCqCOVsVj5iDsKM4+4LqfcuwiQIpX83wabT4sYv
         MzLml0YnOXiK97590FuiEhkjhzZUZSi3Y+ZDQ5M5N00Bzn+YY3pDM8aV9OhBz/i5ew
         ZF0qIMbZ9SZvXAG/aDUvdbaSEzLDTk8ZJOef0NOxpUoTEUGLpyo/xLlCZgmOTR8nf8
         2oxLYdgAxxPTT00j6mktHpu3IjxvcjAjgS0wk+oJNhNouzskRLAuV4ZNnxsw0tqhon
         BuBGRBIc2J3pg==
Date:   Mon, 27 Feb 2023 15:40:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] ptp: kvm: Use decrypted memory in confidential guest
 on x86
Message-ID: <20230227154021.259cce7b@kernel.org>
In-Reply-To: <20230227155819.1189863-1-jpiotrowski@linux.microsoft.com>
References: <20230227155819.1189863-1-jpiotrowski@linux.microsoft.com>
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

On Mon, 27 Feb 2023 15:58:19 +0000 Jeremi Piotrowski wrote:
> KVM_HC_CLOCK_PAIRING currently fails inside SEV-SNP guests because the
> guest passes an address to static data to the host. In confidential
> computing the host can't access arbitrary guest memory so handling the
> hypercall runs into an "rmpfault". To make the hypercall work, the guest
> needs to explicitly mark the memory as decrypted. Do that in
> kvm_arch_ptp_init(), but retain the previous behavior for
> non-confidential guests to save us from having to allocate memory.
> 
> Add a new arch-specific function (kvm_arch_ptp_exit()) to free the
> allocation and mark the memory as encrypted again.

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.
