Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599502EC8E1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 04:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbhAGDKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 22:10:33 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.223]:47901 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726171AbhAGDKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 22:10:32 -0500
HMM_SOURCE_IP: 172.18.0.218:47170.392515856
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.26?logid-6e8cca70383f472e94a819c95e027fc3 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 6794D280079;
        Thu,  7 Jan 2021 11:08:19 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by App0025 with ESMTP id 6e8cca70383f472e94a819c95e027fc3 for fw@strlen.de;
        Thu Jan  7 11:08:26 2021
X-Transaction-ID: 6e8cca70383f472e94a819c95e027fc3
X-filter-score:  filter<0>
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH] tcp: remove obsolete paramter sysctl_tcp_low_latency
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, fw@strlen.de
References: <1608271876-120934-1-git-send-email-liyonglong@chinatelecom.cn>
 <20201218164647.1bcc6cb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   lll <liyonglong@chinatelecom.cn>
Message-ID: <b3cb1c57-d992-72c1-dd24-5d594ff38561@chinatelecom.cn>
Date:   Thu, 7 Jan 2021 11:08:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201218164647.1bcc6cb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/12/19 8:46, Jakub Kicinski Ð´µÀ:
> On Fri, 18 Dec 2020 14:11:16 +0800 lyl wrote:
>> Remove tcp_low_latency, since it is not functional After commit
>> e7942d0633c4 (tcp: remove prequeue support)
>>
>> Signed-off-by: lyl <liyonglong@chinatelecom.cn>
> 
> I don't think we can remove sysctls, even if they no longer control 
> the behavior of the kernel. The existence of the file itself is uAPI.
> 
Got it. But a question: why tcp_tw_recycle can be removed totally?  it is also part of uAPI
