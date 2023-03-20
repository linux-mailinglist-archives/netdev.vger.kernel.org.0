Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C86C2047
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjCTSsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCTSrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:47:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0B6302B9;
        Mon, 20 Mar 2023 11:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50DD5617AC;
        Mon, 20 Mar 2023 18:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6CCC433D2;
        Mon, 20 Mar 2023 18:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679337627;
        bh=9PBDNfwvOXGxVVKGDFzwfj5/VEAUgCVGuZnn2tA+K38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HAaaQ5citNp7zdijzeN2PS4IPNV5hsKvrbcsstpe0mlfCrvIIZ/VsQjKLcZrMQUZh
         fMw5ae40iqwkgiowMQ6742cHmBbxzr8xyc9pdHXX3kxnOwgbiSLekXlpP9XaWojuiY
         WYEbsvrwMZdTNg/EZgesWEXTTmaGWaTTAs4KJaJhG3M2RQ9PDkPd9PHeRJD5gP7E1s
         y/GMx4LKNsZOTV7Xq9KKgCjvuQTKUNs0yWfsiNIJS/Av1Ibr6ZEGSDIDx2BS5tcFlZ
         uGCqZLLxm0FsVAwUIu2OopYKJuMLpocKIAdGmo9NZXvgBxghR8eeCz8Ew3MrzQKBuy
         atFJ8cejH2OAA==
Date:   Mon, 20 Mar 2023 11:40:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 1/2] net-sysfs: display two backlog queue
 len separately
Message-ID: <20230320114026.021d9b3b@kernel.org>
In-Reply-To: <CAL+tcoCpgWUep+jAo--E2CGFp_AshZ+r89fGK_o7fOz9QqB8MA@mail.gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
        <20230315092041.35482-2-kerneljasonxing@gmail.com>
        <CAL+tcoCpgWUep+jAo--E2CGFp_AshZ+r89fGK_o7fOz9QqB8MA@mail.gmail.com>
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

On Sun, 19 Mar 2023 11:05:57 +0800 Jason Xing wrote:
> > Sometimes we need to know which one of backlog queue can be exactly
> > long enough to cause some latency when debugging this part is needed.
> > Thus, we can then separate the display of both.
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>  
> 
> I just noticed that the state of this patch is "Changes Requested" in
> the patchwork[1]. But I didn't see any feedback on this. Please let me
> know if someone is available and provide more suggestions which are
> appreciated.
> 
> [1]: https://patchwork.kernel.org/project/netdevbpf/patch/20230315092041.35482-2-kerneljasonxing@gmail.com/

We work at a patch set granualrity, not at individual patches, 
so if there is feedback for any of the patches you need to repost.
Even if it's just to drop the other patch from the series.
