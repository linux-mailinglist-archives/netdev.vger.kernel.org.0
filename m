Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64AF9F64F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 00:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfH0WoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 18:44:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:34160 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfH0WoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 18:44:20 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2kCI-0004QR-PN; Wed, 28 Aug 2019 00:44:19 +0200
Received: from [178.197.249.36] (helo=pc-63.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2kCI-0003Um-Fq; Wed, 28 Aug 2019 00:44:18 +0200
Subject: Re: [PATCH bpf-next v3 0/4] selftests/bpf: test_progs: misc fixes
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        Andrii Nakryiko <andriin@fb.com>
References: <20190821234427.179886-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ca1f356a-469b-3eec-c0db-3f1cc3e07892@iogearbox.net>
Date:   Wed, 28 Aug 2019 00:44:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190821234427.179886-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25554/Tue Aug 27 10:24:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 1:44 AM, Stanislav Fomichev wrote:
> * add test__skip to indicate skipped tests
> * remove global success/error counts (use environment)
> * remove asserts from the tests
> * remove unused ret from send_signal test
> 
> v3:
> * QCHECK -> CHECK_FAIL (Daniel Borkmann)
> 
> v2:
> * drop patch that changes output to keep consistent with test_verifier
>    (Alexei Starovoitov)
> * QCHECK instead of test__fail (Andrii Nakryiko)
> * test__skip count number of subtests (Andrii Nakryiko)
> 
> Cc: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
