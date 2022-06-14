Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BD854A8FD
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiFNF6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbiFNF6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:58:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AA331220
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 22:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BBE615A5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC0FC3411D;
        Tue, 14 Jun 2022 05:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655186290;
        bh=UZvhoHgz3XkmE+dx++3vpfcGTfD9aiiC4SLluyAGPCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Li62WaNKfvp8J/QK8ewtVoh8hhHeDoiDVOG3bcCQ3wkwj+WW6yeroYeSFkdWyFhUA
         tyf0bzgRer8cfQxZRYhSJjR7tXYBFDnGURLeo8PULzGCi79+G8SS4BgCMJV93ht0RC
         6ovd169XJTFL8R2TUrm8a4C9XGjUQKkl4HoYzaKNvk2rlB8dAEijyoQEZETdR4oqWV
         8Tpa4EZChpR/8Kb2HwZRu7JfgYW4H8Szm7i0UARUadoJwA+/qHjyL49l7gzsEvhLUz
         bT9cV87h5BBS7j+lzJiCsO2mT9nVvNC2g7K4QmmSp+EwCLv5Q9cp+YxBctGOyPovxt
         9UCSiMfTErk7Q==
Date:   Mon, 13 Jun 2022 22:58:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuwei Wang <wangyuweihx@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] sysctl: add
 proc_dointvec_jiffies_minmax
Message-ID: <20220613225808.7f1aa2d2@kernel.org>
In-Reply-To: <20220609105725.2367426-2-wangyuweihx@gmail.com>
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
        <20220609105725.2367426-2-wangyuweihx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jun 2022 10:57:24 +0000 Yuwei Wang wrote:
> +		*valp = tmp;
> +}
> +
> +return 0;
> +}
> +

Looks whitespace damaged
