Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB313BE960
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhGGOKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhGGOKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:10:36 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF19CC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 07:07:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c15so1107154pls.13
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 07:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=K0hkj1LylnIdpGSaYb3oPWajIGwhEUOsi//GUlIep2o=;
        b=qHbW6maryYiWxWlDCqe53OVDUmWP8I0NjsRgV70x9/NPfdF+xNfL/9wKvYBm7OGNp/
         5Hgbs2CGYFt2DuNQ1lycO85iknFDNqFqQtinb/eL3xTUfdTyEwM3Hfus74ARbZJDUB8u
         EbixpEevlJ8yjQnfUAuiXZD/swWVmQ4Z3/7OdNkYnv1M2dRNDyCSsy2IB1yuzambZ/eF
         MyKz7o+msZvtEhhYZA+q5lCMEZG39NwmuQ6kPQn8UDImrNipkkEc6fkWMkW1xsoDZ7Su
         dJrXBzXgB07CcxB/yC5XPzsU1T6XTmbsd28qDnNzUD6THK6LUmQbfDl4+QT67XpqOMgr
         E4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=K0hkj1LylnIdpGSaYb3oPWajIGwhEUOsi//GUlIep2o=;
        b=U1wQU+Ge6oBg4snAl1rqrL8L7Etm5osTyQ7WuDCRdfpeiwOrC14QYy9DaR5HLZtNJ/
         6iI8rWRID8xFGafx83+tDkpNVp+iI7hynw3rDQz2UFJEPlynwJW1HEI3Er1UM4SBE/FR
         EBDbJP+nbwv/YM4VbWSih8egdztpbYLwtDyptT7haCREbVj+z93p0yJFw7sP1hbVyk4F
         Bdvm8PIG4WCa+sLzar/F6hpCsbqSL4CIJLWFmVF0C4ExAoSb6V3ifpH9x1PQ2147CfI/
         C9wxabz7HanGEwnmun+pTdgv3aGuZ6CowUc2RhpvhDvr7dc6YAW3ODpCSb9hVtws89nk
         80Jg==
X-Gm-Message-State: AOAM530qwHp6dB6t4oL42dZTtN1FKKwpTnQ0X65WijX8DL7UiEEBpLoH
        wF7K8/1ExgPI+aJmjhIEhtWstXMZxFFTjw==
X-Google-Smtp-Source: ABdhPJxgeeKzV24ixXf9JYp2zsJRzypzmXupGaYVBzvq/fdI4ABWt6mIW00iEWmd4Fx62kCDDdfGlA==
X-Received: by 2002:a17:90a:c8b:: with SMTP id v11mr6156547pja.114.1625666874912;
        Wed, 07 Jul 2021 07:07:54 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id e16sm13187404pgl.54.2021.07.07.07.07.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 07:07:54 -0700 (PDT)
Date:   Wed, 7 Jul 2021 07:07:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 213669] New: PMTU dicovery not working for IPsec
Message-ID: <20210707070752.47946d92@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 07 Jul 2021 09:08:07 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 213669] New: PMTU dicovery not working for IPsec


https://bugzilla.kernel.org/show_bug.cgi?id=3D213669

            Bug ID: 213669
           Summary: PMTU dicovery not working for IPsec
           Product: Networking
           Version: 2.5
    Kernel Version: 5.12.13
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: marek.gresko@protonmail.com
        Regression: No

Hello,

I have two sites interconnected using ipsec (libreswan)

the situation is as follows:

X <=3D> (a) <=3D> (Internet) <=3D> (b) <=3D> Y

So you have two gateways a and b connected to the internet and their
corresponding internal subnets X and Y. The gateway a is connected to the
provider p using pppoe. The ipsec tunnel is created between a and b to
interconnect subnets X and Y. When gateway b with internal address y itself=
 is
communication to the gateway a using its internal address x. Addresses x an=
d y
are defined by leftsourceif and rightsourceip in the libreswan configuratio=
n,
you get this behavior:

b# ping -M do x -s 1392 -c 1
PING x (x.x.x.x) 1392(1420) bytes of data.

--- ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

b# ping -M do a -s 1460 -c 3
PING a (a.a.a.a) 1460(1488) bytes of data.
=46rom p (p.p.p.p) icmp_seq=3D1 Frag needed and DF set (mtu =3D 1480)
ping: local error: message too long, mtu=3D1480
ping: local error: message too long, mtu=3D1480

--- ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2014ms

b# ping -M do x -s 1392 -c 3
PING x (x.x.x.x) 1392(1420) bytes of data.
ping: local error: message too long, mtu=3D1418
ping: local error: message too long, mtu=3D1418
ping: local error: message too long, mtu=3D1418

--- ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2046ms


Legend:
x.x.x.x is an inner ip address if the gateway (a) (or x from the inside).
a.a.a.a is an outer address of the gateway (a).
p.p.p.p is some address in the provider's network of the (a) side.

So definitely the ipsec tunnel is aware of the mtu only when some outer
communication is in progress. The inner communication itself is not aware of
icmp packets using for PMTU discovery. I had also a situation when also the
outer pings did not help the ipsec to be aware of the MTU and after reboot =
it
started to behave like discribed again.

Did I describe it understandably or should I clarify things?

Thanks

Marek

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
