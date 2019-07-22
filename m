Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D407022C
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbfGVOWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:22:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:39890 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbfGVOWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 10:22:10 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hpZCZ-00016W-NZ; Mon, 22 Jul 2019 16:22:07 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hpZCZ-000SrB-Fu; Mon, 22 Jul 2019 16:22:07 +0200
Subject: Re: [PATCH bpf v4 00/14] sockmap/tls fixes
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        john.fastabend@gmail.com, alexei.starovoitov@gmail.com
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
 <20190719103721.558d9e7d@cakuba.netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3c97d252-37ad-302f-b917-e7ea6e819318@iogearbox.net>
Date:   Mon, 22 Jul 2019 16:22:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190719103721.558d9e7d@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25518/Mon Jul 22 10:12:39 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/19 7:37 PM, Jakub Kicinski wrote:
> On Fri, 19 Jul 2019 10:29:13 -0700, Jakub Kicinski wrote:
>> John says:
>>
>> Resolve a series of splats discovered by syzbot and an unhash
>> TLS issue noted by Eric Dumazet.
> 
> Sorry for the delay, this code is quite tricky. According to my testing
> TLS SW and HW should now work, I hope I didn't regress things on the
> sockmap side.

Applied, thanks everyone!
