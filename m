Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D66F2BE8B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 07:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfE1FTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 01:19:38 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44301 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfE1FTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 01:19:38 -0400
Received: by mail-pl1-f193.google.com with SMTP id c5so7822016pll.11;
        Mon, 27 May 2019 22:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ahiUDT9704AVXg0dEXLHskzytrE6K8fNwMBZeu5usUM=;
        b=GWkBsIUT/tYVVBLhaRirJANyuOC3XD23xCDDGFrQCRcJJSi4PBdDUhxq6FMxy3bS50
         cZgpXmFkJQLek6wL2WnLiX+D33xW1yapSQQbDyQq3HXzgX4P7mD6wBPJ03QW/PfI6ddA
         gcZtBZ7RjF8w5JONMo2of9zjqTCAkl/NrTHTQnnq4qtniYhnHP3Ms1Cgl5fK5HkXFwTw
         H9v90nqAfbZv1bi0RMuEKBbN9vbsQAKpeVjWWtAuSFBW66IqJ6dJOZVoaaWauwzOHl+F
         z4cSGR05i7Ju30yVDkEfZeMYSXxvxa5Mxhi1yofteyE9iMWpo1b4zf+yVrI7GDdFQC1Y
         bOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ahiUDT9704AVXg0dEXLHskzytrE6K8fNwMBZeu5usUM=;
        b=UxZ6FpL86itlAIcOCnrAIKWlfzOmx8n6b6Ecnam7w8RXAmFUP4aRYbzDAbslGcfehp
         7I9huwmLFskRimHtS5qtVXbPSRN+6FxgS9SiYjtRFIR0T6Vbeovn+nz12bIaWnjGxBgA
         oSrvxcOSv6eiyQYfXkEtyKlDozGXW538i6jPmg6K/PvMpwnr2acOatigYJ6+olqLCoUh
         XfjCiXuEkg9X+07ARzPVI8uC+7xvl8dE8w53Pgki5ep3YAbxAF+q4natag9c1TsUdUby
         2TngESkmbrpTC5B6/g1WWxQ1kD1IzvoCckUzmo96ZPHPle5Rc2DAhMNZ94mjOFl9FkVY
         2/YQ==
X-Gm-Message-State: APjAAAV2oi7UlB6/CBFUtAjuXEO05rhqWy0QuqEiPmSsWNW7irsUjc9y
        rifogWksCiYEQG9RaXX9kWQ=
X-Google-Smtp-Source: APXvYqxTpuiMo4b+CmGUL4fPXaM+h/gg6yHY4YMrXfvxOH6H2aqYFV89s3VFldgjt3rJssXWZ+NbeQ==
X-Received: by 2002:a17:902:e28a:: with SMTP id cf10mr128461961plb.77.1559020777464;
        Mon, 27 May 2019 22:19:37 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id y12sm8012769pgp.63.2019.05.27.22.19.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 22:19:36 -0700 (PDT)
Date:   Mon, 27 May 2019 22:19:34 -0700
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
Subject: Re: [PATCH V3 net-next 3/6] net: Add a layer for non-PHY MII time
 stamping drivers.
Message-ID: <20190528051934.wpoz6uuwwqwlr7gw@localhost>
References: <20190521224723.6116-4-richardcochran@gmail.com>
 <20190522010852.GE6577@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522010852.GE6577@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 03:08:52AM +0200, Andrew Lunn wrote:
> probe_channel returns an PTR_ERR. So if (mii_ts) should probably be
> if (IS_ERR(mii_ts))

Nice catch.  Thanks for the careful review!

Richard
