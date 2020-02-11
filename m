Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B39159B09
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 22:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgBKVXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 16:23:31 -0500
Received: from sonic309-21.consmr.mail.ne1.yahoo.com ([66.163.184.147]:35735
        "EHLO sonic309-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727052AbgBKVXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 16:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1581456209; bh=QrvuJcwAPyUumaoukrGchbpbyC6TQ790ruluJV6Sxsw=; h=Date:From:Reply-To:Subject:References:From:Subject; b=IvOnCBdAg9XBZ+6ilQ8Wx0IzjjP9++5Xfo9vbJXZQOdnHfRbKRemtUytSy2IPKimunmmvFeFDXhVD+5nkvWTqxsApFl9BM/nvaCNZ9JNF7u+yuPG8OiNxXmQLyFsEHgi55OgCH9zUP+yA+C3h2pP9K5iN23ouJaj0XhSv693bcTdsgvEy4qD8LixA43gPlIaLb6UeFksvnzU9kyHd41oHSVUdXWH6Ia1UgHb+Cd/6kFQN5DUCRksPTTIk44Oj1rgj4rqmvKCmKyVNjOsoBkyYCdhjAUq4Y05Zou8I5mFU7kWEkartPueKWyDAQKTap2AMtpJcjygL9OZxiUnmmeqFQ==
X-YMail-OSG: ebhOGWgVM1lmnKNqBURbS3ORUEV1Z6aQgqGTptfwlGF74Z5_cB3k9meXkPfu90P
 RIIaQMROfJ8EBC01jHlaahJ9ijbG1H0rXbmsTLTfeOpv_PsMwIczf2.COhvR0kVakpGpqsT0zLK_
 yUO9V0Bir1gwGldIqshd3FQr21ecu_mkeqWUgSSeVMrcfqcJquzVwgpsY_DVNXmf9zfqyafk.1bh
 qTG94R0GFyF.CjJ_tnl8SU9kBL2mR.8iJog8L.OkEnGOJ.Xbs6a443vcpL9LQbni7Jrd4.bALSB7
 Hxs5N9raVJeGdcvS5rLu4_vTMh3Te0ov56RBnTXPcBmcKNlMm4VkTu0mYFd6ewIHo04CLtSFfsxW
 HnTz.tUCJ_b.6aDkWCUFRxKOszI.aBjUzfZnhMGnblemeSiWO2xdEHwp2faucZFAljQbH4P_nA9p
 7kR3E1eQI4fR2lvvprc7nmlv69T.sjjqTmssbY8Z9fV.91wHWC12d.RrCi7WMmpfZeSChgillXL8
 dkcGYNbgLbJGO_ys3Mqj1F9OeuYBtTrNUsuEOev3YATx79F2WNIhBTbK9lg91gHnYoJY2xQFu6ml
 j3eyFP.x4stCT0e9r_uExvwQzDbHpL88Imz477xFFPVYi6Ly1FxMubI7JPHqYQq9DggLNzZxqo7f
 El8aRCwnuHUDpx0KFZ06AKCAjLCVuGTdeL3NAXoxQCBa9lPLO3K.hRQx_QxWLDxtuStQ1e4VsapX
 2xChnXc.IsrXtqLbI4aTgTtnoVvyBkDWoN1itUE4a33opfaDzYTE4liGYmoDZ1G_ehVoNvCz839K
 zuAyQ9y.o5r1zHMWryZSbm8pVMvuPCfS0PghRb9iliJM4.KVUYiqu0HpvL.qOb4gYuI7jKu4uENq
 0opWsvhdXH_q05M004Kn81fpYUkvDv1TVjMxFmrwsOu28TklYt8N3Q5CGH0ViC2tMuUVbyF0vbhd
 KXhRbS49hNNoiEZ9UFnd0sdyxTxlEf.wPUNgUSntUfC.prv7.pKZdVStN7bruBSs2UYmGnIqbyGz
 v6I8Kw1S5PqvBIcUVv4apkvT8XrlXSa_WqjrHbOzfdR259HsuWDdsR6vFSun5ssVcMuk0sq_wNB2
 7zwiSIMrn2ZNv50xZtR8EoAHLjgYFrTUbub1jc5SunoL7ScvPLxokvryAvNRkdM5GmvsVGPsMjAy
 _MbkIpE2Gv2DVPgXiHhi6K67euTFkNVfsfx3BdYiKsJ5gUujm.mwm1SIppkpqPBvLc8jQItOkGmX
 tKyvXxPIWBAqYahG1p.497LulYhZXKnE4MBQsT6svO8W8pCiIlmYUImaL45U90nLMCH5jpQllUBh
 bcVhO
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Tue, 11 Feb 2020 21:23:29 +0000
Date:   Tue, 11 Feb 2020 21:23:28 +0000 (UTC)
From:   Ayesha Coulibaly <missayeshawarlord@aol.com>
Reply-To: aycl111@aol.com
Message-ID: <1699916495.1551570.1581456208484@mail.yahoo.com>
Subject: My Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1699916495.1551570.1581456208484.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15199 YMailNodin Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




My Dear

With warm heart, I offer my friendship and greetings, I hope this message meet you in good time. However, Mine names are Ms. Ayesha Coulibaly. I am 24 years old female. I have sent you mail twice but you never replied any of them. I humbly ask that you reply this message, to enable me disclose the reason while I have been trying to reach out to you. I do apologize for infringing on your privacy.

greetings Ayesha Coulibaly.
