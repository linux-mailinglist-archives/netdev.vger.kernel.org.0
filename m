Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7C84278C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfFLNaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 09:30:13 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33428 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731349AbfFLNaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 09:30:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id k187so8443684pga.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 06:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=r+Z6ENHOd/pxyq2jZaZiWtzwxfMq+O5WPqbpYAgDOps=;
        b=GDlsuEVZRf+yO6PBnCD2wOaunv4j3CEhvGbv3DqihqG4+EaZLyfsda8tkLaizsWowA
         A26/Sil5xltoWomq3WKONFSSL4iNL4USji1zYiScGAlmDU3LaKUsSwn86BfPIpTbet2F
         9NE7FNQu2qO7HkjGcC1DgOhsesHBcRBBqgpNLgXdHjmAcEqxWSqEeuFRYaOp34nrZLns
         GSsSB4dcEx/tv0i/+LAXSEBrvrXlubPalRm88TwmCS/vFD6Lyqqnm4gmRii6c+rEHVfM
         P3CBL2Y1F40Ouilrsx0zPdMTpzIao1SXDj/yojPKo7Ao9+9LjfsCOE7ET1ERPiB3U4wt
         hE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=r+Z6ENHOd/pxyq2jZaZiWtzwxfMq+O5WPqbpYAgDOps=;
        b=R7bw9eLUsDlbr8igrN+EICa1XC27/DHtPEn5H7Tm4930dXoeQi+I4NRqiNvpwrDHoD
         cN+n3NV5oQAHFAtqf+W74Zu4d3OH3YpvPyYqIz2ACRXbnMA+hkUITOopVKuv+iIf5wlE
         aGCRewIbnRhf/Bu8WePZPbBF1QGO2Vvlmr+3msFvfcp4g7VoLJ1pd1CwyOk4i5L8eNjk
         YHFqkREvTSDB2vw4HyoLM91GN9rXhN4KI8S0fI2BxfcOp7shNGI05lAJcaeXqjqAt+bI
         M9DKFiXvKjBAJ1LRxbCXKjGRWgfAS17mDgGn+e6Mqad1gmpvdJbyKM18QpKYJaKkFy0o
         sdmw==
X-Gm-Message-State: APjAAAUDiW/XoUCj0YuwwhCTEbDAQcD31WWXKHrlJJhhR1iAWrxcoX0H
        8GMbXkNwITTJ5O+HAn2amNF/nAYf13U=
X-Google-Smtp-Source: APXvYqxXv2RSKFMOk/j0KIEjpJL0x+XXhw/h7pkOaa3OSYHl2Nuq9sjKRVLDaaFB2hq8emZpOnBfRw==
X-Received: by 2002:a63:2848:: with SMTP id o69mr25205536pgo.258.1560346212608;
        Wed, 12 Jun 2019 06:30:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i5sm4083pjj.8.2019.06.12.06.30.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 06:30:12 -0700 (PDT)
Date:   Wed, 12 Jun 2019 06:30:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 203867] New: invalid parameter to NL_SET_ERR_MSG_ATTR() in
 vxlan.c and geneve.c
Message-ID: <20190612063006.31e27272@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 12 Jun 2019 07:49:06 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 203867] New: invalid parameter to NL_SET_ERR_MSG_ATTR() in vxlan.c and geneve.c


https://bugzilla.kernel.org/show_bug.cgi?id=203867

            Bug ID: 203867
           Summary: invalid parameter to NL_SET_ERR_MSG_ATTR() in vxlan.c
                    and geneve.c
           Product: Networking
           Version: 2.5
    Kernel Version: v5.2.0-rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: krkx2@sovintel.ru
        Regression: No

Created attachment 283213
  --> https://bugzilla.kernel.org/attachment.cgi?id=283213&action=edit  
patch for vxlan.c and geneve.c

Looks like invalid 'attr' parameter is passed to NL_SET_ERR_MSG_ATTR() in
drivers/net/vxlan.c and drivers/net/geneve.c for number of attributes.

For example `tb[IFLA_VXLAN_PORT_RANGE]` instead of
`data[IFLA_VXLAN_PORT_RANGE]` in piece of code below.

        if (data[IFLA_VXLAN_PORT_RANGE]) {
                const struct ifla_vxlan_port_range *p
                        = nla_data(data[IFLA_VXLAN_PORT_RANGE]);

                if (ntohs(p->high) < ntohs(p->low)) {
                        NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PORT_RANGE],
                                            "Invalid source port range");
                        return -EINVAL;
                }
        }

In case this is really a bug, patch is provided in attach.

-- 
You are receiving this mail because:
You are the assignee for the bug.
