Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8B76704D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfGLNm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:42:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:56794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfGLNm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:42:26 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvoe-0000w6-R2; Fri, 12 Jul 2019 15:42:25 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvoe-0001T1-KU; Fri, 12 Jul 2019 15:42:24 +0200
Subject: Re: [PATCH v3 bpf] selftests/bpf: do not ignore clang failures
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii.nakryiko@gmail.com, liu.song.a23@gmail.com
References: <20190711091249.59865-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6c029e6b-7b3c-4007-8f65-db6798a5a3cb@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:42:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190711091249.59865-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/11/2019 11:12 AM, Ilya Leoshkevich wrote:
> When compiling an eBPF prog fails, make still returns 0, because
> failing clang command's output is piped to llc and therefore its
> exit status is ignored.
> 
> When clang fails, pipe the string "clang failed" to llc. This will make
> llc fail with an informative error message. This solution was chosen
> over using pipefail, having separate targets or getting rid of llc
> invocation due to its simplicity.
> 
> In addition, pull Kbuild.include in order to get .DELETE_ON_ERROR target,
> which would cause partial .o files to be removed.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, thanks!
