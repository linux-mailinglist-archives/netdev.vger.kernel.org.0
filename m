Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8B044DCA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbfFMUso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:48:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:59704 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730002AbfFMUso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:48:44 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbWeI-00031Y-6O; Thu, 13 Jun 2019 22:48:42 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbWeI-000UeH-1S; Thu, 13 Jun 2019 22:48:42 +0200
Subject: Re: [PATCH bpf v2 1/2] bpf: simplify definition of BPF_FIB_LOOKUP
 related flags
To:     Martynas Pumputis <m@lambda.lt>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, ast@kernel.org
References: <20190612160541.2550-1-m@lambda.lt>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <74a2e31b-b481-b055-8004-1d3176538510@iogearbox.net>
Date:   Thu, 13 Jun 2019 22:48:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190612160541.2550-1-m@lambda.lt>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25479/Thu Jun 13 10:12:53 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2019 06:05 PM, Martynas Pumputis wrote:
> Previously, the BPF_FIB_LOOKUP_{DIRECT,OUTPUT} flags were defined
> with the help of BIT macro. This had the following issues:
> 
> - In order to user any of the flags, a user was required to depend
>   on <linux/bits.h>.
> - No other flag in bpf.h uses the macro, so it seems that an unwritten
>   convention is to use (1 << (nr)) to define BPF-related flags.
> 
> Signed-off-by: Martynas Pumputis <m@lambda.lt>

Applied, thanks!
