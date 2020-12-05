Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F622CFB2F
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 12:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgLELtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 06:49:02 -0500
Received: from m12-12.163.com ([220.181.12.12]:41312 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgLELpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 06:45:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=GifUQ
        FKYJxVhL7wlF1fqoLwCjDaLUSklH4nwnm56l18=; b=p+qnV7xlpvtS9xCz39Zb7
        3bm904rAUfSXmr/tKVZY2qbz0IS6dJzMlMzRDb293BREVVTymrciE46aYgpNnelT
        CQKoUyUyFp83+Um14T8v4cDY92Qp/5Qk7v7+GwTTGgaJRHois+BdjiVtRVgVneN7
        ZUDidIh3KqXMIBd6hUvu2E=
Received: from [10.8.0.186] (unknown [36.111.140.26])
        by smtp8 (Coremail) with SMTP id DMCowAA3ne1TOctfgq7bFQ--.14053S2;
        Sat, 05 Dec 2020 15:40:06 +0800 (CST)
Subject: Re: [PATCH] mptcp: print new line in mptcp_seq_show() if mptcp isn't
 in use
To:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        pabeni@redhat.com, davem@davemloft.net
References: <c1d61ab4-7626-7c97-7363-73dbc5fa3629@163.com>
 <20201204152119.GA31101@breakpoint.cc>
 <20201204085926.078e5a9a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Jianguo Wu <wujianguo106@163.com>
Message-ID: <1ff1a7e6-7419-52ce-91a3-16133fd3c9a4@163.com>
Date:   Sat, 5 Dec 2020 15:40:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204085926.078e5a9a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowAA3ne1TOctfgq7bFQ--.14053S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrur13WF1rWw43uw48ZF18Zrb_yoW3Wwc_ta
        yvkwnruw1DWw1ktrs5t3Z8WF9a9r1UGrW0vwnxtr90g3say39rWrs7tF1fCa40qayF9rnx
        KrnYya1ayrnagjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnGsjUUUUUU==
X-Originating-IP: [36.111.140.26]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiNxbxkFWBi0wW8QAAs0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK,I will post v2 soon, thanks!

ÔÚ 2020/12/5 0:59, Jakub Kicinski Ð´µÀ:
> On Fri, 4 Dec 2020 16:21:19 +0100 Florian Westphal wrote:
>> Jianguo Wu <wujianguo106@163.com> wrote:
>>> From: Jianguo Wu <wujianguo@chinatelecom.cn>  
>>
>> A brief explanation would have helped.
> 
> Yes, please post a v2 with a sentence describing the problem and output
> before and after the change.
> 
>> This is for net tree.
> 
> By which we mean please tag v2 as [PATCH net v2] in the subject.
> 
>>> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>  
>>
>> Fixes: fc518953bc9c8d7d ("mptcp: add and use MIB counter infrastructure")
>> Acked-by: Florian Westphal <fw@strlen.de>
> 
> And please make sure to add these to your patch before posting so
> Florian doesn't have to resend them.
> 

