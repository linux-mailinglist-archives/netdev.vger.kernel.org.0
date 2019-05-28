Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4F32BE99
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 07:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfE1F26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 01:28:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44375 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfE1F26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 01:28:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id g9so10717722pfo.11;
        Mon, 27 May 2019 22:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jB9i06qh/zAzX63q0a2VNfsKfXywpQKOVjFqzfr5BWo=;
        b=eakJXgU6puzVy39XBEXWzkOelrgBF93wRQIfIR0Cmnieo+IM/fUFEf0Oj+Xjr1olNZ
         rf+INObF0x+xEheQoZ8lAdG86B/qbJZWgGESRUxFJyuZTc3kywIrLrqrZVUakwKkLyOm
         /fddtzP0Y/oNwNFcD14mloiHnt4oYDxOOurAJ8WEfhhBlPpEDL06Dkf/xM+ffVhHWlxv
         FzmjK2WnOOQDJlUDqQ7yCDEuS8M3ZwMpPLCyWNqtev3t13jvcxnXy56+TAxezSEfHdu1
         wOYEBvhUhNCK4Fce2bs3Ee9QaAREkf3UQIUp24Eh0e8ut4GGQU9nyNsuifx4cpU00S2q
         N/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jB9i06qh/zAzX63q0a2VNfsKfXywpQKOVjFqzfr5BWo=;
        b=D5CxPhstRIO/ou2LntpGHQj+6SLOdv8xfR5U5rSO+cqPrf0+iVoKRIaFxKaT0I8Wb+
         Eiz2+LPcJPN2gd5830Szlyh+umDj8aLHaIrL+2+Nde736oLaz/D6rFuCMo/4YhbHnAI7
         bAyr3oCcoqBJtSp6rbIZh60Gb4KsxFoeGYViWma08j6hpucda/4PGRcxpF66MZrlu6wA
         UUfxJ4EiT7UNwNqiHHV/iujIhZSSXnpt2ysv4+Tddeg058/lUihBCA0Cup+Z+jdexlgi
         K1tFqXxwlPv1tWjGtbhhd6Je0kwSYO5Z4xf7TESISDxZSiS5R0XpQiOaT2JILyK51Gw5
         6L9A==
X-Gm-Message-State: APjAAAV6E0gHMRWM4RVJ0CxfS4H7hSow6bzCzf3fr8pvXzOdxlKLl8nq
        pi3Maa1AYYWqY/F2a8ly6UE=
X-Google-Smtp-Source: APXvYqyxo1vGGTnJ42pOVfKam0dkcwGKHFK+wmuTuT2Ax683rIBQF+2BOX+4i2AOwL/deBvCsf1Gcg==
X-Received: by 2002:a65:6088:: with SMTP id t8mr81150032pgu.381.1559021337990;
        Mon, 27 May 2019 22:28:57 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id h11sm13266532pfn.170.2019.05.27.22.28.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 22:28:57 -0700 (PDT)
Date:   Mon, 27 May 2019 22:28:55 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 6/6] ptp: Add a driver for InES time stamping
 IP core.
Message-ID: <20190528052855.5n4eb47rinjzzl4w@localhost>
References: <20190521224723.6116-7-richardcochran@gmail.com>
 <20190522014220.GB734@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522014220.GB734@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 03:42:20AM +0200, Andrew Lunn wrote:
> I don't know about the PTP subsystem, but in general, forward
> declarations are frowned upon, and it is generally requested to
> reorder the functions to remove them.

I am not aware of any general coding style rule or even defacto
practice in this area, but there is a method to this driver.  The
functions are in alphabetical order.  This makes it easier to find
your way around the driver.

Thanks,
Richard
