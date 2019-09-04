Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2DBA968F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfIDWh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:37:26 -0400
Received: from sonic306-21.consmr.mail.sg3.yahoo.com ([106.10.241.141]:38793
        "EHLO sonic306-21.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727156AbfIDWh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1567636643; bh=xJNgyXLYKKzlKVDzCSe1mWOtzuvfwzMEi3xOQNM+MeM=; h=Date:From:Reply-To:Subject:From:Subject; b=G7LPWfrUoCipLmf4ncstpi6cBsM85+2N3ZztjQTWswEpAheRb53bcjVWEVqdmh7ZvtOwQoVtF+KlcMczb0ve3n2myB5jziA2pRymfv+9Sdynuex/BOzKci15FuCK49UWERgnOpzJxExflDOu+bF0dgzAACFzN4s4vs2Dmxt3ol4Xyxa/cnqlDSk5OWeHtVuMUwMnJ2bz7FIBQWhF79KcVbVMcYfZhLYGJwhFEH+Z8Hu+jZtXRkGN/6PywtU+vzE3ooEaZGShU4IQ3SEOhrtEzyAEIgnBIT3t5LFOfkzRgQGeUlnNvGqQgK4VsMEGNOZPwu18lYbKT/J5eX58W/UHlQ==
X-YMail-OSG: hs3beNkVM1lpa5EcY6SuaVpK5SNDBBD4nKP_UADIpfa_3KURkKltSqc1cwtRCDP
 5FNNl4dpBy15Uj4IzATEeYFUHA7tJwXWQGIlZLuq9vsA7oJVBTVUFp0EWFKS7vuSapWB6xFd1seT
 eC84WNAW0zwLogSentKr48.1nWLNt_76bbILn1bDxcJF4CY1kb0FBDX5DUYrFR7_GvGdchfVLu4a
 cvQHYGDa0wr8WN9jR1cPFOiVjDbzY4700HypWjngRRUzNNhydnsVJKh_KHu6foBzjV4eu4ULKgff
 W670q.FAAgcopdTM4Lb2yeCtGXk2p3F8iN_zPSjdLhwzzlIqRqQYyhWlbLf55b55iBnzavRi9Xpr
 OxZG15wOTCPE2qbGMq1rDp1IE.hz84BldmmtigHwh_30Z4a06h5Y8SI1Ws7iBR3o_mJmK2hiZAXO
 Eu17r6JoJgzQlOHEqd6T0UTe19guNswvkYITrYF2Bc4rx7CnFVRQbCk1uBtKRBiBDu0q2vRKO_Hi
 smjgbLzpkR3yneBjQosD4Jn5Xr3lMqsHbF.DCk9GAfTfwrDtdEgdhV9lWEb6GwW4jQxKXwBkXM29
 aKrtfr0_W7yi3MAbUeu2bWuDR8AogOHtSbhGGmQJpjwfKue2vuk95TP18CpShKRia8Sh1RVwW5PZ
 bGeKuQFX6trmJIkIVNbSZnhsxIb4.rfR6_lW.8J7qGdvTsiLQXXyiK5CWjU_kzgWxz2bflLsYauN
 BUCsHvo8Tcocm93NBewfk4bNBxR3N619HWNi0qvOvjS53wujtdzuGG.3J67uHGK_FZL_8eK248Qw
 korgciLY1UcEMIpdkAExovplTqw5qgMZnN2CEGZrEglMiV4rt2ueshKAxjCEbeuEbbW04Fm4Osc6
 YvMuSDUHsatQj.3Zu6jrZIkS0pEiBkuZFm1_MS21y.gP8RZsg5HmC4yJ.UnHr2yLIvVHmiS1w6vI
 KyzykBG7OeB7xxCPlAdjFpjdws75PYFEASbE85kN7gEUWBT0kQfPXQBJmqA60BzQFidbDzk2m_bE
 ADia9KQpQpe0kPDjCqshQDJVMvXfciTeO3QQQhHXvM4anpxm1W6PZbmCLHWiheJ8Fq15Avv1De9K
 VAnjjTXFhnwEI0vflPaqHAVUFxVtaXh6Gv_FMeJk5fbhk4o4yQVWfjP0NTNxtNGIwA_R1Q0G_IXu
 4X59WY2YaOLSLmEju3lOiU7xozlC2Js4qTQhD9ksNza0MSiBWiSNYq7ERRQMMFD280g9itpIDRxX
 8KhXJrtAXX.1GcSy9wPIeAbISeKw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.sg3.yahoo.com with HTTP; Wed, 4 Sep 2019 22:37:23 +0000
Date:   Wed, 4 Sep 2019 22:37:20 +0000 (UTC)
From:   "Mrs. Gaddafi" <mrs.aishagad@gmail.com>
Reply-To: mrsaishag502@gmail.com
Message-ID: <544137416.2118002.1567636640909@mail.yahoo.com>
Subject: HOW IS YOUR DAY,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear Friend,

I came across your e-mail contact prior a private search whilst in need of your partnership for investment assistance in your country. I am opportune to use this medium to exhibit my legal intentions towards investing to your country under your management. I am fully convinced that you will really be of help as a business partner.

My name is Aisha Gaddafi a single Mother and a Widow and i have three Children. I am the only biological Daughter of late Libyan President (Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand United State Dollar ($27.500.000.00 ) and i need a trusted investment Manager/Partner. I am planning to go into investment projects in your country of origin or present country of Location to assist me establish the investments project.

 I am willing to negotiate investment/business profit sharing ratio with you base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent to enable me provide you tell you more details about myself and more information about the release of the investment funds.

I appreciate Your Urgent Reply to my email address:

Best Regards
Mrs Aisha Gaddafi
