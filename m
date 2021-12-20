Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0965747B395
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbhLTTRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbhLTTRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 14:17:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9A8C061574;
        Mon, 20 Dec 2021 11:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v1BnDOOjmi6Wl4p4zOIVQT2pxsBdwziqXbHevL0KGX8=; b=hEThgjc0kNSzpiN47isLsjGIDj
        iTeqGsq+NNhocjTVtBQU7zgGy9iWH3K5t07WzAJvwN6PClQIYsgmYxJewAfKVnjogqDLSO3UP/nJi
        2uio8hzTbwgJDT/FoqiEDljqx57MfRLQAlqCOb7sJ4rdxYBe5zeGR3LhbNTNIoCXI7O9Pgi7rb0Tx
        UMY2EaOZsJuB+KCHw0HrXSV2CLuAH7CacnJRmiPNZ8UJMjIOYg+kEvi/1BCVVQJdbJQ412JegS854
        TNercXeDTQiSKzE3tKbIQP2n7CoTsotRcE/YwIdVGhtX0yh9OBCI7GXD5X41vx7VuxC4tEDpt7q26
        benBq5/A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzOA3-0042pi-Ky; Mon, 20 Dec 2021 19:17:27 +0000
Date:   Mon, 20 Dec 2021 11:17:27 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     akpm@linux-foundation.org, keescook@chromium.org,
        yzaikin@google.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, yukuai3@huawei.com,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next V2] sysctl: returns -EINVAL when a negative value
 is passed to proc_doulongvec_minmax
Message-ID: <YcDWx1P1NdqgED1i@bombadil.infradead.org>
References: <20211220092627.3744624-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220092627.3744624-1-libaokun1@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 05:26:27PM +0800, Baokun Li wrote:
> When we pass a negative value to the proc_doulongvec_minmax() function,
> the function returns 0, but the corresponding interface value does not
> change.
> 
> we can easily reproduce this problem with the following commands:
>     `cd /proc/sys/fs/epoll`
>     `echo -1 > max_user_watches; echo $?; cat max_user_watches`
> 
> This function requires a non-negative number to be passed in, so when
> a negative number is passed in, -EINVAL is returned.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

 Luis
