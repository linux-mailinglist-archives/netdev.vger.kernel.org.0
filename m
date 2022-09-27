Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92675EBB0C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 09:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiI0HBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 03:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiI0HB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 03:01:28 -0400
X-Greylist: delayed 967 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Sep 2022 00:01:27 PDT
Received: from chywmqxp.webtekhosting.com (chywmqxp.webtekhosting.com [194.87.231.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D24E5C37A
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=webtekhosting.com;
 h=Content-Type:MIME-Version:Content-Transfer-Encoding:Content-Description:Subject:To:From:Date:Message-ID; i=mil.duk@webtekhosting.com;
 bh=oZyWtpyOd0g2W+TiHPrJ405bv+w=;
 b=gfkEh3y5MVFaiYXuj+PTPZoE1MrrSKs0MHFYAri64n7OWcAEhmnoZIVj7ay8v8kK+1jnx/3hmYB2
   VHHTDI5lyKC+kVt/3ksWQxSe20VtrIPDysVjEmBpLMqKESf/5WV25AIfnbD5UA89O0QWcbfT0Jn1
   khcK/dYkadFkyDAc4sn9vGFNfjK6DE5SoF2h9K2tnA/ilYHYUV9yWyAksaoBfveqccXITnO3aPlv
   8G/ouRqZ6L1kvNePyi+ERaYGckooo6Nn9sqx0oL7H0ieZRoQGsbk53L1y3cUzD+7Xy9nSSBWeYy7
   bf6+UBqrDd2REUifTzk+qFuC7qgZeVLnzjONBg==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=webtekhosting.com;
 b=GrBZ7j1IdgVYe6NORJG5SCf3VFHI0LO732xJ+fD+J36MO9NXNQHhdha+ckP4GB9e1NLMGp8HwHsX
   9ZeY1MElnxOWErqAipyQ/uDcD9lNDfWHUSGvlAcZ2kR/a+xJAdpQ9lpDEqrEMRKzBtu4rFPZr7Tb
   p1T0NEKef/hgiqAAvGhOKUVHuI5gLA6mNjcYyqg0xoDFu7u8mTr4NwHEgFYzSn9iUp4IfKRgBMtH
   8/3RuWv9cELqkayKu41ZPAGWD3nVZd0aN7tj/gTqtxl6nZtZFjW2oO4pIlFfFl6lR4qoSYzTCa8p
   Z1Gjh9IQO+gpM/1KhkZRzjMFep5YaWcozVqFbg==;
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Business Insight
To:     Recipients <mil.duk@webtekhosting.com>
From:   "Alek Brian" <mil.duk@webtekhosting.com>
Date:   Tue, 27 Sep 2022 08:45:14 +0200
Message-ID: <0.0.0.BF8.1D8D23CB593463C.0@chywmqxp.webtekhosting.com>
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NIXSPAM_IXHASH,RCVD_IN_SBL,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX,
        URIBL_BLACK,URIBL_SBL_A autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  1.7 URIBL_BLACK Contains an URL listed in the URIBL blacklist
        *      [URIs: webtekhosting.com]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        *      [194.87.231.164 listed in zen.spamhaus.org]
        *  0.1 URIBL_SBL_A Contains URL's A record listed in the Spamhaus SBL
        *      blocklist
        *      [URIs: webtekhosting.com]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [194.87.231.164 listed in bl.score.senderscore.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  3.0 NIXSPAM_IXHASH http://www.nixspam.org/
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  1.0 TO_EQ_FM_DIRECT_MX To == From and direct-to-MX
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My name is Alek Brian, Researcher at a reputable company in the United King=
dom , I would like to share with you some business insights .

Please Kindly reply me on my personal email brianalek510@gmail.com


Note: You have the right to quit by the end of my detailed explanation and =
you don't feel like moving forward with me.

But Trust me, you won't regret it.


Best Regards
Alek Brian
brianalek510@gmail.com
