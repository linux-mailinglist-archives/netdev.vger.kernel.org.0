Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDF14E98F9
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243649AbiC1OJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239195AbiC1OJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:09:55 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28885659C;
        Mon, 28 Mar 2022 07:08:12 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648476489; bh=3slHuWOIxQPe7cqdIZMwzJgolq9vj6Tqq63CCgaaj1Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=d1H/N1+JFiEykMRhAkKKG3y/J2+Pap/QuDwM+zv2kfUSf6dF3t/oDyoSamUVFPRy3
         lwvSVj1dez2UNWzI8pZ8eash/5tMLkKvgN6VatAdsX8cHtIcAWKmXAj1hlPOg3RKu5
         uXj5x/E6WK+oMB+5CRmT42nAXVcyVXnCsGbiEr5FJyAGhliOlNPG7ABqbvh3aQ5xIS
         bXH3DAA2cN7SfYvyAi6qKsNcepy6i5ZqMPfXE0xeHA1p1IlaTjTwAbFaa+6EJTbnBI
         XQmcqwpaxY3+I4UJtmrG1ws0ugQAA+kIZRi1F6DeKJW6dE9DCmHZyXmAWUeMeIoBAK
         mAhcc3I36SLJw==
To:     Kalle Valo <kvalo@kernel.org>, trix@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: initialize arrays at compile time
In-Reply-To: <877d8eyz61.fsf@kernel.org>
References: <20220328130727.3090827-1-trix@redhat.com>
 <877d8eyz61.fsf@kernel.org>
Date:   Mon, 28 Mar 2022 16:08:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87lewu5fw7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Hi,
>
> The content type on this email was weird:
>
> Content-Type: application/octet-stream; x-default=true

Hmm, I get:

Content-Type: text/plain; charset="US-ASCII"; x-default=true

Patchwork seems to have parsed the content just fine, but it shows *no*
content-type, so maybe the issue is that the header is missing but
different systems repair that differently?

-Toke
