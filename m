Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1932659666
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 09:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiL3IoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 03:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiL3IoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 03:44:12 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3610E1A040;
        Fri, 30 Dec 2022 00:44:08 -0800 (PST)
Received: from vla5-b2806cb321eb.qloud-c.yandex.net (vla5-b2806cb321eb.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3e0d:0:640:b280:6cb3])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id CEB065FD5D;
        Fri, 30 Dec 2022 11:44:03 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b702::1:2] (unknown [2a02:6b8:b081:b702::1:2])
        by vla5-b2806cb321eb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 2iNnBJ0QXqM1-hpii9JF2;
        Fri, 30 Dec 2022 11:44:03 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672389843; bh=9HkybAdjC40pqk0L1AvXjL22v1hmp35ak9rgDsXiqnc=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=moyUQvrtCJavoqdqNpjlgnOYPerhAGlEJzfxu9kmlO72fjeZHujRiUdWSDLCiSkNL
         rfzEujRryPDC2eebAr1iTn+8u0hukir0Yc36vKuJJCZjNmVMJGuegwVrEVYOueew11
         FFCKSsQmsZbBFulfDnoT6WHwJBu/1r6AS5BUGaEk=
Authentication-Results: vla5-b2806cb321eb.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <a09b374f-45e3-9228-4846-80f655cf3caa@yandex-team.ru>
Date:   Fri, 30 Dec 2022 11:44:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RESEND PATCH net v1] drivers/net/bonding/bond_3ad: return when
 there's no aggregator
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221226084353.1914921-1-d-tatianin@yandex-team.ru>
 <20221229182227.5de48def@kernel.org>
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <20221229182227.5de48def@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/22 5:22 AM, Jakub Kicinski wrote:
> On Mon, 26 Dec 2022 11:43:53 +0300 Daniil Tatianin wrote:
>> Otherwise we would dereference a NULL aggregator pointer when calling
>> __set_agg_ports_ready on the line below.
> 
> Fixes tag, please?
Looks like this code was introduced with the initial git import.
Would that still be useful?
