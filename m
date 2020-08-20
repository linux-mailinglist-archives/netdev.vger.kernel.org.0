Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1258F24C136
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgHTPHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgHTPHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 11:07:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A27E4208DB;
        Thu, 20 Aug 2020 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597936023;
        bh=kNv6JOlgnYCum+27sqnM29G38BI5HiMMzbpbfVSzIu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1mmwC42JetQBMjd8bBYNSW6Li8pDP52j9KWzOjrXlVsTtLrmIfFQ7kTdYmqmVire0
         hzvEuINZk/QmcQ7CedIr4Rg1W0FxI2ldbWYvouwhAicfTX3FYdd1CbZB8MJtWhTQwM
         07VYa2YFDj+m9hR7FkTMNHzatQmHQuHDUNYV6BWs=
Date:   Thu, 20 Aug 2020 08:07:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: implement link_query for bpf
 iterators
Message-ID: <20200820080701.09f23759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200820001323.3740936-1-yhs@fb.com>
References: <20200820001323.3740798-1-yhs@fb.com>
        <20200820001323.3740936-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 17:13:23 -0700 Yonghong Song wrote:
> +	fill_link_info = iter_link->tinfo->reg_info->fill_link_info;
> +	if (fill_link_info)
> +		return fill_link_info(&iter_link->aux, info);
> +
> +        return 0;

ERROR: code indent should use tabs where possible
#138: FILE: kernel/bpf/bpf_iter.c:433:
+        return 0;$

WARNING: please, no spaces at the start of a line
#138: FILE: kernel/bpf/bpf_iter.c:433:
+        return 0;$
