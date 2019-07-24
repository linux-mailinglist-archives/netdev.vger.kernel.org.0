Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE434723C6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfGXBic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:38:32 -0400
Received: from sonic310-20.consmr.mail.bf2.yahoo.com ([74.6.135.194]:46532
        "EHLO sonic310-20.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbfGXBic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bellsouth.net; s=s2048; t=1563932311; bh=ZZ/rHLttVErLzhD+sRD5MjWIH47JtNuuSC4WjFRRv+A=; h=To:From:Subject:Date:From:Subject; b=a6IehIXCMNGm63CjbVwL8xJ4Gwc0ypw9E7dzMAnLEUkcVRxAbBNQD/O2hY60ZpNSLkvD7bJtKfGOzuhRbsNjKTaa3fRTp++PthbHxo+Ysd8f8aslTrAjyBUVE/rDzValzGGM4ezGuVZ1lXkOa32ys+L6xCaQPeODAxk8ZiiNNhNAFwwNK32bpQPN3uxgK8qpVKEc7GqdHjrR39ZsruSIq1dxZAt3xCCk0HMP10J5LFrvmHf8Mzh3X14r78xXbbX4VH7i9nts5iym4fGqlElDyr/SrrRTthciTX4V/zqt9Sj4csST/tHClCmf+tH9/TGfFW5c17ERaIMor5sUzpZxyg==
X-YMail-OSG: LLgm9bsVM1nZ7a4HtPsSMxr9xORsJq4377e4VB.AxvNL44DWjb17IAUaaRfxIdW
 JjUCw09o.diG40.otgKwPLNv9rw9y83BCUPdQgl8iKtVe.PD4ra2RkdC2Aw9eSW.7fyMh745FPwd
 uVzPE4vLCId1BaYRUuNpV9BHVveBZPql6y6ajRjuiXu2kpWfGp9GmmE__J9hqka7sa17Civ266LC
 lUre8xajtdgvpdsOZiCGjrzaYTAoPM3mMztKo.mYQamr3e2W2Qu2or7bIsmdA.j3fFuLSzXuJloH
 KHx034DM3aATvzgeIYxwqzrlvWCxMUDfr1B80Ma6drttTXFpLpt93O8mBwRHxYsVwP4BQxWRveyQ
 afGVbm_u_fRa0zgY.k8xpVHJdFfQ7PAWP8k4Gco5wgWo1zCpZtwK6qMW.KODZX03WmWLVIYcvujC
 KyRJqQqa6EeC2wKSPYb79aytCIfalv5OmZUQcfEGw20mO4t0Mxw0hsoaZB7gN1wlRWkl73Hx9NlY
 MmLr1u4iiOQB4w2IeYLgff9Sm98Ln2IzhvGs6xDWBnyDBGYSv4ZtT6_Joto_pGNaqXecqbj6dXoX
 hNTMXNBGll6pbb6Ooa6Th9gLnOqFXwMdtggH7xc87bDaYTqjhrrL4Z7sq68NCoXgMJt2UCnB0V8y
 DUybpXXfYoBpwozUzr1bv.dDCQ41LhkJhlHDBwpFjb32o_GJovaVrkTDo3u7VpqzqyKp8CL3b0tQ
 NQChvXmCcs.7B1K5dst2hS.5hpyFbrXaG1W0vx090exPHU6.mTX2gxWq9T2xa5eo.Js1bFjOGmEE
 cYbsPf6ePygEiIc3L2L4Q0XEQq.oWjPaJJgwzAjvETuQbY3s.GsfflH0TMTChAe1dIo_Mzdv92P3
 dOm0D05Prg1WbNojSJd6tRMYVEu3mQ3.b0Wa_QSQRwBcIjPtqTEKzh6rfmWH.fLjlbeGvFMwclMG
 8ZRs1AqN8znirTfDc5M1Ba52V3EKZVYi7Xg1wfiVmzaqDY30dI4_3ZLG3zwX0Bfj5o_tybo27wQ0
 gArSW_kmA7ozZ2MVIbm.yp97U.zbSX16ZmzxfpIHp9lk3HMBHxukV2Y3GxoNaRMO.kQLWvwI92gY
 QE9YNcpYSLLO2KZN.n5Gi3vWvTPT7Rlqg7ce9XFrxpFCV7fTPsYWeE0uCz_enECPjDeKGcKPc.4N
 b_eSyFY6RYg8bFXnfvobagB_hVtk9XsfzQ2O3syr.fL9BYDMf2Kdo
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Wed, 24 Jul 2019 01:38:31 +0000
Received: by smtp416.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 511b965a51e2e355237b85287e65231a;
          Wed, 24 Jul 2019 01:38:26 +0000 (UTC)
To:     netdev@vger.kernel.org
From:   Bob Gleitsmann <rjgleits@bellsouth.net>
Subject: kernel v5.3.0-rc1
Message-ID: <ed5c39e4-e364-ccca-0a9e-8d0b4d648bfd@bellsouth.net>
Date:   Tue, 23 Jul 2019 21:38:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


I had problems with network functionality in kernel v5.3.0-rc1. I was
not able to ping local devices with ip address or internet points by
name. I have been testing git kernels for a while and this is the first
time this has happened, i.e., it didn't happen with v5.2.0. One
interesting thing is that simply rebooting with a good kernel doesn't
fix the problem. The machine has to be powered off and restarted.

It was clear that network names were not being resolved.

I can provide more details and try different things to help track down
the problem. I'm using x86-64 system, gentoo linux, r8169 PHY.


Best Wishes,


Bob Gleitsmann

