Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04086319BA
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 07:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfFAFJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 01:09:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43133 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfFAFJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 01:09:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id c6so7413999pfa.10;
        Fri, 31 May 2019 22:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1dgPNVt56fBXmLaPXqOw07kWgT9cJMPYXZSWyIwo+es=;
        b=cU9DRRdg8GyJ0OJ/VaE+c27Il0p4O3JozzFNoe+6ns5VPEE1Io6BhwDokCn0zmyvcR
         tvcnrX6AYBNDuKdJM32rwKvIxy2fQwCaJBA8sTyO4SOU736OMl8dMNBpiKghA8L/ftDg
         BTlJsLktqQEFYW0vnmIZWpQ+aIxgutj9W1SwtK9A0BJ45hiHZC5Y1vI91gYZ+ZdLLwOE
         iF89oXc27qQzWBnIp/BxtIFQKjpbOR+0owAK1ydxqgI06ZJTkhnFb6U6d/+/h2jgaWOX
         Gc8mY465nWs1HN56cHV9JS22epAYYSFFnl2Q6mQSg+9RBJgLqLpZpjdezZk7+Pq4H59f
         AQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1dgPNVt56fBXmLaPXqOw07kWgT9cJMPYXZSWyIwo+es=;
        b=Xs3uvRo3JPp2f+8nPISkuj46geCNCSCyzckZERfkNtv7ipCD5UZ3vbM3gVuwJRSauw
         ejRnXWcdn+Ep5mxLAHOCxDJtTpqHLwPJsr4J3VE80c71VArqNED/NlK6VU4Ik8ENpG1r
         oTOFEZwr20gxlePgTLqCkHiTLqLZvixJBHqg/tEvamIanHXZkxY3uanEEjxx3oQKCcRZ
         2jRD2qXgVg9QqgQSVi3+Phuc/ytjcn5eCnPXeeVun1gPxWoLpUA5vmj1VXqavBF5LeRm
         I8Jfqt6NZZhGN75/0k2wTdHeui6+PrAMSkTR91LVs8RJ3kgvguwPJWYm64VfoFBRORxC
         dn+w==
X-Gm-Message-State: APjAAAUiUelrQ/rFgVqjJoK9yJJaKooOxbjQAE7WWed1n8yiwEQWgXWk
        qoCYgG2+UNejnH3X57jxmU0=
X-Google-Smtp-Source: APXvYqzrIxIlRtJ50qaRnl+K14ZVmK0BtQyv0TW8YjsyFdiIMEKbfU8WWb9nOiSdS/MAyKx9iPcljQ==
X-Received: by 2002:a63:1d02:: with SMTP id d2mr13015907pgd.26.1559365786044;
        Fri, 31 May 2019 22:09:46 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id e19sm286587pfd.7.2019.05.31.22.09.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 22:09:45 -0700 (PDT)
Date:   Fri, 31 May 2019 22:09:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mark.rutland@arm.com, mlichvar@redhat.com, robh+dt@kernel.org,
        willemb@google.com
Subject: Re: [PATCH V5 net-next 0/6] Peer to Peer One-Step time stamping
Message-ID: <20190601050943.vtj3iyuq6tt3hhad@localhost>
References: <cover.1559281985.git.richardcochran@gmail.com>
 <20190531.145456.1740583785604198757.davem@davemloft.net>
 <20190531.171309.290138318415845331.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531.171309.290138318415845331.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 05:13:09PM -0700, David Miller wrote:
> This also does not build.
> 
> Please do an allmodconfig build and save me from having to do this
> another time.

(Dons paper bag over head.)

I have a good excuse... it was the bay area fog that made me do it!

Sorry,
Richard
