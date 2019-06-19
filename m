Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1215E4C335
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbfFSVmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:42:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfFSVmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:42:38 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BB16147E78D9;
        Wed, 19 Jun 2019 14:42:35 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:42:34 -0400 (EDT)
Message-Id: <20190619.174234.2210089047219514238.davem@davemloft.net>
To:     ard.biesheuvel@linaro.org
Cc:     netdev@vger.kernel.org, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com,
        ycheng@google.com
Subject: Re: [PATCH net-next v2 1/1] net: fastopen: robustness and
 endianness fixes for SipHash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619065510.23514-2-ard.biesheuvel@linaro.org>
References: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
        <20190619065510.23514-2-ard.biesheuvel@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:42:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Jun 2019 08:55:10 +0200

> +	ctx->key[0] = (siphash_key_t){
> +		get_unaligned_le64(primary_key),
> +		get_unaligned_le64(primary_key + 8)
> +	};

Please just use normal assignment(s), because not only does this warn
it looks not so nice.

Thanks.
