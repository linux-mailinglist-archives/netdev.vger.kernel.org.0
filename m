Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1A30F6E5
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhBDPyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:54:19 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:42832 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbhBDPvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:51:51 -0500
Received: from [192.168.1.10] (unknown [180.157.168.158])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 0FA98C0217;
        Thu,  4 Feb 2021 23:50:53 +0800 (CST)
Subject: Re: [PATCH net] net/sched: cls_flower: Return invalid for unknown
 ct_state flags rules
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     i.maximets@ovn.org, netdev@vger.kernel.org
References: <1612412244-26434-1-git-send-email-wenxu@ucloud.cn>
 <20210204133856.GH3399@horizon.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <ef18cecf-f3ff-28b2-c53d-049722843c6d@ucloud.cn>
Date:   Thu, 4 Feb 2021 23:50:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20210204133856.GH3399@horizon.localdomain>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGhpPGUhLGU1DTk8ZVkpNSklPTkhDTk9JTElVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDY6LDo*Hz00KgIVISk6AUhC
        EVFPFCpVSlVKTUpJT05IQ05PT0pMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSk1DVUpOQ1lXWQgBWUFJS0tMNwY+
X-HM-Tid: 0a776dbd3c02841ekuqw0fa98c0217
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/2/4 21:38, Marcelo Ricardo Leitner Ð´µÀ:
> Hi,
>
> On Thu, Feb 04, 2021 at 12:17:24PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Reject the unknown ct_state flags of cls flower rules. This also make
>> the userspace like ovs to probe the ct_state flags support in the
>> kernel.
> That's a good start but it could also do some combination sanity
> checks, like ovs does in validate_ct_state(). For example, it does:
>
>       if (state && !(state & CS_TRACKED)) {
>           ds_put_format(ds, "%s: invalid connection state: "
>                         "If \"trk\" is unset, no other flags are set\n",
>
So this sanity checks maybe also need to be added in the ovs kernel modules?

The kernel datapath can work without ovs-vswitchd.

