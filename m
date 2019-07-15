Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B9C69EFE
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfGOWhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:37:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:36690 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730473AbfGOWhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:37:20 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9Kv-0001ua-Cf; Tue, 16 Jul 2019 00:20:45 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9Kv-000Rkk-03; Tue, 16 Jul 2019 00:20:45 +0200
Subject: Re: [PATCH bpf] samples/bpf: build with -D__TARGET_ARCH_$(SRCARCH)
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com
References: <20190715091103.4030-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c48817a7-bc2b-ddaa-c16a-a3a364e8a9d9@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:20:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715091103.4030-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/19 11:11 AM, Ilya Leoshkevich wrote:
> While $ARCH can be relatively flexible (see Makefile and
> tools/scripts/Makefile.arch), $SRCARCH always corresponds to a directory
> name under arch/.
> 
> Therefore, build samples with -D__TARGET_ARCH_$(SRCARCH), since that
> matches the expectations of bpf_helpers.h.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>

Applied, thanks!
