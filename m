Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BDB2ACAC
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 02:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfE0AZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 20:25:11 -0400
Received: from sonic316-47.consmr.mail.bf2.yahoo.com ([74.6.130.221]:40865
        "EHLO sonic316-47.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbfE0AZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 20:25:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1558916710; bh=QFQXNGn0FJohU3l97Cng3z90qjIEAqAKmbCVyMu/adQ=; h=Date:From:Reply-To:Subject:References:From:Subject; b=h2/RUHCmySD93Up3pY6gzqXHfeMf7UroLm0zbeuUf9+8z73LnXYW9DyrLmQVaAoM/Tovw7dqr28chxCULDhIF53OuEjBn1x1p9jNJLdJYacclNjvj+AC2CfAuFCdLYd5lVHYahex3OT580OzMwp6YTUwvvR53kNyuNfXoFdNwAyIBDeu9uDDQO4DzKgkeT9nfbe5M6cw50i20QfPMGP9DC4gcJtU+DA8H+MDZ4G23ysxIQMQ7UKw95uAGTSeh9sPHMDyIkDFjPXjnUI+dqtQ4dLRwPSWhr+TWPXjVYOyfu5hsrF1ZK4Eg6H1IPpa5tjykPpmrZYWCHiyUTDjmhUoaQ==
X-YMail-OSG: FFLOdSMVM1kdljN8sUsdj5yh3CzAsG4G6Dsw2euMFbsmz_we3i5ksOFyZEsuKbT
 I2wDVGAikeu2ZA8JPlyhiZFEyg5n06uwP.7KVLuRNTiP7Ab39LbP_thfoyHu.5MV4R1diuwBTcje
 nE3Bvp8HhdcINVw7jvfEQuHEwQbRDUnFVDYLCs8rDVyWQ.XGCVXlLqaCpLWPHyK3uLdJSyTKBIMU
 GZ5kgnlSypvT.Lu1hEpWHcWQTpFfs9fCCds98vYG2mIb_Wi00NpMpXtxJTtZLhEUYx6o6FSKrtIE
 Xcq1a2x1siiQ0OAttH_mNlQlvJ7JRxCHDPgsmjI1Oqz8U_z08HOWqUx47nCGzjvFNvfrTnEQIMIl
 3xKDbDuv5ZeC_HS5zKfjF9VtQTBMCbiDB3aq8gtM51AS.O7nJDeSoY1SsR7d0wQ4aE3bwRDVPHCu
 pVFKAEfIW4NDwc0Tr_TVLh.shFzVG8AJobOQdHQBOjnOEXKJ8NTaGnLrkKseNdWHT9tCJdWa1wWy
 4Pqn4MHTsd8WbA1IpkQPujFlQtDXXN1NuqLUvJL3g.dQAuJfMlCT3nMZts51xp_gq.1oMaVFMPdC
 iCU1ECLuPkCBYrzgx7nlGHQXn68LWyNgOh.CGisFGb1rl44wDSnWqrbSVlpKYaeSk2z.wGupcZif
 7AFKDkPVy3aXTSy6TKQhgDU3QmhuheOHxIjUO5fbSAtWw2_H_vHqJ1CwNutDuUkwZ3XuYa0k7iWN
 aDqJZ5Mfy3wcDYAFxR8R9mnm.E_IbG7ACD3E9JMrKKkEhfTVhEETbF.qUW.uWJKZbP18_hv73VkS
 2PJ6E0OxGphpae9BwGv69ufpcpfbRGWMVaByQ5dBKBDx2.TiZwI5j1h9eacgFuHz1NAIRWUxtySk
 30B_SjO8.NnsLJXmMSSFXhtyfop_4fa.Xx3a3T5hwOO.09JATMD0WHNjP9N8BvT8WZ08rcW28W2S
 8eBIuIj.JJmsmMyI8ixedlZCDtI9m18BtkHfd7kgTrhIXnB4edNAMVYyL0FYFOe6t6AHedERjIAl
 3AmXeWl8STmb63fak9M33etiEaRqpDf1V7pIj_mN5DPfxH0XeL1PNw05NzL1bO0IwInCh1aMTHfW
 dCyJNEePlIhdb8iX6APwkjOv3q4YofyRFUST6.ugJILb35zstaJmpYD6YH3dNUYegstK0.55uGJ7
 tAYAsDax07jXQW9.9QIEcYtlZgjSsBnfW8GYFnAfMBeVeVGgjgAu7Rj00wYQLUQL4kaDVi1RB44c
 0B5o5YVP05sgzkuxB8RNpxtnEpvwVdBt.7bfmcx1ey5X021FRfcvSckA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Mon, 27 May 2019 00:25:10 +0000
Date:   Mon, 27 May 2019 00:23:09 +0000 (UTC)
From:   Major Dennis Hornbeck <ef44@labourza.online>
Reply-To: Major Dennis Hornbeck <hornbeckmajordennis637@gmail.com>
Message-ID: <708967904.5134176.1558916589465@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <708967904.5134176.1558916589465.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13634 YahooMailBasic Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am in the military unit here in Afghanistan, we have some amount of funds that we want to move out of the country. My partners and I need a good partner someone we can trust. It is risk free and legal. Reply to this email: hornbeckmajordennis637@gmail.com

Regards,
Major Dennis Hornbeck.
