Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F512327C2
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgG2W5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:57:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:52946 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgG2W5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 18:57:51 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0v1B-0005us-8y; Thu, 30 Jul 2020 00:57:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0v1B-000WuQ-2g; Thu, 30 Jul 2020 00:57:49 +0200
Subject: Re: [PATCH net] selftests/bpf: add xdpdrv mode for test_xdp_redirect
To:     William Tu <u9012063@gmail.com>, Song Liu <song@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
References: <20200729085658.403794-1-liuhangbin@gmail.com>
 <CAPhsuW6m8P_7Wjuxz64RQDs85Xv530WjtRS=uUgRihdRLf2mfA@mail.gmail.com>
 <CALDO+SaL6zNzrdnyyG9Sb6eg2o3T4uPRtedMHMEhjO+R16qf_w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a691dd96-c30a-a624-42aa-3979ae03f1d3@iogearbox.net>
Date:   Thu, 30 Jul 2020 00:57:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CALDO+SaL6zNzrdnyyG9Sb6eg2o3T4uPRtedMHMEhjO+R16qf_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25888/Wed Jul 29 16:57:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 11:06 PM, William Tu wrote:
> On Wed, Jul 29, 2020 at 1:59 PM Song Liu <song@kernel.org> wrote:
>> On Wed, Jul 29, 2020 at 1:59 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>>>
>>> This patch add xdpdrv mode for test_xdp_redirect.sh since veth has
>>> support native mode. After update here is the test result:
>>>
>>> ]# ./test_xdp_redirect.sh
>>> selftests: test_xdp_redirect xdpgeneric [PASS]
>>> selftests: test_xdp_redirect xdpdrv [PASS]
>>>
>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>>
>> Acked-by: Song Liu <songliubraving@fb.com>
> LGTM.
> Acked-by: William Tu <u9012063@gmail.com>

Applied, thanks!
