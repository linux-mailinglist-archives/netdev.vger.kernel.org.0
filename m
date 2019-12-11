Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D7311A394
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 05:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfLKEtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 23:49:07 -0500
Received: from mail5.windriver.com ([192.103.53.11]:48610 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbfLKEtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 23:49:07 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id xBB4mlae022410
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 10 Dec 2019 20:48:47 -0800
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.468.0; Tue, 10 Dec
 2019 20:48:46 -0800
Subject: Re: [tipc-discussion] [PATCH net/tipc] Replace rcu_swap_protected()
 with rcu_replace_pointer()
To:     <paulmck@kernel.org>, Tuong Lien Tong <tuong.t.lien@dektech.com.au>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>,
        <davem@davemloft.net>
References: <20191210033146.GA32522@paulmck-ThinkPad-P72>
 <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com>
 <20191210223825.GS2889@paulmck-ThinkPad-P72>
 <54112a30-de24-f6b2-b02e-05bc7d567c57@windriver.com>
 <707801d5afc6$cac68190$605384b0$@dektech.com.au>
 <20191211031751.GZ2889@paulmck-ThinkPad-P72>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <fdbb5b2c-851e-11c1-7e52-5f70b7489504@windriver.com>
Date:   Wed, 11 Dec 2019 12:35:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191211031751.GZ2889@paulmck-ThinkPad-P72>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 11:17 AM, Paul E. McKenney wrote:
>> Acked-by: Ying Xue <ying.xue@windriver.com>
> As in the following?  If so, I will be very happy to apply your Acked-by.

Yes. Thanks!
