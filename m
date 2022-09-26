Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8BB5EB1D0
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiIZUIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiIZUII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:08:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C3871985
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 13:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17278B80C75
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 20:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C153C433B5;
        Mon, 26 Sep 2022 20:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664222884;
        bh=TS6vb0m3k6eiRDpO3DmxP8c72gZLLIPpPyJF6ZBcDOw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HIrq1+gKpHusqRrsE9hyu1PR1dOy1+wxTaEs2E5+dbq6BOmQFUpDlcbG8JgCSVRDg
         wimhH/TAGvhgFnJDSBQ/ekhykin3/uFmjChWMo/FMKh6y2v/iJX3W1rOwIwpwCZsm/
         cSdmqhGIpXtRFeXBMslP1EHfqsVmNM9zW0Uy7NE6xAcaGNAW9N5d4PPowOr8l25Lte
         yKqiFeYDcg6I/YZRu0W9JlwreRRnMYKL+3k3so5GEKNvOuPpa4jwpNiNPpEgcE8OVY
         RVqLHG/y1Gh/lBU0faB14y/wvV5c/Knuw04fqeZA9yKWXgrinVlQypw7XSlumAj8WW
         62E1iAQsPcHpw==
Date:   Mon, 26 Sep 2022 13:08:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: use DEFINE_SHOW_ATTRIBUTE
 to simplify code
Message-ID: <20220926130803.3684471a@kernel.org>
In-Reply-To: <20220922142929.3250844-1-liushixin2@huawei.com>
References: <20220922142929.3250844-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 22:29:29 +0800 Liu Shixin wrote:
> Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.
> No functional change.

Does not apply cleanly. Please rebase on net-next and put 
[PATCH net-next v2] in the subject when reposting.
