Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB5764683C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiLHE0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLHE0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:26:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E36394902;
        Wed,  7 Dec 2022 20:26:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15B77B8223C;
        Thu,  8 Dec 2022 04:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDD2C433D6;
        Thu,  8 Dec 2022 04:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670473561;
        bh=pN+wGVc+4cW/yHQxiTF6zQ8V1EauH9TedbOtylafW/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xw8F6uVjzfJiIWtPGl//KuiDk0NqwqZpU03E12FkNIQIM3SzfysGj+oWk2nQQFYZV
         sWmv9wWq1DMiUmgzKcm3ejtvVHpouGCIAxBzobzQAtlBGTVrSsM/lZrr79Pey+N3cY
         zsS5xKbzVWJLKaBYYQk62CydY3YsD3wtPP2CLQvUyiNvdCoACfVimlCJpj65Is6sTf
         QSA/NGDPp44x3z+lwnOeDnqKDqbW2N1QLwEfevfBekAIaIsDe5j5lByCq+pZGP8rG5
         hbUK5ybG3zodeFWaQmH614T+53DQZi0w/nTh3rrbkkDumccNlEfJCUe8di4m5qO+i0
         zHgkz/wDjwAmg==
Date:   Wed, 7 Dec 2022 20:25:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 01/12] bpf: Document XDP RX metadata
Message-ID: <20221207202559.4d507ccf@kernel.org>
In-Reply-To: <20221206024554.3826186-2-sdf@google.com>
References: <20221206024554.3826186-1-sdf@google.com>
        <20221206024554.3826186-2-sdf@google.com>
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

On Mon,  5 Dec 2022 18:45:43 -0800 Stanislav Fomichev wrote:
> +- ``bpf_xdp_metadata_rx_timestamp_supported`` returns true/false to
> +  indicate whether the device supports RX timestamps
> +- ``bpf_xdp_metadata_rx_timestamp`` returns packet RX timestamp
> +- ``bpf_xdp_metadata_rx_hash_supported`` returns true/false to
> +  indicate whether the device supports RX hash
> +- ``bpf_xdp_metadata_rx_hash`` returns packet RX hash

Would you mind pointing to the discussion about the separate
_supported() kfuncs? I recall folks had concerns about the function
call overhead, and now we have 2 calls per field? :S
