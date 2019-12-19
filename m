Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C20125A39
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 05:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLSENf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 23:13:35 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37736 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfLSENe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 23:13:34 -0500
Received: by mail-pl1-f193.google.com with SMTP id c23so1946652plz.4;
        Wed, 18 Dec 2019 20:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=upHiRWJSEVJFWUfLfM7in3NXhRVEg38lqf98p+toz5E=;
        b=fSv/0l5ouFjQQ2wehjPpwqCHlJcToCQKarXVCdv7c/eftmCmd4CkGFm8FgYIoM4lrn
         X7ameCNM7gbpz+hFx3TCxUFAnLAFz46zaApt8//K0wKXyWHLDzwdR6pDrLGGGBSolkOv
         7A81a/1Th8bqoFg35DiWcSmxJ+GClGOOq4sJpdsSc/IuumKblmXSP+56g3VHFAiELNBE
         7p0PrxNgRwFAhcN6AZT7lej66qyqv896OwxE6D+kYsHPh2TymxvY/FaMh/voDVV8jAWF
         kqcomjHgapcSiTI98dqTAdpNSxZHQkKmoq0mx41+Hu359qjUXWBtQhSWsg8H5NekP+ww
         /n3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=upHiRWJSEVJFWUfLfM7in3NXhRVEg38lqf98p+toz5E=;
        b=VBBqHGCMT6tOXOtN59cZSZAF6oFdrIcm7rk4eu0QB0LbX7/FDgzh18tY89tgAKF/cX
         PvC+m5InZvGd6XKXdZ8OUcnFeZuFz7y0B2Ol/u3bQmHNSQQo98f9OYOKNePs3QJGxA8b
         PibtJoDMYzHcUFExwKwUhUWX247tPPzHwn6SFcgrAVyaRAKl+GacOVOcebLVsB2gO5Vk
         xSuxIPT3hz1HESsAvvGlxWonaOB57rb6hD7VcVNUUywXwaDEKbdyeymla7yck43lfFQ5
         yIc6B3dQMBEXjAMnajmZXUnv6n1J8MIffW/GT+hYn1NnwKJ6iCGUCYfJPBQwba9Vc/iz
         qEBQ==
X-Gm-Message-State: APjAAAUOGZzNpwdAOwHERrIYo67LxXL3hiL09vI6pZXnarHQilLGB5Fr
        /e+M63zkdu2ySIFA7nEHZd4=
X-Google-Smtp-Source: APXvYqx4dX9fXHvGySkJ0IA8AvtwoH7Ube7eFML1SUwvfYD/tMe9vIe+v94Rzs8KeKn5UgRlQyx0mg==
X-Received: by 2002:a17:90a:ca12:: with SMTP id x18mr7059695pjt.66.1576728814155;
        Wed, 18 Dec 2019 20:13:34 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m3sm4939503pgp.32.2019.12.18.20.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 20:13:33 -0800 (PST)
Date:   Wed, 18 Dec 2019 20:13:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 08/11] dt-bindings: ptp: Introduce MII time
 stamping devices.
Message-ID: <20191219041331.GA1380@localhost>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <f74e71626f6c9115ab9cf919cc8eaed10220ecb2.1576511937.git.richardcochran@gmail.com>
 <20191217151705.GF17965@lunn.ch>
 <20191218200339.GB25825@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218200339.GB25825@bogus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 02:03:39PM -0600, Rob Herring wrote:
> On Tue, Dec 17, 2019 at 04:17:05PM +0100, Andrew Lunn wrote:
> > Rob might want YAML?
> 
> Yes, of course I would, but not if this is close to merging as it's on 
> v6.

How nice of you.  I appreciate your leniency!

Thanks,
Richard
