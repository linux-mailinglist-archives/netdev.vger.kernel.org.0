Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF93669EE5
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbfGOWTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:19:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:34030 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730917AbfGOWTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:19:32 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9Jj-0001qs-07; Tue, 16 Jul 2019 00:19:31 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9Ji-000J52-F2; Tue, 16 Jul 2019 00:19:30 +0200
Subject: Re: [PATCH bpf] selftests/bpf: make directory prerequisites
 order-only
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com
References: <20190712135631.91398-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a3823fec-3816-9c38-bb2d-a8391766e64d@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:19:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712135631.91398-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/19 3:56 PM, Ilya Leoshkevich wrote:
> When directories are used as prerequisites in Makefiles, they can cause
> a lot of unnecessary rebuilds, because a directory is considered changed
> whenever a file in this directory is added, removed or modified.
> 
> If the only thing a target is interested in is the existence of the
> directory it depends on, which is the case for selftests/bpf, this
> directory should be specified as an order-only prerequisite: it would
> still be created in case it does not exist, but it would not trigger a
> rebuild of a target in case it's considered changed.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, thanks!
