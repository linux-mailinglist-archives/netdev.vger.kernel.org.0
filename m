Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3FA11BA2D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbfLKRYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:24:15 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46856 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbfLKRYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:24:13 -0500
Received: by mail-qk1-f193.google.com with SMTP id r14so12172845qke.13
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dBM8oys5TvbCl11ighmxMg0gFS0SzAz1pc/mcxYKGHE=;
        b=PsDjP7s8DXRCMoH958ycPNnlvr4sLM+iR3HQK/n5lh/oW+nItJQ9+tidMY6ROrz4LZ
         OL7ZdrekxXMSa99IxXKewLePl7fobN45t43Pi5nyyHoI/94JEvQoxpFrEOOwJ++ZUd3D
         JVXurffhg0RKeGBWtPyUFhFMK/OkBpHtFyozYgKVoSmAHwbtZ2JEBUTgJ9kfoC+bpVJy
         cAUjMMbTqy/9K6Bs9Tl08UKJRObZtp07YXTs7Xeruz4MpB2DIzU+LY68AoMUoPdhise6
         L9hClbfwAzPt6HySI3y+LNbaeupYdGW2JpfSt2hBH0PiT8yO7O2HRmtE8Rf1NGT+3tIZ
         bqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dBM8oys5TvbCl11ighmxMg0gFS0SzAz1pc/mcxYKGHE=;
        b=kmxHziWkdChsIGxdByeeLr056latEI09NF4//Jtsw8W268GbEhQw+tBGJyLPTzlxm1
         Np35UMY+YDAxJKvjQajhAk23aAwo5evjDe/25g1M5Fm99cIu0wMz/dSVXlFpAh7f5/uy
         5NBM34xM7c9kQxu/qNXmQteT41xo0Gaqw4YKtxTYN9wYSXwkBwaX+ryYZIyN6KCMyC1q
         2xUNYxzQrb+BKpLh1te262DjowWZGgQS26kB3xDAhTpHkPa26n1w5aSxHqgN+W4qS1EB
         pz6U7cVpkcrxCFpm0/0U8NfFtoCMKVyXmc9UnokErDNMrg0pT6m0wIsW1XtW2cqwbuRQ
         cGmg==
X-Gm-Message-State: APjAAAWTKAqmvb1dhlMMiqv7M7c+yy3evi/3ralQEo1toR3Qkvkc4Ox/
        YSJDDW2PW03oNX8PlmEJjzSLR1OGdL4=
X-Google-Smtp-Source: APXvYqwWKughra1re8lS3sna9ljP0DczoT+zvscvvEyPs/6gpFFrEM9zzx0sszeTEVmG0pOMiIFfyw==
X-Received: by 2002:a37:658f:: with SMTP id z137mr4197731qkb.234.1576085052486;
        Wed, 11 Dec 2019 09:24:12 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id n190sm858848qke.90.2019.12.11.09.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:24:11 -0800 (PST)
Subject: Re: [PATCH v2 iproute2-next] tc: do not output newline in oneline
 mode
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20191204233726.3152-1-stephen@networkplumber.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5cc23f63-dd58-5eb1-9471-438ec19d14f2@gmail.com>
Date:   Wed, 11 Dec 2019 10:24:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191204233726.3152-1-stephen@networkplumber.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/19 4:37 PM, Stephen Hemminger wrote:
> In oneline mode the line seperator should be \
> but several parts of tc aren't doing it right.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
> v2 - found more places that need changing
> 
>  tc/f_flower.c     | 66 +++++++++++++++++++++++++++++++----------------
>  tc/m_csum.c       |  4 +--
>  tc/m_ct.c         |  5 ++--
>  tc/m_gact.c       |  8 +++---
>  tc/m_mirred.c     |  5 ++--
>  tc/m_mpls.c       |  3 ++-
>  tc/m_pedit.c      |  2 +-
>  tc/m_simple.c     |  2 +-
>  tc/m_tunnel_key.c |  3 ++-
>  tc/m_vlan.c       |  5 ++--
>  tc/m_xt.c         |  2 +-
>  tc/q_cake.c       |  4 +--
>  tc/q_fq_codel.c   |  3 ++-
>  tc/tc_filter.c    |  4 +--
>  tc/tc_qdisc.c     |  8 +++---
>  tc/tc_util.c      |  2 +-
>  16 files changed, 78 insertions(+), 48 deletions(-)
> 

applied to iproute2-next. Thanks


