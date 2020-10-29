Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916F129F5FF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgJ2URZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgJ2URX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 16:17:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AADAC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 13:17:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x13so3287322pfa.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 13:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2a3Kjr1yfgw2OjddxFMr5WYvUh+vrIY5aScCBEB5zcQ=;
        b=VeupTnVUVwywx1DTuiAI0AoCTXCIwiFK3Kc9foMbYAVVZ266p3FP850qyPmiBktctf
         FKdMHNAUqgjozeS3+UFnNM+WBRYP336SIHYvvyIdRcdEj/LvhnnColNS3PFNFEn46yp0
         Wfzou+DIp3AkpSzFHUlVK2Q1fdAxaslFjZjxfaCuH0L7k9PBmgTv6FnDpMF+Qm51HVrN
         GmTyr7yore7NvaNsmi6M0zS9n1zV0ZrXHOaFFIfZfkB+gO0YCgvj4GjWx92b9XOrIxGa
         aRmsBQrNbohWsI89z040BB+5JyVQJdOaVyjx5d08kVwdgp8EcDkyXOBanMJGucBBDYOp
         290g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2a3Kjr1yfgw2OjddxFMr5WYvUh+vrIY5aScCBEB5zcQ=;
        b=qYouVj9vmOGdnp57notSRkyrxQkWq2LNZxRWCJvfhw1vLiKWyokEH5aAnJjw9W5MYn
         U3GrBf+n+7jS8CnfPCFGPEu8s4apmsT5PopQLZG7Ijc+De+L01NjyOEq/hOnM39SvT9i
         INmX67fEBdtibr+IwlhRlKcq/xA1eEmL+XSFzEgQJHUdzyy5RAUw/S8XZfjHPkRcCOgn
         48eo1rbjcpnpDBAWEhUbcglctJxwKc7n162i0FkQwRjbZAHLCcfcNvyqpvMIKxBb+Jsp
         DtY7sQ1hy6nobgqPR3ktoKHH3qLvbk49cPc96cJkEcpQ93zPNtvEg6m5R70kQdTa3NQz
         WRTg==
X-Gm-Message-State: AOAM533ZXbgujGtCkbFlI/cF6/8FrVQ7V0VTAUOl8Eb+AEvsXPeW12se
        Eaem/P+zb0bwcRJjwWHib0ZxR5HHEz1VUTca
X-Google-Smtp-Source: ABdhPJxO0PaNqPFl6fUVCZZaZoxs9ir/Io2diad8hthjHPLWoPAfTkKPRfHTsfKoH+CXsleQ06+74g==
X-Received: by 2002:a05:6a00:2307:b029:164:d5da:c82c with SMTP id h7-20020a056a002307b0290164d5dac82cmr2714583pfh.5.1604002642807;
        Thu, 29 Oct 2020 13:17:22 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h2sm681988pjv.15.2020.10.29.13.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 13:17:22 -0700 (PDT)
Date:   Thu, 29 Oct 2020 13:17:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Puneet Sharma <pusharma@akamai.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: add print options to fix json output
Message-ID: <20201029131718.39b87b03@hermes.local>
In-Reply-To: <20201028183554.18078-1-pusharma@akamai.com>
References: <20201028183554.18078-1-pusharma@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 14:35:54 -0400
Puneet Sharma <pusharma@akamai.com> wrote:

> Currently, json for basic rules output does not produce correct json
> syntax. The following fixes were done to correct it for extended
> matches for use with "basic" filters.
> 
> tc/f_basic.c: replace fprintf with print_uint to support json output.
> fixing this prints "handle" tag correctly in json output.
> 
> tc/m_ematch.c: replace various fprintf with correct print.
> add new "ematch" tag for json output which represents
> "tc filter add ... basic match '()'" string. Added print_raw_string
> to print raw string instead of key value for json.
> 
> lib/json_writer.c: add jsonw_raw_string to print raw text in json.
> 
> lib/json_print.c: add print_color_raw_string to print string
> depending on context.
> 
> example:
> $ tc -s -d -j filter show dev <eth_name> ingress
> Before:
> ...
> "options": {handle 0x2
>   (
>     cmp(u8 at 9 layer 1 eq 6)
>     OR cmp(u8 at 9 layer 1 eq 17)
>   ) AND ipset(test-ipv4 src)
> 
>             "actions": [{
> ...
> 
> After:
> [{
> ...
> "options": {
>     "handle": 1,
>     "ematch": "(cmp(u8 at 9 layer 1 eq 6)OR cmp(u8 at 9 layer 1 eq 17)) AND ipset(test-ipv4 src)",
> ...
> ]
> 
> Signed-off-by: Puneet Sharma <pusharma@akamai.com>
> ---

What is the point of introducing raw string?
The JSON standard says that string fields must use proper escapes.

Please  don't emit invalid JSON. It will break consumption by other libraries.
