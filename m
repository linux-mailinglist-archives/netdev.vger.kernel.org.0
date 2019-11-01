Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C34EC287
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfKAMQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:16:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:36196 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbfKAMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:16:36 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQVr0-0004Q6-5f; Fri, 01 Nov 2019 13:16:34 +0100
Received: from [178.197.249.38] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQVqz-0008n3-Tb; Fri, 01 Nov 2019 13:16:33 +0100
Subject: Re: [PATCH bpf-next] Revert "selftests: bpf: Don't try to read files
 without read permission"
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        alexei.starovoitov@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        bpf@vger.kernel.org, jiri@resnulli.us
References: <20191101005127.1355-1-jakub.kicinski@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ab2db974-9754-1804-caa8-402ad9e8cb50@iogearbox.net>
Date:   Fri, 1 Nov 2019 13:16:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191101005127.1355-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 1:51 AM, Jakub Kicinski wrote:
> This reverts commit 5bc60de50dfe ("selftests: bpf: Don't try to read
> files without read permission").
> 
> Quoted commit does not work at all, and was never tested.
> Script requires root permissions (and tests for them)
> and os.access() will always return true for root.
> 
> The correct fix is needed in the bpf tree, so let's just
> revert and save ourselves the merge conflict.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks!
