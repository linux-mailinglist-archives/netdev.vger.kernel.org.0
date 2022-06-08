Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B171E543654
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbiFHPL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242946AbiFHPKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:10:52 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7830A3F890B
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:02:56 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyxCl-000DU0-2F; Wed, 08 Jun 2022 17:02:43 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyxCk-000OqT-Od; Wed, 08 Jun 2022 17:02:42 +0200
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time for
 periodic probe
To:     Yuwei Wang <wangyuweihx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        roopa@nvidia.com, dsahern@kernel.org,
        =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, yuwei wang <wangyuweihx@hotmail.com>
References: <20220522031739.87399-1-wangyuweihx@gmail.com>
 <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
 <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
 <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
 <797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net>
 <20220524110749.6c29464b@kernel.org>
 <CANmJ_FN6_79nRmmzKzoExzD+KJ5Uzehj8Rw_GQhV0SiBpF3rPg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b1b0cdb5-c21a-dde5-a185-afedd8ddd353@iogearbox.net>
Date:   Wed, 8 Jun 2022 17:02:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANmJ_FN6_79nRmmzKzoExzD+KJ5Uzehj8Rw_GQhV0SiBpF3rPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26566/Wed Jun  8 10:05:45 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Yuwei,

On 5/24/22 9:13 PM, Yuwei Wang wrote:
[...]
> I agree too, so there will be as following parts:
> 1) prevent misconfig by offering a minimum value
> 2) separate the params `INTERVAL_PROBE_TIME` as the probe interval for
> `MANAGED` neigh

Given net-next is open, could you rebase and send a v3 of your probe time knob?

Thanks,
Daniel
