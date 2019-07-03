Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53EF5EF05
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 00:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfGCWIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 18:08:47 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36323 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfGCWIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 18:08:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so1930382pfl.3
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 15:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WjjWRdXySZkjpj26g1Pm4rzHQ2nCZawoM/TZfTFAezI=;
        b=UxSjmshB/efA5VRE78aPgnfuO/Sq/XiYw8vG5chnT45W8s9eIhSvPBCC/mGRdhQRAM
         aPD+zvMYLU6QJzAWBsTOmtbTqcGwnfwfDl1uFLrkBkjO6z7a5yH1SyE3GJ6Y5hBtDN+d
         XZAsuPc8zy95h9yxwn1SR3uls7dO9xvIAB3do=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WjjWRdXySZkjpj26g1Pm4rzHQ2nCZawoM/TZfTFAezI=;
        b=OKY7lji9yDfylGicHiNhJMyqj+13iwLUwUPo3XKxAieqZzGquY0Pt6Eeg7LgxEmXLh
         dTz5ufvvKGufp7lW8LoNVFDNq7b6azlrQy6uROmk4k4eM6WXnNr80T7bwWcWnJ5h4P8U
         zQXbODIpWjNw8uFUeM27urpQBPcrD0ZNxGbMGQ7xFt/Pjio1EhChUyDZ7yDyfJT0fKr6
         B8SS/eJ5FFiV/8pbCIThitMvT7NDDUXVlcIMuDMjieXfP8RzVro9aZC7EWI0ZJBYgcfY
         DQGvSNFGYmVeR7Cddf4trfpAGIOXph5BKbUSfqW00Wh2YopUKT+VegHNNsl6EPHNJ7Od
         k+bA==
X-Gm-Message-State: APjAAAW7JFs4c+aJP0dsOlMmJqozrBq4Xg82QCg71GnGf3rQ6frz7X+2
        e8qry3cM4P6N6RfJ6IK+1pY7oQ==
X-Google-Smtp-Source: APXvYqyNI7R7rRmSWaIP0fI91rk/hM1ha6x5voe4cvZVNb4VcCHs7IcJLnAucRtMAGfGWBsihbi9aw==
X-Received: by 2002:a17:90b:8d8:: with SMTP id ds24mr15201077pjb.135.1562191725828;
        Wed, 03 Jul 2019 15:08:45 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id m16sm3360862pfd.127.2019.07.03.15.08.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 15:08:45 -0700 (PDT)
Date:   Wed, 3 Jul 2019 15:08:43 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
Message-ID: <20190703220843.GJ250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
 <20190703213327.GH18473@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190703213327.GH18473@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 11:33:27PM +0200, Andrew Lunn wrote:
> > I think if we're going to have custom properties for phys, we should
> > have a compatible string to at least validate whether the custom
> > properties are even valid for the node.
> 
> Hi Rob
> 
> What happens with other enumerable busses where a compatible string is
> not used?
> 
> The Ethernet PHY subsystem will ignore the compatible string and load
> the driver which fits the enumeration data. Using the compatible
> string only to get the right YAML validator seems wrong. I would
> prefer adding some other property with a clear name indicates its is
> selecting the validator, and has nothing to do with loading the
> correct driver. And it can then be used as well for USB and PCI
> devices etc.

I also have doubts whether a compatible string is the right answer
here. It's not needed/used by the subsystem, but would it be a
required property because it's needed for validation?
