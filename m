Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47C765F8A8
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 02:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbjAFBJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 20:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbjAFBJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 20:09:02 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205CD6E406;
        Thu,  5 Jan 2023 17:09:02 -0800 (PST)
Message-ID: <e4199805-724d-9eb4-1cdf-d5c2bb3a4dcf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672967340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aUXCA8fba+2o9qzBb9rEnQwnxnYEeA3WFKcD0R8NF2k=;
        b=aQep0indcPEGoU0lTFHcNQWeJqbQ4ehOpMjaT/a88IwUFySnZhlptbW8KX28wSPVUXlexq
        i3V7VlAaud9EUhajsbh9S4zEIagECFqK+fiUXxk/uRw+/eyDbeW6jPOOEI9MqKgvew05xt
        dRONFkx2tOgE04zbmKr0O5RoblBFsQY=
Date:   Thu, 5 Jan 2023 17:08:55 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v6 16/17] net/mlx5e: Support RX XDP metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20230104215949.529093-1-sdf@google.com>
 <20230104215949.529093-17-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230104215949.529093-17-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/23 1:59 PM, Stanislav Fomichev wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
> pointer to the mlx5e_skb_from* functions so it can be retrieved from the
> XDP ctx to do this.

The mlx5 changes lgtm.

Saeed/Tariq, please take a look and ack these two mlx5 patches (15 and 16) if 
they look good to you also.  I notice Tariq has already reviewed the mlx4 
changes (Thanks!).

