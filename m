Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D473DE023
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhHBTi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:38:57 -0400
Received: from gateway30.websitewelcome.com ([192.185.194.16]:42133 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhHBTi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 15:38:56 -0400
X-Greylist: delayed 1415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2021 15:38:56 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id A40F8D4C5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 14:15:03 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id AdN0mIZ0GjSwzAdN0mqx4m; Mon, 02 Aug 2021 14:13:02 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DJIS+a5HsMmnfIxc2Pzhsn+S1rqEqCOqgc6RlnNWJ6o=; b=EBYUsbVyp+HjHZwcH9ALnmg6Fi
        uqEN3Dltc7+UHmEwSBAJhyMK9ZKspqWrC8PHilc2jJro+1UWv1pWzRS1uW+kbZ16KM6ewHjGHIPi3
        gIVHwcI5+GU0K5HQwLswTkbVNGeWWfWU3F2JvH+b8+fs/pT19NRPP8sd1HF4iKNAEAXmBxftqUvgt
        XDJC7lHqzTRCj7WxZAthwVGTn6YaaidkZb56AK+i9VuRjBDcwucB+jRT8DjP7+tCkc4//pUvk5Mcq
        FkPYAjy7URIh/9jGAB3X5QXrT7c4AMnpvN3vNJ19LzKgK0J48BoTWug6ec+dACL9Z469kbuyXgUX3
        /zl0ZXnw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57696 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mAdMy-0042EB-Mo; Mon, 02 Aug 2021 14:13:00 -0500
Subject: Re: [PATCH][next] net/ipv4: Replace one-element array with
 flexible-array member
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     patchwork-bot+netdevbpf@kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210731170830.GA48844@embeddedor>
 <162791400741.18419.5941105433257893840.git-patchwork-notify@kernel.org>
 <6d3c2ba1-ea01-dbc1-1e18-1ba9c7a15181@embeddedor.com>
Message-ID: <4a9987c1-1f7a-35af-af6a-01b96292d2ee@embeddedor.com>
Date:   Mon, 2 Aug 2021 14:15:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6d3c2ba1-ea01-dbc1-1e18-1ba9c7a15181@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mAdMy-0042EB-Mo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:57696
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/21 13:46, Gustavo A. R. Silva wrote:
> 
> 
> On 8/2/21 09:20, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to netdev/net-next.git (refs/heads/master):
>>
>> On Sat, 31 Jul 2021 12:08:30 -0500 you wrote:
>>> There is a regular need in the kernel to provide a way to declare having
>>> a dynamically sized set of trailing elements in a structure. Kernel code
>>> should always use “flexible array members”[1] for these cases. The older
>>> style of one-element or zero-length arrays should no longer be used[2].
>>>
>>> Use an anonymous union with a couple of anonymous structs in order to
>>> keep userspace unchanged:
>>>
>>> [...]
>>
>> Here is the summary with links:
>>   - [next] net/ipv4: Replace one-element array with flexible-array member
>>     https://git.kernel.org/netdev/net-next/c/2d3e5caf96b9
> 
> arghh... this has a bug. Sorry, Dave. I will send a fix for this, shortly.
> 

BTW... can we expect msf->imsf_numsrc to be zero at some point in the following
pieces of code?

net/ipv4/igmp.c:
2553         copycount = count < msf->imsf_numsrc ? count : msf->imsf_numsrc;
2554         len = copycount * sizeof(psl->sl_addr[0]);
2555         msf->imsf_numsrc = count;
2556         if (put_user(IP_MSFILTER_SIZE(copycount), optlen) ||
2557             copy_to_user(optval, msf, IP_MSFILTER_SIZE(0))) {
2558                 return -EFAULT;
2559         }

net/ipv4/ip_sockglue.c:
1228         case IP_MSFILTER:
1229         {
1230                 struct ip_msfilter *msf;
1231
1232                 if (optlen < IP_MSFILTER_SIZE(0))
1233                         goto e_inval;
1234                 if (optlen > sysctl_optmem_max) {
1235                         err = -ENOBUFS;
1236                         break;
1237                 }
1238                 msf = memdup_sockptr(optval, optlen);
1239                 if (IS_ERR(msf)) {

			...

1250                 if (IP_MSFILTER_SIZE(msf->imsf_numsrc) > optlen) {
1251                         kfree(msf);
1252                         err = -EINVAL;
1253                         break;
1254                 }
1255                 err = ip_mc_msfilter(sk, msf, 0);
1256                 kfree(msf);
1257                 break;
1258         }

Thanks
--
Gustavo
