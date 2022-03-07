Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C494D080D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245184AbiCGUAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235271AbiCGUAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:00:54 -0500
X-Greylist: delayed 1820 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Mar 2022 11:59:59 PST
Received: from uncle.firstenglishco.com (uncle.firstenglishco.com [194.31.98.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16466A026
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 11:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=firstenglishco.com;
 h=Reply-To:From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding; i=the.sey@firstenglishco.com;
 bh=fQjlghp2rBsdiUgJ67JpIDLfFEQ=;
 b=dX32yzuvgch0eVTzkrsHzF2qiyHuDWUNOOb5WbWjiqhIJhzVNhK3lYKps9h9EMAoJuPo9BeyswVP
   DvOKz4P8+PdmbDBWdixouaw/edCpH4vHFZIm3IsMHYpRx8GRKNIDEBbiqa6dzplsxizDQgvXJwpw
   gG9clpm/etqT44l/w7iJ7yAvhHSeUrhmEtADxft9HXkpszs7//DZRITK0yLg5bkFIwJetJ1Rf0uz
   DAfMr6j28AP0FXqGgtczRt7Z8kYoVpSr+9ENA+6+aw64xVymCow2NvQB1xyZPJD5EXmJFOqpYI6s
   qFgTP51g1nllBQdJu0zua4gWcT+Cl1qbNgZg0A==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=firstenglishco.com;
 b=We3AnSQQzPxxjVRgEb77L4KohAE9/rOLYFcURx+Sta/qFTMvyOPy/dHTcsqi4Ko7xO/OyJEYTZxw
   CELY0Z9xsCuLu59VkMjqmQVv6t3irpxr2tH8Cssi6xjpihI+iaXqR8nHQX1ztyu4KU6ahK4le5oK
   JNspAmZY9WVI3FZUpwDu220PdTa6mA5HZjGr5RUmYJkIe4KNbOtz+q6mhofzSU6ZgbuYA4+B6f8L
   ZY5apIJRpA/iSvuKNtk7Z4tIVpLf/ZZTQUR6aU8qPtNjkwJ+vFJfh4x45/3Tdidmc/s/sisRf9PQ
   TpdUb1CJPcaFg6E19x/AfHC/VnIBQIwM0TaNkw==;
Reply-To: eymencemil404@gmail.com
From:   the.sey@firstenglishco.com
To:     netdev@vger.kernel.org
Subject: 073HSBC
Date:   7 Mar 2022 20:29:35 +0100
Message-ID: <20220307202935.65D356A5FCBC15F4@firstenglishco.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_DBL_MALWARE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  2.5 URIBL_DBL_MALWARE Contains a malware URL listed in the Spamhaus
        *       DBL blocklist
        *      [URIs: firstenglishco.com]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9554]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [eymencemil404[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings netdev
=20
Good Day. Hope you are well.
=20
I hope my message finds you well and healthy? I am contacting you=20
due to my recent discovery in my bank branch and a profitable=20
proposition for you. I will give you more details regarding my=20
proposal when I get your reply.
Thanks for your understanding.
=20
Best regards
