Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7674366EB9
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfGLMkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:40:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:45642 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727896AbfGLMkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:40:35 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hluqf-0003sE-Uz; Fri, 12 Jul 2019 14:40:26 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hluqf-000Wv3-Nh; Fri, 12 Jul 2019 14:40:25 +0200
Subject: Re: [PATCH] MAINTAINERS: update BPF JIT S390 maintainers
To:     David Miller <davem@davemloft.net>, gor@linux.ibm.com
Cc:     ast@kernel.org, heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        iii@linux.ibm.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <patch.git-d365382dfc69.your-ad-here.call-01562755343-ext-3127@work.hours>
 <your-ad-here.call-01562758494-ext-2794@work.hours>
 <20190711.113343.906691840255971211.davem@davemloft.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aff5da65-ea70-43dd-1fb2-b731a343ce74@iogearbox.net>
Date:   Fri, 12 Jul 2019 14:40:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190711.113343.906691840255971211.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/11/2019 08:33 PM, David Miller wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
> Date: Wed, 10 Jul 2019 13:34:54 +0200
> 
>> Dave, Alexei, Daniel,
>> would you take it via one of your trees? Or should I take it via s390?
> 
> I think it can go via the bpf tree.

Yep, just applied to bpf, thanks!
