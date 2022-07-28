Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C36C583FE3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiG1NYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiG1NYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:24:40 -0400
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254EE5073D
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:24:39 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LtrwN52BQzMqNMF;
        Thu, 28 Jul 2022 15:24:36 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4LtrwN1XcBzlqwwk;
        Thu, 28 Jul 2022 15:24:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1659014676;
        bh=RAweEF+huCI4AjPNTonqz95NxOvYJYl24mF2cUDIipo=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=OPgJqbWri/qJZotQKZQvql1WiQZIiEksauuDKbSxuFE1Qrhe5ONPLebh/8ehusQr2
         815uADrpa9sH6gaMVEJZnO346PhC4t4ApLtI1G1L9ko7tLXmrVKEjSd87A7dICogOz
         RB7yab6zG7n2UHkuhJim4rHAo7jfUyvIzPpXjajE=
Message-ID: <16ce6dc2-6b9c-da02-5737-eb9d26865590@digikod.net>
Date:   Thu, 28 Jul 2022 15:24:35 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-12-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 11/17] seltests/landlock: adds tests for bind() hooks
In-Reply-To: <20220621082313.3330667-12-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/06/2022 10:23, Konstantin Meskhidze wrote:
> Adds selftests for bind() socket action.
> The first is with no landlock restrictions:
>      - bind without restrictions for ip4;
>      - bind without restrictions for ip6;
> The second ones is with mixed landlock rules:
>      - bind with restrictions for ip4;
>      - bind with restrictions for ip6;
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v5:
> * Splits commit.
> * Adds local address 127.0.0.1.
> * Adds FIXTURE_VARIANT and FIXTURE_VARIANT_ADD
> helpers to support both ip4 and ip6 family tests and
> shorten the code.
> * Adds create_socket_variant() and bind_variant() helpers.
> * Gets rid of reuse_addr variable in create_socket_variant.
> * Formats code with clang-format-14.

It seems that a formatting pass is missing for FIXTURE_VARIANT().
