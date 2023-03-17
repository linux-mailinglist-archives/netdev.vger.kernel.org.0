Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA7B6BF175
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCQTKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjCQTKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:10:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC31688F;
        Fri, 17 Mar 2023 12:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED66761230;
        Fri, 17 Mar 2023 19:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309E6C433EF;
        Fri, 17 Mar 2023 19:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679080202;
        bh=yHuGUlIVtSIkC3TpQmH8pIjND8g8wMiJtrRBDAU8eLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pc0wJKcnwcWRfU1tx7qodECMuTb+5eeag2onzQIZ6YoxikSv27ArqHyETYBu2553W
         ZJgeJuy/FIXu12cSjzcXxDOegVeIcQno7Vaxk6uJjQgQctUinGi9jEs0G9vq3F91pp
         2E1xzoCyLdy5FIXPp7bvOnl+nogY8e8Mnxlk/rkpAElOJFkeOJljtdtwF/300qnzCL
         rUEzQIriG1iaXlZMHEzAKUj44hIukZLWiuMklTr75O8Widf5GK28PeJ/hqOMGlR9j8
         haVe0CiyHY3g1LOz1y9REpJWL7DD17t5ISo6rddadugFoqMPGQMuM+zVCqq8lqr8ra
         033QNQNjCBCiA==
Date:   Fri, 17 Mar 2023 12:10:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 RESEND] ptp: kvm: Use decrypted memory in
 confidential guest on x86
Message-ID: <20230317121001.52e37300@kernel.org>
In-Reply-To: <14d92d4b-d2c9-3a63-31b4-b083dba0878e@linux.microsoft.com>
References: <20230308150531.477741-1-jpiotrowski@linux.microsoft.com>
        <14d92d4b-d2c9-3a63-31b4-b083dba0878e@linux.microsoft.com>
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

On Fri, 17 Mar 2023 16:59:37 +0100 Jeremi Piotrowski wrote:
> > Hi,
> > 
> > I would love to not allocate a whole page just for this driver, swiotlb is
> > decrypted but I don't have access to a 'struct device' here. Does anyone have
> > any suggestion?
> 
> Does anyone have any comments or suggestions? Or can this be merged.

Looks like the patch got miscategorized in patchwork.
It LGTM, I'll apply it to netdev if nobody speaks up before 
the end of the day..
