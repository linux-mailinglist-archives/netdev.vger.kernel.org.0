Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF7C5A87D1
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiHaU7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiHaU7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:59:20 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA93BDC0A4;
        Wed, 31 Aug 2022 13:59:15 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oTUno-0002Mb-Ns; Wed, 31 Aug 2022 22:59:12 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oTUno-0000bj-FV; Wed, 31 Aug 2022 22:59:12 +0200
Subject: Re: [PATCH v5 bpf-next 0/6] selftests: xsk: real device testing
 support
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org
References: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <94e14157-f01f-02f3-30eb-5cbad9160d02@iogearbox.net>
Date:   Wed, 31 Aug 2022 22:59:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26644/Wed Aug 31 09:53:02 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/22 3:55 PM, Maciej Fijalkowski wrote:
> v4->v5:
> * ice patches have gone through its own way, so they are out of this
>    revision
> * rebase
> * close prog fd on error path in patch 1 (John)
> * pull out patch for closing netns fd and send it separately (John)
> * remove a patch that made Tx completion rely on pkts_in_flight (John)

Your series still needs a rebase against bpf-next since it doesn't
apply cleanly.

Thanks,
Daniel
