Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0DFCBDC8
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbfJDOrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:47:19 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34564 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388870AbfJDOrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:47:19 -0400
Received: by mail-io1-f66.google.com with SMTP id q1so14170492ion.1;
        Fri, 04 Oct 2019 07:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tEuKXeJozCB5XdqG/5wokzjQB+A76H6zYaN7XHSNPps=;
        b=Bj4gG/GDy5LQfSN1wSliRg7+cAgFeHbqrkkQm2tIDpTG/remxqlzjxwC3jgAkd1bNJ
         StV4yv1gl7Ne+oWEZ3Q+nHZ+GMpiIHtim0MvAh7fdhea28DV0QrSVeJG7bzK9KW9UuJt
         MKJEVm2gTEhBOo8LXIgGGTL22M/okZLLM/HeM9ttu+Nsv/BRdF2bAmC2+hsTpuoruBMv
         WHVk7R9wdGHDaUZCqXcHe3trSipE3KH78HO3/FAnsrzAbIQCsCcuczZ4GflBgIiPxLjx
         GeTb2Hh7ZD6bfPxmxBigZh2i/SHRWPLgeVnHkCqquE9PAZcv6bb94nbEUPb/UvAxZno8
         Lttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tEuKXeJozCB5XdqG/5wokzjQB+A76H6zYaN7XHSNPps=;
        b=ETt745M6sjnBqwwX/2EfiiOcZBxyUOUBtm4R2ZnYGf6D7+3Hr4ngPI/VBDWNI6qWbU
         4k/CcK+OXcu6uf/ng83ngdyVv2ukUMiE+pA8mEcDep16KKoOnvXb3bnSTQiYamUz/sOx
         x8VljwD9Z1e0C8dzOeQkPJdFHpuXCxoQaDgQWwllMHy99lHR9Y6ys+Oytm2rfh0oO3e3
         x4JhgWnWFOf13BNFsOZ6i1K8EnDEVKVmi5KfGmMXxTjFgQit/A02l1ycQA7HS7DSmydl
         nbvLlwWtZHcYkIEJ6jsigGNzD2PcSADm9IcUo3eTMb3Blp4xSdYWcFbEkZfgw9iDmy+8
         kC7w==
X-Gm-Message-State: APjAAAUrFz6oQ4+lRm5a7JYv6SonJGMLewahZi07r3wddRx3n0C9rYkU
        9T2tAFIHs5+QPBN5/EoUsds=
X-Google-Smtp-Source: APXvYqz+VJhBLvgJhoUw3EsQa5REjBvuUpICuHrJRdPYpsbt+OJ0gsxSWu0ZGOxlBkly/oQNcazYAw==
X-Received: by 2002:a92:d847:: with SMTP id h7mr16035211ilq.85.1570200438614;
        Fri, 04 Oct 2019 07:47:18 -0700 (PDT)
Received: from [172.16.99.106] (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id a24sm2122030iok.37.2019.10.04.07.47.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 07:47:17 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191003212856.1222735-1-andriin@fb.com>
 <20191003212856.1222735-6-andriin@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
Date:   Fri, 4 Oct 2019 08:47:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191003212856.1222735-6-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/19 3:28 PM, Andrii Nakryiko wrote:
> Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Ensure
> they are installed along the other libbpf headers. Also, adjust
> selftests and samples include path to include libbpf now.

There are side effects to bringing bpf_helpers.h into libbpf if this
gets propagated to the github sync.

bpf_helpers.h references BPF_FUNC_* which are defined in the
uapi/linux/bpf.h header. That is a kernel version dependent api file
which means attempts to use newer libbpf with older kernel headers is
going to throw errors when compiling bpf programs -- bpf_helpers.h will
contain undefined BPF_FUNC references.
