Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F02A7DE44
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbfHAOvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:51:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43770 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHAOvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:51:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so34215458pfg.10
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=qRmz2Xr1/8BfGPrS8nPC/ALyCL3Td1YFBxo5jcfvrsM=;
        b=Yc8Z8xx8AYBZD1pI/vJL4cM/iUFIlduIXSR+tKjIeiEQUPE334FSh/thEXZmhGuUTm
         Aigav27Z+SXI+Cg8u7QmNqcVyimU2/bozMIlS9T6tNdCt8Il7EJLF6q+qrDTlLXO0vh5
         XGgKGlqK5SlYEmkfgGF34npZnmMvdMj7FEQ6Tbwm7SeWcB69gnWn/tkmBpri5TMFED4d
         2kqkFyNcV0pKO45r5rnemfoP0GMI2O5m7qS7V9gaVG+RVrKF6M7Mb7hZLEwJUMN7NlNK
         usZTTTC75HbjcMNp3IeTh6ovADnaEK3XrTytdv80bH6mRHK9JaIpI3zi0JwaBQIxUi1j
         +wBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=qRmz2Xr1/8BfGPrS8nPC/ALyCL3Td1YFBxo5jcfvrsM=;
        b=VU87ECrYmOVaAebpt5+T3t+atLtoWXDeTice8/qNAFu2Hy1GXmaF4KPzje+P+SLf2y
         uztZc7xL6OA5IXiPxP/W0h+taN/HQATiKY6jk+z4YC8FP4W+fGXVDOlmnM0rOR531sh1
         Coddr/FEIDl9DiaXcyo+7myJuuyfdBYUgYJjA/6c6zlyqWB5CoyUA33m6+MG2uvzO+au
         DG5+daGXkEAdK1IXSAttDvkiuegIhbgOD+FvgQ/UUghlEvDl5SAaazUXJkIRttsNfLUT
         VEXpOMlJyIlvQvp7WnbjyR/a6p6H6nxxzOWjvrIclzTVZH/gTJONmOCHUM4YK6nmTFlV
         sMDw==
X-Gm-Message-State: APjAAAWU0v36NLcZQ8Y3r+SsYnUR1swH9eYuVrJxU3arNAxG4z/gu6hK
        hPJYYBxrgQPp8hIhBHbUKYn64Kgv
X-Google-Smtp-Source: APXvYqwshR9H6zdeRB7y4Ew4ZgnaUBdxPuCNe+Nttcnh0LcRMSanPdqr7lBwfgrRTjg/XCuCTeodLg==
X-Received: by 2002:a63:f91c:: with SMTP id h28mr27321106pgi.397.1564671109215;
        Thu, 01 Aug 2019 07:51:49 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o128sm77788907pfb.42.2019.08.01.07.51.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 07:51:49 -0700 (PDT)
Date:   Thu, 1 Aug 2019 07:51:47 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 204399] New: error in handling vlan tag by raw ethernet
 socket
Message-ID: <20190801075147.1bbbf908@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 01 Aug 2019 06:37:39 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 204399] New: error in handling vlan tag by raw ethernet socket


https://bugzilla.kernel.org/show_bug.cgi?id=204399

            Bug ID: 204399
           Summary: error in handling vlan tag by raw ethernet socket
           Product: Networking
           Version: 2.5
    Kernel Version: 5.0.0-21-generic #22-Ubuntu x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: Lvenkatakumarchakka@gmail.com
        Regression: No

Created attachment 284067
  --> https://bugzilla.kernel.org/attachment.cgi?id=284067&action=edit  
set/unset the variable "stripping_vlan_tag" to reproduce the issue

I am using raw ethernet socket and sending/receiving network traffic.

problem I am seeing is if read socket is opened before starting sending the
vlan traffic, read socket is able to capture packets along with vlan tag. but
if I open the read socket before starting sending the packets, vlan tag is
being stripped and only those four bytes are missing from the packet. Rest of
the packet is intact.

Please refer to the small code snippet which consistently produces the bug.

set/unset the variable "stripping_vlan_tag" to reproduce the issue.

is this a bug in the kernel or any problem with my coding ?

I am working on a project where I will be opening all the required sockets at
once and will be using as and when required. In that case, I am not able to
capture vlan tags which is blocking me. However, tcpdump is capture along with
vlan tag.

please be noted that, both the cards are in same system and are connected just
back to back using a cat5 cable. eth0 is built-in card and eth1 is usb based
external network card.

Is there a way to get rid of this issue ?

Best Regards,
Lokesh.

-- 
You are receiving this mail because:
You are the assignee for the bug.
