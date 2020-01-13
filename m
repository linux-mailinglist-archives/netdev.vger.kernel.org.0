Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863A3139565
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgAMQBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:01:16 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41826 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgAMQBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:01:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so9136049wrw.8
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 08:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VJ2I8bVjh406gtJuNrBH16DaMI1Itvx05/c74M6wft8=;
        b=wcJVBNGQcVPQ0xvdGtG2k2J38F+daqvgDEWf9Oyeul9ot4a52KywkpkM4M13AipHLu
         GI388SfURNeNCjXxXI5C5l8p6ik+pW0ztjmKChcm5CUrj+R7dgx34VMdXff3cvT3K+3b
         jvCYgG5J0tful/gOCIc89D8XdCNiIk1sd4lZ1d3i2J72kzqr7dMJOdenE5yIxmOebUoN
         CvArh3Sh6+t0pm494NwZgNGczFWiMDCjWpExune2b7vr3FDw1AMf1H7O0O/TjtZiMODL
         00h32HfxgbHGZRIwKWHOeywxQrvU5J5h+9tla/KVLgwocrmLRhWd2em9v5Kt9J/3MkMj
         e4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VJ2I8bVjh406gtJuNrBH16DaMI1Itvx05/c74M6wft8=;
        b=dDVNZXLMR+Xk89XwfHEn6eL/V3tPfCdqzO0yOFCgSDCAH9he7hya0gpDtrZtm986n2
         a1ngpWG7NQnBHAAQrKVRHYMmaoiFoO688rVQG1S1WatFMRJ7MvsA7fO1vQyOjMIIm0IQ
         lDU1rr/2aT70fRY6WpYuQNAc1Uuej9vI1DWpmbqbI1/axisE98UxY/s1XSAi4pAoy/4j
         /TLG9e6rwzSYBBTmSYZ6rxwqTa9ZFsd+lytWXuaYOViqeIEhb2yE79vX9rYsUjl3WW7T
         j/k5f2IoASQ4dTLAKbKIkoYHdvCuKhhMSwhI0bEt7poQKLRyAyqJKDahCd8EjT3f8vfO
         t+cA==
X-Gm-Message-State: APjAAAWg5iJW+23XKBqSWofbQv+2UnJx0iUj5n30iQLR2WGq+xP0TVst
        4oDxgLnX8O6XHPalMNqOSiShlQ==
X-Google-Smtp-Source: APXvYqz+wIKpxexS9htZEf5ylW4xVlVtWBFDIb7X9/vCrhz4wjrU+PeGtBByqJUS5lDOlv9N3+huyw==
X-Received: by 2002:a5d:4f8e:: with SMTP id d14mr20115727wru.112.1578931273141;
        Mon, 13 Jan 2020 08:01:13 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id p7sm14332600wmp.31.2020.01.13.08.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 08:01:12 -0800 (PST)
Date:   Mon, 13 Jan 2020 17:01:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 02/15] net: macsec: introduce the
 macsec_context structure
Message-ID: <20200113160111.GF2131@nanopsycho>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
 <20200110162010.338611-3-antoine.tenart@bootlin.com>
 <20200113143956.GB2131@nanopsycho>
 <20200113151231.GD3078@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200113151231.GD3078@kwain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 13, 2020 at 04:12:31PM CET, antoine.tenart@bootlin.com wrote:
>On Mon, Jan 13, 2020 at 03:39:56PM +0100, Jiri Pirko wrote:
>> Fri, Jan 10, 2020 at 05:19:57PM CET, antoine.tenart@bootlin.com wrote:
>> 
>> >diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> >index 1d69f637c5d6..024af2d1d0af 100644
>> >--- a/include/uapi/linux/if_link.h
>> >+++ b/include/uapi/linux/if_link.h
>> >@@ -486,6 +486,13 @@ enum macsec_validation_type {
>> > 	MACSEC_VALIDATE_MAX = __MACSEC_VALIDATE_END - 1,
>> > };
>> > 
>> >+enum macsec_offload {
>> >+	MACSEC_OFFLOAD_OFF = 0,
>> >+	MACSEC_OFFLOAD_PHY = 1,
>> 
>> No need to assign 0, 1 here. That is given.
>
>Right, however MACSEC_VALIDATE_ uses the same notation. I think it's
>nice to be consistent, but of course of patch can be sent to convert
>both of those enums.

Ok.

>
>> >+	__MACSEC_OFFLOAD_END,
>> >+	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
>> >+};
>> >+
>> > /* IPVLAN section */
>> > enum {
>> > 	IFLA_IPVLAN_UNSPEC,
>> >diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
>> >index 8aec8769d944..42efdb84d189 100644
>> >--- a/tools/include/uapi/linux/if_link.h
>> >+++ b/tools/include/uapi/linux/if_link.h
>> 
>> Why you are adding to this header?
>
>Because the two headers are synced.

It is synced manually from time to time. (October is the last time)


>
>Thanks,
>Antoine
>
>-- 
>Antoine Ténart, Bootlin
>Embedded Linux and Kernel engineering
>https://bootlin.com
