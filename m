Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE1A3FBDF7
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbhH3VMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbhH3VMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:12:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287FFC061575;
        Mon, 30 Aug 2021 14:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=0TJxOOH5p+HrFWJLFUcuJ9lBQlj25u4M5wGnQIiRsbw=; b=IkjCmSKT518oxCC2kgAuDDKMLg
        iuxbnyNlRmICByJFCR39yOIv0TUc2eQITfWcYFuXMinBxmOfBAxJuMJ+jhTMWJUfVKu8SQ69f/iWs
        VccoKPInOjgtdVLOy2yB7hd2FKW+SgkB9oGjE5vl872bUC77d32DYDntUa0dMGTe+E0snvdn0rNdb
        NlOuuEGUH/VH+BhWb3UGfgmMY3ylsnh1dD7LnAnBYN3kCuAxRndVF7I2wIvxxqwzg9xDqsTEDXJjR
        0v0CP9ClzKFQcNBAK/WLbPAuFbVTjbsU0Y+B/dH3M8GoE3TZA+fvkA2ExfbW3hmaZg8tRXzjZ2vN9
        LQ+2cH8Q==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKoYu-000bbo-GO; Mon, 30 Aug 2021 21:11:24 +0000
Subject: Re: linux-next: Tree for Aug 30
 (drivers/net/ethernet/litex/litex_liteeth.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>
References: <20210830200956.5d18e60f@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3e254b11-d70c-6318-d691-dd7346d37a3e@infradead.org>
Date:   Mon, 30 Aug 2021 14:11:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210830200956.5d18e60f@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/21 3:09 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20210827:
> 

on x86_64: when CONFIG_OF is not set:


../drivers/net/ethernet/litex/litex_liteeth.c: In function ‘liteeth_setup_slots’:
../drivers/net/ethernet/litex/litex_liteeth.c:207:8: error: implicit declaration of function ‘of_property_read_u32’; did you mean ‘bpf_user_rnd_u32’? [-Werror=implicit-function-declaration]
   err = of_property_read_u32(np, "litex,rx-slots", &priv->num_rx_slots);
         ^~~~~~~~~~~~~~~~~~~~


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
https://people.kernel.org/tglx/notes-about-netiquette
