Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0333963D1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbfHTPLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:11:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:41486 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfHTPLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:11:05 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05ml-0000Y0-7n; Tue, 20 Aug 2019 17:10:59 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05mk-000Oiy-MT; Tue, 20 Aug 2019 17:10:58 +0200
Subject: Re: [PATCH] bpfilter/verifier: add include guard to tnum.h
To:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20190819161035.21826-1-yamada.masahiro@socionext.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bff6d096-4940-0bcc-eb85-67711ec6709a@iogearbox.net>
Date:   Tue, 20 Aug 2019 17:10:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190819161035.21826-1-yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25547/Tue Aug 20 10:27:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/19 6:10 PM, Masahiro Yamada wrote:
> Add a header include guard just in case.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Applied, thanks!
