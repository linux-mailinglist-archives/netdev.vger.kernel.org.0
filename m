Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0915467FD3B
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 07:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjA2G7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 01:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2G7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 01:59:04 -0500
X-Greylist: delayed 2144 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 28 Jan 2023 22:59:04 PST
Received: from host.studiog.us (unknown [45.33.198.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408CF12F3F
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 22:59:04 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by host.studiog.us (Postfix) with ESMTP id BDA174644A;
        Sun, 29 Jan 2023 06:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ascabi.org; h=
        reply-to:date:date:from:from:subject:subject:content-description
        :content-transfer-encoding:mime-version:content-type
        :content-type; s=default; t=1674973249; x=1676787650; bh=CVtESjU
        Kvnafk3T2GN6YxwR6+w/iBU8r/gqzE7wU7BE=; b=NCyU9wmKZkw/eg3nUud2pf4
        /AYb3Edu7kvV4kk1eq86h25GQSzSbUPNaWH3st3UiuiuSAeRfbYkhCy7S6O1gKYN
        kdauc9YoyjYAOsGVhMpo/8CrmFb2RHD1nLhAsyVsSHP3FkrEqfALiE0/Y5yoDYn8
        fJIIElM0oa+XgFskFb/A=
X-Virus-Scanned: Debian amavisd-new at host.studiog.us
Received: from host.studiog.us ([127.0.0.1])
        by localhost (host.studiog.us [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id o9wkVWz2RAtE; Sun, 29 Jan 2023 06:20:49 +0000 (UTC)
Received: from [192.168.8.100] (unknown [154.118.34.117])
        (Authenticated sender: test@ascabi.org)
        by host.studiog.us (Postfix) with ESMTPSA id D803E46441;
        Sun, 29 Jan 2023 06:20:44 +0000 (UTC)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Your funds release:
To:     Recipients <tes@ascabi.org>
From:   "Mr Femi Brown" <tes@ascabi.org>
Date:   Sun, 29 Jan 2023 07:20:51 +0100
Reply-To: info@ousos-elearning.com
Message-Id: <20230129062049.BDA174644A@host.studiog.us>
X-Spam-Status: Yes, score=5.3 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_99,BAYES_999,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        LOTS_OF_MONEY,MONEY_FORM_SHORT,RDNS_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_FRAUD_PHISH,T_FILL_THIS_FORM_SHORT,T_HK_NAME_MR_MRS,
        XFER_LOTSA_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_MR_MRS No description available.
        *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 XFER_LOTSA_MONEY Transfer a lot of money
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.0 T_FILL_THIS_FORM_FRAUD_PHISH Answer suspicious question(s)
        *  0.0 ADVANCE_FEE_4_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This mail is been writing to you because we have come to understand that
you have lost a lot of money all because you want to receive your fund
well note that all that have been put to a stop as the federal government of
Nigeria has promised to assist you with the sum of $5million in other to
compensate you and all you have to do is fill the below information s.

1 full name

2 home phone and cell phone number

3 occupation

4 amount that was lost by you

Send this and get back at once.

Warm regards

Femi
