Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE7A495E2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfFQXaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:30:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQXaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 19:30:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84676151BEF25;
        Mon, 17 Jun 2019 16:30:51 -0700 (PDT)
Date:   Mon, 17 Jun 2019 16:30:50 -0700 (PDT)
Message-Id: <20190617.163050.1853001451258961153.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     fklassen@appneta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        willemb@google.com
Subject: Re: [PATCH net-next v3 0/3] UDP GSO audit tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAF=yD-KQ1dxmNbR8-xoiNTfwHXzO-wQRpz+0ZFN9o36+UE_e6A@mail.gmail.com>
References: <20190617190837.13186-1-fklassen@appneta.com>
        <CAF=yD-KQ1dxmNbR8-xoiNTfwHXzO-wQRpz+0ZFN9o36+UE_e6A@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 16:30:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 17 Jun 2019 16:29:37 -0400

> On Mon, Jun 17, 2019 at 3:09 PM Fred Klassen <fklassen@appneta.com> wrote:
>>
>> Updates to UDP GSO selftests ot optionally stress test CMSG
>> subsytem, and report the reliability and performance of both
>> TX Timestamping and ZEROCOPY messages.
>>
>> Fred Klassen (3):
>>   net/udpgso_bench_tx: options to exercise TX CMSG
>>   net/udpgso_bench.sh add UDP GSO audit tests
>>   net/udpgso_bench.sh test fails on error
>>
>>  tools/testing/selftests/net/udpgso_bench.sh   |  52 ++++-
>>  tools/testing/selftests/net/udpgso_bench_tx.c | 291 ++++++++++++++++++++++++--
>>  2 files changed, 327 insertions(+), 16 deletions(-)
>>
>> --
> 
> For the series:
> 
> Acked-by: Willem de Bruijn <willemb@google.com>

Series applied, thanks everyone.
