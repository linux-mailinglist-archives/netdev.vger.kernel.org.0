Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82E7676038
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjATWhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjATWhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:37:38 -0500
X-Greylist: delayed 87 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Jan 2023 14:37:36 PST
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637DD59C3;
        Fri, 20 Jan 2023 14:37:36 -0800 (PST)
Message-ID: <a89e9e55-d203-e7de-6aaa-ac8658001276@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674254254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IuFJA0nxTY/Wo1ZFrVpqhSslc1N9VObbwxE7PH5ChyI=;
        b=mmR0OP7dpA/iKsA8y+MmrQVe8Jpgvu6dw01LiUUeSKRyZ+5ThYoK5ipDpqHPbZ2weBipa6
        lySuaMFRbQ4i4ULGKW8wgtjlnXz6nDuYM6GOdDsQ094XNJtG2uroMTTlZBI+gMSDSQlrWG
        eW0WY/6X8QeM0tpMW5IqEXe9GBXo8KA=
Date:   Fri, 20 Jan 2023 14:37:29 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v8 16/17] net/mlx5e: Support RX XDP metadata
Content-Language: en-US
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>
References: <20230119221536.3349901-1-sdf@google.com>
 <20230119221536.3349901-17-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230119221536.3349901-17-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
> pointer to the mlx5e_skb_from* functions so it can be retrieved from the
> XDP ctx to do this.

Tariq, I believe Stan and Toke have addressed your comments in v7 on the mlx5 
changes. I have also tested in my mlx5 setup with the xdp_hw_metadata in patch 
17. Please help to take a look at patch 15, 16, and ack them if they look good 
to you also.
