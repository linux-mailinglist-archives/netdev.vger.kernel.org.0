Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DAE74C3A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbfGYKxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 06:53:11 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59691 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbfGYKxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 06:53:11 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CA74F41C05;
        Thu, 25 Jul 2019 18:53:07 +0800 (CST)
Subject: Re: [PATCH net-next 1/3] flow_offload: move tc indirect block to flow
 offload
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
 <20190725102217.zmkpmsnyt7xnz2vu@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <fd918ad6-5dbd-d225-b21a-326bde5782ca@ucloud.cn>
Date:   Thu, 25 Jul 2019 18:53:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725102217.zmkpmsnyt7xnz2vu@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS01IS0tLS0NJQk1CTUxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pjo6MCo*KDg8MlZWKxEyISIS
        LzhPCxxVSlVKTk1PS05KQkNDS09MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSkxKTTcG
X-HM-Tid: 0a6c28c35df72086kuqyca74f41c05
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/25/2019 6:22 PM, Florian Westphal wrote:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> move tc indirect block to flow_offload.c. The nf_tables
>> can use the indr block architecture.
> ... to do what?  Can you please illustrate how this is going to be
> used/useful?
This is used to offload the tunnel packet. The decap rule is set on the tunnel device, but not the hardware device.
