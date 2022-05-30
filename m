Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382CB53872A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 20:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbiE3SRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 14:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbiE3SRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 14:17:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB7A53E18
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 11:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CCE5B80E5F
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 18:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8B5C385B8;
        Mon, 30 May 2022 18:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653934667;
        bh=yLB6X46I1ZfcREozuFZmXo0HgUsTtxckYXMsibxfirQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lKhIDfMPgRp4IkJbBdKWtBYYG0EPSxJFuGjNwNOON22RseY0ZCjvoZHiy/yNhoPde
         n9QJDgbtlLByOY0pgbAkoVSkI/5zUMqmi+rKqlWkkjYD1DXpNiI/NQtxKZtEdra6DP
         ZRFr7ATZ0lofiftYvkH7Rkbu1dLNOnH5KVsyV/Zb63QBZfvrg+Dc9u1HqoaU560ghM
         z9NEYsQ/G9qAidD5Jrv5sD2+h4ZtmYsSzzylIXkPqZCbGf6C+WzN4eIayYm2ZSUjvZ
         Odd5ZeACVQDymtwSWftuONvBkWaNUtTAuc5OeVBF4k67RvWAC7oBp21Pb+zh5N3Iw0
         KUAAC9Nve/bhQ==
Date:   Mon, 30 May 2022 11:17:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Message-ID: <20220530111745.7679b8c4@kernel.org>
In-Reply-To: <20220530141438.2245089-1-maximmi@nvidia.com>
References: <20220530141438.2245089-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 17:14:38 +0300 Maxim Mikityanskiy wrote:
> +	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");

I'd call it "unsafe_sendfile".

Also please send a patch to Documentation/, I forgot about that.
