Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7057A35A6E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfFEK3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 06:29:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:35820 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFEK3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 06:29:15 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYTAP-0005Js-2B; Wed, 05 Jun 2019 12:29:13 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYTAO-000L8e-TK; Wed, 05 Jun 2019 12:29:12 +0200
Subject: Re: [PATCH bpf] selftests/bpf: move test_lirc_mode2_user to
 TEST_GEN_PROGS_EXTENDED
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Sean Young <sean@mess.org>, Yonghong Song <yhs@fb.com>
References: <20190604023505.27390-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <04229133-6bd1-2f80-fc1b-8a3e70cd523c@iogearbox.net>
Date:   Wed, 5 Jun 2019 12:29:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190604023505.27390-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25471/Wed Jun  5 10:12:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2019 04:35 AM, Hangbin Liu wrote:
> test_lirc_mode2_user is included in test_lirc_mode2.sh test and should
> not be run directly.
> 
> Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thanks!
