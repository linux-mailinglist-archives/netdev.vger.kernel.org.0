Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE3192C5F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCYP0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:26:47 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:36152 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgCYP0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:26:44 -0400
Received: by mail-pj1-f42.google.com with SMTP id nu11so1144074pjb.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Jo1o8WxGsR4DDjQOkaqr5qz7Kw+VMjKaOlUaj2WGXt4=;
        b=mwgeZr6oL2gjls+8FIIus07Io/TGvStVa2i/+pcQzwxyxcGXJWu7B4f2PIzMbdempI
         57eZ6HEPSFPEQv7hKdY58SLZ2hO709YKMc1IxHmvXI3pUl8iiMQ7pkV1RaMDXDV0gsQe
         jmBjIP6o6bbMDQyA0UWczeqFc1WjGph7xG1oj9iGFWZCrTAAQ/ZGqVNbJbbz/bXav+5n
         1uXbmspVYUGCmsUuXh+kwTOvA5NGAgKTxC8b7AqXFD7z+RAJXauGAQIsKs7feSTSyM87
         IGkoB7zAXdGKNJbCSRWMVaYkbrHaEkvcXohVvswybejGddPE4/WdUtPDf8x0XWOM64Oj
         UF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Jo1o8WxGsR4DDjQOkaqr5qz7Kw+VMjKaOlUaj2WGXt4=;
        b=is6AYWI28gHFUWNpQcF8903eOlibxAepgZCdU6+oYyrYRF/HAt3I5mgjQT17jYoRYO
         dEtYOxPI916I/ocyJoNYQ+Imz6syXB5n0T/5OUSDGyYGRKJUoBnvJISU48sB0Ss3T6v6
         1haF9y41uhtqOabnDqzlWmB/oWzQrlS67EWMPirDoroSu64izVXXZWilj/dp7/wP0sKM
         7FH+jlKo8xk6P+8PQjyiGtaHUXA3CVR2PbacWrW+MYrB2tchqyxSiM1Bd7L8rHJEF9mF
         /7QR/i/41MM+6kOzkA1LFjwuJhw4FBz6OZjTqhPd2VnIKQKKvGrtRb+qK83xJi9HtFpt
         Cnkg==
X-Gm-Message-State: ANhLgQ2N3hoFTe9zr/RDyb7ealynZlnM+V1XCQ/v+udZCFj/l7M7vEY/
        SkO8UF7yNyqD9dg8wNSpXj2Xu03vhkY5kw==
X-Google-Smtp-Source: ADFU+vuJpgQUwzipgBLSBjCIB2/dcq6OvaAsOl3PTZw1e0DDFQlunYI2aAX0D5yLcg6QblYVW3NjFg==
X-Received: by 2002:a17:902:7008:: with SMTP id y8mr3727469plk.279.1585150001641;
        Wed, 25 Mar 2020 08:26:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e187sm18658553pfe.50.2020.03.25.08.26.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:26:41 -0700 (PDT)
Date:   Wed, 25 Mar 2020 08:26:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206943] New: Forcing IP fragmentation on TCP segments
 maliciously
Message-ID: <20200325082638.60188be0@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 25 Mar 2020 08:37:58 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206943] New: Forcing IP fragmentation on TCP segments maliciously


https://bugzilla.kernel.org/show_bug.cgi?id=206943

            Bug ID: 206943
           Summary: Forcing IP fragmentation on TCP segments maliciously
           Product: Networking
           Version: 2.5
    Kernel Version: version 3.9
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: fengxw18@mails.tsinghua.edu.cn
        Regression: No

A forged ICMP "Fragmentation Needed" message embedded with an echo reply data
can be used to defer the feedback of path MTU, thus tricking a Linux-based host
(version 3.9 and higher) into fragmenting TCP segments, even if the host
performs Path MTU discovery (PMTUD). Hence, an off-path attacker can poison the
TCP data via IP fragmentation.

-- 
You are receiving this mail because:
You are the assignee for the bug.
