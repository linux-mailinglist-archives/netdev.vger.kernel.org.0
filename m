Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010C5F1636
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 13:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbfKFMmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 07:42:31 -0500
Received: from www62.your-server.de ([213.133.104.62]:33528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbfKFMmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 07:42:31 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSKdh-0002NZ-9a; Wed, 06 Nov 2019 13:42:21 +0100
Received: from [2a02:120b:c3f4:3fe0:7967:2209:7be1:fcc9] (helo=pc-11.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSKdg-000U9x-Vw; Wed, 06 Nov 2019 13:42:21 +0100
Subject: Re: [PATCH net-next 2/2] selftests: bpf: log direct file writes
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com
References: <20191105212612.10737-1-jakub.kicinski@netronome.com>
 <20191105212612.10737-3-jakub.kicinski@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <210f02e0-c5e4-3a39-6124-e0b2eb6c545d@iogearbox.net>
Date:   Wed, 6 Nov 2019 13:42:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191105212612.10737-3-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25625/Wed Nov  6 10:44:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 10:26 PM, Jakub Kicinski wrote:
> Recent changes to netdevsim moved creating and destroying
> devices from netlink to sysfs. The sysfs writes have been
> implemented as direct writes, without shelling out. This
> is faster, but leaves no trace in the logs. Add explicit
> logs to make debugging possible.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Assuming this goes directly to net-next, so:

Acked-by: Daniel Borkmann <daniel@iogearbox.net>

Thanks!
