Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EB63BC1A7
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhGEQa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhGEQa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:30:58 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0337BC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 09:28:21 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f20so9166659pfa.1
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 09:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cz/8Rwb0YDjumzk+++rWbErrZHulbAh9qJTVNCYlMkQ=;
        b=o0B4D+LxnCgiRUPoL3j20V5oU71JdbgZdRb7rdL0XmiPYaCuZNr82bWsdXpMpQo7tS
         RpthWcjR4SuBVd1S5mSlZZFC2gXukoGkDInq4UtI46a6eqZJDStq30z5xaCqYqV51Yu/
         7beUrP2QCigjAUcJYJaYKVwaeuwpHpBZQGL/BapgVZ6H9Im6b1k4zaSDHkjXplzrBMPT
         6ASJQObWEWR8OjbVgKlssXcbk0kVLyeYIcFzW17eKStBEsiQxrvd/CpkUJOa+ZOW3blq
         /SuluDSQzRjf9UOWRIW7xpTe8Vpal3Xtwz6FtuyKVN3dI8IhK55gzv4fcEVREndIxovM
         Mw/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cz/8Rwb0YDjumzk+++rWbErrZHulbAh9qJTVNCYlMkQ=;
        b=KdCyFr/S+7SnZHxkYB3iI1ZDKra5eS7lvyft3+5kEvhscIlgb71LwtgQLkNF95w7Al
         NUUcoarG2+sohgU5bWRjBTf6RPKlQFKWXnR4sy9JftXJ72joQ7jKQ1OrjgSwBKpBk9H6
         7o0djSIfSubbD4Fi7oeORk9/08QKlDsX6XafxW+3220YqQL2jMy0Yx79WSuyRJOcA1RA
         TXdHNcr9uYT7LGvgAlyOm776J0SMZOBpN9vKYS74pnVv+VJ+PErXOl1n9rabNTy8uTfa
         CEyGVHKfv0Q1v06nY2r3BHSyx18JmpRZePOvFDf0UcDtj9gf73tDftFukn8PO8ukr3V2
         mPDA==
X-Gm-Message-State: AOAM533Fdd5vUMkP1lwagbcJ/Zrhudk0DZ95t4PqF871q1xc3exPgpXY
        DO5CDuIL4xkphW/wKcLwl6TD8Q==
X-Google-Smtp-Source: ABdhPJwyL9hSBeiQdV4Td88zez9plfnwsO1JhLSOvL0858Lp0FpT9L7cTaxTCIZ971OtyTyM8Fxyew==
X-Received: by 2002:a63:5802:: with SMTP id m2mr2317504pgb.171.1625502500523;
        Mon, 05 Jul 2021 09:28:20 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g204sm13442294pfb.206.2021.07.05.09.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:28:20 -0700 (PDT)
Date:   Mon, 5 Jul 2021 09:28:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json
 output
Message-ID: <20210705092817.45e225d5@hermes.local>
In-Reply-To: <20210607064408.1668142-1-roid@nvidia.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Jun 2021 09:44:08 +0300
Roi Dayan <roid@nvidia.com> wrote:

> -	fprintf(f, " police 0x%x ", p->index);
> +	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);

Why did output format have to change here? Why not:

	print_hex(PRINT_ANY, "police", " police %#x", p->index);
