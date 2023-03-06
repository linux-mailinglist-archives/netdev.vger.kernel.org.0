Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19D36ACBF1
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjCFSG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjCFSGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:06:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02353B208
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 10:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E7460FFA
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 18:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86080C433EF;
        Mon,  6 Mar 2023 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678125978;
        bh=NCxhKpEFYlIJizhgDQDShyeGpntfP2vqKAgOIpL27dg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ao38AcNKRXFqzqVCflPbWmcgogmIVeq88lEL66Cchc9kPXgJRgpXYvpGNRdjgjYyW
         Rvc87A19qqIql32kbT+ONQot6YgP7HgDKvQlrETHlW1D+JaWEUlCR5E3mm9PZ2zJZm
         xAUqOgJOSYDcT9xgtejT281EDkq/XnOaNdkxCuk1y+rm2O3b+duEXEObgzztQafEm4
         7IqDgWTCxs/bSJLWjKZ9CvUlvwv9dSvRfNtmGOt0Mt/L5dwvlAfI1JufeqEtKr/Ibu
         aArvXB35DNb0xa33BAIExrL/SOr46LUKHZmfjXnFRP12QOtEpcTVF1JG0T8yXcZNl7
         tSsCygRFjMolA==
Date:   Mon, 6 Mar 2023 10:06:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] bnxt_en: reset PHC frequency in free-running mode
Message-ID: <20230306100616.6ece1694@kernel.org>
In-Reply-To: <20230306165344.350387-1-vadfed@meta.com>
References: <20230306165344.350387-1-vadfed@meta.com>
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

On Mon, 6 Mar 2023 08:53:44 -0800 Vadim Fedorenko wrote:
> +#define BNXT_PTP_RTC(bp)	(!BNXT_MH(bp) && \
> +				 ((bp)->fw_cap & BNXT_FW_CAP_PTP_RTC))

nit: maybe BNXT_PTP_USE_RTC() ?
