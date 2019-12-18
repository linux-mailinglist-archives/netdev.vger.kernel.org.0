Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA8F812528D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfLRUDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:03:41 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38283 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfLRUDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:03:41 -0500
Received: by mail-oi1-f194.google.com with SMTP id b8so1796499oiy.5;
        Wed, 18 Dec 2019 12:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TzLryL/ukNt8zF+BhyR7ckjbzFxhufgCaK3PUf0/FaY=;
        b=B8yDSwwsjFT2krDJpKu/TWuKG2DRO4xoaEOXmmRhsN6vI7ktz/KtyUtfHEimD3Vg1S
         UYmTIxnYyXg8hr1qjkyoqy1pFEXiF+M7WpCNObznhbDZJF9z2xzfb4lUmCxl1pC6CcI9
         FqN1gnHs6r9qnGRsdioQ4FL6tx7sb7L3+mHrZ/HpXB/vSFJBdojDO1aMdAsa/ww4CFpw
         a7XT5UR27zsfUMOOJJYYYbJ2ohv13P2nxy2zrp13pFlPoN/KNjYSG/bPSZ7WSJk8RjcE
         KgQFS5uY+GXooXlOyW2eHxwV7FAeLLgbyxfWSaGmkfiprAjVwx4zo2QdlLNBUdgMbT4S
         VXHA==
X-Gm-Message-State: APjAAAUihqPhh9TtXkZtiwFkfeaOsNPBETN2Hw6E3yuB7c8QjZZ2UoFY
        8x/M53OBJgJ+dByfPRulcYt5ULA=
X-Google-Smtp-Source: APXvYqypE54KTzl6qms2PHoa2WyxLovimSuB/nZuz6ojYtYLh36jjGK8HFESPzsXKM2IjhIFSw+3bg==
X-Received: by 2002:aca:3846:: with SMTP id f67mr1314512oia.61.1576699420276;
        Wed, 18 Dec 2019 12:03:40 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q7sm1171402otn.9.2019.12.18.12.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 12:03:39 -0800 (PST)
Date:   Wed, 18 Dec 2019 14:03:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
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
Message-ID: <20191218200339.GB25825@bogus>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <f74e71626f6c9115ab9cf919cc8eaed10220ecb2.1576511937.git.richardcochran@gmail.com>
 <20191217151705.GF17965@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217151705.GF17965@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 04:17:05PM +0100, Andrew Lunn wrote:
> On Mon, Dec 16, 2019 at 08:13:23AM -0800, Richard Cochran wrote:
> > This patch add a new binding that allows non-PHY MII time stamping
> > devices to find their buses.  The new documentation covers both the
> > generic binding and one upcoming user.
> > 
> > Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Rob might want YAML?

Yes, of course I would, but not if this is close to merging as it's on 
v6.

Rob
