Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5363CCA
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfGIUjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:39:46 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44089 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbfGIUjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:39:45 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so46055396iob.11
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 13:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oIrPcluHNYY5khd6ANSxsbcUWSjd8ul4i2URTyn+PI8=;
        b=fgKCTCTjIwEPfYzlrrKDF4A20wE47FqUFyWGbF93HayC9AKfOnc71ii/QpnYKfdWE2
         0Q66dKg3U+oiQDTqeUUjzK71o/akNIN69c9QLi1mgV7HvCPtOInbO5FHJe3mq1Kq8P6n
         /eDdw/A3rhvVsVxcTIAHMjqgcyS4nrWNK2Bqb8yMCbGyYiVgTlav1Zsd/DMDggbCuCft
         GR63Pj9iTWX6KzjhqA2prWgQyTHhBEQhd+zChoEoeLwDlKtWWo2S8GYSNkcjBrs7rwL6
         +v5w9F5RFCfiTDv/ytGhmrqpxGztdZ+yBmmiyV4hZSRBMuBM/4xQI/slEvgvwuvrEnJ7
         d12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oIrPcluHNYY5khd6ANSxsbcUWSjd8ul4i2URTyn+PI8=;
        b=MrD0y91iDUzzSrmEsM1XRsTx48rGOlcS55wlTDhGoTOU8YVZkEDE6KBFzmymCgHu8w
         otgEc9Wh5v/m0jF7YZjuIqPFfjmVv7pPz43V9yF1gbNrjcWeoQ8WyNSQqqbsHqGVfBEb
         nzUWQGUYCJUPW07JTJUCKgorr7BT/P8XxaXVu1pskK1/wzunX3BQm3PXc59wJLhPzbhC
         twAq7GcVBO/fNubSw3VSUTzM4FyLmew4o6HlU9NN+TC28BkyPnNyvUuoS+2Yd3SisePr
         VLNw+YSnWyRnKfyOXFiY+EzCZDYeizteBmbRneJMXGQWZMt53uHAA2hI1y8Ws77lhU5B
         C02g==
X-Gm-Message-State: APjAAAWb5iE8ulljN42A82S5LYlQgNlIx1MZ3ZCSNrPrQdLKigUArAmW
        /WG+Pb6JAxJFiipFpMXTPmE=
X-Google-Smtp-Source: APXvYqxkIuKfXRU18bVJaIiEX15/M7xm/NwMshKnWXklHFTx5yHsYCrzNqK/BDcAheMl1Dj3d7/oAg==
X-Received: by 2002:a02:a417:: with SMTP id c23mr8186695jal.141.1562704785085;
        Tue, 09 Jul 2019 13:39:45 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c0e1:11bc:b0c5:7f? ([2601:282:800:fd80:c0e1:11bc:b0c5:7f])
        by smtp.googlemail.com with ESMTPSA id z17sm31356209iol.73.2019.07.09.13.39.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 13:39:44 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 2/3] tc: add mpls actions
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        willemdebruijn.kernel@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
References: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
 <1562687972-23549-3-git-send-email-john.hurley@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d0b46840-9c9b-652d-c70b-d9dee538fd2a@gmail.com>
Date:   Tue, 9 Jul 2019 14:39:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1562687972-23549-3-git-send-email-john.hurley@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/9/19 9:59 AM, John Hurley wrote:
> +static void explain(void)
> +{
> +	fprintf(stderr,
> +		"Usage: mpls pop [ protocol MPLS_PROTO ]\n"
> +		"       mpls push [ protocol MPLS_PROTO ] [ label MPLS_LABEL ] [ tc MPLS_TC ] [ ttl MPLS_TTL ] [ bos MPLS_BOS ] [CONTROL]\n"

that makes for a very long line to the user. Break at the ttl option and
make a newline:

mpls push [ protocol MPLS_PROTO ] [ label MPLS_LABEL ] [ tc MPLS_TC ]
          [ ttl MPLS_TTL ] [ bos MPLS_BOS ] [CONTROL]


> +		"       mpls modify [ label MPLS_LABEL ] [ tc MPLS_TC ] [ ttl MPLS_TTL ] [CONTROL]\n"
> +		"	for pop MPLS_PROTO is next header of packet - e.g. ip or mpls_uc\n"
> +		"       for push MPLS_PROTO is one of mpls_uc or mpls_mc\n"
> +		"            with default: mpls_uc\n"
> +		"       CONTROL := reclassify | pipe | drop | continue | pass |\n"
> +		"                  goto chain <CHAIN_INDEX>\n");
> +}
> +


...

> +static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
> +{
> +	struct rtattr *tb[TCA_MPLS_MAX + 1];
> +	struct tc_mpls *parm;
> +	SPRINT_BUF(b1);
> +	__u32 val;
> +
> +	if (!arg)
> +		return -1;
> +
> +	parse_rtattr_nested(tb, TCA_MPLS_MAX, arg);
> +
> +	if (!tb[TCA_MPLS_PARMS]) {
> +		print_string(PRINT_FP, NULL, "%s", "[NULL mpls parameters]");
> +		return -1;
> +	}
> +	parm = RTA_DATA(tb[TCA_MPLS_PARMS]);
> +
> +	print_string(PRINT_ANY, "kind", "%s ", "mpls");
> +	print_string(PRINT_ANY, "mpls_action", " %s",
> +		     action_names[parm->m_action]);
> +
> +	switch (parm->m_action) {
> +	case TCA_MPLS_ACT_POP:
> +		if (tb[TCA_MPLS_PROTO]) {
> +			__u16 proto;
> +
> +			proto = rta_getattr_u16(tb[TCA_MPLS_PROTO]);
> +			print_string(PRINT_ANY, "protocol", " protocol %s",
> +				     ll_proto_n2a(proto, b1, sizeof(b1)));
> +		}
> +		break;
> +	case TCA_MPLS_ACT_PUSH:
> +		if (tb[TCA_MPLS_PROTO]) {
> +			__u16 proto;
> +
> +			proto = rta_getattr_u16(tb[TCA_MPLS_PROTO]);
> +			print_string(PRINT_ANY, "protocol", " protocol %s",
> +				     ll_proto_n2a(proto, b1, sizeof(b1)));
> +		}
> +		/* Fallthrough */
> +	case TCA_MPLS_ACT_MODIFY:
> +		if (tb[TCA_MPLS_LABEL]) {
> +			val = rta_getattr_u32(tb[TCA_MPLS_LABEL]);
> +			print_uint(PRINT_ANY, "label", " label %u", val);
> +		}
> +		if (tb[TCA_MPLS_TC]) {
> +			val = rta_getattr_u8(tb[TCA_MPLS_TC]);
> +			print_uint(PRINT_ANY, "tc", " tc %u", val);
> +		}
> +		if (tb[TCA_MPLS_BOS]) {
> +			val = rta_getattr_u8(tb[TCA_MPLS_BOS]);
> +			print_uint(PRINT_ANY, "bos", " bos %u", val);
> +		}
> +		if (tb[TCA_MPLS_TTL]) {
> +			val = rta_getattr_u8(tb[TCA_MPLS_TTL]);
> +			print_uint(PRINT_ANY, "ttl", " ttl %u", val);
> +		}
> +		break;
> +	}
> +	print_action_control(f, " ", parm->action, "");
> +
> +	print_uint(PRINT_ANY, "index", "\n\t index %u", parm->index);
> +	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
> +	print_int(PRINT_ANY, "bind", " bind %d", parm->bindcnt);
> +
> +	if (show_stats) {
> +		if (tb[TCA_MPLS_TM]) {
> +			struct tcf_t *tm = RTA_DATA(tb[TCA_MPLS_TM]);
> +
> +			print_tm(f, tm);
> +		}
> +	}
> +
> +	print_string(PRINT_FP, NULL, "%s", "\n");

s/"\n"/_SL_/ ?

