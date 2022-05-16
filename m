Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25082528186
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbiEPKKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiEPKKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:10:51 -0400
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803D064FA
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 03:10:48 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L1w4Q0XbzzMqJR9;
        Mon, 16 May 2022 12:10:46 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L1w4P33kPzljmX4;
        Mon, 16 May 2022 12:10:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652695846;
        bh=V+rni+Z4gxa+WX9M1RKqcCQIQzLwibNer0DCvsggxqo=;
        h=Date:From:To:Cc:References:Subject:In-Reply-To:From;
        b=loYEjtnOZOwKyc1KKLDY+yYIOWiLP1IKkoSOvroIbLQY2nLhlXNWNG8wL6RWpLUvz
         q/pYAsP4EgYVJMdn+dktHTvU9rvyAQaJoOHTFai8evHj+XwN2YX8ATNiaSOBYr8IXa
         z+8rjmoPvapLHgeMVND5m+YQzKblO1CEMmBq6cFA=
Message-ID: <78882640-70ff-9610-1eda-5917550f0ab8@digikod.net>
Date:   Mon, 16 May 2022 12:10:44 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
 <d3340ed0-fe61-3f00-d7ba-44ece235a319@digikod.net>
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
In-Reply-To: <d3340ed0-fe61-3f00-d7ba-44ece235a319@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/04/2022 18:52, Mickaël Salaün wrote:
> You need to update tools/testing/selftests/landlock/config to enable 
> CONFIG_NET and CONFIG_INET.
> 
> 
> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>> Adds two selftests for bind socket action.
>> The one is with no landlock restrictions:
>>      - bind_no_restrictions;
>> The second one is with mixed landlock rules:
>>      - bind_with_restrictions;
> 
> Some typos (that propagated to all selftest patches):
> 
> selftest/landlock: Add tests for bind hook

I did some typo myself, it should be "selftests/landlock:"
