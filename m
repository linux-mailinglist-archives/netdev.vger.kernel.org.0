Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C351F8670
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 05:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgFNDjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 23:39:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5823 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726486AbgFNDjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 23:39:48 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 026B18A9B4B57F43D2F9;
        Sun, 14 Jun 2020 11:39:44 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.88) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Sun, 14 Jun 2020
 11:39:35 +0800
Subject: Re: [PATCH v2 1/2] perf tools: Fix potential memory leaks in perf
 events parser
To:     Markus Elfring <Markus.Elfring@web.de>,
        Cheng Jian <cj.chengjian@huawei.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200611145605.21427-1-chenwandun@huawei.com>
 <20200611145605.21427-2-chenwandun@huawei.com>
 <51efcf82-4c0c-70d3-9700-6969e6decde1@web.de>
From:   Chen Wandun <chenwandun@huawei.com>
Message-ID: <4faf0979-2c9f-f0c7-5778-908b50f740a6@huawei.com>
Date:   Sun, 14 Jun 2020 11:39:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <51efcf82-4c0c-70d3-9700-6969e6decde1@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.215.88]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/6/12 2:50, Markus Elfring 写道:
>> Fix memory leak of in function parse_events_term__sym_hw()
>> and parse_events_term__clone() when error occur.
> How do you think about a wording variant like the following?
>
>     Release a configuration object after a string duplication failed.

Thank you for your reply, I will update in v3

Best Regards,

     Chen Wandun


>
> Regards,
> Markus
>

