Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C7219C659
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 17:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389557AbgDBPt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 11:49:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38315 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388677AbgDBPt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 11:49:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id c21so1939305pfo.5
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 08:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pc+quqbhFRRGLsxRW1G/z8AT4SYVPiwm8u482NsOspY=;
        b=1xeM4V0Mcs5x/tMUgzCBPVyiHqa5OFmy7GIEY1jrE8+FbCRdXK+zkBvb3FVg72utMp
         owA/dk8KwT06gkVooKxU/zlDKxMNaq34QkmHQwSQLMhVyOsyuvcsmP9kCxxv11lp6Nwd
         gfufI+m8TPwOeFUEOPNf5Rs0TqnQbxCri5/qCxR3PuRSIAM8T1PuFfwizdGKzMAppCG9
         UFqZHLNz6GwPO/kakM2HWxJL7TfZnsP1tPL1vHTyRdrxe+EjVSSJodFyCFsW3b+9lL23
         wC3QB1y1Cct1O7PUaSEveMK4RzSnUctvqnZjyX/u955fv9XvNZRN4qD7GaQ2izTrPetN
         0GVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pc+quqbhFRRGLsxRW1G/z8AT4SYVPiwm8u482NsOspY=;
        b=L4XjJ7XmSMBspPvxoAgI+KYeotKCMk4QJNakgIxMOKOm4bm8imcR+frZbjlz9LVsqJ
         2xl9XGe+q3YNXN6OxZL82HzBz2y2pAWW2pU9uXXs4wJsZWOnvmzcUHzNvjwcEhiesKAk
         CEwFXiAIATQ0lELz3NOklatAzKQkr6oJsJolQi1Bxe9TAeEO9GEmjXq1N0dH4A73+hgV
         YwSVEJl9fwSD94ZDr2a+Zjn0qVtnJ5OkGZUOaTEhIqqdE4fEICPaHX82lpEVyTRuxQGK
         AZPAKb15luix3E++frR8DPeStQkGr/8TEI4Xk6dj1JQ7xKyxF13yPOdEiEoRDcLi91If
         lZlA==
X-Gm-Message-State: AGi0Pubt3kP7nKS+2thZCdfo2iDXUsGz40QHmWHDw2zdz1FY+kl9Ukp+
        8vPTs5lmZD4z3QOuZbMpXepq7ZBPVC8+ow==
X-Google-Smtp-Source: APiQypKAyrOYSnyHPH747y4M7JD1O1+HOIgqQUsC8fN/L68TaJveZ5RgJNKKCTW6lIdgitcNJFGm+A==
X-Received: by 2002:a63:f454:: with SMTP id p20mr3974970pgk.149.1585842567051;
        Thu, 02 Apr 2020 08:49:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 66sm4056024pfb.150.2020.04.02.08.49.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:49:26 -0700 (PDT)
Date:   Thu, 2 Apr 2020 08:49:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 207063] New: vrf route oif problem
Message-ID: <20200402084923.4233e2ed@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 02 Apr 2020 14:15:58 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 207063] New: vrf route oif problem


https://bugzilla.kernel.org/show_bug.cgi?id=207063

            Bug ID: 207063
           Summary: vrf route oif problem
           Product: Networking
           Version: 2.5
    Kernel Version: 5.5.11
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: 1455793380@qq.com
        Regression: No

Created attachment 288155
  --> https://bugzilla.kernel.org/attachment.cgi?id=288155&action=edit  
vrf route oif problem

first create vrf
#ip link add vrf-1 type vrf table 10
#ip link set dev vrf-1 up

then add default route and set local table
#ip route add table 10 unreachable default metric 4278198272
#ip rule add pref 32765 table local
#ip rule del pref 0

set slave interfaces
#ip link set dev ens19 master vrf-1
#ip link set dev ens20 master vrf-1

and then add ip
#ip a a 2.2.2.2/24 dev ens19
#ip a a 3.3.3.3/24 dev ens20

add default route
#ip route add default via 2.2.2.2 dev ens19 table 10 metric 300
#ip route add default via 3.3.3.3 dev ens20 table 10 metric 301

use command to test the route
#ip r g 5.5.5.5 oif ens20

but the result is 2.2.2.2 not 3.3.3.3
don't match the oif!!

I try with kernel vesion 5.5.11

-- 
You are receiving this mail because:
You are the assignee for the bug.
