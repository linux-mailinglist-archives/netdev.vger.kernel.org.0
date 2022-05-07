Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61EF51E3E3
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 05:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbiEGEC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 00:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiEGEC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 00:02:59 -0400
X-Greylist: delayed 1804 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 May 2022 20:59:13 PDT
Received: from slot0.crystalscrop.com (slot0.crystalscrop.com [194.31.98.191])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351CC58E49
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 20:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=crystalscrop.com;
 h=Reply-To:From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding; i=info@crystalscrop.com;
 bh=vdtJwgFshmVn/X31MyHPWvuCG4o=;
 b=EFteemtr/7TvyEcDywJAs6G0EJqmbaZz4QLwdS4eFYNn6VDzYZ/jk5taoaLjvbE8uCGzfeOEQVgk
   tpupG/+ylAz/S+gOL33fpy3YKYOLYQe1XlqX2aS2DYhsXhZNXmRwWUweREF2IjSr5GsS7K57Drh1
   yBFo3JNLWFmkATatNoFG2QX0iSDKNilTGK5wTVaz7Ow/EayKZd3CEeaZZWsiQ+EAo43+74GCYMss
   MSyj0iMNIqBTqSAXZT6Q7RjZVkRgy8ZYyiTB9hI5DVqjKFJbprjmscXalt8TuDz9nT49FeyWA4r5
   n30C5iheoIGZitG7cSop23MzkulAUSQM4X76jQ==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=crystalscrop.com;
 b=oqmuVXFg1iBwXXPpkbw9QxhSWOTzslrtkeR6CYXqoQz+BSaMtDZPhefj9KXiuW1/PqV1SKzq8CZh
   pV8jsgIoVOEMvUPeD2J/7YzrDu2FAI6OfkSqI5+8ZJchJhCgCOR5JKjJMlKF25lkdiJamrlnok68
   VYYx5fjKjC2b1nDjC7t6+VYCIZFhEj/EMzqNB0ZEhpdO5ew3eF4d9MlR9VCvENLjWuyaK/0yitu5
   KANxfu2zGOvqgvXIo2Jb/3CrgzdBTnDeTBOlFk5BiLWODvKZYyrwJbzFMDIO9GDpB4fq6lTSPrNQ
   dGO4lxeHqHg3Qk8uO1oyX1O2ALwZIy1E2IToIg==;
Reply-To: info@riitter-sport.com
From:   "Alfred" <info@crystalscrop.com>
To:     netdev@vger.kernel.org
Subject: INQUIRY
Date:   6 May 2022 20:29:05 -0700
Message-ID: <20220506202904.01AC3356205ECBF5@crystalscrop.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_MISSPACED,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_CSS_A,
        URIBL_DBL_MALWARE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  2.5 URIBL_DBL_MALWARE Contains a malware URL listed in the Spamhaus
        *       DBL blocklist
        *      [URIs: crystalscrop.com]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [194.31.98.191 listed in zen.spamhaus.org]
        *  0.1 URIBL_CSS_A Contains URL's A record listed in the Spamhaus CSS
        *      blocklist
        *      [URIs: crystalscrop.com]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8107]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 FROM_MISSPACED From: missing whitespace
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings sir/madam


Alfred Eugen Ritter and Clara Ritter, n=C3=A9e G=C3=B6ttle founded the=20
chocolate and confectionery factory at Innere Moltkestra=C3=9Fe in the=20
Stuttgart district of Bad Cannstatt and the first cornerstone for=20
Ritter Sport's chocolate history was laid - this was where the=20
first "Ritter" chocolates were made and sold.

We have got your contact from our Agent and we are in need of=20
your product as we wish to establish a business relationship with=20
your humble firm.
Kindly provide us with your updated catalog and prices for our=20
preview.
Please indicate your payment terms for our review.
We will get back to you with order details


Alfred T. Ritter
Executive Purchase
https://www.ritter-sport.com
E-MAIL: info@riitter-sport.com
