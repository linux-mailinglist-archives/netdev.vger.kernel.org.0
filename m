Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA468676414
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 06:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjAUF4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 00:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjAUF4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 00:56:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8E070C6B;
        Fri, 20 Jan 2023 21:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DC94B82B0E;
        Sat, 21 Jan 2023 05:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EDCC433D2;
        Sat, 21 Jan 2023 05:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674280559;
        bh=Mxbldmsd8nJvkd6dOqgudsJCO2Frwmy0elgChRpTU+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KsM9sE8m43oFegCCkrS3AwBzSkBhMByVflh7MbEtdY/lXWlGfyt572fJ1FWIBdfdp
         cDiNA2m+8LuIdRcDDsuDhOSxXrpudBmQVMpPbq3oNsOOPBGN0pMNKEHRj81xgRVRW1
         g7sGQLoaLUIygA/Nu0E4oa0vCTLZ/joNwkOwbYNvxUllznD+H0iJDz/zyuXtd9GO1h
         xpMc0tOV9UiO7w9rhFSwAveeHGCiKKmGSMf2lSeGQVi/8wr8yq7GYsvKd3x0upPDgC
         17F8ksMP00rIjuG75kjcYdGKWnAWu7gb8J7p22eSo9XHZL5GG+ot4B+7H61H5zQcDC
         O+HX/MUKx/bKg==
Date:   Fri, 20 Jan 2023 21:55:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <yangyingliang@huawei.com>,
        <weiyongjun1@huawei.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <lennart@lfdomain.com>
Subject: Re: [net-next 0/3] net: ethernet: adi: adin1110: add PTP support
Message-ID: <20230120215557.4534c8ce@kernel.org>
In-Reply-To: <20230120095348.26715-1-alexandru.tachici@analog.com>
References: <20230120095348.26715-1-alexandru.tachici@analog.com>
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

On Fri, 20 Jan 2023 11:53:45 +0200 Alexandru Tachici wrote:
> Add control for the PHC inside the ADIN1110/2111.
> Device contains a syntonized counter driven by a 120 MHz
> clock  with 8 ns resolution.

allmodconfig build breaks:

ERROR: modpost: "ktime_get_fast_timestamps" [drivers/net/ethernet/adi/adin1110.ko] undefined!
