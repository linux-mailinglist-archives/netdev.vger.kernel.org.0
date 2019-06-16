Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5583A47483
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 14:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfFPMo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 08:44:59 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42653 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfFPMo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 08:44:59 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so15414969ior.9
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 05:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WfbihrWIu1aL1UIEO96qVZ+FA5vCGiQTYYQ7NMEMj4A=;
        b=fApG/6k/N1t3we1hx3+YKgo37QJIN9KaSa1wA73tTjx2uW+3USuzlfn0hfUCfQeIog
         CeiRJ6Q0Kr3oO3dD8/uM12CpHqJf+Cu7r4hLQIqMX8gtMlLqrtFNnPYK7FJ3ej9FF0AB
         F7SsHcBM+mlOFCu/EcJXl+U8YOC25BF8EJe+bqX2g95wJVFeZfiw7XLtIjzUeZt/UAVC
         R36rtwp7zdTJTNs5opzI+HuF/QZSlCbLq3xQsyWiSdH0yvWWga9rCg+4414Bt0MlSA2t
         eNSgcXUTD/lMo/ym9at9E19zbe7RbAMyZ0iuY+H+mJ949TrhzGFjLuZaY95KjSZzpzNv
         9Ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WfbihrWIu1aL1UIEO96qVZ+FA5vCGiQTYYQ7NMEMj4A=;
        b=TRzSA/8j6nwH5C4FMXrcHSR0XmrLJNIJkaVnliuJSw72FDRjDrUq77td8tDFOjrID9
         1OXL79Sg4Bp3qs89G779LkOzEX1k/MS9KlE/5nYr0G5iU+tqzjmj8ELCdM7knXFjtfUU
         u/D0qAfW8/Ap+B3+6Y4ZbRdR60zjzgMnTAQcs/2do+k4HVIACits6ScgNloRp/F2EyyC
         U2KKiItJCdOt84D74PF0/6U5F2IxM3DlHm9AlrJCPY+gzUh6MKICP3Em66Ef+FEbRvSX
         +GCGe9bLRGBzK7tKMih5i+w8/jXi0OgNV0+Z73MzqMa/kw5ivdt6MzFbTa1pH7EXh5fR
         TUaA==
X-Gm-Message-State: APjAAAXM6isY1yVRiX0bNPxUa3iMi1H7qpa5/UvsgKzyGRehu+tSoGwk
        tlPks99tLUKcptP9UeUOnWCe1WSzp8J17V3pdjOsMoN7nA==
X-Google-Smtp-Source: APXvYqxmwfuAk3eQA76GzYmnS8Fmh7bGv+HkHwbeRlxAmMQ2HUmnwcI9LI0psUWp+Mk++wyH4OM8YTXTtu1skHVjozE=
X-Received: by 2002:a02:3308:: with SMTP id c8mr10522295jae.103.1560689098677;
 Sun, 16 Jun 2019 05:44:58 -0700 (PDT)
MIME-Version: 1.0
From:   Avi Fishman <avifishman70@gmail.com>
Date:   Sun, 16 Jun 2019 15:44:23 +0300
Message-ID: <CAKKbWA4OaYGXpOD3MBqvj_cdD8YFiVSgJ7yjhdtKv+Goad1=JQ@mail.gmail.com>
Subject: net: ethernet: stmmac: dwmac: mac10_100_1000 star report
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     netdev@vger.kernel.org, uri.trichter@nuvoton.com,
        yoel.hayon@nuvoton.com, eyal.cohen@nuvoton.com, oved.oz@nuvoton.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Synopsys hasn't changed its wdc_ether_mac10_100_1000 since version
3.73a in 2013. They have some open starss (errata) that some of them
can be worked around with SW.
See https://www.synopsys.com/dw/star.php?c=dwc_ether_mac10_100_1000_universal
Does stmmac driver implement those workaround or part of them?
Can you list those which are supported?

-- 
Regards,
Avi
