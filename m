Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274AE1DF030
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbgEVTsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgEVTsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:48:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02383C061A0E;
        Fri, 22 May 2020 12:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=Z6TL3xB3sEMCJ9LTRXR3MO+IKHZXgyi31lHXd2yxQts=; b=fQ7//IUJHaDwbkjSiM04uebhl1
        aNqXz9brV3nB9Y6jaTPGwb9ctnHw2ICGtN1UbNqZmBgZ5SAHTA6C+YPATxBrFOVJZ75j33qGBTHgS
        X0MLThoWkskD34zSn/RqpyIL3jwUzGFb15tz+fNFeN5GehXmVnvU+YqI+RTv/e/gk5VlWLQXK9rCo
        yZgByZbUN3vbFyYrEBJ9b5UKaQE2PLMSVTXaYCKhodFv0O6x4mcoLwJXopLNkN1oiNReWfxiD2cHS
        w/zTCdGLsRASI1eyEou841FEpAeIcNES8KUODpJ228XjrX4An0E1RE6nf2pFk6K/k4MgGUdv+yo9q
        e5KFF/LQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcDf1-0006wR-3N; Fri, 22 May 2020 19:48:51 +0000
Subject: Re: [PATCH -net-next] net: psample: depends on INET
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Yotam Gigi <yotam.gi@gmail.com>
References: <3c51bea5-b7f5-f64d-eaf2-b4dcba82ce16@infradead.org>
 <CAM_iQpV62Vt2yXS9oYrkP-_e1wViYRQ05ASEu4hnB0BsLxEp4w@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6c1c6fec-a3fa-f368-ae40-189a8f062068@infradead.org>
Date:   Fri, 22 May 2020 12:48:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV62Vt2yXS9oYrkP-_e1wViYRQ05ASEu4hnB0BsLxEp4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 12:17 PM, Cong Wang wrote:
> On Fri, May 22, 2020 at 12:03 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix psample build error when CONFIG_INET is not set/enabled.
>> PSAMPLE should depend on INET instead of NET since
>> ip_tunnel_info_opts() is only present for CONFIG_INET.
>>
>> ../net/psample/psample.c: In function ‘__psample_ip_tun_to_nlattr’:
>> ../net/psample/psample.c:216:25: error: implicit declaration of function ‘ip_tunnel_info_opts’; did you mean ‘ip_tunnel_info_opts_set’? [-Werror=implicit-function-declaration]
> 
> Or just make this tunnel support optional. psample does not
> require it to function correctly.

Sure, I thought of that, but it's not clear to me which bits of it
to make optional, so I'll leave it for its maintainer to handle.

thanks.
-- 
~Randy

