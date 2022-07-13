Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D8C573B2B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237167AbiGMQ0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 12:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbiGMQ0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 12:26:00 -0400
X-Greylist: delayed 4936 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Jul 2022 09:25:56 PDT
Received: from delivery.e-purifier.com (delivery.e-purifier.com [197.234.175.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7FB644B;
        Wed, 13 Jul 2022 09:25:56 -0700 (PDT)
Authentication-Results: delivery.e-purifier.com;
        spf=pass (e-purifier.com: domain of moodley1@telkomsa.net designates 105.224.1.22 as permitted sender) smtp.mailfrom=moodley1@telkomsa.net;
Received: from zmmtaout3.telkomsa.net ([105.224.1.22])
        by delivery.e-purifier.com  with ESMTP id 26DF1lo2016177-26DF1lo4016177
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 13 Jul 2022 17:01:47 +0200
Received: from localhost (localhost [127.0.0.1])
        by zmmtaout3.telkomsa.net (Postfix) with ESMTP id 1CD7E2BD5F;
        Wed, 13 Jul 2022 17:00:36 +0200 (SAST)
Received: from zmmtaout3.telkomsa.net ([127.0.0.1])
        by localhost (zmmtaout3.telkomsa.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id YrTHqgMk2W08; Wed, 13 Jul 2022 17:00:35 +0200 (SAST)
Received: from localhost (localhost [127.0.0.1])
        by zmmtaout3.telkomsa.net (Postfix) with ESMTP id A74F92BD6D;
        Wed, 13 Jul 2022 17:00:32 +0200 (SAST)
X-Virus-Scanned: amavisd-new at zmmtaout3.telkomsa.net
Received: from zmmtaout3.telkomsa.net ([127.0.0.1])
        by localhost (zmmtaout3.telkomsa.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PlHz_sTruC7B; Wed, 13 Jul 2022 17:00:32 +0200 (SAST)
Received: from zmstore9.telkomsa.net (unknown [105.224.1.35])
        by zmmtaout3.telkomsa.net (Postfix) with ESMTP id D70262BD25;
        Wed, 13 Jul 2022 16:59:52 +0200 (SAST)
Date:   Wed, 13 Jul 2022 16:57:32 +0200 (SAST)
From:   moodley1@telkomsa.net
Message-ID: <603518918.33120404.1657724252746.JavaMail.zimbra@telkomsa.net>
In-Reply-To: <1973961642.33118723.1657724132801.JavaMail.zimbra@telkomsa.net>
References: <2127485694.31048803.1657662626489.JavaMail.zimbra@telkomsa.net> <980133854.32889861.1657719768395.JavaMail.zimbra@telkomsa.net> <1053654300.32902192.1657719834566.JavaMail.zimbra@telkomsa.net> <1659146035.32936102.1657720147525.JavaMail.zimbra@telkomsa.net> <618554591.32945678.1657720268622.JavaMail.zimbra@telkomsa.net> <782242463.32974907.1657720739247.JavaMail.zimbra@telkomsa.net> <872503409.33007043.1657721100496.JavaMail.zimbra@telkomsa.net> <1973961642.33118723.1657724132801.JavaMail.zimbra@telkomsa.net>
Subject: Please Read
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [41.150.32.161]
X-Mailer: Zimbra 8.8.15_GA_4308 (zclient/8.8.15_GA_4308)
Thread-Topic: Please Read
Thread-Index: zrwTMR13eISbWlCcDqfemSplFCEPBZodD7nHD1yGqeG0h3Tw/vRNVBIJmgHRXppY0sP7ZkZCsYgNld2DkPBhA5vTMSDb/j86+UH3A5VIfrOoNg+rFDzDiOwERXzRCTLj0og+GRhJ67dyELL7RDGg30Mzez+dJ7/DDPlt+hwCfa9zh0jPZrOTNhEMJwzePc2GiZnXqUQbOIOog3hHmWn4gPR2Q+07FVAbvIoYVbZdSiq7DvnAF5Umf5rt4Gvy+orTe4G0OyS/9EHE2LF/z9JikgsGi8I6NUtly2+wzg2+WTI+9l2D/nqqt7oVzvBZ/J9ORFpePwIVs0SrzmHMKrAQ9GkaiVc8giyaroMueBZjnhqZqoJ46EnvHPWtzUznwBs=
X-FE-Last-Public-Client-IP: 105.224.1.22
X-FE-Policy-ID: 5:3:2:SYSTEM
X-Spam-Status: No, score=3.2 required=5.0 tests=BAYES_50,MISSING_HEADERS,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,
I viewed your profile on Linkedin regarding a proposal that has something in common with you, kindly reply back for more details on my private email: nikkifenton323@gmail.com

Nikki Fenton,
nikkifenton323@gmail.com



























































