Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52528D047
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 16:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbgJMOcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 10:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387516AbgJMOcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 10:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602599532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=1dyh4O/Po2RAeMBP/CljDCDOAkKkGegOjY+PWwd5bnc=;
        b=URdcr3AzFt3MPjlKoVpIRgGN/2Esj9JW+cjpgkFeWpvJaKy8YzJ1pp9qQdD3z6E4kRN9vR
        ygZ18I3TGFQJ2DX7d7pn6IFzFOqstZlz4aFQ0rEOnI7HVljiHQABf4oxWqLXlnx6LT+pBY
        go8x70ruElG1NrS7qgR9imxLt9VtNs4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-fex48MdeNl23rdc3nk5qDw-1; Tue, 13 Oct 2020 10:32:10 -0400
X-MC-Unique: fex48MdeNl23rdc3nk5qDw-1
Received: by mail-wm1-f70.google.com with SMTP id 13so61123wmf.0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 07:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1dyh4O/Po2RAeMBP/CljDCDOAkKkGegOjY+PWwd5bnc=;
        b=WynDGpec9tGowlWkeoO4P5fVBFbWGN1aAvY3nO4dNPX8iNtkOa6VpNzENh3j+XYY++
         aUjS8LljlY953gYwH9f5pG/VcW6CYvnW65K1kpFUoI3rv0kn6d8L6O4HbKNPYnTKBS0P
         ptMJa/utd+F0zci1H+Koni97wBPwfaifrnRnqpWlMt1gn/iM65qt7i175JVTbrh8wYwn
         Yw18zRDDJAJB5I4uV4EEqx4zvdKTJBmoMb+lkxs4OH+eXA67D4JLMvEI0QZC4BVn2ksR
         xMwTEmSBsis/osxU91CMkoed196zGHPs+BvNJ9oZgxsJIIWJEBE2PoCkCg52Vxp39+I8
         fprA==
X-Gm-Message-State: AOAM532XJtfMr5NqNxx8nH93LMyI/d/pr+nqrCVxk5ed3kOy6DOVFk7b
        ZaS/wu0hP9IYOIeBaNtMn0LshnbER/4/5nIEZYbBwZ6nzfiVMpVrugShO620VLMz/6co2i1aqUi
        YbNtzZiQ/XC0wXl0N
X-Received: by 2002:a1c:5602:: with SMTP id k2mr130810wmb.25.1602599529337;
        Tue, 13 Oct 2020 07:32:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRuyTCPY8kYdQZagAiLMV60oQBsFfiRpC13OJ3MzVDOKB09d+c6+aZeURIg4WNQWxF8L/I8g==
X-Received: by 2002:a1c:5602:: with SMTP id k2mr130798wmb.25.1602599529154;
        Tue, 13 Oct 2020 07:32:09 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id s185sm141315wmf.3.2020.10.13.07.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 07:32:08 -0700 (PDT)
Date:   Tue, 13 Oct 2020 16:32:06 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: [PATCH iproute2-next 0/2] tc: support for new MPLS L2 VPN actions
Message-ID: <cover.1602598178.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds the possibility for TC to tunnel Ethernet frames
over MPLS.

Patch 1 allows adding or removing the Ethernet header.
Patch 2 allows pushing an MPLS LSE before the MAC header.

By combining these actions, it becomes possible to encapsulate an
entire Ethernet frame into MPLS, then add an outer Ethernet header
and send the resulting frame to the next hop.

Guillaume Nault (2):
  m_vlan: add pop_eth and push_eth actions
  m_mpls: add mac_push action

 lib/ll_proto.c            |  1 +
 man/man8/tc-mpls.8        | 44 ++++++++++++++++++--
 man/man8/tc-vlan.8        | 44 ++++++++++++++++++--
 tc/m_mpls.c               | 41 +++++++++++++------
 tc/m_vlan.c               | 69 +++++++++++++++++++++++++++++++
 testsuite/tests/tc/mpls.t | 69 +++++++++++++++++++++++++++++++
 testsuite/tests/tc/vlan.t | 86 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 335 insertions(+), 19 deletions(-)
 create mode 100755 testsuite/tests/tc/mpls.t
 create mode 100755 testsuite/tests/tc/vlan.t

-- 
2.21.3

