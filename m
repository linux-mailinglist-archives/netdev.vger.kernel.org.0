Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A78454E1D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbfFYMAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:00:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:51514 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFYMAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:00:36 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfk7l-0002Se-LS; Tue, 25 Jun 2019 14:00:33 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfk7l-0005Do-CT; Tue, 25 Jun 2019 14:00:33 +0200
Subject: Re: [PATCH bpf-next] MAINTAINERS: add reviewer to maintainers entry
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190624052455.10659-1-bjorn.topel@gmail.com>
 <B5DAC105-8F88-43F7-9F6F-6C0B436C4F06@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e0654342-7110-c1e3-53bc-cb9c303252e9@iogearbox.net>
Date:   Tue, 25 Jun 2019 14:00:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <B5DAC105-8F88-43F7-9F6F-6C0B436C4F06@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25491/Tue Jun 25 10:02:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/24/2019 10:54 PM, Jonathan Lemon wrote:
> On 23 Jun 2019, at 22:24, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Jonathan Lemon has volunteered as an official AF_XDP reviewer. Thank
>> you, Jonathan!
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Given it's a doc update, I've applied it to bpf, thanks!
