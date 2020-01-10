Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122C313716A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgAJPgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:36:13 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54138 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgAJPgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:36:13 -0500
Received: by mail-pj1-f68.google.com with SMTP id n96so1113756pjc.3
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 07:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xl+l/Ff1h5aHS/j+yY4JLSVy0LAWP0ovd4UAXh2rwYI=;
        b=GD+hkpL7mVIsQjwBZ1pGAowSiGQaH8CrQQ0jhQbZMOA8cGm5Un+8k5Gi+5VBH2O+U+
         P6F5PMier1CZAh1PWTFbO2OsxfxV9cIwCLQgLoT+G5gDry8t5oTJdGJUqIZVvQh6sGXF
         r20ruywtum4tOg7Jkl+EDazul8zJoAJ79CIM187WMPKi67r6BE6UbPegWc78d/zHYCHm
         jFC4JxnYQDRkG0aMZ1760wa21eU1FolRndacSM/YpQyOs+o0D7K9/N6+VVqtNp9kdrsf
         ULwGP4lZwgjCMMH61AVwRvT4nbJNdQedY+4pFddeEpdcqDt79RrkdF+HPdXkC18qMus8
         iWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xl+l/Ff1h5aHS/j+yY4JLSVy0LAWP0ovd4UAXh2rwYI=;
        b=e85ihIwZpT7E34+4VF0pDF3+b2EfwUQ7RE6/Bbfr7nnwjwlpDVvO5jG+y4DZ96B7t0
         +l8NRph5wJFXgCA6L9rk/NbglN/gQfYIgemZPBRMvXax2yHWWYbQ2RoSDdEPlqhIE+1g
         F0regL2q5AcUq0V33yWD6sIN5vYJkFcSCORfzTzTcpyOOs8i54XYXT7p5BQAyeWjrbbY
         Y888wVdXtkIB+KsvaXQ8Flgkux8frwXJ5SfDhpTtI+yG1MeFP+JcryeIbAgIZfR3GQJc
         YJZD/QowdMB+eEFCzKx8bAhH1HtT4FkiSs3xOgZFXjCLvlqdH2Q/YbSu//jvtCiur84E
         nasg==
X-Gm-Message-State: APjAAAVdwEnTI9VwEUCbCVDGAN52PLUv64RRGjl40l0Y2fY9wVljvwpq
        N2895PDKQ9Py2dxYNzpXgL+60g==
X-Google-Smtp-Source: APXvYqxSZPzdmIwpivEu+hPAuqodSnrGHj7sAf0eyiVtKM+EsamCQsp1Ns5CchOK9jKGiSsUdzSH2w==
X-Received: by 2002:a17:90a:f88:: with SMTP id 8mr5729629pjz.72.1578670572660;
        Fri, 10 Jan 2020 07:36:12 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 20sm3414887pfn.175.2020.01.10.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:36:12 -0800 (PST)
Date:   Fri, 10 Jan 2020 07:36:09 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <dsahern@gmail.com>, <jiri@mellanox.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for
 Media Redundancy Protocol(MRP)
Message-ID: <20200110073609.0eddf6e3@hermes.lan>
In-Reply-To: <20200110090206.gihfd3coeilkyi23@soft-dev3.microsemi.net>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
        <20200109081907.06281c0f@hermes.lan>
        <20200110090206.gihfd3coeilkyi23@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 10:02:06 +0100
Horatiu Vultur <horatiu.vultur@microchip.com> wrote:

> > 
> > Can this be implemented in userspace?  
> 
> The reason for putting this in kernal space is to HW offload this in
> switchdev/dsa driver. The switches which typically supports this are
> small and don't have a lot of CPU power and the bandwidth between the
> CPU and switch core is typically limited(at least this is the case with
> the switches that we are working). Therefor we need to use HW offload
> components which can inject the frames at the needed frequency and other
> components which can terminate the expected frames and just raise and
> interrupt if the test frames are not received as expected(and a few
> other HW features).
> 
> To put this in user-space we see two options:
> 1. We need to define a netlink interface which allows a user-space
> control application to ask the kernel to ask the switchdev driver to
> setup the frame-injector or frame-terminator. In theory this would be
> possible, and we have considered it, but we think that this interface
> will be too specific for our HW and will need to be changed every time
> we want to add support for a new SoC. By focusing the user-space
> interfaces on the protocol requirement, we feel more confident that we
> have an interface which we can continue to be backwards compatible with,
> and also support future/other chips with what ever facilities (if any)
> they have to HW offload.
> 
> 2. Do a UIO driver and keep protocol and driver in user-space. We do not
> really like this approach for many reasons: it pretty much prevents us from
> collaborating with the community to solve this and it will be really hard
> to have the switchdev driver controlling part of the chip and a
> user-space driver controlling other parts.
> 
> > 
> > Putting STP in the kernel was a mistake (even original author says so).
> > Adding more control protocols in kernel is a security and stability risk.  

The principal in networking is to separate control and data plane.
This is widely adopted in many areas: OVS, routing, etc.

There is an existing devlink interface for device control, it would
make sense to extend it to allow for more control of frame inject etc.
