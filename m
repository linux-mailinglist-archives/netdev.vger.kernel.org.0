Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870ED259096
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgIAOfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:35:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:41788 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgIAOVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:21:11 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kD79l-0001tM-TC; Tue, 01 Sep 2020 16:21:05 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kD79l-000FYS-Lo; Tue, 01 Sep 2020 16:21:05 +0200
Subject: Re: [PATCH bpf-next v2] bpf: {cpu,dev}map: change various functions
 return type from int to void
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        brouer@redhat.com, dsahern@gmail.com
References: <20200901083928.6199-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <871e61b9-b1f2-5ef1-6cb1-ecfd72ca4ea3@iogearbox.net>
Date:   Tue, 1 Sep 2020 16:21:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200901083928.6199-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 10:39 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The functions bq_enqueue(), bq_flush_to_queue(), and bq_xmit_all() in
> {cpu,dev}map.c always return zero. Changing the return type from int
> to void makes the code easier to follow.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Applied, thanks!
