Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3E38DFFE
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 05:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhEXEAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 00:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhEXEAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 00:00:25 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6C1C061574;
        Sun, 23 May 2021 20:58:56 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id c10so19759512qtx.10;
        Sun, 23 May 2021 20:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KthjrxwbvYGpZ3e6LbQTyiB1kjUlQ5KLfPlDMi+SCY0=;
        b=T2oCXd9cW1BQDbbgU9vIUXP0IO/Cn+hlsxmDJhifNtlvrfL+VtZtUr3o02+BF/dKbl
         XVsfRcBzEbfVJER4lIKR3v9IHUhN7DzC6ft24BYHZMTWKRWPfJpiGulCBhn1Redmm+QR
         cHVLOAtE+viZ9Z1VKR9ANowKPOTlbQB+w5SOlzleyNeW5LaCFpYNUES45tOBvTfEBb+N
         Z+e3MKvZRq4BeeSCpxaxC1yUOwkzJgZQmNqUTBZuGanDG5RskwjvlqEE59xhbIyKslDH
         muQZiXC4fM7FF8msZ0RTsNhYyoMd16BdaaMi4XDQApAeXoEXdKwsM0e6BRvIW7SAW0uA
         toyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KthjrxwbvYGpZ3e6LbQTyiB1kjUlQ5KLfPlDMi+SCY0=;
        b=ghfSPSsHGdhW+FgA6dL7gaF0SK75J2LvqS83rHMhKe9m3ObFtNZClz8Wly4COkJ9sX
         P1boVErwUYutPhFTvs0VEFcNoNJ4z3YPbUxuzcRIgOHzmpdhjtJPUl3J4J5OXf8Bnrbo
         lU/Mvt2xrOcScGyvfxVCdBRI9vJv22nWUD28ul/gpAichB6qqkbcgH4TQp/yfYjcEp1w
         zoB7Gm9pfNjMSl3ld+UqAFhDbQ+KCwu6gJ7/TI20pa5IfeOa1BYVhHNpeOZPtVX92yX5
         /1pQj3r70SwOS9l/+GW+72t8+90e6dzI1RwY/p76NCw8al+wyPVQqMbATxl/ZvSeXhxV
         D/og==
X-Gm-Message-State: AOAM531qBJRlWsU9ZUkgLeWh6Yh2U3VkVz9z75HxP8DYFvs2ODyHxzHk
        NsYGHNTIN17H+GkQBTO8TGubLLk8zp7zmQGczdY=
X-Google-Smtp-Source: ABdhPJxDmkQfvIqs1KdsrlWef3bBm57FB+gWGR3InCzvSNYlHk9qKSdJce3/+EEfio98dIZSq2EbkyR8+xF/BMuJYVg=
X-Received: by 2002:a05:622a:1044:: with SMTP id f4mr25315648qte.181.1621828733650;
 Sun, 23 May 2021 20:58:53 -0700 (PDT)
MIME-Version: 1.0
From:   dzp <dzp1001167@gmail.com>
Date:   Mon, 24 May 2021 11:58:43 +0800
Message-ID: <CAKtZ4UP8pnSOtRRFsfDJQjT9SnsXcHpxiqEHXpCrjPBuPo443Q@mail.gmail.com>
Subject: remove unnecessary brackets
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000008e69f205c30b6db9"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008e69f205c30b6db9
Content-Type: text/plain; charset="UTF-8"

hi list,
    this patch remove unnecessary brackets for ipv4/tcp_output.c

best regards

--0000000000008e69f205c30b6db9
Content-Type: application/octet-stream; 
	name="0001-ipv4-tcp_output-remove-unnecessary-brackets.patch"
Content-Disposition: attachment; 
	filename="0001-ipv4-tcp_output-remove-unnecessary-brackets.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kp22y1ib0>
X-Attachment-Id: f_kp22y1ib0

RnJvbSBkNzM2YTVlNGE5NjZiYmZmZWQ5MGEwNjQ3NzE5ZGRlNzUwYjI5ZDA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBaaGlwaW5nIGR1IDx6aGlwaW5nZHVAdGVuY2VudC5jb20+CkRh
dGU6IE1vbiwgMjQgTWF5IDIwMjEgMDM6Mzc6MzYgKzA4MDAKU3ViamVjdDogW1BBVENIXSBpcHY0
OnRjcF9vdXRwdXQ6cmVtb3ZlIHVubmVjZXNzYXJ5IGJyYWNrZXRzCgpUaGVyZSBhcmUgdG9vIG1h
bnkgYnJhY2tldHMuIE1heWJlIG9ubHkgb25lIGJyYWNrZXQgaXMgZW5vdWdoLgoKU2lnbmVkLW9m
Zi1ieTogWmhpcGluZyBEdSA8emhpcGluZ2R1QHRlbmNlbnQuY29tPgoKZGlmZiAtLWdpdCBhL25l
dC9pcHY0L3RjcF9vdXRwdXQuYyBiL25ldC9pcHY0L3RjcF9vdXRwdXQuYwppbmRleCBiZGU3ODFm
Li41NDU1ZGUzIDEwMDY0NAotLS0gYS9uZXQvaXB2NC90Y3Bfb3V0cHV0LmMKKysrIGIvbmV0L2lw
djQvdGNwX291dHB1dC5jCkBAIC0yNjIwLDcgKzI2MjAsNyBAQCBzdGF0aWMgYm9vbCB0Y3Bfd3Jp
dGVfeG1pdChzdHJ1Y3Qgc29jayAqc2ssIHVuc2lnbmVkIGludCBtc3Nfbm93LCBpbnQgbm9uYWds
ZSwKIAl9CiAKIAltYXhfc2VncyA9IHRjcF90c29fc2VncyhzaywgbXNzX25vdyk7Ci0Jd2hpbGUg
KChza2IgPSB0Y3Bfc2VuZF9oZWFkKHNrKSkpIHsKKwl3aGlsZSAoc2tiID0gdGNwX3NlbmRfaGVh
ZChzaykpIHsKIAkJdW5zaWduZWQgaW50IGxpbWl0OwogCiAJCWlmICh1bmxpa2VseSh0cC0+cmVw
YWlyKSAmJiB0cC0+cmVwYWlyX3F1ZXVlID09IFRDUF9TRU5EX1FVRVVFKSB7Ci0tIAoxLjguMy4x
Cgo=
--0000000000008e69f205c30b6db9--
