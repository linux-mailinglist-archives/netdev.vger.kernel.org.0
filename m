Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8CC1962B6
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgC1Av2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:51:28 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34231 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgC1Av1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:51:27 -0400
Received: by mail-pl1-f194.google.com with SMTP id a23so4135031plm.1
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 17:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S0+Z+nPLzS4QBozq3nSxwf/1jD/gboqKe2RTzXjmd1k=;
        b=OfzSxNQAu5TbP7ujMt7aZbRY1vPQI+Q94paDkJ5EiP1IL5aWAl4vIzGI8SoNRVdDPW
         1SG27assGgfNMHwe5i4uuxUTEoPlSPPRN/ugHMjo30Fjd5NvRByB/QN2vsIIwaUMMCXk
         X6pF6U+nqSTupv1LcbBSBGCPGKwEagcZN+bblMP0jf61FQDnXjS8kERAy+mNOgOQZquf
         IoYBg8M+hASAonHOpJIqTNQcHYZkfIkgr/2vB5MZ1mlChKNRXTcg3hqmGYQxGuy4ZiyO
         Az+wDXOa03ljSQ/cmVKmBizHwwVSt3cKetvmuG2H1ABvwi78h6xXui9nRgV0dsIksBqt
         Mn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0+Z+nPLzS4QBozq3nSxwf/1jD/gboqKe2RTzXjmd1k=;
        b=TxobKEcoZcSwz76O+1jcTavlR02wqITvZrrEZKJggdHFle5yJ9RUg8bHK6wqS4xSqL
         uluxnW7bhZeUNEJrBe0f4PlY766CEDX8FS7ygiVxo+EF4UJn+/Tf937KeXNsby6EZ7b9
         1tpeuQ0siQyM25utt9UhHuoZ9ch57apDBoxvzy6550YT7aOtObEK2/1ROP+54/AXqRa0
         mIawmfyL90N9JoL895qfeQjFmd0qmYB5ofyRorZn5u1FsorXis4k3Fn5QW1SpDFO1bSS
         yPGVpSgSPZwNI5VgmK2sKtJq0KyZjnlitruNjXBSqARiLqvX+78grYJIglPsH1e6ZAMi
         szlQ==
X-Gm-Message-State: ANhLgQ3JLT82s0DNIDXoj2lXRe05B/GBGLptkv+Cmums4Dxyy9BFosMY
        q0sTgO8Y7o6zQD8J9mpy/3br4QQ1zu9ubA==
X-Google-Smtp-Source: ADFU+vtBy59vI+lIaEHusHzacPBAMUXSGrt0YAGpX5gBuEvgATiLVX7jFXkR3/WG6vEKDb8T6wCmtw==
X-Received: by 2002:a17:90a:2541:: with SMTP id j59mr2215633pje.128.1585356686661;
        Fri, 27 Mar 2020 17:51:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e187sm5049070pfe.50.2020.03.27.17.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 17:51:26 -0700 (PDT)
Date:   Fri, 27 Mar 2020 17:51:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 1/3] tc: p_ip6: Support pedit of IPv6
 dsfield
Message-ID: <20200327175123.1930e099@hermes.lan>
In-Reply-To: <628ade92d458e62f9471911d3cf8f3b193212eaa.1585331173.git.petrm@mellanox.com>
References: <cover.1585331173.git.petrm@mellanox.com>
        <628ade92d458e62f9471911d3cf8f3b193212eaa.1585331173.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 20:55:08 +0300
Petr Machata <petrm@mellanox.com> wrote:

> Support keywords dsfield, traffic_class and tos in the IPv6 context.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
>  man/man8/tc-pedit.8 | 14 ++++++++++++--
>  tc/p_ip6.c          | 16 ++++++++++++++++
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
> index bbd725c4..b44b0263 100644
> --- a/man/man8/tc-pedit.8
> +++ b/man/man8/tc-pedit.8
> @@ -60,8 +60,8 @@ pedit - generic packet editor action
>  
>  .ti -8
>  .IR IP6HDR_FIELD " := { "
> -.BR src " | " dst " | " flow_lbl " | " payload_len " | " nexthdr " |"
> -.BR hoplimit " }"
> +.BR src " | " dst " | " tos " | " dsfield " | " traffic_class " | "
> +.BR flow_lbl " | " payload_len " | " nexthdr " |" hoplimit " }"
>  
>  .ti -8
>  .IR TCPHDR_FIELD " := { "
> @@ -228,6 +228,16 @@ are:
>  .B src
>  .TQ
>  .B dst
> +.TP
> +.B tos
> +.TQ
> +.B dsfield
> +.TQ
> +.B traffic_class
> +Traffic Class, an 8-bit quantity. Because the field is shifted by 4 bits,
> +it is necessary to specify the full 16-bit halfword, with the actual
> +dsfield value sandwiched between 4-bit zeroes.
> +.TP
>  .TQ
>  .B flow_lbl
>  .TQ
> diff --git a/tc/p_ip6.c b/tc/p_ip6.c
> index 7cc7997b..b6fe81f5 100644
> --- a/tc/p_ip6.c
> +++ b/tc/p_ip6.c
> @@ -56,6 +56,22 @@ parse_ip6(int *argc_p, char ***argv_p,
>  		res = parse_cmd(&argc, &argv, 4, TU32, 0x0007ffff, sel, tkey);
>  		goto done;
>  	}
> +	if (strcmp(*argv, "traffic_class") == 0 ||
> +	    strcmp(*argv, "tos") == 0 ||
> +	    strcmp(*argv, "dsfield") == 0) {
> +		NEXT_ARG();
> +		tkey->off = 1;
> +		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
> +
> +		/* Shift the field by 4 bits on success. */
> +		if (!res) {
> +			int nkeys = sel->sel.nkeys;
> +			struct tc_pedit_key *key = &sel->sel.keys[nkeys - 1];
> +			key->mask = htonl(ntohl(key->mask) << 4 | 0xf);
> +			key->val = htonl(ntohl(key->val) << 4);
> +		}
> +		goto done;
> +	}
Why in the middle of the list? Why three aliases for the same value?
Since this is new code choose one and make it match what IPv6 standard
calls that field.
