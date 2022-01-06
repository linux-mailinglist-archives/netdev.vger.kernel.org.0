Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBAB486D3A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245048AbiAFWaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiAFWaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 17:30:16 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506A8C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 14:30:16 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id y9so3791555pgr.11
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 14:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U9C1nv+1jIWVx7r/rlR/FqACZNmS8tkcb2cjoKtuPdk=;
        b=WYNgQaTLjNiuwBrkx9jP8KvWr8ZaOCvhVflLbrZdj6vbPxYTKLlmLvSgoAaep4vPu7
         HsUHFnLLouRwqU6RSYrJm5v3jET2LzTHXSFHrRBV8QLZ7EsB2bN1SJevwrkyRO+oljhi
         8rnRQL7n9mFxADANEEikPgY1ULR84pRxbyyDV98TbuVs3SpJSIwBP+r38LJmsDYtI12O
         XrHjfY90g9Vj91HDQPn+rk/gzh/+iyKpRX3hrMmfkW1RjOo85kKBsBHepxJHMuCjz4gc
         h3BNngGwp7Z06LDqietgSO1sW2wIA7+iGz8gJ1/H8ND9G0nzCBYgrb/r6L1v1KTINTRY
         lx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U9C1nv+1jIWVx7r/rlR/FqACZNmS8tkcb2cjoKtuPdk=;
        b=f+aZE4/CzagBeb4ff1ITHlcsB+GtU80pV6eAJRAU0em1MoxTDTNY8KT2BOkxhzoOIi
         uTp21kv8/TuuUcIXQlkp9cBBOETLk6dm87K321CPqtteSXfOnyQ1uRMkNWMEMHb9iLzv
         1hq3FGnB3hgGEmYSrf9yt5zfTBRpajojbZLvvvmpO5qyIuy3m4Qgv07b+A9Sr4yHUHmb
         8qgYWz/msguIwuEKpNCFLYtRobT5TS8UqiQ2/sd7FGunfWUqpgkxN15As8Smsd5QvoxE
         ZjgNi2QuqvFTnq5UNd4HUhP8L4xEu/0N6axokg+vRys8JytLxRivMLIBx0ILOlsc3nCM
         nIqg==
X-Gm-Message-State: AOAM530sgcP/1dve/aXWK9rabl5/32N3ZdqZTWRe81o9crdpf0EWqbtM
        Kw4pS/LZBHHQieTG32XqD2aSGw==
X-Google-Smtp-Source: ABdhPJw4W8LRhC0kLPyBVuJqWJFwsGN26vG+5n60jJbQmRUkEGB4kFbK9j6B59GRuNTGfBMSEtjPxg==
X-Received: by 2002:a62:2f86:0:b0:4bc:fe4d:4831 with SMTP id v128-20020a622f86000000b004bcfe4d4831mr2308840pfv.23.1641508215793;
        Thu, 06 Jan 2022 14:30:15 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x33sm3984480pfh.212.2022.01.06.14.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 14:30:15 -0800 (PST)
Date:   Thu, 6 Jan 2022 14:30:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Message-ID: <20220106143013.63e5a910@hermes.local>
In-Reply-To: <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
References: <cover.1641493556.git.liangwen12year@gmail.com>
        <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jan 2022 13:45:51 -0500
Wen Liang <liangwen12year@gmail.com> wrote:

>  	} else if (sel && sel->flags & TC_U32_TERMINAL) {
> -		fprintf(f, "terminal flowid ??? ");
> +		print_bool(PRINT_ANY, "terminal_flowid", "terminal flowid ??? ", true);

This looks like another error (ie to stderr) like the earlier case

>  	if (tb[TCA_U32_LINK]) {
>  		SPRINT_BUF(b1);
> -		fprintf(f, "link %s ",
> -			sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]),
> +		print_string(PRINT_ANY, "link", "link %s ", sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]),
>  					  b1));

Break that long line up. Would look better with a temporary variable.

FYI - good test is to run the json output into python's json parser to make sure it is valid.
