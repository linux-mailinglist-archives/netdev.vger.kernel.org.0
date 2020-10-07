Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAAC28655E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgJGRBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:01:23 -0400
Received: from out2.virusfree.cz ([79.133.37.44]:49551 "EHLO out2.virusfree.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgJGRBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:01:22 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2020 13:01:22 EDT
Received: (qmail 32405 invoked from network); 7 Oct 2020 18:54:39 +0200
Received: from out2.virusfree.cz by out2.virusfree.cz
 (VF-Scanner: Clear:RC:0(2001:67c:1591::6):SC:0(-2.3/5.0):CC:0:;
 processed in 0.7 s); 07 Oct 2020 16:54:39 +0000
X-VF-Scanner-Mail-From: tc@excello.cz
X-VF-Scanner-Rcpt-To: netdev@vger.kernel.org
X-VF-Scanner-ID: 20201007165438.493894.32376.out2.virusfree.cz.0
X-Spam-Report: SA_TESTS
  0.1 RCVD_IN_BAD            RBL: Received via a relay in BAD VF mirror
                             [89.203.223.14 listed in bad.virusfree.cz]
 -2.9 RSPAMD_CHECK           RSPAMD: message is HAM with score -2.8900
  0.8 BAYES_50               BODY: Bayes spam probability is 40 to 60%
                             [score: 0.4626]
 -0.3 CRM114_CHECK           CRM114: message is UNSURE with crm114-score 1.080
X-Spam-Status: No, hits=-2.3, required=5.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=excello.cz; h=
        date:message-id:from:to:subject:reply-to; q=dns/txt; s=default;
         t=1602089678; bh=QU+sXI/g81OSzIbMDTIK7aOsHxH9GkCQwQnFAxM4Qq0=; b=
        iVhfEjbxTCya9I4Rbr8xw1qrLSWX6OlTO6TAlTCWKop5r8g8I6Oq3grW0Nj9dsiV
        tuAJfkao1ntuniIljRgnE8F9SDtU+/KmxdcQHFwfYM4i5g4aLq4smfBGoEbG6J9+
        JvkAC3hjajoSrxwNh1xlfK1xoRqQ6+cwcI9AzfWscys=
Received: from posta.excello.cz (2001:67c:1591::6)
  by out2.virusfree.cz with ESMTPS (TLSv1.3, TLS_AES_256_GCM_SHA384); 7 Oct 2020 18:54:38 +0200
Received: from localhost.localdomain (unknown [89.203.223.14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by posta.excello.cz (Postfix) with ESMTPSA id F3F429D3C87;
        Wed,  7 Oct 2020 18:54:37 +0200 (CEST)
Message-ID: <77e01ed3609e390e06d536d0c30eb8925a312071.camel@excello.cz>
Subject: Re: [PATCH net] tg3: Fix soft lockup when tg3_reset_task() fails.
From:   Tomas Charvat <tc@excello.cz>
To:     CABb8VeHA8yEmi-iDs3O-eRfOucWqGM+9p6gj87NLdjeQHfJROA@mail.gmail.com
Cc:     netdev <netdev@vger.kernel.org>
Date:   Wed, 07 Oct 2020 18:54:37 +0200
Organization: Excello s.r.o.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings, 
tg3 with kernel 5.4.69 is able to get into state, that its reseting
link forever. From mii-tools -w XXX I can see, that link is going up
and down every 3-8 seconds. 
Take down/up interface doesnt help.
However there is no any error in dmesg or anywhere else.

Tested kernel is not modular, only reboot helped.
NIC details are:
driver=tg3 driverversion=3.137 firmware=5720-v1.39 NCSI v1.5.1.0

Best regards
-- 
Tomas Charvat <tc@excello.cz>
Excello s.r.o.

