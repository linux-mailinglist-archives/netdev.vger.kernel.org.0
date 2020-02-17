Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C823161601
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgBQPWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:22:18 -0500
Received: from www62.your-server.de ([213.133.104.62]:55692 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbgBQPWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:22:18 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j3iDo-0006lQ-7Y; Mon, 17 Feb 2020 16:22:08 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j3iDn-000V5F-P3; Mon, 17 Feb 2020 16:22:07 +0100
Subject: Re: [PATCH v3] samples/bpf: Add xdp_stat sample program
To:     Eric Sage <eric@sage.org>, bpf@vger.kernel.org
Cc:     ast@kernel.org, kafai@fb.com, yhs@fb.com, andriin@fb.com,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <CAEf4BzbjXRFYkr2LCh50mLV+cQ9WrgRB+U4CbxekVVf=nfRUZw@mail.gmail.com>
 <20200129035457.90892-1-eric@sage.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2f05b54f-0b01-1f7e-d665-9e0e3c5ff7d8@iogearbox.net>
Date:   Mon, 17 Feb 2020 16:22:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200129035457.90892-1-eric@sage.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25726/Mon Feb 17 15:01:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/20 4:54 AM, Eric Sage wrote:
> At Facebook we use tail calls to jump between our firewall filters and
> our L4LB. This is a program I wrote to estimate per program performance
> by swapping out the entries in the program array with interceptors that
> take measurements and then jump to the original entries.
> 
> I found the sample programs to be invaluable in understanding how to use
> the libbpf API (as well as the test env from the xdp-tutorial repo for
> testing), and want to return the favor. I am currently working on
> my next iteration that uses fentry/fexit to be less invasive,
> but I thought it was an interesting PoC of what you can do with program
> arrays.
> 
> Signed-off-by: Eric Sage <eric@sage.org>

Now that bpf-next is back open, this needs a rebase for proceeding to get merged.

Thanks,
Daniel
