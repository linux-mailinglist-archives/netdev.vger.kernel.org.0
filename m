Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6F76ACF82
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCFUt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCFUtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:49:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38FD6EB8
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 12:49:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D51460FCB
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 20:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B012EC4339B;
        Mon,  6 Mar 2023 20:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678135793;
        bh=jbcX5Fy2XaAH3P00FpmSrdfIVKo7dovQHNPq5RQo4Nk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S7mI9QYUwGKgjLOkDLatVvAHIWyihOP64rhjwp3EVpxEWjliq62rU6X9hkiaPhNrW
         jKxAwEwo5Jk9Pw+wiVDkQgASRU4hPuolebYkyt+KllxwBMfhfMGOAn6rFH+8aY/4O9
         K1oPuSIttPVdqP/2Nk5fKYywcPzNvbxxzhAM2PCFrOlO5pdronfH4hjk4L3oskqNvC
         +/213RcKRqfrXFeUW7MXYSwNC4zKK2zB0k8TWo611dqNuY70WLvnPDMMX0rQ3h13xu
         rArrgaidRPraFcT3d5YyDj10RzddZWGy7yyFl9kVCj8H4bDsY/PIk+vlmSoqPrVMZQ
         XZ8im5wHO+8ow==
Date:   Mon, 6 Mar 2023 12:49:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        <netdev@vger.kernel.org>
Subject: Re: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Message-ID: <20230306124952.1b86d165@kernel.org>
In-Reply-To: <20230306155726.4035925-1-vadfed@meta.com>
References: <20230306155726.4035925-1-vadfed@meta.com>
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

On Mon, 6 Mar 2023 07:57:26 -0800 Vadim Fedorenko wrote:
> Flashing firmware via devlink flash was failing on PTP OCP devices
> because it is using Quad SPI mode, but the driver was not properly
> behaving. With force_irq flag landed it now can be fixed.
> 
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>

Give it until Friday, the patch needs to be in the networking trees
(our PR cadence during the merge window is less regular than outside
it).
