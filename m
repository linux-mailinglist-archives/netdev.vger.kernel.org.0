Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A1762CF2
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 02:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfGIAMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 20:12:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:50112 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfGIAMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 20:12:55 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkdkb-0007XH-OO; Tue, 09 Jul 2019 02:12:53 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkdkb-0001D7-BG; Tue, 09 Jul 2019 02:12:53 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_reuseport_array on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190703115034.53984-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7b93483d-8ba2-6c87-5f16-29586f3cb2c8@iogearbox.net>
Date:   Tue, 9 Jul 2019 02:12:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190703115034.53984-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2019 01:50 PM, Ilya Leoshkevich wrote:
> Fix endianness issue: passing a pointer to 64-bit fd as a 32-bit key
> does not work on big-endian architectures. So cast fd to 32-bits when
> necessary.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, thanks!
