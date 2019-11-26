Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9204010A6C8
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfKZWru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:47:50 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39775 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKZWrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:47:49 -0500
Received: by mail-pl1-f194.google.com with SMTP id o9so8814899plk.6
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 14:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8VYg+Moa5/S7aXoSBMb5a8ScpDGfedx2ND3qqxTeHcQ=;
        b=QXcvzrw5rMnyWkZ9LtkhFHoXBa4pJ4grUpzrExbq7RE0X7gw2Xdm3aoNO93TnBw1OR
         h+j0Yf3RjZ9xfRKiZIGImkUCSoLLz5CRjE3yspjszIqTPnBmWSdlsGaGEY7nXIr8RKTx
         Mj0M3O3QMpcdEVMw+GWYKT6oZ+2ZccVaoRoCq5Sh/arCCy5Ndf9u0N5USwzP/06Jw+dd
         QKNMblCFEKBAlOEZi3SukaJBTvOsiI7MT8vln644774c1FHkNc1VDtNSZgKw7Cz7wDiR
         BTVCdmJ4caVenUJVLduLwJybOkirBH2744u4phq2MvqrajSK1j0YlrbY8aWcP/mcKFQ+
         99Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8VYg+Moa5/S7aXoSBMb5a8ScpDGfedx2ND3qqxTeHcQ=;
        b=OQCyow2Wmy/LA3Xyo3cwXc4hraomboRB+kJ2ODLh3U+JIsE1xMnGOLygi/WaprYNuE
         LOLFQTAwtpHnMSqLkA8lywCT8YaCZyNZMhEgevXEuR1OUOsxYCsjJxc8t9YXmbIlA5sv
         w8oTTXNhWvw7R/XmWmlaSpVPfbZ+4wSPkY21Llsf7j7Z49ty/F5fNcrFdVmsYJ4pB56P
         KgPbMazl5HDZMIfej0+zqXnGJylNwi5r9o9zJvi3o0/k1jt6dv0GzuKWE+luOZId4SLJ
         qM7RTARLJWK/868XSBNUbjgVijDeOpUeqNdTQ+mm8W08rMVAG/v6ABTB/cLijsEQGh7A
         PjIw==
X-Gm-Message-State: APjAAAWLtgGFpoj1ip2pTiDIqsIJWXVc0Fi4Q4kjipdmNO3qiE/OD9ED
        TUtc8mLoMUbjQDOqUpFxEPTsaA==
X-Google-Smtp-Source: APXvYqypxxhXXe6Zk41fVUyMQ2BhbQEqI/D6QEvsRv/hEu5RP4Mk5aWzrJeagSJhbZNw5ZX3mkyt5g==
X-Received: by 2002:a17:902:b487:: with SMTP id y7mr721308plr.274.1574808468882;
        Tue, 26 Nov 2019 14:47:48 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id u9sm13728875pfm.102.2019.11.26.14.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 14:47:48 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:47:47 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH bpf] bpf: support pre-2.25-binutils objcopy for vmlinux
 BTF
Message-ID: <20191126224747.GD3145429@mini-arch.hsd1.ca.comcast.net>
References: <20191126174221.200522-1-sdf@google.com>
 <5ddda9354c976_9832aef3a62e5b8ab@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ddda9354c976_9832aef3a62e5b8ab@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26, John Fastabend wrote:
> Stanislav Fomichev wrote:
> > If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
> > .BTF section of vmlinux is empty and kernel will prohibit
> > BPF loading and return "in-kernel BTF is malformed".
> > 
> > --dump-section argument to binutils' objcopy was added in version 2.25.
> > When using pre-2.25 binutils, BTF generation silently fails. Convert
> > to --only-section which is present on pre-2.25 binutils.
> 
> hmm I think we should fail hard if a feature explicitly asked for
> in the .config is not able to be built due to tooling. Otherwise
> users may later try to use a feature that can only be supported by
> BTF and that will have to fail at runtime. The runtime failure
> seems more likely to surprise users compared to the inconvience
> of having a compile time error. I view this similar to how having
> old ssl libs fails the build with the various signing options are
> set.
I agree. This is what actually happened to me. At some point
all my selftests started to fail.

> Can we print a useful help message instead so users can disable
> CONFIG_DEBUG_INFO_BTF or update binutils?
I'm not sure objcopy returns with error if it fails to execute the command.
I guess we can query the size of .BTF section in vmlinux and print
an error if it's empty.

Another thing we can do is to add a special 'data_size == 0' to
btf_parse_vmlinux. That way, at least, kernel can fall-back to
pre-BTF world instead of assuming that BTF is malformed (it's not
malformed, it's just not there). But that's, again, a surprise
at runtime. Checking at build time seems like a better option.
