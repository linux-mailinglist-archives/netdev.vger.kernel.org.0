Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998A81BB71A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgD1G6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:58:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52106 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbgD1G6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 02:58:48 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B775DF1D1502DF519A93;
        Tue, 28 Apr 2020 14:58:45 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.92) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 28 Apr 2020
 14:58:44 +0800
Subject: Re: [PATCH bpf-next v3 1/2] bpf: Change error code when ops is NULL
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <andrii.nakryiko@gmail.com>,
        <dan.carpenter@oracle.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20200426063635.130680-1-maowenan@huawei.com>
 <20200426063635.130680-2-maowenan@huawei.com>
 <6f975e8c-34f5-4bcb-d99d-d1977866bedf@iogearbox.net>
From:   maowenan <maowenan@huawei.com>
Message-ID: <0e8261b9-5519-fca3-afb2-e92ef98e8ea4@huawei.com>
Date:   Tue, 28 Apr 2020 14:58:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6f975e8c-34f5-4bcb-d99d-d1977866bedf@iogearbox.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.92]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/28 5:37, Daniel Borkmann wrote:
> bpftool feature probe kernel | grep sockmap
ok, thanks.

