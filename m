Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F5D1F5793
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 17:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgFJPSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 11:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgFJPSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 11:18:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDAAC03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 08:18:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u5so1129193pgn.5
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 08:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=njwXkRLhpbwJpwE28Xoyp4QDD0utuEbplByiFs2TJNM=;
        b=zcLg7VvaihtvTwWpJP+aFNIujEis7B74/M5WLWXj+2dFdGo0dY8K+UOqTGE9wp0GKQ
         cDHlsfyuJRiugBCwZZV2qYlrnj4nnBmxdhYoxf42y/Uei2pBKacv4iKRpFbhxu72K+oF
         ABDIa+jhzVBcpNN3f0vNCJ7t4ZD7zs8jPapE96ZHsF7lmlmd2TPQTZRjw3AdhnQq4Qr5
         /W+3LI/ILR+Q3j2lQWsOcCafuzC47yRxGSYssSRELhmiGrUH7ATb8sHnu6yE61S3zVnU
         cxZ7adbIRUDXYRXi5XDCTmNcncZBIPGM5EAS6HKPTJUQjUcp3/4ykEdb/hB5SATAOla2
         qbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=njwXkRLhpbwJpwE28Xoyp4QDD0utuEbplByiFs2TJNM=;
        b=RDyZ4upeYzltbX6MPhx2eurHfHbNdD/VRMtmRIuUq4jpw1GiKNc6RyVQSMei65wmCy
         3cWB3s0RiEn062gvn2AzxRq5MI40B6d4htZ4N5d039D5KzP7XW2uyZkqk5ZZuRZ0hSH0
         su+JjdMQBs5lzVqjAlGZLt+O5uSUpp3y71zDE59FIRfu/Z8TEbFRwHuxkAOT15VZlDPD
         5DIlEQmnryWSJtscOj/w/gedDRi2h+97Po6DfQt9flBJZPh537P3GxxaM0JnshGx1R8J
         DrezDc0DzkRdby4f3aWKyPM1G42t0Pk8AnvY2VMdvqK6sqt7rQ0FsMRywcJT0p/QLsQh
         FVxA==
X-Gm-Message-State: AOAM5310ACJOW47vGTewXDYKllg4m/F6lJ8HShtQfHDnMA2Uw00XNbWJ
        v4Fe7d/h+AFI3GgzLAJhZlI58HgBx1Q=
X-Google-Smtp-Source: ABdhPJyrZkFven5bSQTCdJ4Au++YjP3QZ2Klgbi26HD7WLcnm1KyW3yQ7iTGmo0d3AHxD63WuzGCjw==
X-Received: by 2002:a63:c5a:: with SMTP id 26mr3034867pgm.270.1591802312390;
        Wed, 10 Jun 2020 08:18:32 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q92sm126927pjh.12.2020.06.10.08.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 08:18:32 -0700 (PDT)
Date:   Wed, 10 Jun 2020 08:18:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 208121] New: IPsec AH ICV Padding for IPv4
Message-ID: <20200610081823.35098936@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 10 Jun 2020 09:32:26 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 208121] New: IPsec AH ICV Padding for IPv4


https://bugzilla.kernel.org/show_bug.cgi?id=208121

            Bug ID: 208121
           Summary: IPsec AH ICV Padding for IPv4
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.0.37.40
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: markus.gasser@elektrobit.com
        Regression: No

Created attachment 289597
  --> https://bugzilla.kernel.org/attachment.cgi?id=289597&action=edit  
packet capture

According to RFC 4302[1]:

> As mentioned in Section 2.6, the ICV field may include explicit
> padding if required to ensure that the AH header is a multiple of 32
> bits (IPv4) or 64 bits (IPv6).  If padding is required, its length is
> determined by two factors:
> 
>            - the length of the ICV
>            - the IP protocol version (v4 or v6)  
[...]
>    Inclusion of padding in excess of the minimum amount required to
>    satisfy IPv4/IPv6 alignment requirements is prohibited.  

However, in the Linux implementation padding is always added (and expected) so
that the Authentication Header (AH) is a multiple of 64 bits, independent of
the IP version used. This is an issue when the IPsec AH with IPv4 is used with
HMAC authentication e.g. HMAC-sha256-128. In this case the ICV field is 128
bits long, which results in an AH length of 96 + 128 = 224 bits. Even though
this is a multiple of 32 bits, Linux adds an additional 32 bits of padding.
Additionally, Linux drops incoming packets that do not have this padding.

In the attached file the outgoing packets, that are wrongfully padded can be
seen.

[1] https://tools.ietf.org/html/rfc4302#section-3.3.3.2.1

-- 
You are receiving this mail because:
You are the assignee for the bug.
